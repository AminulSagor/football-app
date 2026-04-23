class CreateAccountModalModel {
  static const Object _unset = Object();

  final String fullName;
  final String email;
  final String password;
  final bool acceptedTerms;
  final bool isPasswordVisible;
  final bool isSubmitting;

  final String? fullNameError;
  final String? emailError;
  final String? passwordError;
  final String? termsError;

  const CreateAccountModalModel({
    this.fullName = '',
    this.email = '',
    this.password = '',
    this.acceptedTerms = false,
    this.isPasswordVisible = false,
    this.isSubmitting = false,
    this.fullNameError,
    this.emailError,
    this.passwordError,
    this.termsError,
  });

  bool get canSubmit =>
      fullName.trim().isNotEmpty &&
      email.trim().isNotEmpty &&
      password.isNotEmpty &&
      acceptedTerms &&
      !isSubmitting;

  CreateAccountModalModel copyWith({
    String? fullName,
    String? email,
    String? password,
    bool? acceptedTerms,
    bool? isPasswordVisible,
    bool? isSubmitting,
    Object? fullNameError = _unset,
    Object? emailError = _unset,
    Object? passwordError = _unset,
    Object? termsError = _unset,
  }) {
    return CreateAccountModalModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      acceptedTerms: acceptedTerms ?? this.acceptedTerms,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      fullNameError: identical(fullNameError, _unset)
          ? this.fullNameError
          : fullNameError as String?,
      emailError: identical(emailError, _unset)
          ? this.emailError
          : emailError as String?,
      passwordError: identical(passwordError, _unset)
          ? this.passwordError
          : passwordError as String?,
      termsError: identical(termsError, _unset)
          ? this.termsError
          : termsError as String?,
    );
  }
}

class OtpVerificationModel {
  static const Object _unset = Object();

  final String email;
  final String code;
  final bool isVerifying;
  final int resendSeconds;
  final String? codeError;

  const OtpVerificationModel({
    required this.email,
    this.code = '',
    this.isVerifying = false,
    this.resendSeconds = 55,
    this.codeError,
  });

  bool get canVerify => code.length == 4 && !isVerifying;

  OtpVerificationModel copyWith({
    String? email,
    String? code,
    bool? isVerifying,
    int? resendSeconds,
    Object? codeError = _unset,
  }) {
    return OtpVerificationModel(
      email: email ?? this.email,
      code: code ?? this.code,
      isVerifying: isVerifying ?? this.isVerifying,
      resendSeconds: resendSeconds ?? this.resendSeconds,
      codeError: identical(codeError, _unset)
          ? this.codeError
          : codeError as String?,
    );
  }
}

class ProfilePicUploadModel {
  final bool hasSelectedPhoto;
  final bool isSubmitting;

  const ProfilePicUploadModel({
    this.hasSelectedPhoto = false,
    this.isSubmitting = false,
  });

  ProfilePicUploadModel copyWith({bool? hasSelectedPhoto, bool? isSubmitting}) {
    return ProfilePicUploadModel(
      hasSelectedPhoto: hasSelectedPhoto ?? this.hasSelectedPhoto,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
