import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../shared/app_bar_view.dart';
import 'signup_controller.dart';

class VerifiedProfilePicUploadView
    extends GetView<VerifiedProfilePicUploadController> {
  const VerifiedProfilePicUploadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 22.h, 24.w, 22.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                title: 'KICSCORE',
                isBrandTitle: true,
                padding: EdgeInsets.zero,
                titleStyle: TextStyle(
                  color: AppColors.brand,
                  fontSize: AppTextStyles.sizeHeading.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.6.sp,
                ),
              ),
              SizedBox(height: 26.h),
              Center(
                child: Text(
                  "Verified! Let's set up\nyour profile.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 30.sp,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              Center(
                child: Text(
                  'Upload a photo so your friends can\nfind you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: AppTextStyles.sizeBody.sp,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: (Get.height * 0.1).h),
              Center(child: _PhotoSelector(controller: controller)),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 64.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textStrong,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.r),
                    ),
                    textStyle: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.6.sp,
                    ),
                  ),
                  onPressed: controller.continueFlow,
                  child: const Text('CONTINUE'),
                ),
              ),
              SizedBox(height: 14.h),
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSubtle,
                    textStyle: TextStyle(
                      fontSize: AppTextStyles.sizeCaption.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4.sp,
                    ),
                  ),
                  onPressed: controller.skipForNow,
                  child: const Text('SKIP FOR NOW'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhotoSelector extends StatelessWidget {
  final VerifiedProfilePicUploadController controller;

  const _PhotoSelector({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: controller.selectPhoto,
          borderRadius: BorderRadius.circular(200.r),
          child: Container(
            width: 192.r,
            height: 192.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceMuted,
              // gradient: const RadialGradient(
              //   colors: [Color(0xFF263430), Color(0xFF0E1714)],
              //   center: Alignment(-0.2, -0.2),
              //   radius: 0.9,
              // ),
              border: Border.all(color: AppColors.borderSoft, width: 1.w),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_a_photo_outlined,
                  size: 44.r,
                  color: AppColors.primary,
                ),
                SizedBox(height: 10.h),
                Text(
                  'SELECT PHOTO',
                  style: TextStyle(
                    color: AppColors.textSubtle,
                    fontSize: AppTextStyles.sizeTiny.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.2.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: -4.w,
          bottom: 10.h,
          child: InkWell(
            onTap: controller.selectPhoto,
            borderRadius: BorderRadius.circular(50.r),
            child: Container(
              width: 56.r,
              height: 56.r,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, size: 28.r, color: AppColors.textStrong),
            ),
          ),
        ),
      ],
    );
  }
}
