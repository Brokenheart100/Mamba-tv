import '../../domain/failure.dart';

String errorMessage(Object error) {
  if (error is AppFailure) return error.message;
  if (error is FormatException) return error.message;
  return '操作未完成，请重试';
}
