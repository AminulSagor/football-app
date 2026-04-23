import '../../../../core/services/storage_service.dart';
import '../auth_models/auth_models.dart';

class SettingsAuthService {
  final StorageService _storageService;

  SettingsAuthService({required StorageService storageService})
    : _storageService = storageService;

  Future<SettingsAuthSessionUiModel?> loadSession(
    SettingsLoadSessionPayloadModel _,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));

    final token = _storageService.token;
    if (!_storageService.isLoggedIn || token.isEmpty) {
      return null;
    }

    final responseJson = <String, dynamic>{
      'token': token,
      'user': <String, dynamic>{
        'full_name': _storageService.userFullName,
        'email': _storageService.userEmail,
        'avatar_seed': _storageService.userAvatarSeed,
      },
    };

    final session = SettingsAuthSessionUiModel.fromJson(responseJson);
    if (session.user.fullName.trim().isEmpty ||
        session.user.email.trim().isEmpty) {
      await _storageService.clearLoggedInData();
      return null;
    }

    return session;
  }

  Future<SettingsAuthSessionUiModel> signIn(
    SettingsSignInPayloadModel payload,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 320));

    final normalizedEmail = payload.email.trim().toLowerCase();
    final fullName = _deriveNameFromEmail(normalizedEmail);
    final responseJson = <String, dynamic>{
      'token': 'demo-token-${DateTime.now().millisecondsSinceEpoch}',
      'user': <String, dynamic>{
        'full_name': fullName,
        'email': normalizedEmail,
        'avatar_seed': fullName,
      },
    };

    final session = SettingsAuthSessionUiModel.fromJson(responseJson);
    await _storageService.setLoggedInData(
      session.token,
      fullName: session.user.fullName,
      email: session.user.email,
      avatarSeed: session.user.avatarSeed,
    );
    return session;
  }

  Future<SettingsLogoutUiModel> logout(
    SettingsLogoutPayloadModel payload,
  ) async {
    final hadToken = payload.token.trim().isNotEmpty;
    await Future<void>.delayed(const Duration(milliseconds: 220));
    await _storageService.clearLoggedInData();

    final responseJson = <String, dynamic>{
      'logged_out': true,
      'had_token': hadToken,
    };
    return SettingsLogoutUiModel.fromJson(responseJson);
  }

  Future<SettingsProfileUpdateUiModel> updateProfile(
    SettingsProfileUpdatePayloadModel payload,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final responseJson = <String, dynamic>{
      'updated': true,
      'user': <String, dynamic>{
        'full_name': payload.fullName.trim(),
        'email': payload.email.trim().toLowerCase(),
        'avatar_seed': payload.fullName.trim(),
      },
    };

    final result = SettingsProfileUpdateUiModel.fromJson(responseJson);
    await _storageService.setProfileData(
      fullName: result.user.fullName,
      email: result.user.email,
      avatarSeed: result.user.avatarSeed,
    );
    return result;
  }

  Future<SettingsDeleteAccountUiModel> deleteAccount(
    SettingsDeleteAccountPayloadModel payload,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 280));

    final isMatch =
        payload.confirmationName.trim().toLowerCase() ==
        payload.currentUserName.trim().toLowerCase();
    if (!isMatch) {
      throw Exception('delete_account_confirmation_mismatch');
    }

    await _storageService.clearLoggedInData();

    final responseJson = <String, dynamic>{'deleted': true};
    return SettingsDeleteAccountUiModel.fromJson(responseJson);
  }

  String _deriveNameFromEmail(String email) {
    final localPart = email.split('@').first.trim();
    if (localPart.isEmpty) {
      return 'User';
    }

    final normalized = localPart
        .replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), ' ')
        .replaceAll(RegExp(r'[._-]+'), ' ')
        .trim();
    if (normalized.isEmpty) {
      return 'User';
    }

    return normalized
        .split(' ')
        .where((segment) => segment.isNotEmpty)
        .map(
          (segment) =>
              '${segment[0].toUpperCase()}${segment.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}
