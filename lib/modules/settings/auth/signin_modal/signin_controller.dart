import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/services/api_error_handler.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../routes/app_routes.dart';
import '../auth_models/auth_models.dart';
import '../auth_services/auth_services.dart';
import '../forgot_password/models/forgot_password_models.dart';
import '../forgot_password/services/forgot_password_service.dart';
import 'models/models.dart';

class SignInController extends GetxController {
  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  final SettingsAuthService _authService;
  final ForgotPasswordService _forgotPasswordService;

  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  final Rx<SignInModalModel> state = const SignInModalModel().obs;

  SignInController({
    required SettingsAuthService authService,
    required ForgotPasswordService forgotPasswordService,
  }) : _authService = authService,
       _forgotPasswordService = forgotPasswordService;

  @override
  void onInit() {
    super.onInit();
    emailTextController.addListener(_onEmailChanged);
    passwordTextController.addListener(_onPasswordChanged);
  }

  @override
  void onClose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    super.onClose();
  }

  void _onEmailChanged() {
    final nextEmail = emailTextController.text;

    if (nextEmail == state.value.email) {
      return;
    }

    state.value = state.value.copyWith(email: nextEmail, emailError: null);
  }

  void _onPasswordChanged() {
    final nextPassword = passwordTextController.text;

    if (nextPassword == state.value.password) {
      return;
    }

    state.value = state.value.copyWith(
      password: nextPassword,
      passwordError: null,
    );
  }

  void togglePasswordVisibility() {
    state.value = state.value.copyWith(
      isPasswordVisible: !state.value.isPasswordVisible,
    );
  }

  Future<void> submit() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!_validate()) {
      return;
    }

    state.value = state.value.copyWith(isSubmitting: true);

    final payload = SettingsSignInPayloadModel(
      email: state.value.email.trim(),
      password: state.value.password,
    );

    try {
      final session = await _authService.signIn(payload);

      if (isClosed) {
        return;
      }

      state.value = state.value.copyWith(isSubmitting: false);

      Get.back<SettingsAuthSessionUiModel>(result: session);
    } on dio.DioException catch (error) {
      String? message;

      final data = error.response?.data;

      if (data is Map<String, dynamic>) {
        final rawMessage = data['message'];

        if (rawMessage is String && rawMessage.trim().isNotEmpty) {
          message = rawMessage.trim();
        } else if (rawMessage is List && rawMessage.isNotEmpty) {
          final first = rawMessage.first;

          if (first is String && first.trim().isNotEmpty) {
            message = first.trim();
          }
        }
      }

      if (error.response?.statusCode == 401 ||
          (message != null && message.toLowerCase().contains('invalid'))) {
        state.value = state.value.copyWith(
          isSubmitting: false,
          passwordError: message ?? 'Invalid email or password',
          emailError: null,
        );
        return;
      }

      state.value = state.value.copyWith(isSubmitting: false);

      Get.closeAllSnackbars();
      Get.snackbar(
        'Error',
        message ?? 'Could not sign in right now. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.snackbarBackground,
        colorText: AppColors.snackbarText,
        margin: EdgeInsets.all(14.r),
        duration: const Duration(seconds: 2),
      );
    } catch (_) {
      state.value = state.value.copyWith(isSubmitting: false);

      Get.closeAllSnackbars();
      Get.snackbar(
        'Error',
        'Could not sign in right now. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.snackbarBackground,
        colorText: AppColors.snackbarText,
        margin: EdgeInsets.all(14.r),
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> forgotPassword() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!_validateForgotPasswordEmail()) {
      return;
    }

    if (state.value.isSendingResetOtp) {
      return;
    }

    final email = state.value.email.trim();

    state.value = state.value.copyWith(isSendingResetOtp: true);

    final response = await ApiErrorHandler.handle<void>(
      () => _forgotPasswordService.sendResetOtp(
        ForgotPasswordSendOtpPayload(email: email),
      ),
      fallbackErrorCode: 'forgot_password_failed',
      userMessage: 'Could not send reset code. Please try again.',
    );

    if (isClosed) {
      return;
    }

    state.value = state.value.copyWith(isSendingResetOtp: false);

    if (!response.success) {
      return;
    }

    Get.back<void>();

    Future.microtask(() {
      Get.toNamed(
        AppRoutes.forgotPassword,
        arguments: <String, dynamic>{'email': email},
      );
    });
  }

  void createAccount() {
    Get.snackbar(
      'Create account',
      'Signup flow is not connected yet.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.snackbarBackground,
      colorText: AppColors.snackbarText,
      margin: EdgeInsets.all(14.r),
      duration: const Duration(seconds: 2),
    );
  }

  bool _validateForgotPasswordEmail() {
    final email = state.value.email.trim();

    String? emailError;

    if (email.isEmpty) {
      emailError = 'Enter your email first to reset password';
    } else if (!_emailPattern.hasMatch(email)) {
      emailError = 'Enter a valid email';
    }

    state.value = state.value.copyWith(emailError: emailError);

    return emailError == null;
  }

  bool _validate() {
    final email = state.value.email.trim();
    final password = state.value.password;

    String? emailError;
    String? passwordError;

    if (email.isEmpty) {
      emailError = 'Email is required';
    } else if (!_emailPattern.hasMatch(email)) {
      emailError = 'Enter a valid email';
    }

    if (password.isEmpty) {
      passwordError = 'Password is required';
    } else if (password.length < 6) {
      passwordError = 'Password must be at least 6 characters';
    }

    state.value = state.value.copyWith(
      emailError: emailError,
      passwordError: passwordError,
    );

    return emailError == null && passwordError == null;
  }
}
