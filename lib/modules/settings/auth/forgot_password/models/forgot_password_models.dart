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

class ForgotPasswordOtpVerifyPayload {
  final String email;
  final String code;

  const ForgotPasswordOtpVerifyPayload({
    required this.email,
    required this.code,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'email': email, 'code': code};
  }
}

class ForgotPasswordOtpResult {
  final String email;
  final String resetToken;
  final bool verified;

  const ForgotPasswordOtpResult({
    required this.email,
    required this.resetToken,
    required this.verified,
  });

  factory ForgotPasswordOtpResult.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordOtpResult(
      email: json['email'] as String? ?? '',
      resetToken: json['reset_token'] as String? ?? '',
      verified: json['verified'] as bool? ?? false,
    );
  }
}

class ForgotPasswordResendPayload {
  final String email;

  const ForgotPasswordResendPayload({required this.email});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'email': email};
  }
}

class ForgotPasswordResendResult {
  final bool sent;
  final int resendSeconds;

  const ForgotPasswordResendResult({
    required this.sent,
    required this.resendSeconds,
  });

  factory ForgotPasswordResendResult.fromJson(Map<String, dynamic> json) {
    final rawSeconds = json['resend_seconds'];
    final seconds = rawSeconds is int
        ? rawSeconds
        : rawSeconds is num
        ? rawSeconds.toInt()
        : 55;

    return ForgotPasswordResendResult(
      sent: json['sent'] as bool? ?? false,
      resendSeconds: seconds,
    );
  }
}

class ResetPasswordViewModel {
  static const Object _unset = Object();

  final String email;
  final String resetToken;
  final String newPassword;
  final String confirmPassword;
  final bool isSubmitting;
  final String? newPasswordError;
  final String? confirmPasswordError;

  const ResetPasswordViewModel({
    required this.email,
    required this.resetToken,
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
    String? resetToken,
    String? newPassword,
    String? confirmPassword,
    bool? isSubmitting,
    Object? newPasswordError = _unset,
    Object? confirmPasswordError = _unset,
  }) {
    return ResetPasswordViewModel(
      email: email ?? this.email,
      resetToken: resetToken ?? this.resetToken,
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
  final String resetToken;
  final String password;
  final String confirmPassword;

  const ResetPasswordPayload({
    required this.email,
    required this.resetToken,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'reset_token': resetToken,
      'password': password,
      'confirm_password': confirmPassword,
    };
  }
}

class ResetPasswordResult {
  final bool passwordUpdated;

  const ResetPasswordResult({required this.passwordUpdated});

  factory ResetPasswordResult.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResult(
      passwordUpdated: json['password_updated'] as bool? ?? false,
    );
  }
}
