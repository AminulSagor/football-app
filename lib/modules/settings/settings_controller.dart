import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/api_error_handler.dart';
import '../../core/services/storage_service.dart';
import '../../routes/app_routes.dart';
import 'auth/auth_models.dart';
import 'auth/auth_services.dart';
import 'auth/signin_modal/signin_view.dart';
import 'settings_models.dart';

class SettingsController extends GetxController {
  static final RegExp _fullNamePattern = RegExp(
    r"^[A-Za-z]+(?:[ '.-][A-Za-z]+)*$",
  );

  final SettingsAuthService _authService;
  String avatarLocation = 'assets/avatars/default.png';
  SettingsController({required SettingsAuthService authService})
    : _authService = authService;

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

  void setUnits(SettingsUnits nextUnits) {
    state.value = state.value.copyWith(units: nextUnits);
  }

  void setMatchAlertsEnabled(bool enabled) {
    state.value = state.value.copyWith(matchAlertsEnabled: enabled);
  }

  Future<void> openSignInModal(BuildContext context) async {
    if (state.value.isAuthBusy) {
      return;
    }

    final signInInput = await SignInModalView.show(context);
    if (signInInput == null) {
      return;
    }

    state.value = state.value.copyWith(isSigningIn: true);

    final response = await ApiErrorHandler.handle<SettingsAuthSessionUiModel>(
      () => _authService.signIn(
        SettingsSignInPayloadModel(
          email: signInInput.email,
          password: signInInput.password,
        ),
      ),
      fallbackErrorCode: 'settings_sign_in_failed',
      userMessage: 'Could not sign in right now. Please try again.',
    );

    if (isClosed) {
      return;
    }

    if (!response.success || response.data == null) {
      state.value = state.value.copyWith(isSigningIn: false);
      return;
    }

    state.value = state.value.copyWith(
      isSigningIn: false,
      isRestoringSession: false,
      user: response.data!.user,
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

    editProfileState.value = current.copyWith(isSaving: true);

    final payload = SettingsProfileUpdatePayloadModel(
      fullName: editProfileState.value.fullName.trim(),
      email: editProfileState.value.email,
      oldPassword: editProfileState.value.oldPassword,
      newPassword: editProfileState.value.newPassword,
      confirmPassword: editProfileState.value.confirmPassword,
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
      fullNameError = 'Contains Invalid Characters';
    }

    if (current.hasPasswordChanges) {
      if (current.oldPassword.isEmpty) {
        oldPasswordError = 'Old password is required';
      }
      if (current.newPassword.isEmpty) {
        newPasswordError = 'New password is required';
      } else if (current.newPassword.length < 6) {
        newPasswordError = 'Password must be at least 6 characters';
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
        () => SettingsAuthService(storageService: Get.find<StorageService>()),
        fenix: true,
      );
    }

    if (!Get.isRegistered<SettingsController>()) {
      Get.lazyPut<SettingsController>(
        () => SettingsController(authService: Get.find<SettingsAuthService>()),
      );
    }
  }
}
