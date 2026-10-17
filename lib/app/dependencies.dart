import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

import '../data/database/app_database.dart';
import '../data/playback/media_kit_engine.dart';
import '../data/repositories/bangumi_repository.dart';
import '../data/repositories/local_library_repository.dart';
import '../data/repositories/preferences_repository.dart';
import '../data/services/bangumi_service.dart';
import '../data/services/maccms_service.dart';
import '../data/services/animeko_source_service.dart';
import '../data/services/web_video_resolver.dart';
import '../data/repositories/source_repository.dart';
import '../domain/repositories.dart';
import '../domain/video_source.dart';
import 'logging.dart';

class AppDependencies {
  const AppDependencies({
    required this.catalog,
    required this.library,
    required this.settings,
    required this.createEngine,
    required this.sources,
    this.talker,
    this.onClose,
  });
  final CatalogRepository catalog;
  final LibraryRepository library;
  final SettingsRepository settings;
  final PlaybackEngine Function() createEngine;
  final SourceRepository sources;
  final Talker? talker;
  final Future<void> Function()? onClose;
  factory AppDependencies.create({
    bool androidEmulator = false,
    Talker? talker,
  }) {
    final log = talker ?? createAppTalker();
    final preferences = SharedPreferencesAsync();
    final database = AppDatabase.defaults();
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.bgm.tv',
        connectTimeout: const Duration(seconds: 12),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          'User-Agent': 'Mamba-Animation-TV/0.1 (Flutter; local-first catalog)',
          'Accept': 'application/json',
        },
      ),
    );
    dio.interceptors.add(catalogHttpLogger(log));
    final sourceDio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 12),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          'User-Agent': 'Mamba-Animation-TV/0.1',
          'Accept': 'application/json',
        },
      ),
    );
    sourceDio.interceptors.add(sourceHttpLogger(log));
    final cookieJar = CookieJar();
    sourceDio.interceptors.add(CookieManager(cookieJar));
    final resolver = WebVideoResolver(cookieJar);
    return AppDependencies(
      talker: log,
      catalog: BangumiRepository(BangumiService(dio)),
      library: LocalLibraryRepository(database),
      settings: PreferencesRepository(preferences),
      sources: PreferencesSourceRepository(
        preferences,
        MacCmsService(sourceDio),
        log,
        animeko: AnimekoSourceService(
          sourceDio,
          resolveWebPage: resolver.resolve,
        ),
      ),
      createEngine: () => MediaKitEngine(androidEmulator: androidEmulator),
      onClose: () async {
        dio.close(force: true);
        sourceDio.close(force: true);
        await database.close();
      },
    );
  }
}
