import 'package:dio/dio.dart';
import '../errors/exceptions.dart';

Exception handleDioError(DioException e) {
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.sendTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.connectionError) {
    return const NetworkException('تعذر الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت');
  }

  final response = e.response;
  if (response != null) {
    final data = response.data;
    String message = 'حدث خطأ غير متوقع';
    String? code;

    if (data is Map<String, dynamic>) {
      if (data['message'] != null) {
        if (data['message'] is List) {
          message = (data['message'] as List).join(', ');
        } else {
          message = data['message'].toString();
        }
      }
      if (data['code'] != null) {
        code = data['code'].toString();
      }
    }

    final statusCode = response.statusCode;
    if (statusCode == 401 || statusCode == 403) {
      return AuthException(message, statusCode: statusCode, code: code);
    }
    return ServerException(message, statusCode: statusCode);
  }

  return const NetworkException('فشل الاتصال بالخادم، يرجى المحاولة لاحقاً');
}
