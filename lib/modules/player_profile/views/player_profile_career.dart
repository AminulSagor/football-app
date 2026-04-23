// lib/modules/player_profile/views/player_profile_career.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/themes/app_colors.dart';
import '../../shared/following_ui.dart';
import '../model/player_profile_model.dart';
import '../player_profile_controller.dart';

class PlayerProfileCareerPage extends GetView<PlayerProfileController> {
  const PlayerProfileCareerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state.value;

      return ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 28.h),
        children: [
          _CareerSection(
            title: 'Senior Career',
            items: state.seniorCareer,
            includeSkeletonRows: true,
          ),
          SizedBox(height: 18.h),
          _CareerSection(
            title: 'National Team',
            items: state.nationalCareer,
            includeSkeletonRows: false,
          ),
        ],
      );
    });
  }
}

class _CareerSection extends StatelessWidget {
  final String title;
  final List<PlayerCareerClubUiModel> items;
  final bool includeSkeletonRows;

  const _CareerSection({
    required this.title,
    required this.items,
    required this.includeSkeletonRows,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppColors.palette(theme.brightness);
    final totalCount = includeSkeletonRows ? items.length : items.length;

    return Container(
      decoration: _cardDecoration(context),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
              color: palette.textHint.withAlpha(60),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: AppColors.palette(Theme.of(context).brightness).textPrimary,
                fontSize: 11.6.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 16.h),
            child: Column(
              children: [
                for (var i = 0; i < totalCount; i++) ...[
                  _CareerCard(
                    item: items[i],
                    isPlaceholder: includeSkeletonRows && i >= 3,
                  ),
                  if (i != totalCount - 1) SizedBox(height: 12.h),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CareerCard extends StatelessWidget {
  final PlayerCareerClubUiModel item;
  final bool isPlaceholder;

  const _CareerCard({
    required this.item,
    required this.isPlaceholder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppColors.palette(theme.brightness);

    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: Colors.white.withAlpha(6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SeedCircleAvatar(
            seed: isPlaceholder ? '' : item.seed,
            size: 20,
            fontSize: 8.5,
            borderColor: isPlaceholder
                ? palette.textPrimary.withAlpha(220)
                : palette.textMuted.withAlpha(120),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isPlaceholder)
                  Container(
                    width: 62.w,
                    height: 10.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(220),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  )
                else
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: palette.textPrimary,
                      fontSize: 11.7.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                SizedBox(height: 4.h),
                if (isPlaceholder)
                  Container(
                    width: 84.w,
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF39E0B3),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  )
                else
                  Text(
                    item.rangeLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xFF39E0B3),
                      fontSize: 8.1.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'MATCHES PLAYED',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: palette.textMuted.withAlpha(175),
                          fontSize: 9.2.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    _ValuePill(label: item.matches, isPlaceholder: isPlaceholder),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'GOALS',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: palette.textMuted.withAlpha(175),
                          fontSize: 9.2.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    _ValuePill(label: item.goals, isPlaceholder: isPlaceholder),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ValuePill extends StatelessWidget {
  final String label;
  final bool isPlaceholder;

  const _ValuePill({
    required this.label,
    required this.isPlaceholder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 28.w),
      height: 22.h,
      padding: EdgeInsets.symmetric(horizontal: 7.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        color: const Color(0xFF39E0B3),
      ),
      alignment: Alignment.center,
      child: isPlaceholder
          ? null
          : Text(
              label,
              style: TextStyle(
                color: Colors.black,
                fontSize: 9.sp,
                fontWeight: FontWeight.w800,
                height: 1.0,
              ),
            ),
    );
  }
}

BoxDecoration _cardDecoration(BuildContext context) {
  final theme = Theme.of(context);
  final palette = AppColors.palette(theme.brightness);

  return BoxDecoration(
    borderRadius: BorderRadius.circular(22.r),
    color: palette.surface,
    border: Border.all(
      color: palette.divider.withAlpha(85),
      width: 1.w,
    ),
  );
}