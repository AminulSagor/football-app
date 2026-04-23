import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/themes/app_text_styles.dart';
import '../../shared/following_ui.dart';
import '../coach_profile_controller.dart';
import '../model/coach_profile_model.dart';

class CoachProfileCareerPage extends GetView<CoachProfileController> {
  const CoachProfileCareerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = controller.state.value.careerItems;
      final theme = Theme.of(context);
      return ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 28.h),
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22.r),
              gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [theme.colorScheme.surface, theme.scaffoldBackgroundColor]),
              border: Border.all(color: theme.colorScheme.onSurface.withAlpha(10), width: 1.w),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  decoration: BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)), color: theme.colorScheme.onSurface.withAlpha(4)),
                  child: Text('Coaching Career', style: TextStyle(color: theme.colorScheme.onSurface, fontSize: AppTextStyles.sizeBody.sp, fontWeight: FontWeight.w700)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 16.h),
                  child: Column(
                    children: [
                      for (var index = 0; index < items.length; index++) ...[
                        _CareerTile(item: items[index]),
                        if (index != items.length - 1) SizedBox(height: 12.h),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class _CareerTile extends StatelessWidget {
  final CoachCareerItemUiModel item;

  const _CareerTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final isPlaceholder = item.title == 'Placeholder';
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18.r), color: theme.colorScheme.onSurface.withAlpha(6)),
      child: Row(
        children: [
          SeedCircleAvatar(seed: isPlaceholder ? '' : item.seed, size: 22, fontSize: AppTextStyles.sizeTiny, borderColor: theme.colorScheme.onSurface.withAlpha(55)),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isPlaceholder)
                  Container(width: 82.w, height: 10.h, decoration: BoxDecoration(color: theme.colorScheme.onSurface.withAlpha(180), borderRadius: BorderRadius.circular(10.r)))
                else
                  Text(item.title, style: TextStyle(color: theme.colorScheme.onSurface, fontSize: AppTextStyles.sizeBodyLarge.sp, fontWeight: FontWeight.w700)),
                SizedBox(height: 6.h),
                if (isPlaceholder)
                  Container(width: 82.w, height: 7.h, decoration: BoxDecoration(color: theme.colorScheme.onSurface.withAlpha(180), borderRadius: BorderRadius.circular(10.r)))
                else
                  Text(item.rangeLabel, style: TextStyle(color: theme.colorScheme.primary, fontSize: AppTextStyles.sizeCaption.sp, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
