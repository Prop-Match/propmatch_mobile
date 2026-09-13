import 'dart:convert';
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

    // Handle both Map and ResponseBody/stream errors
    Map<String, dynamic>? mapData;
    if (data is Map<String, dynamic>) {
      mapData = data;
    } else if (data is String) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic>) mapData = decoded;
      } catch (_) {}
    } else if (data is ResponseBody) {
      // Stream error - body not yet decoded (429/401 on SSE)
      // Treat as throttling or auth based on status
      if (response.statusCode == 429) {
        return const ServerException('تم تجاوز الحد المسموح (20 رسالة في الدقيقة)، يرجى الانتظار دقيقة ثم المحاولة مرة أخرى', statusCode: 429);
      }
      if (response.statusCode == 401) {
        return const AuthException('انتهت صلاحية الجلسة، جارٍ إعادة تسجيل الدخول تلقائياً', statusCode: 401);
      }
    }

    if (mapData != null) {
      if (mapData['message'] != null) {
        if (mapData['message'] is List) {
          message = (mapData['message'] as List).join(', ');
        } else {
          message = mapData['message'].toString();
        }
      }
      if (mapData['code'] != null) {
        code = mapData['code'].toString();
      }
    } else if (data is String && data.isNotEmpty) {
      message = data;
    }

    final statusCode = response.statusCode;
    if (statusCode == 429) {
      return ServerException(
        message.contains('حدث خطأ') ? 'تم تجاوز الحد المسموح (20 رسالة في الدقيقة)، يرجى الانتظار دقيقة ثم المحاولة مرة أخرى' : message,
        statusCode: statusCode,
      );
    }
    if (statusCode == 401 || statusCode == 403) {
      return AuthException(message, statusCode: statusCode, code: code);
    }
    return ServerException(message, statusCode: statusCode);
  }

  return const NetworkException('فشل الاتصال بالخادم، يرجى المحاولة لاحقاً');
}
