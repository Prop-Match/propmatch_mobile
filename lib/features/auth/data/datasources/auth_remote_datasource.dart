import 'package:propmatch_mobile/core/constants/api_endpoints.dart';
import 'package:propmatch_mobile/core/network/dio_client.dart';
import '../models/auth_response_dto.dart';
import '../models/user_dto.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseDto> login(String email, String password);
  Future<AuthResponseDto> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required UserRole role,
  });
  Future<UserDto> getMe();
  Future<void> sendOtp(String email);
  Future<void> resendEmailVerification(String email);
  Future<bool> verifyOtp(String email, String otp);
  Future<AuthResponseDto> verifyEmailOtp(String email, String code);
  Future<void> forgotPassword(String email);
  Future<void> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _client;

  AuthRemoteDataSourceImpl(this._client);

  @override
  Future<AuthResponseDto> login(String email, String password) async {
    final response = await _client.post(
      ApiEndpoints.login,
      data: {
        'email': email.trim().toLowerCase(),
        'password': password,
      },
    );
    return AuthResponseDto.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<AuthResponseDto> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required UserRole role,
  }) async {
    final response = await _client.post(
      ApiEndpoints.register,
      data: {
        'fullName': fullName.trim(),
        'email': email.trim().toLowerCase(),
        'phoneNumber': phoneNumber.trim(),
        'password': password,
        'role': role == UserRole.landlord ? 'LANDLORD' : 'TENANT',
      },
    );
    return AuthResponseDto.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<UserDto> getMe() async {
    final response = await _client.get(ApiEndpoints.me);
    return UserDto.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> sendOtp(String email) async {
    await resendEmailVerification(email);
  }

  @override
  Future<void> resendEmailVerification(String email) async {
    await _client.post(
      ApiEndpoints.resendEmailVerification,
      data: {'email': email.trim().toLowerCase()},
    );
  }

  @override
  Future<bool> verifyOtp(String email, String otp) async {
    try {
      await verifyEmailOtp(email, otp);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<AuthResponseDto> verifyEmailOtp(String email, String code) async {
    final response = await _client.post(
      ApiEndpoints.verifyEmail,
      data: {
        'email': email.trim().toLowerCase(),
        'code': code.trim(),
      },
    );
    return AuthResponseDto.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> forgotPassword(String email) async {
    await _client.post(
      ApiEndpoints.forgotPassword,
      data: {'email': email.trim().toLowerCase()},
    );
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    await _client.post(
      ApiEndpoints.resetPassword,
      data: {
        'email': email.trim().toLowerCase(),
        'token': token,
        'newPassword': newPassword,
      },
    );
  }
}
