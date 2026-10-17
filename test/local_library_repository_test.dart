import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mamba_tv/data/database/app_database.dart';
import 'package:mamba_tv/data/repositories/local_library_repository.dart';
import 'package:mamba_tv/domain/models.dart';
import 'package:mamba_tv/domain/use_cases/prepare_playback.dart';

import 'support/fakes.dart';

void main() {
  late AppDatabase database;
  late LocalLibraryRepository library;
  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    library = LocalLibraryRepository(database);
  });
  tearDown(() => database.close());
  test(
    'favorites, progress and source survive a database close and reopen',
    () async {
      await database.close();
      final directory = await Directory.systemTemp.createTemp(
        'mamba-tv-restart-',
      );
      final file = File('${directory.path}/library.sqlite');
      database = AppDatabase(NativeDatabase(file));
      library = LocalLibraryRepository(database);
      await library.setFavorite(testAnime, true);
      await library.bindMedia(
        11,
        PlayableMedia(
          Uri.parse('https://example.com/1.mp4'),
          headers: const {'Referer': 'https://example.com/play'},
          binding: const MediaSourceBinding(
            sourceId: 'animeko:json-api:test',
            label: '第1集',
            address: '88',
            context: {'id': '88', 'channel': '主线'},
          ),
        ),
      );
      await library.saveProgress(
        WatchProgress(
          anime: testAnime,
          episode: testEpisode,
          position: const Duration(minutes: 4),
          duration: const Duration(minutes: 24),
          updatedAt: DateTime.now(),
        ),
      );
      await database.close();
      database = AppDatabase(NativeDatabase(file));
      library = LocalLibraryRepository(database);
      expect(await library.isFavorite(1), true);
      expect(
        (await library.getProgress(11))!.position,
        const Duration(minutes: 4),
      );
      expect((await library.getMedia(11))!.uri.path, '/1.mp4');
      expect(
        (await library.getMedia(11))!.headers['Referer'],
        'https://example.com/play',
      );
      expect((await library.getMedia(11))!.binding!.context['id'], '88');
      await database.close();
      database = AppDatabase(NativeDatabase.memory());
      await directory.delete(recursive: true);
    },
  );
  test('favorites roundtrip nested DTO data and support removal', () async {
    await library.setFavorite(testAnime, true);
    expect(await library.isFavorite(1), true);
    expect(await library.watchFavorites().first, [testAnime]);
    await library.setFavorite(testAnime, false);
    expect(await library.isFavorite(1), false);
  });
  test('episode progress upserts without duplicating history', () async {
    final first = WatchProgress(
      anime: testAnime,
      episode: testEpisode,
      position: const Duration(seconds: 3),
      duration: const Duration(minutes: 24),
      updatedAt: DateTime(2026, 10, 16),
    );
    await library.saveProgress(first);
    await library.saveProgress(
      first.copyWith(position: const Duration(seconds: 6)),
    );
    expect(
      (await library.getProgress(11))!.position,
      const Duration(seconds: 6),
    );
    expect((await library.watchHistory().first).length, 1);
    await library.deleteProgress(11);
    expect(await library.getProgress(11), isNull);
  });
  test('media binding is scoped to episode and can be replaced', () async {
    await library.bindMedia(11, parseMediaAddress('https://example.com/a.mp4'));
    await library.bindMedia(11, parseMediaAddress('https://example.com/b.mp4'));
    expect((await library.getMedia(11))!.uri.path, '/b.mp4');
    expect(await library.getMedia(12), isNull);
  });
  test('v1 media bindings migrate without losing the saved address', () async {
    await database.close();
    database = AppDatabase(
      NativeDatabase.memory(
        setup: (raw) {
          raw.execute(
            'CREATE TABLE media_bindings (episode_id INTEGER NOT NULL PRIMARY KEY, uri TEXT NOT NULL)',
          );
          raw.execute(
            "INSERT INTO media_bindings VALUES (11, 'https://example.com/old.mp4')",
          );
          raw.execute('PRAGMA user_version = 1');
        },
      ),
    );
    library = LocalLibraryRepository(database);
    final old = await library.getMedia(11);
    expect(old!.uri.path, '/old.mp4');
    expect(old.headers, isEmpty);
    expect(old.binding, isNull);
    await library.bindMedia(
      11,
      PlayableMedia(old.uri, headers: const {'Referer': 'https://example.com'}),
    );
    expect(
      (await library.getMedia(11))!.headers['Referer'],
      'https://example.com',
    );
  });
}
