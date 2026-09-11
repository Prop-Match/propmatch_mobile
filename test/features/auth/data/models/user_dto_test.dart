import 'package:flutter_test/flutter_test.dart';
import 'package:propmatch_mobile/features/auth/data/models/user_dto.dart';
import 'package:propmatch_mobile/features/auth/domain/entities/user_entity.dart';

void main() {
  const tUserDto = UserDto(
    id: 'user-123-uuid',
    fullName: 'أحمد محمود',
    email: 'tenant@example.com',
    phoneNumber: '01012345678',
    role: UserRole.tenant,
    isActive: true,
    isEmailVerified: true,
    isIdentityVerified: false,
  );

  final tUserJson = {
    'id': 'user-123-uuid',
    'fullName': 'أحمد محمود',
    'email': 'tenant@example.com',
    'phoneNumber': '01012345678',
    'role': 'TENANT',
    'isActive': true,
    'emailVerifiedAt': '2026-08-01T12:00:00.000Z',
    'identityVerification': null,
  };

  group('UserDto', () {
    test('should be a subclass of UserEntity', () {
      expect(tUserDto, isA<UserEntity>());
    });

    test('fromJson correctly deserializes standard NestJS user payload', () {
      final result = UserDto.fromJson(tUserJson);
      expect(result.id, equals('user-123-uuid'));
      expect(result.fullName, equals('أحمد محمود'));
      expect(result.role, equals(UserRole.tenant));
      expect(result.isEmailVerified, isTrue);
      expect(result.isIdentityVerified, isFalse);
    });

    test('fromJson handles LANDLORD role string correctly', () {
      final landlordJson = Map<String, dynamic>.from(tUserJson)..['role'] = 'LANDLORD';
      final result = UserDto.fromJson(landlordJson);
      expect(result.role, equals(UserRole.landlord));
    });

    test('toJson serializes UserDto to Map', () {
      final json = tUserDto.toJson();
      expect(json['id'], equals('user-123-uuid'));
      expect(json['email'], equals('tenant@example.com'));
      expect(json['role'], equals('TENANT'));
    });
  });
}
