import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/api_error_handler.dart';
import '../../../../routes/app_routes.dart';
import 'forgot_password_models.dart';
import 'forgot_password_service.dart';

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

  Future<void> verifyOtp() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_validate()) {
      return;
    }

    state.value = state.value.copyWith(isVerifying: true);

    final payload = ForgotPasswordOtpVerifyPayload(
      email: state.value.email.trim(),
      code: state.value.code,
    );

    final response = await ApiErrorHandler.handle<ForgotPasswordOtpResult>(
      () => _service.verifyOtp(payload),
      fallbackErrorCode: 'verify_code_failed',
      userMessage: 'Unable to verify the code. Please try again.',
    );

    if (isClosed) {
      return;
    }

    if (!response.success ||
        response.data == null ||
        !response.data!.verified) {
      state.value = state.value.copyWith(
        isVerifying: false,
        codeError: 'Invalid code. Please try again.',
      );
      return;
    }

    state.value = state.value.copyWith(isVerifying: false);

    Get.toNamed(
      AppRoutes.resetPassword,
      arguments: <String, dynamic>{
        'email': response.data!.email.isEmpty
            ? state.value.email
            : response.data!.email,
        'resetToken': response.data!.resetToken,
      },
    );
  }

  Future<void> resendCode() async {
    if (!state.value.canResend) {
      return;
    }

    state.value = state.value.copyWith(isResending: true);

    final payload = ForgotPasswordResendPayload(
      email: state.value.email.trim(),
    );
    final response = await ApiErrorHandler.handle<ForgotPasswordResendResult>(
      () => _service.resendCode(payload),
      fallbackErrorCode: 'resend_code_failed',
      userMessage: 'Could not resend the code right now. Please try again.',
    );

    if (isClosed) {
      return;
    }

    if (!response.success || response.data == null || !response.data!.sent) {
      state.value = state.value.copyWith(isResending: false);
      return;
    }

    state.value = state.value.copyWith(
      isResending: false,
      resendSeconds: response.data!.resendSeconds,
    );
    _startResendTimer();
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
  final ForgotPasswordService _service;

  final TextEditingController newPasswordTextController =
      TextEditingController();
  final TextEditingController confirmPasswordTextController =
      TextEditingController();

  final Rx<ResetPasswordViewModel> state;

  ResetPasswordController({
    required ForgotPasswordService service,
    required String email,
    required String resetToken,
  }) : _service = service,
       state = ResetPasswordViewModel(email: email, resetToken: resetToken).obs;

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
      resetToken: state.value.resetToken,
      password: state.value.newPassword,
      confirmPassword: state.value.confirmPassword,
    );

    final response = await ApiErrorHandler.handle<ResetPasswordResult>(
      () => _service.resetPassword(payload),
      fallbackErrorCode: 'reset_password_failed',
      userMessage: 'Could not change your password. Please try again.',
    );

    if (isClosed) {
      return;
    }

    if (!response.success ||
        response.data == null ||
        !response.data!.passwordUpdated) {
      state.value = state.value.copyWith(isSubmitting: false);
      return;
    }

    state.value = state.value.copyWith(isSubmitting: false);
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
    final newPassword = state.value.newPassword;
    final confirmPassword = state.value.confirmPassword;

    String? newPasswordError;
    String? confirmPasswordError;

    if (newPassword.isEmpty) {
      newPasswordError = 'New password is required';
    } else if (newPassword.length < 6) {
      newPasswordError = 'Password must be at least 6 characters';
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
  void goToHome() {
    Get.offAllNamed(AppRoutes.bottomNav);
  }
}

class ForgotPasswordOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordService>(
      () => ForgotPasswordService(),
      fenix: true,
    );

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
    Get.lazyPut<ForgotPasswordService>(
      () => ForgotPasswordService(),
      fenix: true,
    );

    final email = _readEmail(Get.arguments);
    final resetToken = _readResetToken(Get.arguments);

    Get.lazyPut<ResetPasswordController>(
      () => ResetPasswordController(
        service: Get.find<ForgotPasswordService>(),
        email: email,
        resetToken: resetToken,
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

  return 'user@email.com';
}

String _readResetToken(dynamic args) {
  if (args is Map) {
    final token = args['resetToken'];
    if (token is String) {
      return token;
    }
  }

  return '';
}
