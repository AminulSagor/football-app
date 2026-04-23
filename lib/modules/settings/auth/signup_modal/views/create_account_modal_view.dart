import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/themes/app_colors.dart';
import '../../../../../core/themes/app_text_styles.dart';
import '../../../../../routes/app_routes.dart';
import '../../signin_modal/signin_view.dart';
import '../signup_controller.dart';

class CreateAccountModalView extends GetView<CreateAccountModalController> {
  final String controllerTag;

  const CreateAccountModalView({super.key, required this.controllerTag});

  @override
  String? get tag => controllerTag;

  static Future<void> show(BuildContext context) async {
    final controllerTag =
        'create-account-modal-${DateTime.now().microsecondsSinceEpoch}';
    const transitionDuration = Duration(milliseconds: 220);

    Get.put<CreateAccountModalController>(
      CreateAccountModalController(),
      tag: controllerTag,
    );

    await showGeneralDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.transparent,
      transitionDuration: transitionDuration,
      pageBuilder: (context, animation, secondaryAnimation) {
        return CreateAccountModalView(controllerTag: controllerTag);
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.98, end: 1).animate(curved),
            child: child,
          ),
        );
      },
    );

    if (Get.isRegistered<CreateAccountModalController>(tag: controllerTag)) {
      Future<void>.delayed(transitionDuration, () {
        if (Get.isRegistered<CreateAccountModalController>(
          tag: controllerTag,
        )) {
          Get.delete<CreateAccountModalController>(
            tag: controllerTag,
            force: true,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dialogTop = 115.7.h;
    final availableHeight =
        MediaQuery.sizeOf(context).height - dialogTop - 16.h;
    final dialogHeight = math.min(703.h, math.max(0, availableHeight));

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: ColoredBox(color: AppColors.overlay),
                ),
              ),
            ),
          ),
          Positioned(
            top: dialogTop,
            left: 16.w,
            right: 16.w,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = math.min(358.w, constraints.maxWidth);
                return Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: width,
                    height: dialogHeight.toDouble(),
                    child: _DialogCard(controller: controller),
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

class _DialogCard extends StatelessWidget {
  final CreateAccountModalController controller;

  const _DialogCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 384.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(40.r),
        border: Border.all(color: AppColors.border, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            offset: Offset(0, 32.h),
            blurRadius: 64.r,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(32.w, 48.h, 32.w, 32.h),
        child: Obx(() {
          final state = controller.state.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20.r),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(4.r),
                    child: Icon(
                      Icons.close,
                      size: 28.r,
                      color: AppColors.textMutedSoft,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Center(
                child: Text(
                  'Join Kicscore',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textPrimarySoft,
                    fontSize: AppTextStyles.sizeTitle.sp,
                    height: 1,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Center(
                child: Text(
                  'Create an account to get started',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondarySoft,
                    fontSize: AppTextStyles.sizeBody.sp,
                    height: 1.2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 28.h),
              _LabeledTextField(
                label: 'FULL NAME',
                hint: 'John Doe',
                controller: controller.fullNameTextController,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                icon: Icons.person_outline,
                errorText: state.fullNameError,
              ),
              SizedBox(height: 18.h),
              _LabeledTextField(
                label: 'EMAIL ADDRESS',
                hint: 'name@example.com',
                controller: controller.emailTextController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                icon: Icons.email_outlined,
                errorText: state.emailError,
              ),
              SizedBox(height: 18.h),
              _LabeledTextField(
                label: 'PASSWORD',
                hint: '........',
                controller: controller.passwordTextController,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                icon: Icons.lock_outline,
                obscureText: !state.isPasswordVisible,
                errorText: state.passwordError,
                onSubmitted: (_) => controller.submitCreateAccount(),
                trailing: IconButton(
                  onPressed: controller.togglePasswordVisibility,
                  splashRadius: 18.r,
                  icon: Icon(
                    state.isPasswordVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textSubtleSoft,
                    size: 22.r,
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: controller.toggleAcceptedTerms,
                    borderRadius: BorderRadius.circular(6.r),
                    child: Container(
                      width: 22.r,
                      height: 22.r,
                      decoration: BoxDecoration(
                        color: state.acceptedTerms
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(
                          color: state.acceptedTerms
                              ? AppColors.primary
                              : AppColors.actionDisabled,
                          width: 1.w,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: state.acceptedTerms
                          ? Icon(
                              Icons.check,
                              size: 16.r,
                              color: AppColors.textStrong,
                            )
                          : null,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Wrap(
                      children: [
                        Text(
                          'I agree to the ',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: AppTextStyles.sizeLabel.sp,
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).pop();
                            Future.microtask(
                              () => Get.toNamed(AppRoutes.termsAndCondition),
                            );
                          },
                          child: Text(
                            'Terms of Service',
                            style: TextStyle(
                              color: AppColors.link,
                              fontSize: AppTextStyles.sizeLabel.sp,
                              height: 1.4,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.link,
                            ),
                          ),
                        ),
                        Text(
                          ' and ',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: AppTextStyles.sizeLabel.sp,
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).pop();
                            Future.microtask(
                              () => Get.toNamed(AppRoutes.privacyPolicy),
                            );
                          },
                          child: Text(
                            'Privacy Policy',
                            style: TextStyle(
                              color: AppColors.link,
                              fontSize: AppTextStyles.sizeLabel.sp,
                              height: 1.4,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.link,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (state.termsError != null) ...[
                SizedBox(height: 8.h),
                Text(
                  state.termsError!,
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: AppTextStyles.sizeCaption.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              SizedBox(height: 22.h),
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
                      fontSize: AppTextStyles.sizeBody.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.6.sp,
                    ),
                  ),
                  onPressed: state.isSubmitting
                      ? null
                      : controller.submitCreateAccount,
                  child: state.isSubmitting
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
                      : const Text('CREATE ACCOUNT'),
                ),
              ),
              SizedBox(height: 18.h),
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(
                        color: AppColors.textSubtleAlt,
                        fontSize: AppTextStyles.sizeBodySmall.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).pop();
                        final rootContext = Get.overlayContext;
                        if (rootContext != null) {
                          Future.microtask(
                            () => SignInModalView.show(rootContext),
                          );
                        }
                      },
                      borderRadius: BorderRadius.circular(4.r),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: AppColors.linkStrong,
                            fontSize: AppTextStyles.sizeBodySmall.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _LabeledTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final Widget? trailing;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;
  final String? errorText;

  const _LabeledTextField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.icon,
    required this.keyboardType,
    required this.textInputAction,
    this.trailing,
    this.obscureText = false,
    this.onSubmitted,
    this.errorText,
  });

  @override
  State<_LabeledTextField> createState() => _LabeledTextFieldState();
}

class _LabeledTextFieldState extends State<_LabeledTextField> {
  late final FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (!mounted) {
      return;
    }
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.errorText != null
        ? AppColors.errorStrong
        : (_hasFocus ? AppColors.primary : Colors.transparent);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            color: AppColors.textLabel,
            fontSize: AppTextStyles.sizeLabel.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5.sp,
          ),
        ),
        SizedBox(height: 10.h),
        AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          height: 52.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [AppColors.inputGradientStart, AppColors.inputGradientEnd],
            ),
            border: Border.all(
              color: borderColor,
              width: 1.w,
            ),
          ),
          child: Row(
            children: [
              SizedBox(width: 14.w),
              Icon(widget.icon, color: AppColors.inputIcon, size: 22.r),
              SizedBox(width: 12.w),
              Expanded(
                child: TextField(
                  focusNode: _focusNode,
                  controller: widget.controller,
                  obscureText: widget.obscureText,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  onSubmitted: widget.onSubmitted,
                  style: TextStyle(
                    color: AppColors.inputText,
                    fontSize: AppTextStyles.sizeBody.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  cursorColor: AppColors.link,
                  decoration: InputDecoration(
                    filled: false,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    hintText: widget.hint,
                    hintStyle: TextStyle(
                      color: AppColors.textHint,
                      fontSize: AppTextStyles.sizeBody.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    isCollapsed: true,
                  ),
                ),
              ),
              if (widget.trailing != null) widget.trailing!,
              SizedBox(width: 8.w),
            ],
          ),
        ),
        if (widget.errorText != null) ...[
          SizedBox(height: 6.h),
          Text(
            widget.errorText!,
            style: TextStyle(
              color: AppColors.error,
              fontSize: AppTextStyles.sizeCaption.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
