import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/themes/app_colors.dart';
import '../../../../../core/themes/app_text_styles.dart';
import '../models/legal_models.dart';
import '../tos_controller.dart';
import 'legal_widgets.dart';

class TermsConditionView extends GetView<LegalController> {
  const TermsConditionView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = controller.termsAndCondition;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: LegalBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 0),
                child: const LegalTopBar(title: 'Terms & Condition'),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(22.w, 24.h, 22.w, 30.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LegalLastUpdated(value: data.lastUpdated),
                      SizedBox(height: 26.h),
                      ...List.generate(
                        data.sections.length,
                        (index) => _TermsSectionItem(
                          index: index + 1,
                          section: data.sections[index],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      LegalContactSection(
                        title: data.contactTitle,
                        body: data.contactBody,
                        email: data.contactEmail,
                      ),
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

class _TermsSectionItem extends StatelessWidget {
  final int index;
  final LegalParagraphSectionModel section;

  const _TermsSectionItem({required this.index, required this.section});

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
              fontSize: AppTextStyles.sizeHero.sp,
              fontWeight: FontWeight.w700,
              height: 1.05,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            section.body,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppTextStyles.sizeBodyLarge.sp,
              fontWeight: FontWeight.w500,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}
