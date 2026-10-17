import 'package:flutter_test/flutter_test.dart';
import 'package:mamba_tv/domain/models.dart';
import 'package:mamba_tv/domain/use_cases/prepare_playback.dart';
import 'package:mamba_tv/domain/video_source.dart';

import 'support/fakes.dart';

void main() {
  late FakeLibrary library;
  setUp(() {
    library = FakeLibrary();
  });
  tearDown(() => library.close());
  test(
    'missing source is explicit; no unrelated demo media is substituted',
    () async {
      await expectLater(
        PreparePlayback(library)(testEpisode),
        throwsA(isA<MissingMediaException>()),
      );
    },
  );
  test('resume unfinished episode, restart a finished one', () async {
    library.media[11] = parseMediaAddress('https://example.com/1.mp4');
    final progress = WatchProgress(
      anime: testAnime,
      episode: testEpisode,
      position: const Duration(minutes: 5),
      duration: const Duration(minutes: 24),
      updatedAt: DateTime.now(),
    );
    library.progress[11] = progress;
    expect(
      (await PreparePlayback(library)(testEpisode)).start,
      const Duration(minutes: 5),
    );
    library.progress[11] = progress.copyWith(
      position: const Duration(minutes: 24),
    );
    expect((await PreparePlayback(library)(testEpisode)).start, Duration.zero);
  });
  test('reject invalid and credential-bearing media URIs', () {
    for (final uri in [
      'http://example.com/a',
      'file:///a',
      'https://user:pass@example.com/a',
      'hello',
    ]) {
      expect(() => parseMediaAddress(uri), throwsFormatException);
    }
    expect(
      parseMediaAddress(' https://example.com/a.m3u8?token=a ').uri.host,
      'example.com',
    );
  });
  test('confirmed source selection is re-resolved without searching or remapping episodes', () async {
    final sources = FakeSources()
      ..sources = [
        const VideoSource(
          id: 'test',
          name: '测试',
          endpoint: 'https://example.com',
        ),
      ];
    const binding = MediaSourceBinding(
      sourceId: 'test',
      label: '第1集',
      address: 'https://example.com/fresh.mp4',
    );
    final expired = PlayableMedia(
      Uri.parse('https://example.com/expired.mp4'),
      binding: binding,
    );
    final refreshed = await RefreshMediaBinding(library, sources)(11, expired);
    expect(refreshed.uri.path, '/fresh.mp4');
    expect(refreshed.binding, binding);
    expect((await library.getMedia(11))!.uri.path, '/fresh.mp4');
    expect(await library.getMedia(12), isNull);
  });
}
