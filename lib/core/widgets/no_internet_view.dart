import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../themes/app_text_styles.dart';

class NoInternetView extends StatelessWidget {
  final bool isRetrying;
  final VoidCallback onRetry;

  const NoInternetView({
    super.key,
    required this.isRetrying,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 28.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72.r,
                  height: 72.r,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: Icon(
                    Icons.wifi_off_rounded,
                    color: theme.colorScheme.secondary,
                    size: 34.r,
                  ),
                ),
                SizedBox(height: 22.h),
                Text(
                  'No internet connection',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: AppTextStyles.sizeTitle.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Please check your connection and try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withAlpha(170),
                    fontSize: AppTextStyles.sizeBody.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  height: 44.h,
                  child: ElevatedButton.icon(
                    onPressed: isRetrying ? null : onRetry,
                    icon: isRetrying
                        ? SizedBox(
                            width: 16.r,
                            height: 16.r,
                            child: CircularProgressIndicator(strokeWidth: 2.w),
                          )
                        : Icon(Icons.refresh_rounded, size: 18.r),
                    label: Text(isRetrying ? 'Checking...' : 'Retry'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
