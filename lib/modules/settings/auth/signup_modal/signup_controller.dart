import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/services/api_client.dart';
import '../../../../core/services/api_error_handler.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../routes/app_routes.dart';
import 'models/signup_models.dart';
import 'services/signup_service.dart';

class CreateAccountModalController extends GetxController {
  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  final SignupService _service;

  final TextEditingController fullNameTextController = TextEditingController();
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  final Rx<CreateAccountModalModel> state = const CreateAccountModalModel().obs;

  CreateAccountModalController({required SignupService service})
    : _service = service;

  @override
  void onInit() {
    super.onInit();
    fullNameTextController.addListener(_onFullNameChanged);
    emailTextController.addListener(_onEmailChanged);
    passwordTextController.addListener(_onPasswordChanged);
  }

  @override
  void onClose() {
    fullNameTextController.dispose();
    emailTextController.dispose();
    passwordTextController.dispose();
    super.onClose();
  }

  void _onFullNameChanged() {
    final next = fullNameTextController.text;
    if (next == state.value.fullName) {
      return;
    }

    state.value = state.value.copyWith(fullName: next, fullNameError: null);
  }

  void _onEmailChanged() {
    final next = emailTextController.text;
    if (next == state.value.email) {
      return;
    }

    state.value = state.value.copyWith(email: next, emailError: null);
  }

  void _onPasswordChanged() {
    final next = passwordTextController.text;
    if (next == state.value.password) {
      return;
    }

    state.value = state.value.copyWith(password: next, passwordError: null);
  }

  void togglePasswordVisibility() {
    state.value = state.value.copyWith(
      isPasswordVisible: !state.value.isPasswordVisible,
    );
  }

  void toggleAcceptedTerms() {
    final next = !state.value.acceptedTerms;
    state.value = state.value.copyWith(
      acceptedTerms: next,
      termsError: next ? null : state.value.termsError,
    );
  }

  Future<void> submitCreateAccount() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_validate()) {
      return;
    }

    state.value = state.value.copyWith(isSubmitting: true);

    final payload = SignupRegisterPayload(
      fullName: state.value.fullName.trim(),
      email: state.value.email.trim(),
      password: state.value.password,
    );

    final response = await ApiErrorHandler.handle<SignupRegisterResult>(
      () => _service.register(payload),
      fallbackErrorCode: 'register_failed',
      userMessage: 'Could not create your account. Please try again.',
    );

    if (isClosed) {
      return;
    }

    if (!response.success || response.data == null) {
      state.value = state.value.copyWith(isSubmitting: false);
      return;
    }

    final result = response.data!;
    final email = result.email.isNotEmpty ? result.email : payload.email;

    state.value = state.value.copyWith(isSubmitting: false);
    Get.back<void>();

    Future.microtask(() {
      if (result.requiresVerification) {
        Get.toNamed(AppRoutes.signupOtp, arguments: {'email': email});
      } else {
        Get.toNamed(AppRoutes.accountCreated);
      }
    });
  }

  bool _validate() {
    final fullName = state.value.fullName.trim();
    final email = state.value.email.trim();
    final password = state.value.password;
    final acceptedTerms = state.value.acceptedTerms;

    String? fullNameError;
    String? emailError;
    String? passwordError;
    String? termsError;

    if (fullName.isEmpty) {
      fullNameError = 'Full name is required';
    }

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

    if (!acceptedTerms) {
      termsError = 'Please accept the terms to continue';
    }

    state.value = state.value.copyWith(
      fullNameError: fullNameError,
      emailError: emailError,
      passwordError: passwordError,
      termsError: termsError,
    );

    return fullNameError == null &&
        emailError == null &&
        passwordError == null &&
        termsError == null;
  }
}

class VerificationPendingOtpController extends GetxController {
  final SignupService _service;
  final Rx<OtpVerificationModel> state;

  final List<TextEditingController> digitControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> digitFocusNodes = List.generate(4, (_) => FocusNode());

  VerificationPendingOtpController({
    required SignupService service,
    required String email,
  }) : _service = service,
       state = OtpVerificationModel(email: email).obs;

  @override
  void onClose() {
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
      final last = value.substring(value.length - 1);
      digitControllers[index]
        ..text = last
        ..selection = TextSelection.collapsed(offset: last.length);
      value = last;
    }

    if (value.isNotEmpty && index < digitFocusNodes.length - 1) {
      digitFocusNodes[index + 1].requestFocus();
    }

    if (value.isEmpty && index > 0) {
      digitFocusNodes[index - 1].requestFocus();
    }

    final code = digitControllers.map((c) => c.text).join();
    state.value = state.value.copyWith(code: code, codeError: null);
  }

  Future<void> verify() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_validate()) {
      return;
    }

    state.value = state.value.copyWith(isVerifying: true);

    final payload = SignupVerifyEmailPayload(
      email: state.value.email.trim(),
      otp: state.value.code,
    );

    final response = await ApiErrorHandler.handle<SignupVerifyEmailResult>(
      () => _service.verifyEmail(payload),
      fallbackErrorCode: 'verify_email_failed',
      userMessage: 'Unable to verify the code. Please try again.',
    );

    if (isClosed) {
      return;
    }

    if (!response.success || response.data == null) {
      state.value = state.value.copyWith(
        isVerifying: false,
        codeError: 'Invalid code. Please try again.',
      );
      return;
    }

    state.value = state.value.copyWith(isVerifying: false);
    Get.offNamed(AppRoutes.accountCreated);
  }

  Future<void> resendCode() async {
    final email = state.value.email.trim();
    if (email.isEmpty) {
      return;
    }

    final payload = SignupResendOtpPayload(email: email);
    final response = await ApiErrorHandler.handle<void>(
      () => _service.resendOtp(payload),
      fallbackErrorCode: 'resend_otp_failed',
      userMessage: 'Could not resend the code right now. Please try again.',
    );

    if (isClosed) {
      return;
    }

    if (response.success) {
      state.value = state.value.copyWith(resendSeconds: 55);
      Get.snackbar(
        'Resend code',
        'A new code has been sent.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.snackbarBackground,
        colorText: AppColors.snackbarText,
        margin: EdgeInsets.all(14.r),
        duration: const Duration(seconds: 2),
      );
    }
  }

  bool _validate() {
    final code = state.value.code;
    String? codeError;

    if (code.length != 4) {
      codeError = 'Enter the 4-digit code';
    } else if (code.contains(RegExp(r'\D'))) {
      codeError = 'Code must be digits';
    }

    state.value = state.value.copyWith(codeError: codeError);
    return codeError == null;
  }
}

class VerifiedProfilePicUploadController extends GetxController {
  final Rx<ProfilePicUploadModel> state = const ProfilePicUploadModel().obs;

  void selectPhoto() {
    Get.snackbar(
      'Select photo',
      'Photo selection is not connected yet.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.snackbarBackground,
      colorText: AppColors.snackbarText,
      margin: EdgeInsets.all(14.r),
      duration: const Duration(seconds: 2),
    );
  }

  void continueFlow() {
    _returnToBottomNav();
  }

  void skipForNow() {
    _returnToBottomNav();
  }

  void _returnToBottomNav() {
    var reachedBottomNav = false;

    Get.until((route) {
      final isBottomNav = route.settings.name == AppRoutes.bottomNav;
      if (isBottomNav) {
        reachedBottomNav = true;
      }
      return isBottomNav;
    });

    if (!reachedBottomNav) {
      Get.offAllNamed(AppRoutes.bottomNav);
    }
  }
}

class SignupOtpBinding extends Bindings {
  @override
  void dependencies() {
    final email = _readEmail(Get.arguments);

    if (!Get.isRegistered<SignupService>()) {
      Get.lazyPut<SignupService>(
        () => SignupService(apiClient: Get.find<ApiClient>()),
        fenix: true,
      );
    }

    Get.lazyPut<VerificationPendingOtpController>(
      () => VerificationPendingOtpController(
        service: Get.find<SignupService>(),
        email: email,
      ),
    );
  }

  String _readEmail(dynamic args) {
    if (args is Map) {
      final value = args['email'];
      if (value is String) {
        return value;
      }
    }

    return '';
  }
}

class AccountCreatedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifiedProfilePicUploadController>(
      () => VerifiedProfilePicUploadController(),
    );
  }
}
