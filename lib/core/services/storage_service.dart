import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _authTokenKey = 'auth_token';
  static const String _userFullNameKey = 'user_full_name';
  static const String _userEmailKey = 'user_email';
  static const String _userAvatarSeedKey = 'user_avatar_seed';

  late SharedPreferences _prefs;
  late bool _isLoggedIn;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    _isLoggedIn = _prefs.getBool(_isLoggedInKey) ?? false;
    return this;
  }

  String get token => _prefs.getString(_authTokenKey) ?? '';
  String get userFullName => _prefs.getString(_userFullNameKey) ?? '';
  String get userEmail => _prefs.getString(_userEmailKey) ?? '';
  String get userAvatarSeed => _prefs.getString(_userAvatarSeedKey) ?? '';

  Future<void> clearToken() async {
    await _prefs.remove(_authTokenKey);
  }

  bool get isLoggedIn => _isLoggedIn;

  Future<void> setLoggedInData(
    String token, {
    required String fullName,
    required String email,
    required String avatarSeed,
  }) async {
    _isLoggedIn = true;
    await _prefs.setBool(_isLoggedInKey, true);
    await _prefs.setString(_authTokenKey, token);
    await _prefs.setString(_userFullNameKey, fullName);
    await _prefs.setString(_userEmailKey, email);
    await _prefs.setString(_userAvatarSeedKey, avatarSeed);
  }

  Future<void> setProfileData({
    required String fullName,
    required String email,
    required String avatarSeed,
  }) async {
    await _prefs.setString(_userFullNameKey, fullName);
    await _prefs.setString(_userEmailKey, email);
    await _prefs.setString(_userAvatarSeedKey, avatarSeed);
  }

  Future<void> clearLoggedInData() async {
    _isLoggedIn = false;
    await _prefs.setBool(_isLoggedInKey, false);
    await _prefs.remove(_authTokenKey);
    await _prefs.remove(_userFullNameKey);
    await _prefs.remove(_userEmailKey);
    await _prefs.remove(_userAvatarSeedKey);
  }
}
