class SignInModalModel {
  static const Object _unset = Object();

  final String email;
  final String password;
  final bool isPasswordVisible;
  final bool isSubmitting;
  final String? emailError;
  final String? passwordError;

  const SignInModalModel({
    this.email = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.isSubmitting = false,
    this.emailError,
    this.passwordError,
  });

  bool get canSubmit =>
      email.trim().isNotEmpty && password.isNotEmpty && !isSubmitting;

  SignInModalModel copyWith({
    String? email,
    String? password,
    bool? isPasswordVisible,
    bool? isSubmitting,
    Object? emailError = _unset,
    Object? passwordError = _unset,
  }) {
    return SignInModalModel(
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      emailError: identical(emailError, _unset)
          ? this.emailError
          : emailError as String?,
      passwordError: identical(passwordError, _unset)
          ? this.passwordError
          : passwordError as String?,
    );
  }
}

class SignInSubmitPayloadModel {
  final String email;
  final String password;

  const SignInSubmitPayloadModel({required this.email, required this.password});
}
