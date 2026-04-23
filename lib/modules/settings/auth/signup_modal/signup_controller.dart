import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../routes/app_routes.dart';
import 'models/signup_models.dart';

class CreateAccountModalController extends GetxController {
  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  final TextEditingController fullNameTextController = TextEditingController();
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  final Rx<CreateAccountModalModel> state = const CreateAccountModalModel().obs;

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

    // TODO: Wire to signup service once backend is connected.
    await Future<void>.delayed(const Duration(milliseconds: 320));

    if (isClosed) {
      return;
    }

    final email = state.value.email.trim();
    state.value = state.value.copyWith(isSubmitting: false);
    Get.back<void>();

    Future.microtask(() {
      Get.toNamed(AppRoutes.signupOtp, arguments: {'email': email});
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
  final Rx<OtpVerificationModel> state;

  final List<TextEditingController> digitControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> digitFocusNodes = List.generate(4, (_) => FocusNode());

  VerificationPendingOtpController({required String email})
    : state = OtpVerificationModel(email: email).obs;

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

    // TODO: Wire verify to backend OTP verification.
    await Future<void>.delayed(const Duration(milliseconds: 320));

    if (isClosed) {
      return;
    }

    state.value = state.value.copyWith(isVerifying: false);
    Get.offNamed(AppRoutes.accountCreated);
  }

  void resendCode() {
    Get.snackbar(
      'Resend code',
      'Resend is not connected yet.',
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

    Get.lazyPut<VerificationPendingOtpController>(
      () => VerificationPendingOtpController(email: email),
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
