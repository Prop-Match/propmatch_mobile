import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:propmatch_mobile/core/network/dio_client.dart';
import 'package:propmatch_mobile/core/constants/api_endpoints.dart';
import 'package:propmatch_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:propmatch_mobile/features/auth/domain/entities/user_entity.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  late MockDioClient mockDioClient;
  late AuthRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDioClient = MockDioClient();
    dataSource = AuthRemoteDataSourceImpl(mockDioClient);
  });

  const tUserJson = {
    'id': 'user-123',
    'fullName': 'أحمد محمود',
    'email': 'tenant@example.com',
    'phoneNumber': '01012345678',
    'role': 'TENANT',
    'isActive': true,
  };

  group('login', () {
    test('calls POST /auth/login and returns AuthResponseDto', () async {
      final responseData = {
        'accessToken': 'jwt_access_token',
        'user': tUserJson,
      };

      when(() => mockDioClient.post(
            ApiEndpoints.login,
            data: any(named: 'data'),
          )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ApiEndpoints.login),
            data: responseData,
            statusCode: 200,
          ));

      final result = await dataSource.login('tenant@example.com', 'password123');

      expect(result.token, equals('jwt_access_token'));
      expect(result.user.id, equals('user-123'));
      expect(result.user.role, equals(UserRole.tenant));
      verify(() => mockDioClient.post(
            ApiEndpoints.login,
            data: {
              'email': 'tenant@example.com',
              'password': 'password123',
            },
          )).called(1);
    });
  });

  group('register', () {
    test('calls POST /auth/register and returns AuthResponseDto', () async {
      final responseData = {
        'accessToken': 'jwt_access_token',
        'user': tUserJson,
      };

      when(() => mockDioClient.post(
            ApiEndpoints.register,
            data: any(named: 'data'),
          )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ApiEndpoints.register),
            data: responseData,
            statusCode: 201,
          ));

      final result = await dataSource.register(
        fullName: 'أحمد محمود',
        email: 'tenant@example.com',
        phoneNumber: '01012345678',
        password: 'password123',
        role: UserRole.tenant,
      );

      expect(result.token, equals('jwt_access_token'));
      verify(() => mockDioClient.post(
            ApiEndpoints.register,
            data: {
              'fullName': 'أحمد محمود',
              'email': 'tenant@example.com',
              'phoneNumber': '01012345678',
              'password': 'password123',
              'role': 'TENANT',
            },
          )).called(1);
    });
  });
}
