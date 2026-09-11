import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import 'package:propmatch_mobile/features/auth/domain/entities/user_entity.dart';

class SharedPreferencesService {
  final SharedPreferences _prefs;

  SharedPreferencesService(this._prefs);

  Future<bool> saveAuthToken(String token) async {
    return _prefs.setString(StorageKeys.authToken, token);
  }

  String? getAuthToken() {
    return _prefs.getString(StorageKeys.authToken);
  }

  Future<bool> saveRefreshToken(String refreshToken) async {
    return _prefs.setString(StorageKeys.refreshToken, refreshToken);
  }

  String? getRefreshToken() {
    return _prefs.getString(StorageKeys.refreshToken);
  }

  Future<bool> clearSession() async {
    final removedToken = await _prefs.remove(StorageKeys.authToken);
    final removedRefresh = await _prefs.remove(StorageKeys.refreshToken);
    final removedUser = await _prefs.remove(StorageKeys.cachedUser);
    final removedRole = await _prefs.remove(StorageKeys.selectedRole);
    return (removedToken || true) && (removedRefresh || true) && (removedUser || true) && (removedRole || true);
  }

  Future<bool> clearAuth() => clearSession();

  Future<bool> saveUserJson(String userJson) async {
    return _prefs.setString(StorageKeys.cachedUser, userJson);
  }

  String? getUserJson() {
    return _prefs.getString(StorageKeys.cachedUser);
  }

  Future<bool> saveSelectedRole(String role) async {
    return _prefs.setString(StorageKeys.selectedRole, role);
  }

  String? getSelectedRole() {
    return _prefs.getString(StorageKeys.selectedRole);
  }

  Future<bool> saveUserRole(UserRole role) {
    return saveSelectedRole(role == UserRole.landlord ? 'landlord' : 'tenant');
  }

  UserRole getUserRole() {
    final roleStr = getSelectedRole();
    return roleStr == 'landlord' ? UserRole.landlord : UserRole.tenant;
  }

  Future<bool> setSeenOnboarding(bool seen) async {
    return _prefs.setBool(StorageKeys.hasSeenOnboarding, seen);
  }

  bool hasSeenOnboarding() {
    return _prefs.getBool(StorageKeys.hasSeenOnboarding) ?? false;
  }

  Future<bool> setOnboardingSeen(bool seen) => setSeenOnboarding(seen);
  bool isOnboardingSeen() => hasSeenOnboarding();

  Future<bool> saveSearchFilters(String filtersJson) async {
    return _prefs.setString(StorageKeys.cachedSearchFilters, filtersJson);
  }

  String? getSearchFilters() {
    return _prefs.getString(StorageKeys.cachedSearchFilters);
  }
}
