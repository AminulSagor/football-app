import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/api_client.dart';
import '../../core/services/api_error_handler.dart';
import '../../core/services/storage_service.dart';
import '../../core/utils/profile_image_upload_util.dart';
import '../../routes/app_routes.dart';
import 'auth/auth_models/auth_models.dart';
import 'auth/auth_services/auth_services.dart';
import 'auth/signin_modal/signin_view.dart';
import 'model/settings_models.dart';

class SettingsController extends GetxController {
  static final RegExp _fullNamePattern = RegExp(
    r"^[A-Za-z]+(?:[ '-][A-Za-z]+)*$",
  );

  static final RegExp _passwordPattern = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)');

  final SettingsAuthService _authService;
  final ProfileImageUploadUtil _profileImageUploadUtil;

  SettingsController({
    required SettingsAuthService authService,
    required ProfileImageUploadUtil profileImageUploadUtil,
  }) : _authService = authService,
       _profileImageUploadUtil = profileImageUploadUtil;

  final Rx<SettingsViewModel> state = const SettingsViewModel().obs;

  final Rx<SettingsEditProfileViewModel> editProfileState =
      const SettingsEditProfileViewModel().obs;

  final TextEditingController fullNameTextController = TextEditingController();
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController oldPasswordTextController =
      TextEditingController();
  final TextEditingController newPasswordTextController =
      TextEditingController();
  final TextEditingController confirmPasswordTextController =
      TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fullNameTextController.addListener(_onFullNameChanged);
    oldPasswordTextController.addListener(_onOldPasswordChanged);
    newPasswordTextController.addListener(_onNewPasswordChanged);
    confirmPasswordTextController.addListener(_onConfirmPasswordChanged);
    _restoreSession();
  }

  @override
  void onClose() {
    fullNameTextController.dispose();
    emailTextController.dispose();
    oldPasswordTextController.dispose();
    newPasswordTextController.dispose();
    confirmPasswordTextController.dispose();
    super.onClose();
  }

  Future<void> changeProfilePhoto() async {
    final currentUser = state.value.user;

    if (currentUser == null || editProfileState.value.isUploadingPhoto) {
      return;
    }

    final pickedImage = await _profileImageUploadUtil.pickProfileImage();

    if (pickedImage == null || isClosed) {
      return;
    }

    editProfileState.value = editProfileState.value.copyWith(
      isUploadingPhoto: true,
    );

    final response = await ApiErrorHandler.handle<ProfileImageUploadResult>(
      () => _profileImageUploadUtil.uploadAndSetProfilePhoto(pickedImage),
      fallbackErrorCode: 'profile_photo_upload_failed',
      userMessage: 'Could not upload your profile photo. Please try again.',
    );

    if (isClosed) {
      return;
    }

    editProfileState.value = editProfileState.value.copyWith(
      isUploadingPhoto: false,
    );

    if (!response.success || response.data == null) {
      return;
    }

    final result = response.data!;

    final updatedUser = currentUser.copyWith(
      profilePhotoFileId: result.fileId,
      photoReadUrl: result.photoReadUrl,
    );

    state.value = state.value.copyWith(user: updatedUser);

    editProfileState.value = editProfileState.value.copyWith(
      photoReadUrl: result.photoReadUrl,
    );
  }

  Future<void> setUnits(SettingsUnits nextUnits) async {
    final current = state.value;

    if (current.units == nextUnits) {
      return;
    }

    state.value = current.copyWith(units: nextUnits);

    if (!current.isLoggedIn) {
      return;
    }

    final response = await ApiErrorHandler.handle<void>(
      () =>
          _authService.updateUnits(unitSystem: _unitSystemApiValue(nextUnits)),
      fallbackErrorCode: 'settings_units_update_failed',
      userMessage: 'Could not update unit settings right now.',
    );

    if (isClosed) {
      return;
    }

    if (!response.success) {
      state.value = state.value.copyWith(units: current.units);
    }
  }

  Future<void> setMatchAlertsEnabled(bool enabled) async {
    final current = state.value;

    if (!current.isLoggedIn || current.matchAlertsEnabled == enabled) {
      return;
    }

    state.value = current.copyWith(matchAlertsEnabled: enabled);

    final response = await ApiErrorHandler.handle<void>(
      () => _authService.updateMatchAlertsPreference(enabled: enabled),
      fallbackErrorCode: 'match_alerts_update_failed',
      userMessage: 'Could not update match alerts right now.',
    );

    if (isClosed) {
      return;
    }

    if (!response.success) {
      state.value = state.value.copyWith(
        matchAlertsEnabled: current.matchAlertsEnabled,
      );
    }
  }

  Future<void> openSignInModal(BuildContext context) async {
    if (state.value.isAuthBusy) {
      return;
    }

    state.value = state.value.copyWith(isSigningIn: true);

    final session = await SignInModalView.show(context);

    if (isClosed) {
      return;
    }

    state.value = state.value.copyWith(isSigningIn: false);

    if (session == null) {
      return;
    }

    state.value = state.value.copyWith(
      isRestoringSession: false,
      user: session.user,
    );
  }

  Future<void> logout() async {
    final currentState = state.value;

    if (!currentState.isLoggedIn || currentState.isAuthBusy) {
      return;
    }

    state.value = currentState.copyWith(isLoggingOut: true);

    final response = await ApiErrorHandler.handle<SettingsLogoutUiModel>(
      () => _authService.logout(
        SettingsLogoutPayloadModel(token: Get.find<StorageService>().token),
      ),
      fallbackErrorCode: 'settings_logout_failed',
      userMessage: 'Unable to log out. Please try again.',
    );

    if (isClosed) {
      return;
    }

    if (!response.success ||
        response.data == null ||
        !response.data!.loggedOut) {
      state.value = state.value.copyWith(isLoggingOut: false);
      return;
    }

    state.value = state.value.copyWith(isLoggingOut: false, user: null);

    _resetEditProfile();
  }

  void openEditProfile() {
    final user = state.value.user;

    if (user == null) {
      return;
    }

    _hydrateEditProfileFromUser(user);
    Get.toNamed(AppRoutes.settingsEditProfile);
  }

  void toggleSecurityEditing() {
    final current = editProfileState.value;
    final next = !current.isSecurityEditing;

    editProfileState.value = current.copyWith(
      isSecurityEditing: next,
      oldPassword: next ? current.oldPassword : '',
      newPassword: next ? current.newPassword : '',
      confirmPassword: next ? current.confirmPassword : '',
      oldPasswordError: null,
      newPasswordError: null,
      confirmPasswordError: null,
    );

    if (!next) {
      oldPasswordTextController.clear();
      newPasswordTextController.clear();
      confirmPasswordTextController.clear();
    }
  }

  void openForgotPasswordFromEditProfile() {
    final email = editProfileState.value.email.trim();

    Get.toNamed(
      AppRoutes.forgotPassword,
      arguments: <String, dynamic>{'email': email},
    );
  }

  Future<bool> saveEditProfile() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final current = editProfileState.value;

    if (!current.hasChanges) {
      return false;
    }

    if (!_validateEditProfile()) {
      return false;
    }

    editProfileState.value = editProfileState.value.copyWith(isSaving: true);

    final latest = editProfileState.value;

    final payload = SettingsProfileUpdatePayloadModel(
      initialFullName: latest.initialFullName,
      fullName: latest.fullName.trim(),
      email: latest.email,
      oldPassword: latest.oldPassword,
      newPassword: latest.newPassword,
      confirmPassword: latest.confirmPassword,
    );

    final response = await ApiErrorHandler.handle<SettingsProfileUpdateUiModel>(
      () => _authService.updateProfile(payload),
      fallbackErrorCode: 'settings_update_profile_failed',
      userMessage: 'Unable to save profile changes right now.',
    );

    if (isClosed) {
      return false;
    }

    if (!response.success || response.data == null || !response.data!.updated) {
      editProfileState.value = editProfileState.value.copyWith(isSaving: false);
      return false;
    }

    final updatedUser = response.data!.user;

    state.value = state.value.copyWith(user: updatedUser);
    _hydrateEditProfileFromUser(updatedUser);

    return true;
  }

  Future<bool> deleteAccount(String confirmationName) async {
    final user = state.value.user;

    if (user == null) {
      return false;
    }

    final normalized = confirmationName.trim().toLowerCase();

    if (normalized != user.fullName.trim().toLowerCase()) {
      return false;
    }

    editProfileState.value = editProfileState.value.copyWith(
      isDeletingAccount: true,
    );

    final response = await ApiErrorHandler.handle<SettingsDeleteAccountUiModel>(
      () => _authService.deleteAccount(
        SettingsDeleteAccountPayloadModel(
          confirmationName: confirmationName,
          currentUserName: user.fullName,
        ),
      ),
      fallbackErrorCode: 'settings_delete_account_failed',
      userMessage: 'Could not delete this account right now.',
    );

    if (isClosed) {
      return false;
    }

    editProfileState.value = editProfileState.value.copyWith(
      isDeletingAccount: false,
    );

    if (!response.success || response.data == null || !response.data!.deleted) {
      return false;
    }

    state.value = state.value.copyWith(user: null);
    _resetEditProfile();

    return true;
  }

  Future<void> _restoreSession() async {
    state.value = state.value.copyWith(isRestoringSession: true);

    final response = await ApiErrorHandler.handle<SettingsAuthSessionUiModel?>(
      () => _authService.loadSession(const SettingsLoadSessionPayloadModel()),
      fallbackErrorCode: 'settings_restore_session_failed',
      userMessage: 'Could not restore your account state.',
    );

    if (isClosed) {
      return;
    }

    if (!response.success) {
      state.value = state.value.copyWith(isRestoringSession: false, user: null);
      return;
    }

    state.value = state.value.copyWith(
      isRestoringSession: false,
      user: response.data?.user,
    );
  }

  void _hydrateEditProfileFromUser(SettingsUserUiModel user) {
    fullNameTextController.text = user.fullName;
    emailTextController.text = user.email;
    oldPasswordTextController.clear();
    newPasswordTextController.clear();
    confirmPasswordTextController.clear();

    editProfileState.value = SettingsEditProfileViewModel(
      initialFullName: user.fullName,
      fullName: user.fullName,
      email: user.email,
      photoReadUrl: user.photoReadUrl,
    );
  }

  void _resetEditProfile() {
    fullNameTextController.clear();
    emailTextController.clear();
    oldPasswordTextController.clear();
    newPasswordTextController.clear();
    confirmPasswordTextController.clear();

    editProfileState.value = const SettingsEditProfileViewModel();
  }

  bool _validateEditProfile() {
    final current = editProfileState.value;
    final fullName = current.fullName.trim();

    String? fullNameError;
    String? oldPasswordError;
    String? newPasswordError;
    String? confirmPasswordError;

    if (fullName.isEmpty) {
      fullNameError = 'Full name is required';
    } else if (!_fullNamePattern.hasMatch(fullName)) {
      fullNameError = 'Only letters, spaces, hyphen and apostrophe are allowed';
    }

    if (current.hasPasswordChanges) {
      if (current.oldPassword.isEmpty) {
        oldPasswordError = 'Old password is required';
      }

      if (current.newPassword.isEmpty) {
        newPasswordError = 'New password is required';
      } else if (current.newPassword.length < 6) {
        newPasswordError = 'Password must be at least 6 characters';
      } else if (!_passwordPattern.hasMatch(current.newPassword)) {
        newPasswordError =
            'Password must contain at least one letter and one number';
      }

      if (current.confirmPassword.isEmpty) {
        confirmPasswordError = 'Confirm your new password';
      } else if (current.confirmPassword != current.newPassword) {
        confirmPasswordError =
            "Password don't match, Carefully provide your password";
      }
    }

    editProfileState.value = current.copyWith(
      fullName: fullName,
      fullNameError: fullNameError,
      oldPasswordError: oldPasswordError,
      newPasswordError: newPasswordError,
      confirmPasswordError: confirmPasswordError,
    );

    return fullNameError == null &&
        oldPasswordError == null &&
        newPasswordError == null &&
        confirmPasswordError == null;
  }

  String _unitSystemApiValue(SettingsUnits units) {
    switch (units) {
      case SettingsUnits.metric:
        return 'METRIC';
      case SettingsUnits.imperial:
        return 'IMPERIAL';
    }
  }

  void _onFullNameChanged() {
    final next = fullNameTextController.text;

    if (next == editProfileState.value.fullName) {
      return;
    }

    editProfileState.value = editProfileState.value.copyWith(
      fullName: next,
      fullNameError: null,
    );
  }

  void _onOldPasswordChanged() {
    final next = oldPasswordTextController.text;

    if (next == editProfileState.value.oldPassword) {
      return;
    }

    editProfileState.value = editProfileState.value.copyWith(
      oldPassword: next,
      oldPasswordError: null,
    );
  }

  void _onNewPasswordChanged() {
    final next = newPasswordTextController.text;

    if (next == editProfileState.value.newPassword) {
      return;
    }

    editProfileState.value = editProfileState.value.copyWith(
      newPassword: next,
      newPasswordError: null,
      confirmPasswordError: null,
    );
  }

  void _onConfirmPasswordChanged() {
    final next = confirmPasswordTextController.text;

    if (next == editProfileState.value.confirmPassword) {
      return;
    }

    editProfileState.value = editProfileState.value.copyWith(
      confirmPassword: next,
      confirmPasswordError: null,
    );
  }
}

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<SettingsAuthService>()) {
      Get.lazyPut<SettingsAuthService>(
        () => SettingsAuthService(
          apiClient: Get.find<ApiClient>(),
          storageService: Get.find<StorageService>(),
        ),
        fenix: true,
      );
    }

    if (!Get.isRegistered<ProfileImageUploadUtil>()) {
      Get.lazyPut<ProfileImageUploadUtil>(
        () => ProfileImageUploadUtil(apiClient: Get.find<ApiClient>()),
        fenix: true,
      );
    }

    if (!Get.isRegistered<SettingsController>()) {
      Get.lazyPut<SettingsController>(
        () => SettingsController(
          authService: Get.find<SettingsAuthService>(),
          profileImageUploadUtil: Get.find<ProfileImageUploadUtil>(),
        ),
        fenix: true,
      );
    }
  }
}
