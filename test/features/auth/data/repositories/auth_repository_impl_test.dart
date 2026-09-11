import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:propmatch_mobile/core/errors/exceptions.dart';
import 'package:propmatch_mobile/core/errors/failures.dart';
import 'package:propmatch_mobile/core/storage/shared_preferences_service.dart';
import 'package:propmatch_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:propmatch_mobile/features/auth/data/models/auth_response_dto.dart';
import 'package:propmatch_mobile/features/auth/data/models/user_dto.dart';
import 'package:propmatch_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:propmatch_mobile/features/auth/domain/entities/user_entity.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}
class MockSharedPreferencesService extends Mock implements SharedPreferencesService {}

void main() {
  late MockAuthRemoteDataSource mockRemote;
  late MockSharedPreferencesService mockStorage;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockRemote = MockAuthRemoteDataSource();
    mockStorage = MockSharedPreferencesService();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemote,
      storageService: mockStorage,
    );
  });

  const tUserDto = UserDto(
    id: 'u1',
    fullName: 'أحمد محمود',
    email: 'tenant@example.com',
    phoneNumber: '01012345678',
    role: UserRole.tenant,
    isActive: true,
  );

  const tAuthResponse = AuthResponseDto(
    token: 'jwt_123',
    refreshToken: 'refresh_123',
    user: tUserDto,
  );

  group('login', () {
    test('successful login saves token & user to storage and returns user', () async {
      when(() => mockRemote.login(any(), any())).thenAnswer((_) async => tAuthResponse);
      when(() => mockStorage.saveAuthToken(any())).thenAnswer((_) async => true);
      when(() => mockStorage.saveRefreshToken(any())).thenAnswer((_) async => true);
      when(() => mockStorage.saveUserJson(any())).thenAnswer((_) async => true);
      when(() => mockStorage.saveSelectedRole(any())).thenAnswer((_) async => true);

      final result = await repository.login('tenant@example.com', 'password123');

      expect(result.isSuccess, isTrue);
      expect(result.user, equals(tUserDto));
      verify(() => mockStorage.saveAuthToken('jwt_123')).called(1);
    });

    test('returns AuthFailure when invalid credentials provided', () async {
      when(() => mockRemote.login(any(), any()))
          .thenThrow(const AuthException('بيانات الدخول غير صحيحة', statusCode: 401));

      final result = await repository.login('tenant@example.com', 'wrong');

      expect(result.isSuccess, isFalse);
      expect(result.failure, isA<AuthFailure>());
      expect(result.failure?.message, equals('بيانات الدخول غير صحيحة'));
    });
  });

  group('OTP', () {
    test('resendEmailOtp calls remoteDataSource.resendEmailVerification', () async {
      when(() => mockRemote.resendEmailVerification('tenant@example.com'))
          .thenAnswer((_) async {});

      final result = await repository.resendEmailOtp('tenant@example.com');

      expect(result.isSuccess, isTrue);
      verify(() => mockRemote.resendEmailVerification('tenant@example.com')).called(1);
    });

    test('verifyEmailOtp saves session and returns user on success', () async {
      when(() => mockRemote.verifyEmailOtp('tenant@example.com', '123456'))
          .thenAnswer((_) async => tAuthResponse);
      when(() => mockStorage.saveAuthToken(any())).thenAnswer((_) async => true);
      when(() => mockStorage.saveRefreshToken(any())).thenAnswer((_) async => true);
      when(() => mockStorage.saveUserJson(any())).thenAnswer((_) async => true);
      when(() => mockStorage.saveSelectedRole(any())).thenAnswer((_) async => true);

      final result = await repository.verifyEmailOtp('tenant@example.com', '123456');

      expect(result.isSuccess, isTrue);
      expect(result.user, equals(tUserDto));
      verify(() => mockStorage.saveAuthToken('jwt_123')).called(1);
    });
  });

  group('logout', () {
    test('clears session from storage', () async {
      when(() => mockStorage.clearSession()).thenAnswer((_) async => true);

      final result = await repository.logout();

      expect(result.isSuccess, isTrue);
      verify(() => mockStorage.clearSession()).called(1);
    });
  });
}
