import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../domain/repositories.dart';
import '../domain/video_source.dart';
import '../domain/danmaku.dart';
import '../domain/bangumi_discovery.dart';
import 'dependencies.dart';
import 'logging.dart';

// The root scope supplies production dependencies; tests can override either
// this bundle or an individual domain contract, without loading platform plugins.
final appDependenciesProvider = Provider<AppDependencies>(
  (ref) =>
      throw StateError('AppDependencies must be supplied by the root scope'),
);
final catalogRepositoryProvider = Provider<CatalogRepository>(
  (ref) => ref.watch(appDependenciesProvider).catalog,
);
final libraryRepositoryProvider = Provider<LibraryRepository>(
  (ref) => ref.watch(appDependenciesProvider).library,
);
final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => ref.watch(appDependenciesProvider).settings,
);
final playbackEngineFactoryProvider = Provider<PlaybackEngine Function()>(
  (ref) => ref.watch(appDependenciesProvider).createEngine,
);

final sourceRepositoryProvider = Provider<SourceRepository>(
  (ref) => ref.watch(appDependenciesProvider).sources,
);
final talkerProvider = Provider<Talker>(
  (ref) => createAppTalker(console: false),
);

// Optional for isolated player tests and demo hosts; production overrides it.
final danmakuRepositoryProvider = Provider<DanmakuRepository?>((ref) => null);
final bangumiDiscoveryRepositoryProvider =
    Provider<BangumiDiscoveryRepository?>(
      (ref) => ref.watch(appDependenciesProvider).discovery,
    );
