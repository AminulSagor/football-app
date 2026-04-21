import 'auth/auth_models.dart';

enum SettingsUnits { metric, imperial }

class SettingsViewModel {
  static const Object _unset = Object();
  final SettingsUnits units;
  final bool matchAlertsEnabled;
  final bool isRestoringSession;
  final bool isSigningIn;
  final bool isLoggingOut;
  final SettingsUserUiModel? user;

  const SettingsViewModel({
    this.units = SettingsUnits.metric,
    this.matchAlertsEnabled = true,
    this.isRestoringSession = true,
    this.isSigningIn = false,
    this.isLoggingOut = false,
    this.user,
  });

  bool get isLoggedIn => user != null;
  bool get isAuthBusy => isRestoringSession || isSigningIn || isLoggingOut;

  SettingsViewModel copyWith({
    SettingsUnits? units,
    bool? matchAlertsEnabled,
    bool? isRestoringSession,
    bool? isSigningIn,
    bool? isLoggingOut,
    Object? user = _unset,
    String? avatarLocation,
  }) {
    return SettingsViewModel(
      units: units ?? this.units,
      matchAlertsEnabled: matchAlertsEnabled ?? this.matchAlertsEnabled,
      isRestoringSession: isRestoringSession ?? this.isRestoringSession,
      isSigningIn: isSigningIn ?? this.isSigningIn,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
      user: identical(user, _unset) ? this.user : user as SettingsUserUiModel?,
    );
  }
}

class SettingsEditProfileViewModel {
  static const Object _unset = Object();

  final String initialFullName;
  final String fullName;
  final String email;
  final bool isSecurityEditing;
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;
  final bool isSaving;
  final bool isDeletingAccount;
  final String? fullNameError;
  final String? oldPasswordError;
  final String? newPasswordError;
  final String? confirmPasswordError;

  const SettingsEditProfileViewModel({
    this.initialFullName = '',
    this.fullName = '',
    this.email = '',
    this.isSecurityEditing = false,
    this.oldPassword = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.isSaving = false,
    this.isDeletingAccount = false,
    this.fullNameError,
    this.oldPasswordError,
    this.newPasswordError,
    this.confirmPasswordError,
  });

  bool get hasProfileChanges => fullName.trim() != initialFullName.trim();

  bool get hasPasswordChanges =>
      oldPassword.isNotEmpty ||
      newPassword.isNotEmpty ||
      confirmPassword.isNotEmpty;

  bool get hasChanges => hasProfileChanges || hasPasswordChanges;

  bool get canSave => hasChanges && !isSaving && !isDeletingAccount;

  SettingsEditProfileViewModel copyWith({
    String? initialFullName,
    String? fullName,
    String? email,
    bool? isSecurityEditing,
    String? oldPassword,
    String? newPassword,
    String? confirmPassword,
    bool? isSaving,
    bool? isDeletingAccount,
    Object? fullNameError = _unset,
    Object? oldPasswordError = _unset,
    Object? newPasswordError = _unset,
    Object? confirmPasswordError = _unset,
  }) {
    return SettingsEditProfileViewModel(
      initialFullName: initialFullName ?? this.initialFullName,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      isSecurityEditing: isSecurityEditing ?? this.isSecurityEditing,
      oldPassword: oldPassword ?? this.oldPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isSaving: isSaving ?? this.isSaving,
      isDeletingAccount: isDeletingAccount ?? this.isDeletingAccount,
      fullNameError: identical(fullNameError, _unset)
          ? this.fullNameError
          : fullNameError as String?,
      oldPasswordError: identical(oldPasswordError, _unset)
          ? this.oldPasswordError
          : oldPasswordError as String?,
      newPasswordError: identical(newPasswordError, _unset)
          ? this.newPasswordError
          : newPasswordError as String?,
      confirmPasswordError: identical(confirmPasswordError, _unset)
          ? this.confirmPasswordError
          : confirmPasswordError as String?,
    );
  }
}
