// lib/modules/player_profile/views/player_profile_stats.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/themes/app_colors.dart';
import '../model/player_profile_model.dart';
import '../player_profile_controller.dart';

class PlayerProfileStatsPage extends GetView<PlayerProfileController> {
  const PlayerProfileStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppColors.palette(theme.brightness);

    return Obx(() {
      final state = controller.state.value;

      return ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 28.h),
        children: [
          Container(
            height: 42.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: palette.surface,
              border: Border.all(color: palette.divider.withAlpha(85), width: 1.w),
            ),
            child: Row(
              children: [
                Container(
                  width: 18.r,
                  height: 18.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: palette.textMuted.withAlpha(110),
                      width: 1.w,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    state.selectedSeason,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: palette.textPrimary,
                      fontSize: 10.8.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: palette.textPrimary,
                  size: 18.r,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            decoration: _cardDecoration(context),
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: const Color(0xFF108B65),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '2,083',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Minutes Played',
                          style: TextStyle(
                            color: Colors.white.withAlpha(180),
                            fontSize: 8.7.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      for (var i = 0; i < state.summaryMetrics.length; i++) ...[
                        Expanded(child: _SummaryMetric(item: state.summaryMetrics[i])),
                        if (i != state.summaryMetrics.length - 1) SizedBox(width: 10.w),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 18.h),
          Container(
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
                    'Season performance',
                    style: TextStyle(
                      color: palette.textPrimary,
                      fontSize: 11.6.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 18.h),
                  child: Column(
                    children: [
                      for (var i = 0; i < state.statSections.length; i++) ...[
                        _StatSection(item: state.statSections[i]),
                        if (i != state.statSections.length - 1)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 18.h),
                            child: Container(
                              height: 1.h,
                              color: palette.divider.withAlpha(110),
                            ),
                          ),
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

class _SummaryMetric extends StatelessWidget {
  final PlayerProfileMetricUiModel item;

  const _SummaryMetric({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppColors.palette(theme.brightness);

    return Container(
      height: 58.h,
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Colors.white.withAlpha(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item.value,
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: 11.sp,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            item.label,
            style: TextStyle(
              color: palette.textMuted.withAlpha(150),
              fontSize: 8.8.sp,
              fontWeight: FontWeight.w500,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatSection extends StatelessWidget {
  final PlayerProfileStatSectionUiModel item;

  const _StatSection({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppColors.palette(theme.brightness);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.title,
          style: TextStyle(
            color: palette.textPrimary,
            fontSize: 11.6.sp,
            fontWeight: FontWeight.w800,
            height: 1.1,
          ),
        ),
        SizedBox(height: 18.h),
        for (var i = 0; i < item.metrics.length; i++) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  item.metrics[i].label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: palette.textMuted.withAlpha(180),
                    fontSize: 10.2.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Container(
                constraints: BoxConstraints(minWidth: 22.w),
                height: 20.h,
                padding: EdgeInsets.symmetric(horizontal: 7.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  color: item.metrics[i].valueColor,
                ),
                alignment: Alignment.center,
                child: Text(
                  item.metrics[i].value,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 8.8.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.0,
                  ),
                ),
              ),
            ],
          ),
          if (i != item.metrics.length - 1) SizedBox(height: 16.h),
        ],
      ],
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