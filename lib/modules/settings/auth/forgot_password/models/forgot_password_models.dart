class ForgotPasswordOtpViewModel {
  static const Object _unset = Object();

  final String email;
  final String code;
  final int resendSeconds;
  final bool isVerifying;
  final bool isResending;
  final String? codeError;

  const ForgotPasswordOtpViewModel({
    required this.email,
    this.code = '',
    this.resendSeconds = 55,
    this.isVerifying = false,
    this.isResending = false,
    this.codeError,
  });

  bool get canVerify => code.length == 4 && !isVerifying;
  bool get canResend => resendSeconds == 0 && !isResending;

  ForgotPasswordOtpViewModel copyWith({
    String? email,
    String? code,
    int? resendSeconds,
    bool? isVerifying,
    bool? isResending,
    Object? codeError = _unset,
  }) {
    return ForgotPasswordOtpViewModel(
      email: email ?? this.email,
      code: code ?? this.code,
      resendSeconds: resendSeconds ?? this.resendSeconds,
      isVerifying: isVerifying ?? this.isVerifying,
      isResending: isResending ?? this.isResending,
      codeError: identical(codeError, _unset)
          ? this.codeError
          : codeError as String?,
    );
  }
}

class ForgotPasswordSendOtpPayload {
  final String email;

  const ForgotPasswordSendOtpPayload({required this.email});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'email': email};
  }
}

class ResetPasswordViewModel {
  static const Object _unset = Object();

  final String email;
  final String otp;
  final String newPassword;
  final String confirmPassword;
  final bool isSubmitting;
  final String? newPasswordError;
  final String? confirmPasswordError;

  const ResetPasswordViewModel({
    required this.email,
    required this.otp,
    this.newPassword = '',
    this.confirmPassword = '',
    this.isSubmitting = false,
    this.newPasswordError,
    this.confirmPasswordError,
  });

  bool get canSubmit =>
      newPassword.isNotEmpty && confirmPassword.isNotEmpty && !isSubmitting;

  ResetPasswordViewModel copyWith({
    String? email,
    String? otp,
    String? newPassword,
    String? confirmPassword,
    bool? isSubmitting,
    Object? newPasswordError = _unset,
    Object? confirmPasswordError = _unset,
  }) {
    return ResetPasswordViewModel(
      email: email ?? this.email,
      otp: otp ?? this.otp,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      newPasswordError: identical(newPasswordError, _unset)
          ? this.newPasswordError
          : newPasswordError as String?,
      confirmPasswordError: identical(confirmPasswordError, _unset)
          ? this.confirmPasswordError
          : confirmPasswordError as String?,
    );
  }
}

class ResetPasswordPayload {
  final String email;
  final String otp;
  final String newPassword;

  const ResetPasswordPayload({
    required this.email,
    required this.otp,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'otp': otp,
      'newPassword': newPassword,
    };
  }
}
