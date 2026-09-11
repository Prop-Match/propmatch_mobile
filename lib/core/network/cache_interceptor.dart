import 'package:dio/dio.dart';

class CacheInterceptor extends Interceptor {
  final Map<String, _CacheEntry> _cache = {};
  final Duration defaultTtl;

  CacheInterceptor({this.defaultTtl = const Duration(minutes: 5)});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Only cache GET requests
    if (options.method.toUpperCase() != 'GET') {
      return handler.next(options);
    }

    final bool forceRefresh = options.extra['refresh'] == true;
    final key = options.uri.toString();

    if (!forceRefresh && _cache.containsKey(key)) {
      final entry = _cache[key]!;
      if (!entry.isExpired) {
        return handler.resolve(
          Response(
            requestOptions: options,
            data: entry.data,
            statusCode: 200,
            statusMessage: 'OK (From Cache)',
          ),
        );
      } else {
        _cache.remove(key);
      }
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.method.toUpperCase() == 'GET' && response.statusCode == 200) {
      final key = response.requestOptions.uri.toString();
      _cache[key] = _CacheEntry(
        data: response.data,
        expiry: DateTime.now().add(defaultTtl),
      );
    }
    return handler.next(response);
  }

  void clearCache() {
    _cache.clear();
  }
}

class _CacheEntry {
  final dynamic data;
  final DateTime expiry;

  _CacheEntry({required this.data, required this.expiry});

  bool get isExpired => DateTime.now().isAfter(expiry);
}
