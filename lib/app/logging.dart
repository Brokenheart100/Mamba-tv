import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';

Talker createAppTalker({bool console = kDebugMode}) => TalkerFlutter.init(
  settings: TalkerSettings(maxHistoryItems: 300, useConsoleLogs: console),
);

TalkerDioLogger catalogHttpLogger(Talker talker) => TalkerDioLogger(
  talker: talker,
  settings: const TalkerDioLoggerSettings(
    printRequestData: false,
    printRequestHeaders: false,
    printRequestExtra: false,
    printResponseData: false,
    printResponseHeaders: false,
    printErrorData: false,
    printErrorHeaders: false,
    printErrorMessage: false,
    printResponseTime: true,
  ),
);

TalkerRiverpodObserver stateLogger(Talker talker) => TalkerRiverpodObserver(
  talker: talker,
  settings: TalkerRiverpodLoggerSettings(
    enabled: kDebugMode,
    printProviderDisposed: true,
    printStateFullData: false,
    printFailFullData: false,
    providerFilter: (provider) => provider.name != 'playback',
  ),
);

/// Errors from providers or media libraries can contain private playback URLs.
/// Keep the failure type and stack; omit external exception messages.
void logFailure(Talker talker, String action, Object error, StackTrace stack) {
  talker.error('$action (${error.runtimeType})', null, stack);
}

/// Source endpoints can contain credentials in their query. These logs retain
/// timing/status only, without retaining Dio responses or private media URLs.
Interceptor sourceHttpLogger(Talker talker) => InterceptorsWrapper(
  onRequest: (options, handler) {
    options.extra['source_started'] = DateTime.now();
    talker.debug(
      '视频源请求 ${options.method} · ${options.extra['source_id'] ?? '-'}',
    );
    handler.next(options);
  },
  onResponse: (response, handler) {
    final started =
        response.requestOptions.extra['source_started'] as DateTime?;
    final elapsed = started == null
        ? 0
        : DateTime.now().difference(started).inMilliseconds;
    talker.info(
      '视频源响应 ${response.statusCode} · ${elapsed}ms · ${response.requestOptions.extra['source_id'] ?? '-'}',
    );
    handler.next(response);
  },
  onError: (error, handler) {
    talker.warning(
      '视频源请求失败 ${error.type.name} · ${error.response?.statusCode ?? '-'}',
    );
    handler.next(error);
  },
);
