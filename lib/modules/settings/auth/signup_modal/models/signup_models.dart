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

class SignupRegisterPayload {
  final String fullName;
  final String email;
  final String password;

  const SignupRegisterPayload({
    required this.fullName,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'fullName': fullName,
      'email': email,
      'password': password,
    };
  }
}

class SignupRegisterResult {
  final String email;
  final bool requiresVerification;

  const SignupRegisterResult({
    required this.email,
    required this.requiresVerification,
  });

  factory SignupRegisterResult.fromJson(Map<String, dynamic> json) {
    return SignupRegisterResult(
      email: json['email'] as String? ?? '',
      requiresVerification: json['requiresVerification'] as bool? ?? false,
    );
  }
}

class SignupVerifyEmailPayload {
  final String email;
  final String otp;

  const SignupVerifyEmailPayload({required this.email, required this.otp});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'email': email, 'otp': otp};
  }
}

class SignupVerifiedUserModel {
  final String id;
  final String email;
  final String fullName;
  final String role;

  const SignupVerifiedUserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
  });

  factory SignupVerifiedUserModel.fromJson(Map<String, dynamic> json) {
    return SignupVerifiedUserModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      role: json['role'] as String? ?? '',
    );
  }
}

class SignupTokenModel {
  final String accessToken;
  final String tokenType;
  final String expiresIn;

  const SignupTokenModel({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory SignupTokenModel.fromJson(Map<String, dynamic> json) {
    return SignupTokenModel(
      accessToken: json['accessToken'] as String? ?? '',
      tokenType: json['tokenType'] as String? ?? '',
      expiresIn: json['expiresIn'] as String? ?? '',
    );
  }
}

class SignupVerifyEmailResult {
  final SignupVerifiedUserModel user;
  final SignupTokenModel token;

  const SignupVerifyEmailResult({required this.user, required this.token});

  factory SignupVerifyEmailResult.fromJson(Map<String, dynamic> json) {
    return SignupVerifyEmailResult(
      user: SignupVerifiedUserModel.fromJson(
        (json['user'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
      token: SignupTokenModel.fromJson(
        (json['token'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
    );
  }
}

class SignupResendOtpPayload {
  final String email;

  const SignupResendOtpPayload({required this.email});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'email': email};
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
