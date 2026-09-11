import 'package:equatable/equatable.dart';

enum UserRole { tenant, landlord }

class UserEntity extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final UserRole role;
  final String? avatarUrl;
  final bool isActive;
  final bool isEmailVerified;
  final bool isIdentityVerified;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.role,
    this.avatarUrl,
    this.isActive = true,
    this.isEmailVerified = false,
    this.isIdentityVerified = false,
  });

  @override
  List<Object?> get props => [
        id,
        fullName,
        email,
        phoneNumber,
        role,
        avatarUrl,
        isActive,
        isEmailVerified,
        isIdentityVerified,
      ];
}
