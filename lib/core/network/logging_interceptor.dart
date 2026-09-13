import 'dart:developer' as developer;
import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['request_start_time'] = DateTime.now().millisecondsSinceEpoch;

    developer.log(
      '🌐 [DIO REQUEST] ${options.method.toUpperCase()} -> ${options.uri}',
      name: 'PropMatch.Network',
    );
    if (options.headers.isNotEmpty) {
      developer.log('📋 Headers: ${options.headers}', name: 'PropMatch.Network');
    }
    if (options.data != null) {
      developer.log('📦 Data: ${options.data}', name: 'PropMatch.Network');
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = response.requestOptions.extra['request_start_time'] as int?;
    final duration = startTime != null ? DateTime.now().millisecondsSinceEpoch - startTime : 0;

    developer.log(
      '✅ [DIO RESPONSE] ${response.statusCode} ${response.requestOptions.method.toUpperCase()} (${duration}ms) <- ${response.requestOptions.uri}',
      name: 'PropMatch.Network',
    );

    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    developer.log(
      '❌ [DIO ERROR] ${err.response?.statusCode ?? "NO STATUS"} ${err.requestOptions.method.toUpperCase()} <- ${err.requestOptions.uri}',
      name: 'PropMatch.Network',
      error: err.error,
    );
    final data = err.response?.data;
    if (data != null) {
      // For SSE streaming errors, data is ResponseBody - don't log as Instance
      if (data is ResponseBody) {
        developer.log('💥 Error Response: <ResponseBody stream> status=${err.response?.statusCode} headers=${err.response?.headers}', name: 'PropMatch.Network');
      } else {
        developer.log('💥 Error Response: $data', name: 'PropMatch.Network');
      }
    }

    return handler.next(err);
  }
}
