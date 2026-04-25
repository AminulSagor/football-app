import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/themes/app_colors.dart';
import '../../../../../core/themes/app_text_styles.dart';
import '../../../../../routes/app_routes.dart';
import '../models/legal_models.dart';
import '../tos_controller.dart';
import 'legal_widgets.dart';

class PrivacyPolicyView extends GetView<LegalController> {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = controller.privacyPolicy;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: LegalBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 0),
                child: const LegalTopBar(title: 'Privacy Policy'),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(22.w, 24.h, 22.w, 18.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LegalLastUpdated(value: data.lastUpdated),
                      SizedBox(height: 24.h),
                      ...List.generate(
                        data.sections.length,
                        (index) => _PrivacySectionItem(
                          index: index + 1,
                          section: data.sections[index],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      LegalContactSection(
                        title: data.contactTitle,
                        body: data.contactBody,
                        email: data.contactEmail,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(22.w, 0, 22.w, 12.h + bottomInset),
                child: SizedBox(
                  width: double.infinity,
                  height: 46.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primarySoft,
                      foregroundColor: AppColors.background,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      textStyle: TextStyle(
                        fontSize: AppTextStyles.sizeBodySmall.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: () => Get.toNamed(AppRoutes.termsAndCondition),
                    child: Text(data.termsButtonLabel),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrivacySectionItem extends StatelessWidget {
  final int index;
  final LegalParagraphSectionModel section;

  const _PrivacySectionItem({required this.index, required this.section});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 28.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$index',
                  style: TextStyle(
                    color: AppColors.primarySoft,
                    fontSize: AppTextStyles.sizeBodySmall.sp,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  section.heading,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: AppTextStyles.sizeHeading.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Padding(
            padding: EdgeInsets.only(left: 56.w),
            child: Text(
              section.body,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: AppTextStyles.sizeBody.sp,
                fontWeight: FontWeight.w500,
                height: 1.52,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
