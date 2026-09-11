import 'user_dto.dart';

class AuthResponseDto {
  final String token;
  final String? refreshToken;
  final UserDto user;

  const AuthResponseDto({
    required this.token,
    this.refreshToken,
    required this.user,
  });

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    final token = (json['accessToken'] ?? json['access_token'] ?? json['token'] ?? '') as String;
    final refreshToken = (json['refreshToken'] ?? json['refresh_token']) as String?;
    
    // User might be nested or in root
    Map<String, dynamic> userMap = {};
    if (json['user'] is Map<String, dynamic>) {
      userMap = json['user'] as Map<String, dynamic>;
    } else {
      userMap = json;
    }

    return AuthResponseDto(
      token: token,
      refreshToken: refreshToken,
      user: UserDto.fromJson(userMap),
    );
  }
}
