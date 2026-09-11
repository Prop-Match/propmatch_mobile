import 'package:dio/dio.dart';
import '../storage/shared_preferences_service.dart';

class AuthInterceptor extends Interceptor {
  final SharedPreferencesService _storageService;

  AuthInterceptor(this._storageService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _storageService.getAuthToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }
}
