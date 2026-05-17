import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/services/api_client.dart';
import '../../../../core/services/api_error_handler.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../routes/app_routes.dart';
import 'models/forgot_password_models.dart';
import 'services/forgot_password_service.dart';

class ForgotPasswordOtpController extends GetxController {
  final ForgotPasswordService _service;
  final Rx<ForgotPasswordOtpViewModel> state;

  final List<TextEditingController> digitControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  final List<FocusNode> digitFocusNodes = List.generate(4, (_) => FocusNode());

  Timer? _resendTimer;

  ForgotPasswordOtpController({
    required ForgotPasswordService service,
    required String email,
  }) : _service = service,
       state = ForgotPasswordOtpViewModel(email: email).obs;

  @override
  void onInit() {
    super.onInit();
    _startResendTimer();
  }

  @override
  void onClose() {
    _resendTimer?.cancel();

    for (final controller in digitControllers) {
      controller.dispose();
    }

    for (final node in digitFocusNodes) {
      node.dispose();
    }

    super.onClose();
  }

  void onDigitChanged(int index, String value) {
    if (value.length > 1) {
      _fillFromBulkInput(index, value);
      return;
    }

    if (value.isNotEmpty && index < digitFocusNodes.length - 1) {
      digitFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      digitFocusNodes[index - 1].requestFocus();
    }

    _syncCode();
  }

  void verifyOtp() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!_validate()) {
      return;
    }

    Get.toNamed(
      AppRoutes.resetPassword,
      arguments: <String, dynamic>{
        'email': state.value.email.trim(),
        'otp': state.value.code,
      },
    );
  }

  Future<void> resendCode() async {
    if (!state.value.canResend) {
      return;
    }

    final email = state.value.email.trim();

    if (email.isEmpty) {
      state.value = state.value.copyWith(
        codeError: 'Email is missing. Please start again from login.',
      );
      return;
    }

    state.value = state.value.copyWith(isResending: true);

    final response = await ApiErrorHandler.handle<void>(
      () => _service.sendResetOtp(ForgotPasswordSendOtpPayload(email: email)),
      fallbackErrorCode: 'resend_reset_otp_failed',
      userMessage: 'Could not resend the code right now. Please try again.',
    );

    if (isClosed) {
      return;
    }

    state.value = state.value.copyWith(isResending: false);

    if (!response.success) {
      return;
    }

    state.value = state.value.copyWith(resendSeconds: 55);
    _startResendTimer();

    Get.closeAllSnackbars();
    Get.snackbar(
      'Reset code sent',
      'A new password reset code has been sent to your email.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.snackbarBackground,
      colorText: AppColors.snackbarText,
      margin: EdgeInsets.all(14.r),
      duration: const Duration(seconds: 2),
    );
  }

  bool _validate() {
    final code = state.value.code;

    String? codeError;

    if (code.length != 4) {
      codeError = 'Enter the 4-digit code';
    } else if (code.contains(RegExp(r'\D'))) {
      codeError = 'Code must contain only numbers';
    }

    state.value = state.value.copyWith(codeError: codeError);

    return codeError == null;
  }

  void _fillFromBulkInput(int startIndex, String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');

    if (digits.isEmpty) {
      digitControllers[startIndex].clear();
      _syncCode();
      return;
    }

    var writeIndex = startIndex;

    for (final digit in digits.split('')) {
      if (writeIndex >= digitControllers.length) {
        break;
      }

      digitControllers[writeIndex]
        ..text = digit
        ..selection = const TextSelection.collapsed(offset: 1);

      writeIndex++;
    }

    if (writeIndex < digitFocusNodes.length) {
      digitFocusNodes[writeIndex].requestFocus();
    } else {
      FocusManager.instance.primaryFocus?.unfocus();
    }

    _syncCode();
  }

  void _syncCode() {
    final code = digitControllers.map((controller) => controller.text).join();

    state.value = state.value.copyWith(code: code, codeError: null);
  }

  void _startResendTimer() {
    _resendTimer?.cancel();

    if (state.value.resendSeconds <= 0) {
      return;
    }

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }

      final next = state.value.resendSeconds - 1;

      if (next <= 0) {
        state.value = state.value.copyWith(resendSeconds: 0);
        timer.cancel();
        return;
      }

      state.value = state.value.copyWith(resendSeconds: next);
    });
  }
}

class ResetPasswordController extends GetxController {
  static final RegExp _passwordPattern = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)');

  final ForgotPasswordService _service;

  final TextEditingController newPasswordTextController =
      TextEditingController();

  final TextEditingController confirmPasswordTextController =
      TextEditingController();

  final Rx<ResetPasswordViewModel> state;

  ResetPasswordController({
    required ForgotPasswordService service,
    required String email,
    required String otp,
  }) : _service = service,
       state = ResetPasswordViewModel(email: email, otp: otp).obs;

  @override
  void onInit() {
    super.onInit();
    newPasswordTextController.addListener(_onNewPasswordChanged);
    confirmPasswordTextController.addListener(_onConfirmPasswordChanged);
  }

  @override
  void onClose() {
    newPasswordTextController.dispose();
    confirmPasswordTextController.dispose();
    super.onClose();
  }

  void restartVerification() {
    Get.offNamed(
      AppRoutes.forgotPassword,
      arguments: <String, dynamic>{'email': state.value.email},
    );
  }

  Future<void> submit() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!_validate()) {
      return;
    }

    state.value = state.value.copyWith(isSubmitting: true);

    final payload = ResetPasswordPayload(
      email: state.value.email.trim(),
      otp: state.value.otp.trim(),
      newPassword: state.value.newPassword,
    );

    final response = await ApiErrorHandler.handle<void>(
      () => _service.resetPassword(payload),
      fallbackErrorCode: 'reset_password_failed',
      userMessage: 'Could not change your password. Please try again.',
    );

    if (isClosed) {
      return;
    }

    state.value = state.value.copyWith(isSubmitting: false);

    if (!response.success) {
      return;
    }

    Get.offNamed(AppRoutes.forgotPasswordSuccess);
  }

  void _onNewPasswordChanged() {
    final value = newPasswordTextController.text;

    if (value == state.value.newPassword) {
      return;
    }

    state.value = state.value.copyWith(
      newPassword: value,
      newPasswordError: null,
    );
  }

  void _onConfirmPasswordChanged() {
    final value = confirmPasswordTextController.text;

    if (value == state.value.confirmPassword) {
      return;
    }

    state.value = state.value.copyWith(
      confirmPassword: value,
      confirmPasswordError: null,
    );
  }

  bool _validate() {
    final email = state.value.email.trim();
    final otp = state.value.otp.trim();
    final newPassword = state.value.newPassword;
    final confirmPassword = state.value.confirmPassword;

    String? newPasswordError;
    String? confirmPasswordError;

    if (email.isEmpty || otp.length != 4) {
      newPasswordError = 'Reset session expired. Please request a new code.';
    } else if (newPassword.isEmpty) {
      newPasswordError = 'New password is required';
    } else if (newPassword.length < 6) {
      newPasswordError = 'Password must be at least 6 characters';
    } else if (!_passwordPattern.hasMatch(newPassword)) {
      newPasswordError =
          'Password must contain at least one letter and one number';
    }

    if (confirmPassword.isEmpty) {
      confirmPasswordError = 'Confirm your password';
    } else if (confirmPassword != newPassword) {
      confirmPasswordError = 'Passwords do not match';
    }

    state.value = state.value.copyWith(
      newPasswordError: newPasswordError,
      confirmPasswordError: confirmPasswordError,
    );

    return newPasswordError == null && confirmPasswordError == null;
  }
}

class ForgotPasswordSuccessController extends GetxController {
  void goBackAfterReset() {
    Get.until((route) => route.isFirst);
  }
}

class ForgotPasswordOtpBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ForgotPasswordService>()) {
      Get.lazyPut<ForgotPasswordService>(
        () => ForgotPasswordService(apiClient: Get.find<ApiClient>()),
        fenix: true,
      );
    }

    final email = _readEmail(Get.arguments);

    Get.lazyPut<ForgotPasswordOtpController>(
      () => ForgotPasswordOtpController(
        service: Get.find<ForgotPasswordService>(),
        email: email,
      ),
    );
  }
}

class ForgotPasswordResetBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ForgotPasswordService>()) {
      Get.lazyPut<ForgotPasswordService>(
        () => ForgotPasswordService(apiClient: Get.find<ApiClient>()),
        fenix: true,
      );
    }

    final email = _readEmail(Get.arguments);
    final otp = _readOtp(Get.arguments);

    Get.lazyPut<ResetPasswordController>(
      () => ResetPasswordController(
        service: Get.find<ForgotPasswordService>(),
        email: email,
        otp: otp,
      ),
    );
  }
}

class ForgotPasswordSuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordSuccessController>(
      () => ForgotPasswordSuccessController(),
    );
  }
}

String _readEmail(dynamic args) {
  if (args is Map) {
    final email = args['email'];

    if (email is String && email.trim().isNotEmpty) {
      return email.trim();
    }
  }

  return '';
}

String _readOtp(dynamic args) {
  if (args is Map) {
    final otp = args['otp'];

    if (otp is String && otp.trim().isNotEmpty) {
      return otp.trim();
    }
  }

  return '';
}
