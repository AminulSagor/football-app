import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../../../../core/themes/app_text_styles.dart';
import 'package:get/get.dart';
import '../../../../../routes/routes.dart';

class LegalBackground extends StatelessWidget {
  final Widget child;

  const LegalBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background,
            const Color(0xFF07110E),
          ],
        ),
      ),
      child: child,
    );
  }
}

class LegalTopBar extends StatelessWidget {
  final String title;

  const LegalTopBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(18.r),
          onTap: () => Navigator.of(context).maybePop(),
          child: Padding(
            padding: EdgeInsets.all(4.r),
            child: Icon(
              Icons.arrow_back,
              size: 23.r,
              color: AppColors.primarySoft,
            ),
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.primarySoft,
              fontSize: AppTextStyles.sizeTitle.sp,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(18.r),
          onTap: () => Get.toNamed(AppRoutes.notifications),
          child: Padding(
            padding: EdgeInsets.all(4.r),
            child: Icon(
              Icons.notifications_none_rounded,
              size: 22.r,
              color: AppColors.textMuted,
            ),
          ),
        ),
      ],
    );
  }
}

class LegalLastUpdated extends StatelessWidget {
  final String value;

  const LegalLastUpdated({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: AppTextStyles.sizeBodySmall.sp,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w400,
            height: 1.2,
          ),
        ),
        SizedBox(height: 18.h),
        Container(
          width: 80.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            borderRadius: BorderRadius.circular(99.r),
          ),
        ),
      ],
    );
  }
}

class LegalContactSection extends StatelessWidget {
  final String title;
  final String body;
  final String email;

  const LegalContactSection({
    super.key,
    required this.title,
    required this.body,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: AppColors.divider.withAlpha(90), height: 1.h),
        SizedBox(height: 26.h),
        Row(
          children: [
            Container(
              width: 32.r,
              height: 32.r,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10.r),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.mail_outline_rounded,
                size: 20.r,
                color: AppColors.primarySoft,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              title,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: AppTextStyles.sizeHeading.sp,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ],
        ),
        SizedBox(height: 18.h),
        Padding(
          padding: EdgeInsets.only(left: 44.w),
          child: Text(
            body,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppTextStyles.sizeBodyLarge.sp,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.only(left: 44.w),
          child: Text(
            '$email  ->',
            style: TextStyle(
              color: AppColors.primarySoft,
              fontSize: AppTextStyles.sizeHeading.sp,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}
