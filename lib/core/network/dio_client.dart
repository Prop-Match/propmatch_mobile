import 'package:dio/dio.dart';
import 'package:propmatch_mobile/core/storage/shared_preferences_service.dart';
import 'auth_interceptor.dart';
import 'cache_interceptor.dart';
import 'logging_interceptor.dart';
import 'refresh_interceptor.dart';

class DioClient {
  final Dio _dio;
  final SharedPreferencesService storageService;
  final CacheInterceptor cacheInterceptor;

  DioClient({
    required this.storageService,
    required String baseUrl,
    Dio? dio,
  })  : cacheInterceptor = CacheInterceptor(),
        _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl,
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
                sendTimeout: const Duration(seconds: 15),
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            ) {
    _dio.interceptors.addAll([
      AuthInterceptor(storageService),
      cacheInterceptor,
      LoggingInterceptor(),
    ]);
    // Refresh must be after Auth but handle 401 before other handlers
    // Insert refresh logic: we need dio reference, so add now
    _dio.interceptors.add(RefreshInterceptor(_dio, storageService));
  }

  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool forceRefresh = false,
  }) async {
    final opts = options ?? Options();
    if (forceRefresh) {
      opts.extra = {...?opts.extra, 'refresh': true};
    }
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: opts,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }
}
