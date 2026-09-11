import 'package:propmatch_mobile/core/utils/result.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<AuthResult> login(String email, String password);
  Future<AuthResult> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required UserRole role,
  });
  Future<Result<UserEntity>> getCurrentUser();
  Future<Result<bool>> logout();
  Future<Result<bool>> sendOtp(String email);
  Future<Result<bool>> resendEmailOtp(String email);
  Future<Result<bool>> verifyOtp(String email, String otp);
  Future<AuthResult> verifyEmailOtp(String email, String code);
  Future<Result<bool>> forgotPassword(String email);
  Future<Result<bool>> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  });
  UserEntity? getCachedUser();
}
