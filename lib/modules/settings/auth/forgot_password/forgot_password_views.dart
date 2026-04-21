import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../shared/app_bar_view.dart';
import 'forgot_password_controller.dart';

class ForgotPasswordOtpView extends GetView<ForgotPasswordOtpController> {
  const ForgotPasswordOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const _ForgotPasswordAtmosphere(),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
                final minContentHeight = math.max(
                  0.0,
                  constraints.maxHeight - bottomInset - 36.h,
                );

                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    24.w,
                    22.h,
                    24.w,
                    14.h + bottomInset,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: minContentHeight),
                    child: Obx(() {
                      final state = controller.state.value;
                      final gapAfterSummary = math.max(
                        52.h,
                        minContentHeight * 0.13,
                      );
                      final gapBeforeButton = math.max(
                        58.h,
                        minContentHeight * 0.25,
                      );
                      final resendText = state.isResending
                          ? 'Sending...'
                          : state.canResend
                          ? 'Resend code'
                          : 'Resend code in 00:${state.resendSeconds.toString().padLeft(2, '0')}';

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _ForgotPasswordBrandHeader(),
                          SizedBox(height: 76.h),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 44.sp,
                                height: 1.04,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.8.sp,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Reset your\n',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                TextSpan(
                                  text: 'password',
                                  style: TextStyle(color: AppColors.primaryAlt),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            "We've sent a 4-digit code to",
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 16.sp,
                              height: 1.35,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            state.email,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18.sp,
                              height: 1.3,
                              fontWeight: FontWeight.w700,
                              //decoration: TextDecoration.underline,
                              //decorationColor: AppColors.primaryAlt,
                              //decorationThickness: 2.w,
                            ),
                          ),

                          Container(
                            height: 1.5.h,
                            width: (state.email.length * 11).h,
                            color: AppColors.primaryAlt,
                          ),
                          SizedBox(height: gapAfterSummary),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(4, (index) {
                              return _OtpDigitBox(
                                controller: controller.digitControllers[index],
                                focusNode: controller.digitFocusNodes[index],
                                autofocus: index == 0,
                                onChanged: (value) =>
                                    controller.onDigitChanged(index, value),
                              );
                            }),
                          ),
                          if (state.codeError != null) ...[
                            SizedBox(height: 10.h),
                            Text(
                              state.codeError!,
                              style: TextStyle(
                                color: AppColors.error,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                          SizedBox(height: gapBeforeButton),
                          _PrimaryActionButton(
                            text: 'VERIFY',
                            isLoading: state.isVerifying,
                            onPressed: state.isVerifying
                                ? null
                                : controller.verifyOtp,
                          ),
                          SizedBox(height: 26.h),
                          Center(
                            child: Text(
                              "DIDN'T RECEIVE THE CODE?",
                              style: TextStyle(
                                color: AppColors.textSubtle,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.4.sp,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Center(
                            child: InkWell(
                              onTap: state.canResend
                                  ? controller.resendCode
                                  : null,
                              borderRadius: BorderRadius.circular(8.r),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 6.h,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 16.r,
                                      color: state.canResend
                                          ? AppColors.primaryAlt
                                          : AppColors.textSubtle,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      resendText,
                                      style: TextStyle(
                                        color: state.canResend
                                            ? AppColors.primaryAlt
                                            : AppColors.textSubtle,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ForgotPasswordResetView extends GetView<ResetPasswordController> {
  const ForgotPasswordResetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const _ForgotPasswordAtmosphere(),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
                final minContentHeight = math.max(
                  0.0,
                  constraints.maxHeight - bottomInset - 36.h,
                );

                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    24.w,
                    22.h,
                    24.w,
                    14.h + bottomInset,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: minContentHeight),
                    child: Obx(() {
                      final state = controller.state.value;
                      final gapBeforeButton = math.max(
                        52.h,
                        minContentHeight * 0.18,
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _ForgotPasswordBrandHeader(),
                          SizedBox(height: 74.h),
                          Text(
                            'Verified!',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 48.sp,
                              height: 1,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.7.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Set new password',
                            style: TextStyle(
                              color: AppColors.primaryAlt,
                              fontSize: 24.sp,
                              height: 1,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.4.sp,
                            ),
                          ),
                          SizedBox(height: 44.h),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20.r),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(
                                  16.w,
                                  18.h,
                                  16.w,
                                  14.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: AppColors.borderSoft,
                                    width: 1.w,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _ResetPasswordField(
                                      label: 'NEW PASSWORD',
                                      icon: Icons.lock_outline_rounded,
                                      hint: '••••••••••',
                                      controller:
                                          controller.newPasswordTextController,
                                      errorText: state.newPasswordError,
                                    ),
                                    SizedBox(height: 16.h),
                                    _ResetPasswordField(
                                      label: 'CONFIRM PASSWORD',
                                      icon: Icons.lock_reset_outlined,
                                      hint: '••••••••••',
                                      controller: controller
                                          .confirmPasswordTextController,
                                      errorText: state.confirmPasswordError,
                                      textInputAction: TextInputAction.done,
                                      onSubmitted: (_) => controller.submit(),
                                    ),
                                    SizedBox(height: 10.h),
                                    TextButton(
                                      onPressed: controller.restartVerification,
                                      style: TextButton.styleFrom(
                                        foregroundColor: AppColors.textSubtle,
                                        minimumSize: Size.zero,
                                        padding: EdgeInsets.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        'FORGOT PASSWORD?',
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1.2.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: gapBeforeButton),
                          _PrimaryActionButton(
                            text: 'CHANGE PASSWORD',
                            isLoading: state.isSubmitting,
                            onPressed: state.canSubmit
                                ? controller.submit
                                : null,
                          ),
                        ],
                      );
                    }),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ForgotPasswordSuccessView
    extends GetView<ForgotPasswordSuccessController> {
  const ForgotPasswordSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const _ForgotPasswordAtmosphere(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 22.h, 24.w, 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _ForgotPasswordBrandHeader(),
                  SizedBox(height: 162.h),
                  Text(
                    'Success!',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 48.sp,
                      height: 1,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.7.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'NEW PASSWORD SET!',
                    style: TextStyle(
                      color: AppColors.primaryAlt,
                      fontSize: 24.sp,
                      height: 1,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.1.sp,
                    ),
                  ),
                  SizedBox(height: 54.h),
                  const Center(child: _SuccessStateOrb()),
                  const Spacer(),
                  _PrimaryActionButton(
                    text: 'GO TO HOME',
                    onPressed: controller.goToHome,
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ForgotPasswordBrandHeader extends StatelessWidget {
  const _ForgotPasswordBrandHeader();

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: 'KICSCORE',
      isBrandTitle: true,
      padding: EdgeInsets.zero,
      titleStyle: TextStyle(
        color: AppColors.brand,
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4.sp,
      ),
    );
  }
}

class _ForgotPasswordAtmosphere extends StatelessWidget {
  const _ForgotPasswordAtmosphere();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: Get.isDarkMode
                      ? const [Color(0xFF010B09), Color(0xFF000907)]
                      : [AppColors.background, AppColors.surfaceSoft],
                ),
              ),
            ),
          ),
          Positioned(
            left: -130.w,
            right: -130.w,
            bottom: -170.h,
            height: 340.h,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: Get.isDarkMode
                      ? const [Color(0x29108B65), Color(0x00108B65)]
                      : [
                          AppColors.primary.withAlpha(36),
                          AppColors.primary.withAlpha(0),
                        ],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OtpDigitBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final bool autofocus;

  const _OtpDigitBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: focusNode,
      builder: (context, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          width: 74.w,
          height: 89.h,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: focusNode.hasFocus
                  ? AppColors.primaryAlt
                  : Colors.transparent,
              width: 1.2.w,
            ),
          ),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: TextField(
        autofocus: autofocus,
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          color: AppColors.primaryAlt,
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
        cursorColor: AppColors.primaryAlt,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        decoration: InputDecoration(
          filled: false,
          fillColor: Colors.transparent,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          isCollapsed: true,
          hintText: '•',
          hintStyle: TextStyle(
            color: AppColors.textSubtle,
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

class _ResetPasswordField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final String? errorText;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;

  const _ResetPasswordField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.errorText,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: AppTextStyles.sizeCaption.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          height: 56.h,
          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: errorText == null ? Colors.transparent : AppColors.error,
              width: 1.w,
            ),
          ),
          child: Row(
            children: [
              SizedBox(width: 14.w),
              Icon(icon, color: AppColors.textHint, size: 20.r),
              SizedBox(width: 10.w),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: textInputAction,
                  onSubmitted: onSubmitted,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  cursorColor: AppColors.primaryAlt,
                  decoration: InputDecoration(
                    filled: false,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                    isCollapsed: true,
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: AppColors.textHint,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 14.w),
            ],
          ),
        ),
        if (errorText != null) ...[
          SizedBox(height: 6.h),
          Text(
            errorText!,
            style: TextStyle(
              color: AppColors.error,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;

  const _PrimaryActionButton({
    required this.text,
    this.isLoading = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final buttonShadow = Get.isDarkMode
        ? const Color(0x99118660)
        : AppColors.primary.withAlpha(64);
    final buttonDisabled = AppColors.primaryAlt.withAlpha(
      Get.isDarkMode ? 136 : 124,
    );
    final buttonDisabledText = AppColors.textOnPrimary.withAlpha(
      Get.isDarkMode ? 153 : 186,
    );

    return Container(
      width: double.infinity,
      height: 64.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: buttonShadow,
            blurRadius: 5.r,
            spreadRadius: -2.r,
            offset: Offset(0, 1.h),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryAlt,
          foregroundColor: AppColors.textOnPrimary,
          disabledBackgroundColor: buttonDisabled,
          disabledForegroundColor: buttonDisabledText,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.r),
          ),
          textStyle: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.6.sp,
          ),
        ),
        onPressed: onPressed,
        child: isLoading
            ? SizedBox(
                width: 22.r,
                height: 22.r,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4.r,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.textOnPrimary,
                  ),
                ),
              )
            : Text(text, style: TextStyle(color: AppColors.textOnPrimary)),
      ),
    );
  }
}

class _SuccessStateOrb extends StatelessWidget {
  const _SuccessStateOrb();

  @override
  Widget build(BuildContext context) {
    final successOrbOuter = Get.isDarkMode
        ? const [Color(0x55108B65), Color(0x0A108B65), Color(0x00108B65)]
        : [
            AppColors.primary.withAlpha(84),
            AppColors.primary.withAlpha(24),
            AppColors.primary.withAlpha(0),
          ];
    final successOrbInner = Get.isDarkMode
        ? const Color(0xFF17211F)
        : AppColors.surfaceSoft;
    final successOrbBorder = Get.isDarkMode
        ? const Color(0x3339B794)
        : AppColors.primary.withAlpha(70);
    final successOrbShadow = AppColors.primary.withAlpha(
      Get.isDarkMode ? 102 : 58,
    );
    final successCheck = Get.isDarkMode
        ? const Color(0xFF04261D)
        : Colors.white;

    return SizedBox(
      width: 232.r,
      height: 232.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 232.r,
            height: 232.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: successOrbOuter,
                stops: [0.0, 0.55, 1.0],
              ),
            ),
          ),
          Container(
            width: 126.r,
            height: 126.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: successOrbInner,
              border: Border.all(color: successOrbBorder, width: 1.w),
              boxShadow: [
                BoxShadow(
                  color: successOrbShadow,
                  blurRadius: 20.r,
                  spreadRadius: 2.r,
                ),
              ],
            ),
          ),
          Container(
            width: 56.r,
            height: 56.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryAlt,
            ),
            child: Icon(Icons.check, color: successCheck, size: 38.r),
          ),
        ],
      ),
    );
  }
}
