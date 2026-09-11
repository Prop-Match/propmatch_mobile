import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:propmatch_mobile/core/network/dio_client.dart';
import 'package:propmatch_mobile/core/network/auth_interceptor.dart';
import 'package:propmatch_mobile/core/storage/shared_preferences_service.dart';

class MockSharedPreferencesService extends Mock implements SharedPreferencesService {}
class MockRequestInterceptorHandler extends Mock implements RequestInterceptorHandler {}

void main() {
  late MockSharedPreferencesService mockStorage;
  late AuthInterceptor interceptor;

  setUp(() {
    mockStorage = MockSharedPreferencesService();
    interceptor = AuthInterceptor(mockStorage);
  });

  group('AuthInterceptor', () {
    test('adds Authorization header when token exists', () async {
      when(() => mockStorage.getAuthToken()).thenReturn('test-jwt-token');

      final options = RequestOptions(path: '/properties');
      final handler = MockRequestInterceptorHandler();

      interceptor.onRequest(options, handler);

      expect(options.headers['Authorization'], equals('Bearer test-jwt-token'));
      verify(() => handler.next(options)).called(1);
    });

    test('does not add Authorization header when token is null', () async {
      when(() => mockStorage.getAuthToken()).thenReturn(null);

      final options = RequestOptions(path: '/properties');
      final handler = MockRequestInterceptorHandler();

      interceptor.onRequest(options, handler);

      expect(options.headers['Authorization'], isNull);
      verify(() => handler.next(options)).called(1);
    });
  });

  group('DioClient', () {
    test('initializes with correct baseUrl and headers', () {
      final client = DioClient(
        storageService: mockStorage,
        baseUrl: 'https://propmatch.technative.me',
      );

      expect(client.dio.options.baseUrl, equals('https://propmatch.technative.me'));
      expect(client.dio.options.headers['Accept'], equals('application/json'));
    });
  });
}
