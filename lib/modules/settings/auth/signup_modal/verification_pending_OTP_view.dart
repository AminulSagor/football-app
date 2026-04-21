import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../shared/app_bar_view.dart';
import 'signup_controller.dart';

class VerificationPendingOtpView
    extends GetView<VerificationPendingOtpController> {
  const VerificationPendingOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
            final minContentHeight = math.max(
              0.0,
              constraints.maxHeight - bottomInset - 44.h,
            );

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                24.w,
                22.h,
                24.w,
                22.h + bottomInset,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: minContentHeight),
                child: Obx(() {
                  final state = controller.state.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomAppBar(
                        title: 'KICSCORE',
                        isBrandTitle: true,
                        padding: EdgeInsets.zero,
                        titleStyle: TextStyle(
                          color: AppColors.brand,
                          fontSize: AppTextStyles.sizeHeading.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.6.sp,
                        ),
                      ),
                      SizedBox(height: 62.h),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Verify your\n',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 44.sp,
                                height: 1.05,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(
                              text: 'email',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 44.sp,
                                height: 1.05,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 18.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "We've sent a 4-digit code to",
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: AppTextStyles.sizeBody.sp,
                              height: 1.4,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            state.email.isEmpty
                                ? 'user@email.com'
                                : state.email,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: AppTextStyles.sizeBody.sp,
                              height: 1.4,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Container(
                            height: 2.w,
                            width: state.email.length * 8.w,
                            color: AppColors.primary,
                            //width: double.infinity,
                          ),
                        ],
                      ),
                      SizedBox(height: (Get.height * 0.1).h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(4, (index) {
                          return _OtpDigitBox(
                            controller: controller.digitControllers[index],
                            focusNode: controller.digitFocusNodes[index],
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
                            fontSize: AppTextStyles.sizeCaption.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      SizedBox(height: (Get.height * 0.2).h),
                      //Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 56.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.textStrong,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28.r),
                            ),
                            textStyle: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.6.sp,
                            ),
                          ),
                          onPressed: state.isVerifying
                              ? null
                              : () => controller.verify(),
                          child: state.isVerifying
                              ? SizedBox(
                                  width: 22.r,
                                  height: 22.r,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.4.r,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.textStrong,
                                    ),
                                  ),
                                )
                              : const Text('VERIFY'),
                        ),
                      ),
                      SizedBox(height: 18.h),
                      Center(
                        child: Text(
                          "DIDN'T RECEIVE THE CODE?",
                          style: TextStyle(
                            color: AppColors.textSubtle,
                            fontSize: AppTextStyles.sizeOverline.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Center(
                        child: InkWell(
                          onTap: controller.resendCode,
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
                                  color: AppColors.textSubtle,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Resend code in 00:${state.resendSeconds.toString().padLeft(2, '0')}',
                                  style: TextStyle(
                                    color: AppColors.textSubtle,
                                    fontSize: AppTextStyles.sizeBodySmall.sp,
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
    );
  }
}

class _OtpDigitBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _OtpDigitBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: focusNode,
      builder: (context, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          width: 73.r,
          height: 90.r,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: focusNode.hasFocus
                  ? AppColors.primary
                  : Colors.transparent,
              width: 1.2.w,
            ),
          ),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          color: AppColors.primary,
          fontSize: AppTextStyles.sizeTitle.sp,
          fontWeight: FontWeight.w800,
        ),
        cursorColor: AppColors.primary,
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
            color: AppColors.textHint,
            fontSize: AppTextStyles.sizeTitle.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
