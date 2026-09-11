import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:propmatch_mobile/core/constants/api_endpoints.dart';
import 'package:propmatch_mobile/core/network/dio_client.dart';
import 'package:propmatch_mobile/core/services/push_notification_service.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  late MobilePushNotificationService service;
  late MockDioClient mockDioClient;

  setUp(() {
    mockDioClient = MockDioClient();
    service = MobilePushNotificationService(dioClient: mockDioClient);
  });

  group('MobilePushNotificationService', () {
    test('registerToken posts token to backend device-token endpoint', () async {
      when(() => mockDioClient.post(
            '${ApiEndpoints.notifications}/device-token',
            data: any(named: 'data'),
          )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 200,
            data: {'ok': true},
          ));

      await service.registerToken('test_fcm_token_123');

      verify(() => mockDioClient.post(
            '${ApiEndpoints.notifications}/device-token',
            data: any(
              named: 'data',
              that: predicate<Map<String, dynamic>>((map) => map['token'] == 'test_fcm_token_123'),
            ),
          )).called(1);
    });

    test('removeToken posts token to backend device-token/remove endpoint', () async {
      when(() => mockDioClient.post(
            '${ApiEndpoints.notifications}/device-token/remove',
            data: any(named: 'data'),
          )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 200,
            data: {'ok': true},
          ));

      await service.removeToken('test_fcm_token_123');

      verify(() => mockDioClient.post(
            '${ApiEndpoints.notifications}/device-token/remove',
            data: any(
              named: 'data',
              that: predicate<Map<String, dynamic>>((map) => map['token'] == 'test_fcm_token_123'),
            ),
          )).called(1);
    });
  });
}
