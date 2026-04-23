import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import 'models/models.dart';
import 'signin_controller.dart';
import '../signup_modal/views/create_account_modal_view.dart';

class SignInModalView extends GetView<SignInController> {
  final String controllerTag;

  const SignInModalView({super.key, required this.controllerTag});

  @override
  String? get tag => controllerTag;

  static Future<SignInSubmitPayloadModel?> show(BuildContext context) async {
    final controllerTag =
        'signin-modal-${DateTime.now().microsecondsSinceEpoch}';
    const transitionDuration = Duration(milliseconds: 220);

    Get.put<SignInController>(SignInController(), tag: controllerTag);

    final result = await showGeneralDialog<SignInSubmitPayloadModel>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: const Color.fromARGB(0, 0, 0, 0),
      transitionDuration: transitionDuration,
      pageBuilder: (context, animation, secondaryAnimation) {
        return SignInModalView(controllerTag: controllerTag);
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

    if (Get.isRegistered<SignInController>(tag: controllerTag)) {
      Future<void>.delayed(transitionDuration, () {
        if (Get.isRegistered<SignInController>(tag: controllerTag)) {
          Get.delete<SignInController>(tag: controllerTag, force: true);
        }
      });
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height - 48.h;
    final dialogHeight = math.min(539.h, maxHeight);

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
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = math.min(342.w, constraints.maxWidth);

                  return SizedBox(
                    width: width,
                    height: dialogHeight,
                    child: _DialogCard(controller: controller),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DialogCard extends StatelessWidget {
  final SignInController controller;

  const _DialogCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 384.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24.r),
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
        padding: EdgeInsets.fromLTRB(24.w, 18.h, 24.w, 22.h),
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
                  'Welcome Back',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textPrimarySoft,
                    fontSize: AppTextStyles.sizeHero.sp,
                    height: 1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Center(
                child: Text(
                  'Sign in to your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondarySoft,
                    fontSize: AppTextStyles.sizeBody.sp,
                    height: 1.2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 34.h),
              _LabeledTextField(
                label: 'EMAIL ADDRESS',
                hint: 'name@example.com',
                controller: controller.emailTextController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                icon: Icons.email_outlined,
                errorText: state.emailError,
              ),
              SizedBox(height: 20.h),
              _LabeledTextField(
                label: 'PASSWORD',
                hint: '••••••••',
                controller: controller.passwordTextController,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                icon: Icons.lock_outline,
                obscureText: !state.isPasswordVisible,
                errorText: state.passwordError,
                onSubmitted: (_) => controller.submit(),
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
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.link,
                    textStyle: TextStyle(
                      fontSize: AppTextStyles.sizeBodySmall.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    padding: EdgeInsets.only(top: 8.h),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: controller.forgotPassword,
                  child: const Text('Forgot password?'),
                ),
              ),
              SizedBox(height: 24.h),
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
                  onPressed: state.canSubmit ? controller.submit : null,
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
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'SIGN IN',
                              style: TextStyle(
                                letterSpacing: 1.2.sp,
                                fontSize: AppTextStyles.sizeBodySmall.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Icon(Icons.login_rounded, size: 20.r),
                          ],
                        ),
                ),
              ),
              SizedBox(height: 22.h),
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'New to Kicscore? ',
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
                          CreateAccountModalView.show(rootContext);
                        }
                      },
                      borderRadius: BorderRadius.circular(4.r),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        child: Text(
                          'Create Account',
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
              colors: [
                AppColors.inputGradientStart,
                AppColors.inputGradientEnd,
              ],
            ),
            border: Border.all(color: borderColor, width: 1.w),
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
