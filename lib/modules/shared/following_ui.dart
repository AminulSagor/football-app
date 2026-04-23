import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/themes/app_text_styles.dart';
import '../../core/themes/app_colors.dart';

class FollowToggleButton extends StatelessWidget {
  final bool isFollowing;
  final VoidCallback onTap;
  final double height;
  final EdgeInsetsGeometry? padding;

  const FollowToggleButton({
    super.key,
    required this.isFollowing,
    required this.onTap,
    this.height = 34,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(height.r / 2),
        onTap: onTap,
        child: Container(
          height: height.h,
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 24.w, vertical: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height.r / 2),
            color: isFollowing ? Colors.transparent : theme.colorScheme.secondary,
            border: Border.all(
              color: theme.colorScheme.secondary,
              width: 1.2.w,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            isFollowing ? 'Following' : 'Follow',
            style: TextStyle(
              color: isFollowing ? theme.colorScheme.secondary : theme.colorScheme.onSecondary,
              fontSize: AppTextStyles.sizeBodySmall.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class SeedCircleAvatar extends StatelessWidget {
  final String seed;
  final double size;
  final Color? borderColor;
  final Color? backgroundColor;
  final double fontSize;

  const SeedCircleAvatar({
    super.key,
    required this.seed,
    this.size = 56,
    this.borderColor,
    this.backgroundColor,
    this.fontSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = backgroundColor ?? theme.colorScheme.surface;
    final border = borderColor ?? theme.colorScheme.secondary;

    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bg,
        border: Border.all(color: border, width: 1.w),
      ),
      alignment: Alignment.center,
      child: Text(
        seed,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: fontSize.sp,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
    );
  }
}

class SeedSquareBadge extends StatelessWidget {
  final String seed;
  final Color color;
  final double size;

  const SeedSquareBadge({
    super.key,
    required this.seed,
    required this.color,
    this.size = 26,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular((size / 3).r),
        color: color,
      ),
      alignment: Alignment.center,
      child: Text(
        seed,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: AppTextStyles.sizeTiny.sp,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
    );
  }
}

Future<bool?> showUnfollowConfirmationDialog(
  BuildContext context, {
  required String subjectLabel,
  required String helperText,
}) {
  return showDialog<bool>(
    context: context,
    barrierColor: AppColors.overlay,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Theme.of(dialogContext).colorScheme.surface,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppColors.palette(Theme.of(dialogContext).brightness).inputGradientStart,
                AppColors.palette(Theme.of(dialogContext).brightness).inputGradientEnd,
              ],
            ),
            border: Border.all(color: Theme.of(dialogContext).dividerColor, width: 1.w),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 26.h, 24.w, 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 88.r,
                  height: 88.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.palette(Theme.of(dialogContext).brightness).primary.withAlpha(51),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.warning_amber_rounded,
                    size: 44.r,
                    color: AppColors.palette(Theme.of(dialogContext).brightness).primaryAlt,
                  ),
                ),
                SizedBox(height: 22.h),
                Text(
                  'ARE YOU SURE?',
                  style: TextStyle(
                    color: Theme.of(dialogContext).colorScheme.onSurface,
                    fontSize: AppTextStyles.sizeBodyLarge.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  subjectLabel,
                  style: TextStyle(
                    color: Theme.of(dialogContext).colorScheme.onSurface.withAlpha(145),
                    fontSize: AppTextStyles.sizeBody.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 18.h),
                Text(
                  helperText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(dialogContext).colorScheme.onSurface.withAlpha(155),
                    fontSize: AppTextStyles.sizeBody.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.55,
                  ),
                ),
                SizedBox(height: 20.h),
                _DialogActionButton(
                  label: 'Unfollow',
                  backgroundColor: Theme.of(dialogContext).colorScheme.error,
                  textColor: Theme.of(dialogContext).colorScheme.onError,
                  onTap: () => Navigator.of(dialogContext).pop(true),
                ),
                SizedBox(height: 12.h),
                _DialogActionButton(
                  label: 'GO BACK',
                  backgroundColor: Theme.of(dialogContext).dividerColor.withAlpha(6),
                  textColor: Theme.of(dialogContext).colorScheme.onSurface.withAlpha(135),
                  onTap: () => Navigator.of(dialogContext).pop(false),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _DialogActionButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onTap;

  const _DialogActionButton({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: backgroundColor,
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: AppTextStyles.sizeBody.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
