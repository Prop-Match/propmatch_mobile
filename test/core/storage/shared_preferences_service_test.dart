import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:propmatch_mobile/core/constants/app_constants.dart';
import 'package:propmatch_mobile/core/storage/shared_preferences_service.dart';
import 'package:propmatch_mobile/features/auth/domain/entities/user_entity.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockPrefs;
  late SharedPreferencesService service;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    service = SharedPreferencesService(mockPrefs);
  });

  group('SharedPreferencesService', () {
    test('saves and retrieves auth token correctly', () async {
      when(() => mockPrefs.setString(StorageKeys.authToken, 'jwt123')).thenAnswer((_) async => true);
      when(() => mockPrefs.getString(StorageKeys.authToken)).thenReturn('jwt123');

      await service.saveAuthToken('jwt123');
      final token = service.getAuthToken();

      expect(token, equals('jwt123'));
      verify(() => mockPrefs.setString(StorageKeys.authToken, 'jwt123')).called(1);
    });

    test('saves and retrieves refresh token correctly', () async {
      when(() => mockPrefs.setString(StorageKeys.refreshToken, 'refresh123')).thenAnswer((_) async => true);
      when(() => mockPrefs.getString(StorageKeys.refreshToken)).thenReturn('refresh123');

      await service.saveRefreshToken('refresh123');
      final refreshToken = service.getRefreshToken();

      expect(refreshToken, equals('refresh123'));
      verify(() => mockPrefs.setString(StorageKeys.refreshToken, 'refresh123')).called(1);
    });

    test('clears auth tokens on logout', () async {
      when(() => mockPrefs.remove(StorageKeys.authToken)).thenAnswer((_) async => true);
      when(() => mockPrefs.remove(StorageKeys.refreshToken)).thenAnswer((_) async => true);
      when(() => mockPrefs.remove(StorageKeys.cachedUser)).thenAnswer((_) async => true);
      when(() => mockPrefs.remove(StorageKeys.selectedRole)).thenAnswer((_) async => true);

      await service.clearAuth();

      verify(() => mockPrefs.remove(StorageKeys.authToken)).called(1);
      verify(() => mockPrefs.remove(StorageKeys.refreshToken)).called(1);
      verify(() => mockPrefs.remove(StorageKeys.cachedUser)).called(1);
      verify(() => mockPrefs.remove(StorageKeys.selectedRole)).called(1);
    });

    test('saves and retrieves user JSON string', () async {
      const userJson = '{"id":"1","fullName":"أحمد"}';
      when(() => mockPrefs.setString(StorageKeys.cachedUser, userJson)).thenAnswer((_) async => true);
      when(() => mockPrefs.getString(StorageKeys.cachedUser)).thenReturn(userJson);

      await service.saveUserJson(userJson);
      final retrieved = service.getUserJson();

      expect(retrieved, equals(userJson));
    });

    test('saves and retrieves selected user role (tenant or landlord)', () async {
      when(() => mockPrefs.setString(StorageKeys.selectedRole, 'tenant')).thenAnswer((_) async => true);
      when(() => mockPrefs.getString(StorageKeys.selectedRole)).thenReturn('tenant');

      await service.saveUserRole(UserRole.tenant);
      final role = service.getUserRole();

      expect(role, equals(UserRole.tenant));
    });

    test('handles onboarding seen flag', () async {
      when(() => mockPrefs.setBool(StorageKeys.hasSeenOnboarding, true)).thenAnswer((_) async => true);
      when(() => mockPrefs.getBool(StorageKeys.hasSeenOnboarding)).thenReturn(true);

      await service.setOnboardingSeen(true);
      final seen = service.isOnboardingSeen();

      expect(seen, isTrue);
    });
  });
}
