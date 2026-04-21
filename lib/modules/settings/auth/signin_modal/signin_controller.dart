import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../routes/app_routes.dart';
import 'models.dart';

class SignInController extends GetxController {
  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  final Rx<SignInModalModel> state = const SignInModalModel().obs;

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

    await Future<void>.delayed(const Duration(milliseconds: 180));

    if (!isClosed) {
      state.value = state.value.copyWith(isSubmitting: false);
      Get.back<SignInSubmitPayloadModel>(
        result: SignInSubmitPayloadModel(
          email: state.value.email.trim(),
          password: state.value.password,
        ),
      );
    }
  }

  void forgotPassword() {
    final email = state.value.email.trim();

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
