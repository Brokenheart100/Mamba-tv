import 'package:flutter/material.dart';

import 'dart:ui';

import 'package:media_kit/media_kit.dart';

import 'app/app.dart';
import 'app/dependencies.dart';
import 'app/logging.dart';
import 'data/platform/device_environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final talker = createAppTalker();
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    logFailure(
      talker,
      'Flutter 框架异常',
      details.exception,
      details.stack ?? StackTrace.current,
    );
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    logFailure(talker, '未处理的异步异常', error, stack);
    return true;
  };
  MediaKit.ensureInitialized();
  final emulator = await isAndroidEmulator();
  talker.info('Mamba TV 启动');
  runApp(
    MambaTvApp(
      dependencies: AppDependencies.create(
        androidEmulator: emulator,
        talker: talker,
      ),
    ),
  );
}
