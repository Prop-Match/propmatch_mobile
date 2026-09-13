import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../storage/shared_preferences_service.dart';

/// Handles 401 by using the saved refreshToken to get a new accessToken
/// and retries the original request. Mirrors web's browserClient refreshSession().
class RefreshInterceptor extends Interceptor {
  final Dio dio;
  final SharedPreferencesService storage;
  bool _isRefreshing = false;
  Completer<bool>? _refreshCompleter;

  RefreshInterceptor(this.dio, this.storage);

  bool _isAuthPath(String path) {
    return path.contains('/auth/refresh') ||
        path.contains('/auth/login') ||
        path.contains('/auth/register') ||
        path.contains('/auth/verify-email') ||
        path.contains('/auth/resend-email-verification');
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;
    final requestPath = err.requestOptions.path;

    // Only handle 401, not throttling (429) or other errors
    if (status != 401) {
      return handler.next(err);
    }
    // Avoid loop on refresh endpoint itself
    if (_isAuthPath(requestPath)) {
      return handler.next(err);
    }
    // Prevent infinite retry
    if (err.requestOptions.extra['retried'] == true) {
      return handler.next(err);
    }

    final refreshToken = storage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      // No refresh token -> clear session and forward 401
      await storage.clearSession();
      return handler.next(err);
    }

    // Queue concurrent 401s on same refresh promise (like web's refreshPromise)
    if (_isRefreshing) {
      final success = await _refreshCompleter?.future ?? false;
      if (success) {
        return _retryWithNewToken(err, handler);
      } else {
        return handler.next(err);
      }
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<bool>();

    try {
      // Use a fresh Dio without this interceptor to avoid recursion? Use dio but mark extra
      final res = await dio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
        options: Options(
          extra: {'retried': true, 'isRefreshRequest': true},
          // Ensure we don't use stream responseType
          responseType: ResponseType.json,
        ),
      );

      final data = res.data ?? {};
      // Backend returns { accessToken, refreshToken, user } or tokens object
      final newAccess = (data['accessToken'] ?? data['access_token'] ?? data['token']) as String?;
      final newRefresh = (data['refreshToken'] ?? data['refresh_token']) as String?;
      final user = data['user'];

      if (newAccess == null || newAccess.isEmpty) {
        throw DioException(requestOptions: err.requestOptions, error: 'Refresh returned no token');
      }

      await storage.saveAuthToken(newAccess);
      if (newRefresh != null && newRefresh.isNotEmpty) {
        await storage.saveRefreshToken(newRefresh);
      }
      if (user is Map<String, dynamic>) {
        try {
          final jsonStr = jsonEncode(user);
          await storage.saveUserJson(jsonStr);
        } catch (_) {}
      }

      _refreshCompleter?.complete(true);
      return _retryWithNewToken(err, handler);
    } catch (e) {
      _refreshCompleter?.complete(false);
      // Refresh failed -> clear session (like web clearAuthCookies)
      await storage.clearSession();
      return handler.next(err);
    } finally {
      _isRefreshing = false;
      Future.microtask(() => _refreshCompleter = null);
    }
  }

  Future<void> _retryWithNewToken(DioException err, ErrorInterceptorHandler handler) async {
    final newToken = storage.getAuthToken();
    if (newToken == null || newToken.isEmpty) {
      return handler.next(err);
    }
    try {
      final opts = err.requestOptions;
      opts.headers['Authorization'] = 'Bearer $newToken';
      opts.extra['retried'] = true;
      final response = await dio.fetch(opts);
      return handler.resolve(response);
    } catch (e) {
      if (e is DioException) {
        return handler.next(e);
      }
      return handler.next(err);
    }
  }
}
