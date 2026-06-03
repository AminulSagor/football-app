import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/themes/app_colors.dart';
import '../../../../../core/themes/app_text_styles.dart';
import '../models/legal_models.dart';
import '../tos_controller.dart';
import 'legal_widgets.dart';

class PrivacyPolicyView extends GetView<LegalController> {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = controller.privacyPolicy;

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
                  padding: EdgeInsets.fromLTRB(22.w, 24.h, 22.w, 30.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.lastUpdated,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: AppTextStyles.sizeOverline.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 3.sp,
                          height: 1.25,
                        ),
                      ),
                      SizedBox(height: 34.h),
                      ...List.generate(
                        data.sections.length,
                        (index) => _PrivacySectionItem(
                          index: index + 1,
                          section: data.sections[index],
                        ),
                      ),
                      if (data.contactTitle.isNotEmpty ||
                          data.contactBody.isNotEmpty ||
                          data.contactEmail.isNotEmpty) ...[
                        SizedBox(height: 8.h),
                        LegalContactSection(
                          title: data.contactTitle,
                          body: data.contactBody,
                          email: data.contactEmail,
                        ),
                      ],
                    ],
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
      padding: EdgeInsets.only(bottom: 36.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$index. ${section.heading}',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppTextStyles.sizeBodyLarge.sp,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            section.body,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppTextStyles.sizeBody.sp,
              fontWeight: FontWeight.w500,
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }
}
