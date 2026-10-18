# Development conventions

- Work in this standalone Flutter project. Do not edit adjacent animeko-web or other checkouts to implement TV features.
- Use MVVM: thin views, Riverpod Notifier ViewModels with immutable state and repository-provider injection. Keep FocusNode / BuildContext / ScrollController in presentation widgets.
- Domain is pure Dart. Data implements its contracts and maps external DTOs and errors. Wire concrete implementations in app/dependencies.dart and domain providers in app/providers.dart. Use ProviderScope overrides in tests.
- Verify package APIs against the pinned package source or primary documentation. Commit pubspec.lock and generated Freezed / JSON / Drift files.
- Bangumi metadata is not a video source. Never silently replace a real episode with a demo clip or infer resource mappings from approximate names.
- Keep playback demo sessions out of the user's history. Serialize progress writes and release native playback resources on exit.
- After relevant changes run flutter analyze and flutter test. Rebuild APK after Android/platform changes. Separate mock tests, real API checks, emulator results and actual TV hardware acceptance in docs/verification.md.
- Never commit SDK paths, credentials or user media bindings. Release signing is a separate configuration task.
- For Flutter changes under lib/, consult .agent/rules/flutter-hot-reload.md from the official Dart/Flutter plugin. Apply the user's current restrictions on emulator and device operations before connecting to an app or triggering reload; plugin rules do not override those restrictions or the project's Riverpod architecture.
