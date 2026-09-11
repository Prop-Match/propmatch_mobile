import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:propmatch_mobile/core/errors/failures.dart';
import 'package:propmatch_mobile/core/utils/result.dart';
import 'package:propmatch_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:propmatch_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:propmatch_mobile/features/auth/presentation/cubit/auth_cubit.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late AuthCubit authCubit;

  const tUser = UserEntity(
    id: 'user-1',
    fullName: 'أحمد محمود',
    email: 'ahmed@example.com',
    phoneNumber: '+201012345678',
    role: UserRole.tenant,
  );

  setUp(() {
    mockRepository = MockAuthRepository();
    authCubit = AuthCubit(repository: mockRepository);
  });

  tearDown(() {
    authCubit.close();
  });

  test('initial state should be AuthInitial', () {
    expect(authCubit.state, equals(const AuthState.initial()));
  });

  group('checkAuthStatus', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, Authenticated] when session is active',
      build: () {
        when(() => mockRepository.getCurrentUser()).thenAnswer((_) async => const Result.success(tUser));
        return authCubit;
      },
      act: (cubit) => cubit.checkAuthStatus(),
      expect: () => [
        const AuthState.loading(),
        const AuthState.authenticated(tUser),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, Unauthenticated] when no session is active',
      build: () {
        when(() => mockRepository.getCurrentUser()).thenAnswer((_) async => const Result.failure(AuthFailure('No session')));
        return authCubit;
      },
      act: (cubit) => cubit.checkAuthStatus(),
      expect: () => [
        const AuthState.loading(),
        const AuthState.unauthenticated(),
      ],
    );
  });

  group('login', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, Authenticated] on successful login',
      build: () {
        when(() => mockRepository.login(
              'ahmed@example.com',
              'Password123!',
            )).thenAnswer((_) async => const AuthResult.success(tUser));
        return authCubit;
      },
      act: (cubit) => cubit.login(
        'ahmed@example.com',
        'Password123!',
      ),
      expect: () => [
        const AuthState.loading(),
        const AuthState.authenticated(tUser),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthError] on failed login',
      build: () {
        when(() => mockRepository.login(
              'ahmed@example.com',
              'WrongPassword',
            )).thenAnswer((_) async => const AuthResult.failure(AuthFailure('بيانات الدخول غير صحيحة')));
        return authCubit;
      },
      act: (cubit) => cubit.login(
        'ahmed@example.com',
        'WrongPassword',
      ),
      expect: () => [
        const AuthState.loading(),
        const AuthState.error('بيانات الدخول غير صحيحة'),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthNeedsOtpVerification] on 403 EMAIL_NOT_VERIFIED and triggers resendEmailOtp',
      build: () {
        when(() => mockRepository.login(
              'ahmed@example.com',
              'Password123!',
            )).thenAnswer((_) async => const AuthResult.failure(AuthFailure(
              'يرجى تأكيد بريدك الإلكتروني قبل تسجيل الدخول.',
              statusCode: 403,
              code: 'EMAIL_NOT_VERIFIED',
            )));
        when(() => mockRepository.resendEmailOtp('ahmed@example.com'))
            .thenAnswer((_) async => const Result.success(true));
        return authCubit;
      },
      act: (cubit) => cubit.login(
        'ahmed@example.com',
        'Password123!',
      ),
      expect: () => [
        const AuthState.loading(),
        const AuthState.needsOtpVerification(
          email: 'ahmed@example.com',
          message: 'يرجى تأكيد بريدك الإلكتروني قبل تسجيل الدخول.',
        ),
      ],
      verify: (_) {
        verify(() => mockRepository.resendEmailOtp('ahmed@example.com')).called(1);
      },
    );
  });

  group('verifyEmailOtp', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, Authenticated] on successful OTP verification',
      build: () {
        when(() => mockRepository.verifyEmailOtp('ahmed@example.com', '123456'))
            .thenAnswer((_) async => const AuthResult.success(tUser));
        return authCubit;
      },
      act: (cubit) => cubit.verifyEmailOtp('ahmed@example.com', '123456'),
      expect: () => [
        const AuthState.loading(),
        const AuthState.authenticated(tUser),
      ],
    );
  });

  group('logout', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, Unauthenticated] on logout',
      build: () {
        when(() => mockRepository.logout()).thenAnswer((_) async => const Result.success(true));
        return authCubit;
      },
      act: (cubit) => cubit.logout(),
      expect: () => [
        const AuthState.loading(),
        const AuthState.unauthenticated(),
      ],
    );
  });
}
