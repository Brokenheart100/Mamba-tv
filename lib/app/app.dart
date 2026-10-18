import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../presentation/core/page_parts.dart';
import '../presentation/core/tv_shell.dart';
import '../presentation/features/catalog/home_view.dart';
import '../presentation/features/catalog/search_view.dart';
import '../presentation/features/catalog/category_view.dart';
import '../presentation/features/catalog/discovery_views.dart';
import '../presentation/features/detail/detail_view.dart';
import '../presentation/features/library/library_view.dart';
import '../presentation/features/playback/playback_view.dart';
import '../presentation/features/settings/settings_view.dart';
import '../presentation/features/sources/sources_view.dart';
import '../presentation/features/sources/source_picker_view.dart';
import 'dependencies.dart';
import 'providers.dart';
import 'theme.dart';
import 'logging.dart';

class MambaTvApp extends StatefulWidget {
  const MambaTvApp({
    super.key,
    required this.dependencies,
    this.initialLocation = '/',
  });
  final AppDependencies dependencies;
  final String initialLocation;
  @override
  State<MambaTvApp> createState() => _MambaTvAppState();
}

class _MambaTvAppState extends State<MambaTvApp> {
  late final GoRouter _router;
  late final Talker _talker;
  @override
  void initState() {
    super.initState();
    _talker = widget.dependencies.talker ?? createAppTalker(console: false);
    Widget player(
      int subjectId,
      int episodeId,
      LocalKey routeKey, {
      bool demo = false,
    }) => PlaybackView(
      session: (
        subjectId: subjectId,
        episodeId: episodeId,
        isDemo: demo,
        routeKey: routeKey,
      ),
    );
    _router = GoRouter(
      initialLocation: widget.initialLocation,
      errorBuilder: (context, state) => Scaffold(
        body: StatusPanel(title: '页面不存在', onRetry: () => context.go('/')),
      ),
      routes: [
        GoRoute(path: '/sources', builder: (_, _) => const SourcesView()),
        GoRoute(
          path: '/logs',
          builder: (_, _) => TalkerScreen(talker: _talker, appBarTitle: '应用日志'),
        ),
        GoRoute(
          path: '/sources/select/:subjectId/:episodeId',
          builder: (_, state) {
            final subject = int.tryParse(
              state.pathParameters['subjectId'] ?? '',
            );
            final episode = int.tryParse(
              state.pathParameters['episodeId'] ?? '',
            );
            if (subject == null ||
                episode == null ||
                subject <= 0 ||
                episode <= 0) {
              return const Scaffold(body: StatusPanel(title: '无效章节编号'));
            }
            return SourcePickerView(
              target: (subjectId: subject, episodeId: episode),
            );
          },
        ),
        ShellRoute(
          builder: (context, state, child) =>
              TvShell(location: state.uri.path, child: child),
          routes: [
            GoRoute(path: '/', builder: (_, _) => const HomeView()),
            GoRoute(path: '/calendar', builder: (_, _) => const CalendarView()),
            GoRoute(path: '/browse', builder: (_, _) => const BrowseView()),
            GoRoute(
              path: '/categories',
              builder: (_, _) => const CategoryView(),
            ),
            GoRoute(path: '/search', builder: (_, _) => const SearchView()),
            GoRoute(path: '/library', builder: (_, _) => const LibraryView()),
            GoRoute(
              path: '/history',
              builder: (_, _) => const LibraryView(history: true),
            ),
            GoRoute(path: '/settings', builder: (_, _) => const SettingsView()),
          ],
        ),
        GoRoute(
          path: '/anime/:id',
          builder: (_, state) {
            final id = int.tryParse(state.pathParameters['id'] ?? '');
            if (id == null || id <= 0) {
              return const Scaffold(body: StatusPanel(title: '无效番剧编号'));
            }
            return DetailView(subjectId: id);
          },
        ),
        GoRoute(
          path: '/play/:subjectId/:episodeId',
          builder: (_, state) {
            final subject = int.tryParse(
              state.pathParameters['subjectId'] ?? '',
            );
            final episode = int.tryParse(
              state.pathParameters['episodeId'] ?? '',
            );
            if (subject == null ||
                episode == null ||
                subject <= 0 ||
                episode <= 0) {
              return const Scaffold(body: StatusPanel(title: '无效章节编号'));
            }
            return player(subject, episode, state.pageKey);
          },
        ),
        GoRoute(
          path: '/player-lab',
          builder: (_, state) => player(0, 0, state.pageKey, demo: true),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _router.dispose();
    unawaited(widget.dependencies.onClose?.call());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ProviderScope(
    overrides: [
      appDependenciesProvider.overrideWithValue(widget.dependencies),
      talkerProvider.overrideWithValue(_talker),
      danmakuRepositoryProvider.overrideWithValue(widget.dependencies.danmaku),
    ],
    observers: [stateLogger(_talker)],
    child: MaterialApp.router(
      title: 'Mamba Animation TV',
      locale: const Locale('zh', 'CN'),
      supportedLocales: const [Locale('zh', 'CN'), Locale('en')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      debugShowCheckedModeBanner: false,
      theme: tvTheme(),
      routerConfig: _router,
    ),
  );
}
