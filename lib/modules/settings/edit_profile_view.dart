import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/themes/app_colors.dart';
import '../../core/themes/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../shared/app_bar_view.dart';
import 'settings_controller.dart';
import 'model/settings_models.dart';

class EditProfileView extends GetView<SettingsController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.scaffoldBackgroundColor,
              theme.colorScheme.surface.withAlpha(
                theme.brightness == Brightness.dark ? 34 : 12,
              ),
            ],
          ),
        ),
        child: SafeArea(
          child: Obx(() {
            final settingsState = controller.state.value;
            if (!settingsState.isLoggedIn) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (Get.currentRoute == AppRoutes.settingsEditProfile) {
                  Get.back<void>();
                }
              });
              return const SizedBox.shrink();
            }

            final state = controller.editProfileState.value;

            return ListView(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 22.h),
              children: [
                CustomAppBar(
                  title: 'Edit Profile',
                  showBackButton: true,
                  onBackTap: () => Get.back<void>(),
                  padding: EdgeInsets.only(top: 2.h, bottom: 12.h),
                  titleStyle: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontSize: (AppTextStyles.sizeTitle + 2).sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10.h),
                _EditProfileHeaderCard(
                  fullName: state.fullName,
                  isActive: state.isSecurityEditing,
                ),
                SizedBox(height: 18.h),
                _FieldLabel(label: 'FULL NAME', errorText: state.fullNameError),
                SizedBox(height: 8.h),
                _ProfileInputField(
                  controller: controller.fullNameTextController,
                  hintText: 'User Name',
                  icon: Icons.person_outline,
                  errorText: state.fullNameError,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 20.h),
                const _FieldLabel(label: 'EMAIL ADDRESS'),
                SizedBox(height: 8.h),
                _ProfileInputField(
                  controller: controller.emailTextController,
                  hintText: 'user@email.com',
                  icon: Icons.email_outlined,
                  enabled: false,
                ),
                SizedBox(height: 22.h),
                _SecurityHeader(
                  isEditing: state.isSecurityEditing,
                  onModify: controller.toggleSecurityEditing,
                ),
                SizedBox(height: 8.h),
                _SecurityCard(
                  state: state,
                  isActive: state.isSecurityEditing,
                  oldPasswordController: controller.oldPasswordTextController,
                  newPasswordController: controller.newPasswordTextController,
                  confirmPasswordController:
                      controller.confirmPasswordTextController,
                  onForgotPassword:
                      controller.openForgotPasswordFromEditProfile,
                ),
                SizedBox(height: 14.h),
                Text(
                  state.hasChanges
                      ? 'Changes have been made here, press save changes to apply'
                      : 'No unsaved profile changes yet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: state.hasChanges
                        ? theme.colorScheme.onSurface.withAlpha(220)
                        : theme.colorScheme.onSurface.withAlpha(120),
                    fontSize: AppTextStyles.sizeCaption.sp,
                    letterSpacing: 0.8.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  height: 58.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      disabledBackgroundColor: theme.colorScheme.primary
                          .withAlpha(72),
                      disabledForegroundColor: theme.colorScheme.onPrimary
                          .withAlpha(130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                    onPressed: state.canSave
                        ? () async {
                            final didSave = await controller.saveEditProfile();
                            if (didSave && context.mounted) {
                              Get.back<void>();
                            }
                          }
                        : null,
                    child: state.isSaving
                        ? SizedBox(
                            width: 22.r,
                            height: 22.r,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2.w,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: AppTextStyles.sizeBodyLarge.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 16.h),
                Divider(color: theme.dividerColor, height: 1.h),
                SizedBox(height: 12.h),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                  ),
                  onPressed: state.isDeletingAccount
                      ? null
                      : () => _showDeleteAccountDialog(context),
                  icon: state.isDeletingAccount
                      ? SizedBox(
                          width: 16.r,
                          height: 16.r,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0.w,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.error,
                            ),
                          ),
                        )
                      : Icon(Icons.delete_outline, size: 18.r),
                  label: Text(
                    'DELETE ACCOUNT',
                    style: TextStyle(
                      fontSize: AppTextStyles.sizeBodySmall.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.2.sp,
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Future<void> _showDeleteAccountDialog(BuildContext context) async {
    final fullName = controller.state.value.user?.fullName ?? '';

    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withAlpha(130),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return _DeleteAccountDialog(
          fullName: fullName,
          settingsController: controller,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}

class _EditProfileHeaderCard extends StatelessWidget {
  final String fullName;
  final bool isActive;

  const _EditProfileHeaderCard({required this.fullName, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        color: theme.colorScheme.surface,
        border: Border.all(
          color: isActive ? theme.colorScheme.primary : theme.dividerColor,
          width: isActive ? 1.3.w : 1.w,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 18.h, 14.w, 20.h),
        child: Column(
          children: [
            _HeaderAvatar(fullName: fullName),
            SizedBox(height: 14.h),
            SizedBox(
              height: 42.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                ),
                onPressed: () {
                  Get.snackbar(
                    'Change Photo',
                    'Photo update is not connected yet.',
                    snackPosition: SnackPosition.BOTTOM,
                    margin: EdgeInsets.all(14.r),
                    backgroundColor: theme.colorScheme.surface,
                    colorText: theme.colorScheme.onSurface,
                  );
                },
                child: Text(
                  'Change Photo',
                  style: TextStyle(
                    fontSize: AppTextStyles.sizeBody.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderAvatar extends StatelessWidget {
  final String fullName;

  const _HeaderAvatar({required this.fullName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Image.asset(
          'assets/avatars/default.png',
          width: 130.r,
          height: 130.r,
          fit: BoxFit.cover,
        ),
        Positioned(
          right: 8.w,
          bottom: 17.h,
          child: Container(
            width: 28.r,
            height: 28.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary,
              border: Border.all(
                color: theme.colorScheme.onPrimary,
                width: 1.4,
              ),
            ),
            child: Icon(
              Icons.edit,
              size: 16.r,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  final String? errorText;

  const _FieldLabel({required this.label, this.errorText});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: theme.colorScheme.onSurface.withAlpha(145),
            fontSize: AppTextStyles.sizeCaption.sp,
            letterSpacing: 2.0.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (errorText != null)
          Text(
            ' ($errorText)',
            style: TextStyle(
              color: theme.colorScheme.error,
              fontSize: AppTextStyles.sizeCaption.sp,
              letterSpacing: 0.4.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
      ],
    );
  }
}

class _ProfileInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final String? errorText;
  final bool enabled;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;

  const _ProfileInputField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.errorText,
    this.enabled = true,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fillColor = AppColors.palette(theme.brightness).surfaceMuted;
    final borderColor = errorText != null
        ? theme.colorScheme.error
        : theme.dividerColor.withAlpha(enabled ? 170 : 100);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 160),
      opacity: enabled ? 1 : 0.5,
      child: Container(
        height: 58.h,
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: borderColor, width: 1.w),
        ),
        child: Row(
          children: [
            SizedBox(width: 14.w),
            Icon(
              icon,
              size: 21.r,
              color: theme.colorScheme.onSurface.withAlpha(170),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: TextField(
                controller: controller,
                enabled: enabled,
                obscureText: obscureText,
                keyboardType: keyboardType,
                textInputAction: textInputAction,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: AppTextStyles.sizeBodyLarge.sp,
                  fontWeight: FontWeight.w600,
                ),
                cursorColor: theme.colorScheme.primary,
                decoration: InputDecoration(
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withAlpha(115),
                    fontSize: AppTextStyles.sizeBodyLarge.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  isCollapsed: true,
                ),
              ),
            ),
            SizedBox(width: 12.w),
          ],
        ),
      ),
    );
  }
}

class _SecurityHeader extends StatelessWidget {
  final bool isEditing;
  final VoidCallback onModify;

  const _SecurityHeader({required this.isEditing, required this.onModify});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(
          'SECURITY',
          style: TextStyle(
            color: theme.colorScheme.onSurface.withAlpha(145),
            fontSize: AppTextStyles.sizeCaption.sp,
            letterSpacing: 2.0.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        SizedBox(
          height: 34.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isEditing
                  ? theme.colorScheme.primary
                  : theme.colorScheme.primary.withAlpha(44),
              foregroundColor: isEditing
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 22.w),
            ),
            onPressed: onModify,
            child: Text(
              'MODIFY',
              style: TextStyle(
                fontSize: AppTextStyles.sizeCaption.sp,
                letterSpacing: 1.8.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SecurityCard extends StatelessWidget {
  final SettingsEditProfileViewModel state;
  final bool isActive;
  final TextEditingController oldPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onForgotPassword;

  const _SecurityCard({
    required this.state,
    this.isActive = false,
    required this.oldPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.onForgotPassword,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: theme.colorScheme.surface,
        border: Border.all(
          color: isActive ? theme.colorScheme.primary : theme.dividerColor,
          width: isActive ? 1.3.w : 1.w,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(12.w, 14.h, 12.w, 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _FieldLabel(label: 'OLD PASSWORD'),
            SizedBox(height: 8.h),
            _ProfileInputField(
              controller: oldPasswordController,
              hintText: '•••••••••••',
              icon: Icons.lock_outline,
              errorText: state.oldPasswordError,
              enabled: state.isSecurityEditing,
              obscureText: true,
            ),
            SizedBox(height: 14.h),
            const _FieldLabel(label: 'NEW PASSWORD'),
            SizedBox(height: 8.h),
            _ProfileInputField(
              controller: newPasswordController,
              hintText: '•••••••••••',
              icon: Icons.restart_alt,
              errorText: state.newPasswordError,
              enabled: state.isSecurityEditing,
              obscureText: true,
            ),
            SizedBox(height: 14.h),
            const _FieldLabel(label: 'CONFIRM PASSWORD'),
            SizedBox(height: 8.h),
            _ProfileInputField(
              controller: confirmPasswordController,
              hintText: '•••••••••••',
              icon: Icons.restart_alt,
              errorText: state.confirmPasswordError,
              enabled: state.isSecurityEditing,
              obscureText: true,
              textInputAction: TextInputAction.done,
            ),
            if (state.confirmPasswordError != null) ...[
              SizedBox(height: 10.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  state.confirmPasswordError!,
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontSize: AppTextStyles.sizeBodySmall.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
            SizedBox(height: 8.h),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textStyle: TextStyle(
                    fontSize: AppTextStyles.sizeBodySmall.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2.sp,
                  ),
                ),
                onPressed: onForgotPassword,
                child: const Text('FORGOT PASSWORD?'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeleteAccountDialog extends StatefulWidget {
  final String fullName;
  final SettingsController settingsController;

  const _DeleteAccountDialog({
    required this.fullName,
    required this.settingsController,
  });

  @override
  State<_DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  late final TextEditingController _nameController;
  String? _errorText;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _nameController.addListener(_onNameChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _nameController.dispose();
    super.dispose();
  }

  void _onNameChanged() {
    if (!mounted) {
      return;
    }
    setState(() {
      if (_errorText != null) {
        _errorText = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppColors.palette(theme.brightness);
    final activeDeleteColor = palette.errorStrong;
    final disabledDeleteColor = palette.error;
    final normalizedInputName = _nameController.text.trim().toLowerCase();
    final normalizedUserName = widget.fullName.trim().toLowerCase();
    final canDelete =
        normalizedUserName.isNotEmpty &&
        normalizedInputName == normalizedUserName &&
        !_isSubmitting;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: ColoredBox(color: Colors.black.withAlpha(80)),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Container(
                width: 356.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  color: theme.colorScheme.surface,
                  border: Border.all(color: theme.dividerColor, width: 1.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(70),
                      blurRadius: 30.r,
                      offset: Offset(0, 20.h),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 20.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 82.r,
                        height: 82.r,
                        decoration: BoxDecoration(
                          color:
                              (canDelete
                                      ? activeDeleteColor
                                      : disabledDeleteColor)
                                  .withAlpha(44),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.warning_amber_rounded,
                          color: canDelete
                              ? activeDeleteColor
                              : disabledDeleteColor,
                          size: 40.r,
                        ),
                      ),
                      SizedBox(height: 18.h),
                      Text(
                        'DELETE ACCOUNT?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                              fontSize: AppTextStyles.sizeHero.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.4.sp,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'This action cannot be undone. You will permanently lose all your progress, including the page you follow',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withAlpha(182),
                          fontSize: AppTextStyles.sizeBody.sp,
                          height: 1.45,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      _FieldLabel(
                        label: 'TYPE YOUR NAME TO CONFIRM',
                        errorText: _errorText,
                      ),
                      SizedBox(height: 8.h),
                      _ProfileInputField(
                        controller: _nameController,
                        hintText: 'Enter your full name',
                        icon: Icons.person_outline,
                        textInputAction: TextInputAction.done,
                        errorText: _errorText,
                      ),
                      SizedBox(height: 18.h),
                      SizedBox(
                        width: double.infinity,
                        height: 52.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: canDelete
                                ? activeDeleteColor
                                : disabledDeleteColor,
                            foregroundColor: theme.colorScheme.onError,
                            disabledBackgroundColor: disabledDeleteColor,
                            disabledForegroundColor: theme.colorScheme.onError
                                .withAlpha(160),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26.r),
                            ),
                          ),
                          onPressed: canDelete ? _confirmDelete : null,
                          child: _isSubmitting
                              ? SizedBox(
                                  width: 20.r,
                                  height: 20.r,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2.w,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      theme.colorScheme.onError,
                                    ),
                                  ),
                                )
                              : Text(
                                  'DELETE PERMANENTLY',
                                  style: TextStyle(
                                    fontSize: AppTextStyles.sizeBody.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      SizedBox(
                        width: double.infinity,
                        height: 52.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.surface,
                            foregroundColor: theme.colorScheme.onSurface
                                .withAlpha(180),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26.r),
                            ),
                          ),
                          onPressed: _isSubmitting
                              ? null
                              : () => Navigator.of(context).pop(),
                          child: Text(
                            'GO BACK',
                            style: TextStyle(
                              fontSize: AppTextStyles.sizeBodyLarge.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete() async {
    setState(() {
      _isSubmitting = true;
      _errorText = null;
    });

    final isDeleted = await widget.settingsController.deleteAccount(
      _nameController.text,
    );
    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmitting = false;
      if (!isDeleted) {
        _errorText = 'Name confirmation does not match';
      }
    });

    if (!isDeleted) {
      return;
    }

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    Get.back<void>();
  }
}
