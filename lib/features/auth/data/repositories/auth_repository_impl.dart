import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:propmatch_mobile/core/errors/exceptions.dart';
import 'package:propmatch_mobile/core/errors/failures.dart';
import 'package:propmatch_mobile/core/network/error_handler.dart';
import 'package:propmatch_mobile/core/storage/shared_preferences_service.dart';
import 'package:propmatch_mobile/core/utils/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SharedPreferencesService storageService;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.storageService,
  });

  @override
  Future<AuthResult> login(String email, String password) async {
    try {
      final authResponse = await remoteDataSource.login(email, password);
      await _persistSession(authResponse.token, authResponse.refreshToken, authResponse.user);
      return AuthResult.success(authResponse.user);
    } on DioException catch (e) {
      final appEx = handleDioError(e);
      if (appEx is AuthException) {
        return AuthResult.failure(AuthFailure(appEx.message, statusCode: appEx.statusCode, code: appEx.code));
      } else if (appEx is ServerException) {
        return AuthResult.failure(ServerFailure(appEx.message, statusCode: appEx.statusCode));
      } else if (appEx is NetworkException) {
        return AuthResult.failure(NetworkFailure(appEx.message));
      }
      return AuthResult.failure(ServerFailure(appEx.toString()));
    } on AuthException catch (e) {
      return AuthResult.failure(AuthFailure(e.message, statusCode: e.statusCode, code: e.code));
    } on ServerException catch (e) {
      return AuthResult.failure(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return AuthResult.failure(NetworkFailure(e.message));
    } catch (e) {
      return AuthResult.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<AuthResult> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required UserRole role,
  }) async {
    try {
      final authResponse = await remoteDataSource.register(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        role: role,
      );
      await _persistSession(authResponse.token, authResponse.refreshToken, authResponse.user);
      return AuthResult.success(authResponse.user);
    } on DioException catch (e) {
      final appEx = handleDioError(e);
      if (appEx is AuthException) {
        return AuthResult.failure(AuthFailure(appEx.message, statusCode: appEx.statusCode, code: appEx.code));
      } else if (appEx is ServerException) {
        return AuthResult.failure(ServerFailure(appEx.message, statusCode: appEx.statusCode));
      } else if (appEx is NetworkException) {
        return AuthResult.failure(NetworkFailure(appEx.message));
      }
      return AuthResult.failure(ServerFailure(appEx.toString()));
    } on AuthException catch (e) {
      return AuthResult.failure(AuthFailure(e.message, statusCode: e.statusCode, code: e.code));
    } on ServerException catch (e) {
      return AuthResult.failure(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return AuthResult.failure(NetworkFailure(e.message));
    } catch (e) {
      return AuthResult.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<UserEntity>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getMe();
      await storageService.saveUserJson(jsonEncode(user.toJson()));
      return Result.success(user);
    } on AuthException catch (e) {
      return Result.failure(AuthFailure(e.message, statusCode: e.statusCode));
    } on ServerException catch (e) {
      // Fallback to cached user if available
      final cached = getCachedUser();
      if (cached != null) return Result.success(cached);
      return Result.failure(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      final cached = getCachedUser();
      if (cached != null) return Result.success(cached);
      return Result.failure(NetworkFailure(e.message));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<bool>> logout() async {
    try {
      await storageService.clearSession();
      return const Result.success(true);
    } catch (e) {
      return Result.failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<bool>> sendOtp(String email) async {
    return resendEmailOtp(email);
  }

  @override
  Future<Result<bool>> resendEmailOtp(String email) async {
    try {
      await remoteDataSource.resendEmailVerification(email);
      return const Result.success(true);
    } on DioException catch (e) {
      final appEx = handleDioError(e);
      return Result.failure(ServerFailure(
        appEx is ServerException ? appEx.message : (appEx is AuthException ? appEx.message : 'فشل إرسال رمز التحقق'),
      ));
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<bool>> verifyOtp(String email, String otp) async {
    final result = await verifyEmailOtp(email, otp);
    return result.isSuccess ? const Result.success(true) : Result.failure(result.failure!);
  }

  @override
  Future<AuthResult> verifyEmailOtp(String email, String code) async {
    try {
      final authResponse = await remoteDataSource.verifyEmailOtp(email, code);
      await _persistSession(authResponse.token, authResponse.refreshToken, authResponse.user);
      return AuthResult.success(authResponse.user);
    } on DioException catch (e) {
      final appEx = handleDioError(e);
      if (appEx is AuthException) {
        return AuthResult.failure(AuthFailure(appEx.message, statusCode: appEx.statusCode, code: appEx.code));
      } else if (appEx is ServerException) {
        return AuthResult.failure(ServerFailure(appEx.message, statusCode: appEx.statusCode));
      } else if (appEx is NetworkException) {
        return AuthResult.failure(NetworkFailure(appEx.message));
      }
      return AuthResult.failure(ServerFailure(appEx.toString()));
    } on AuthException catch (e) {
      return AuthResult.failure(AuthFailure(e.message, statusCode: e.statusCode, code: e.code));
    } on ServerException catch (e) {
      return AuthResult.failure(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return AuthResult.failure(NetworkFailure(e.message));
    } catch (e) {
      return AuthResult.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<bool>> forgotPassword(String email) async {
    try {
      await remoteDataSource.forgotPassword(email);
      return const Result.success(true);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<bool>> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.resetPassword(
        email: email,
        token: token,
        newPassword: newPassword,
      );
      return const Result.success(true);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  UserEntity? getCachedUser() {
    final raw = storageService.getUserJson();
    if (raw == null || raw.isEmpty) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return UserDto.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<void> _persistSession(String token, String? refreshToken, UserDto user) async {
    await storageService.saveAuthToken(token);
    if (refreshToken != null) {
      await storageService.saveRefreshToken(refreshToken);
    }
    await storageService.saveUserJson(jsonEncode(user.toJson()));
    await storageService.saveSelectedRole(user.role == UserRole.landlord ? 'LANDLORD' : 'TENANT');
  }
}
