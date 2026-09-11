import '../../domain/entities/user_entity.dart';

class UserDto extends UserEntity {
  const UserDto({
    required super.id,
    required super.fullName,
    required super.email,
    required super.phoneNumber,
    required super.role,
    super.avatarUrl,
    super.isActive = true,
    super.isEmailVerified = false,
    super.isIdentityVerified = false,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    UserRole role = UserRole.tenant;
    final roleStr = (json['role'] as String?)?.toUpperCase();
    if (roleStr == 'LANDLORD') {
      role = UserRole.landlord;
    }

    final isEmailVerified = json['emailVerifiedAt'] != null || json['isEmailVerified'] == true;
    final isIdentityVerified = json['identityVerification'] != null &&
        json['identityVerification']['status'] == 'APPROVED';

    return UserDto(
      id: json['id'] as String,
      fullName: (json['fullName'] ?? json['full_name'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      phoneNumber: (json['phoneNumber'] ?? json['phone_number'] ?? '') as String,
      role: role,
      avatarUrl: (json['avatarUrl'] ?? json['avatar_url']) as String?,
      isActive: json['isActive'] ?? json['is_active'] ?? true,
      isEmailVerified: isEmailVerified,
      isIdentityVerified: isIdentityVerified,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role == UserRole.landlord ? 'LANDLORD' : 'TENANT',
      'avatarUrl': avatarUrl,
      'isActive': isActive,
      'isEmailVerified': isEmailVerified,
      'isIdentityVerified': isIdentityVerified,
    };
  }
}
