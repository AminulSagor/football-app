import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _authTokenKey = 'auth_token';
  static const String _authTokenTypeKey = 'auth_token_type';
  static const String _authTokenExpiresKey = 'auth_token_expires';
  static const String _userFullNameKey = 'user_full_name';
  static const String _userEmailKey = 'user_email';
  static const String _userAvatarSeedKey = 'user_avatar_seed';
  static const String _userIdKey = 'user_id';
  static const String _userRoleKey = 'user_role';

  late SharedPreferences _prefs;
  late bool _isLoggedIn;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    _isLoggedIn = _prefs.getBool(_isLoggedInKey) ?? false;
    return this;
  }

  String get token => _prefs.getString(_authTokenKey) ?? '';
  String get tokenType => _prefs.getString(_authTokenTypeKey) ?? '';
  String get tokenExpires => _prefs.getString(_authTokenExpiresKey) ?? '';
  String get userFullName => _prefs.getString(_userFullNameKey) ?? '';
  String get userEmail => _prefs.getString(_userEmailKey) ?? '';
  String get userAvatarSeed => _prefs.getString(_userAvatarSeedKey) ?? '';
  String get userId => _prefs.getString(_userIdKey) ?? '';
  String get userRole => _prefs.getString(_userRoleKey) ?? '';

  Future<void> clearToken() async {
    await _prefs.remove(_authTokenKey);
  }

  bool get isLoggedIn => _isLoggedIn;

  // Future<void>

  Future<void> setLoggedInData(
    String token, {
    required String fullName,
    required String email,
    required String avatarSeed,
    String? tokenType,
    String? expiresIn,
    String? userId,
    String? role,
  }) async {
    _isLoggedIn = true;
    await _prefs.setBool(_isLoggedInKey, true);
    await _prefs.setString(_authTokenKey, token);
    if (tokenType != null) {
      await _prefs.setString(_authTokenTypeKey, tokenType);
    }
    if (expiresIn != null) {
      await _prefs.setString(_authTokenExpiresKey, expiresIn);
    }
    await _prefs.setString(_userFullNameKey, fullName);
    await _prefs.setString(_userEmailKey, email);
    await _prefs.setString(_userAvatarSeedKey, avatarSeed);
    if (userId != null) {
      await _prefs.setString(_userIdKey, userId);
    }
    if (role != null) {
      await _prefs.setString(_userRoleKey, role);
    }
  }

  Future<void> setProfileData({
    required String fullName,
    required String email,
    required String avatarSeed,
    String? role,
  }) async {
    await _prefs.setString(_userFullNameKey, fullName);
    await _prefs.setString(_userEmailKey, email);
    await _prefs.setString(_userAvatarSeedKey, avatarSeed);
    if (role != null) {
      await _prefs.setString(_userRoleKey, role);
    }
  }

  Future<void> clearLoggedInData() async {
    _isLoggedIn = false;
    await _prefs.setBool(_isLoggedInKey, false);
    await _prefs.remove(_authTokenKey);
    await _prefs.remove(_authTokenTypeKey);
    await _prefs.remove(_authTokenExpiresKey);
    await _prefs.remove(_userFullNameKey);
    await _prefs.remove(_userEmailKey);
    await _prefs.remove(_userAvatarSeedKey);
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_userRoleKey);
  }
}
