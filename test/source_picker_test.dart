import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mamba_tv/app/providers.dart';
import 'package:mamba_tv/domain/video_source.dart';
import 'package:mamba_tv/domain/use_cases/prepare_playback.dart';
import 'package:mamba_tv/presentation/features/sources/source_picker_view_model.dart';

import 'support/maccms_fixture.dart' show configuredSource;
import 'support/fakes.dart';

class DelayedSources extends FakeSources {
  final requests = <({String keyword, Completer<SourcePage> result})>[];
  @override
  Future<SourcePage> search(
    VideoSource source,
    String keyword, {
    int page = 1,
  }) {
    final result = Completer<SourcePage>();
    requests.add((keyword: keyword, result: result));
    return result.future;
  }
}

void main() {
  const target = (subjectId: 1, episodeId: 11);
  final provider = sourcePickerViewModelProvider(target);
  test('explicit selection binds only the requested chapter and feeds existing playback use case', () async {
    final sources = FakeSources()
      ..sources = [
        configuredSource,
        configuredSource.copyWith(id: 'disabled', enabled: false),
      ];
    final library = FakeLibrary();
    addTearDown(library.close);
    final container = ProviderContainer(
      overrides: [
        catalogRepositoryProvider.overrideWithValue(FakeCatalog()),
        libraryRepositoryProvider.overrideWithValue(library),
        sourceRepositoryProvider.overrideWithValue(sources),
      ],
    );
    addTearDown(container.dispose);
    container.listen(provider, (_, _) {});
    await container.pump();
    await Future<void>.delayed(Duration.zero);
    expect(container.read(provider).sources, [configuredSource]);
    final vm = container.read(provider.notifier);
    expect(library.media, isEmpty);
    await vm.chooseTitle(container.read(provider).results.single);
    expect(library.media, isEmpty);
    final selected = container.read(provider).lines.single.episodes.last;
    expect(await vm.bind(selected), true);
    final prepared = await PreparePlayback(library)(testEpisode);
    final engine = FakeEngine();
    await engine.open(prepared.media, start: prepared.start);
    expect(engine.opened.single.uri.toString(), 'https://example.com/two.mp4');
    expect(library.media.keys, [11]);
    expect(await library.getMedia(12), isNull);
    await engine.dispose();
  });

  test(
    'latest query wins; pending requests can finish after provider disposal',
    () async {
      final sources = DelayedSources()..sources = [configuredSource];
      final container = ProviderContainer(
        overrides: [
          catalogRepositoryProvider.overrideWithValue(FakeCatalog()),
          sourceRepositoryProvider.overrideWithValue(sources),
        ],
      );
      addTearDown(container.dispose);
      final subscription = container.listen(provider, (_, _) {});
      await container.pump();
      await Future<void>.delayed(Duration.zero);
      final vm = container.read(provider.notifier);
      final latest = vm.search('new');
      sources.requests.last.result.complete(
        const SourcePage(
          [SourceTitle(id: '2', title: 'new')],
          page: 1,
          pageCount: 1,
          total: 1,
        ),
      );
      await latest;
      sources.requests.first.result.complete(
        const SourcePage([], page: 1, pageCount: 0, total: 0),
      );
      await container.pump();
      expect(container.read(provider).results.single.title, 'new');
      final pending = vm.search('pending');
      subscription.close();
      await container.pump();
      sources.requests.last.result.complete(
        const SourcePage([], page: 1, pageCount: 0, total: 0),
      );
      await pending;
      expect(container.exists(provider), false);
    },
  );
}
