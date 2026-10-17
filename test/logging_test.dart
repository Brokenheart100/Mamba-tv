import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mamba_tv/app/logging.dart';

void main() {
  test('Talker caps history and omits private source URLs, payloads and error text', () async {
    final talker = createAppTalker(console: false);
    for (var index = 0; index < 350; index++) {
      talker.info('event $index');
    }
    expect(talker.history.length, 300);
    talker.cleanHistory();
    final dio = Dio();
    addTearDown(dio.close);
    dio.interceptors.add(sourceHttpLogger(talker));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) => handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: 'private-payload',
          ),
          true,
        ),
      ),
    );
    await dio.get('https://example.com/api?token=private-token');
    logFailure(
      talker,
      '播放器异常',
      StateError('https://example.com/private-video.mp4'),
      StackTrace.current,
    );
    final output = talker.history
        .map((log) => log.generateTextMessage())
        .join('\n');
    expect(output, contains('视频源响应 200'));
    expect(output, isNot(contains('private-')));
  });
  test('Riverpod logs state lifecycle without state contents', () {
    final talker = createAppTalker(console: false);
    final provider = Provider<String>(
      (ref) => 'secret-address',
      name: 'testState',
    );
    final container = ProviderContainer(observers: [stateLogger(talker)]);
    container.read(provider);
    container.dispose();
    final output = talker.history
        .map((log) => log.generateTextMessage())
        .join('\n');
    expect(output, contains('testState'));
    expect(output, isNot(contains('secret-address')));
  });
}
