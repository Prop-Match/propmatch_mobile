import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propmatch_mobile/core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

export 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;

  AuthCubit({required this.repository}) : super(const AuthState.initial());

  Future<void> checkAuthStatus() async {
    emit(const AuthState.loading());
    final result = await repository.getCurrentUser();
    if (result.isSuccess && result.data != null) {
      emit(AuthState.authenticated(result.data!));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> login(String email, String password) async {
    emit(const AuthState.loading());
    final result = await repository.login(email, password);
    if (result.isSuccess && result.user != null) {
      emit(AuthState.authenticated(result.user!));
    } else {
      final failure = result.failure;
      if (failure?.statusCode == 403 ||
          (failure is AuthFailure && failure.code == 'EMAIL_NOT_VERIFIED')) {
        // Automatically trigger OTP dispatch to the user's email
        await repository.resendEmailOtp(email);
        emit(AuthState.needsOtpVerification(
          email: email.trim().toLowerCase(),
          message: failure?.message ?? 'يرجى تأكيد بريدك الإلكتروني للمتابعة',
        ));
      } else {
        emit(AuthState.error(failure?.message ?? 'فشل تسجيل الدخول'));
      }
    }
  }

  Future<void> verifyEmailOtp(String email, String code) async {
    emit(const AuthState.loading());
    final result = await repository.verifyEmailOtp(email, code);
    if (result.isSuccess && result.user != null) {
      emit(AuthState.authenticated(result.user!));
    } else {
      emit(AuthState.error(result.failure?.message ?? 'رمز التحقق غير صحيح أو منتهي الصلاحية'));
    }
  }

  Future<bool> resendEmailOtp(String email) async {
    final result = await repository.resendEmailOtp(email);
    return result.isSuccess;
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required UserRole role,
  }) async {
    emit(const AuthState.loading());
    final result = await repository.register(
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
      role: role,
    );
    if (result.isSuccess && result.user != null) {
      emit(AuthState.authenticated(result.user!));
    } else {
      emit(AuthState.error(result.failure?.message ?? 'فشل إنشاء الحساب'));
    }
  }

  Future<void> logout() async {
    emit(const AuthState.loading());
    await repository.logout();
    emit(const AuthState.unauthenticated());
  }
}
