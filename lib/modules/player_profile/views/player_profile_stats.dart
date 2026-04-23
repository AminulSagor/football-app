import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/themes/app_text_styles.dart';
import '../../shared/following_ui.dart';
import '../player_profile_controller.dart';
import '../model/player_profile_model.dart';

class PlayerProfileStatsPage extends GetView<PlayerProfileController> {
  const PlayerProfileStatsPage({super.key});

  Future<void> _showSeasonPicker(BuildContext context) async {
    final current = controller.state.value;
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF141B18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(18.w, 14.h, 18.w, 18.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(120),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                SizedBox(height: 18.h),
                for (final season in current.seasons)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16.r),
                        onTap: () => Navigator.of(context).pop(season),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: season == current.selectedSeason
                                ? const Color(0xFF39E0B3).withAlpha(24)
                                : Colors.white.withAlpha(6),
                            border: Border.all(
                              color: season == current.selectedSeason
                                  ? const Color(0xFF39E0B3)
                                  : Colors.white.withAlpha(16),
                              width: 1.w,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  season,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: AppTextStyles.sizeBody.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              if (season == current.selectedSeason)
                                Icon(Icons.check_rounded, size: 18.r, color: const Color(0xFF39E0B3)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null) {
      controller.selectSeason(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state.value;
      return ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 28.h),
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(18.r),
              onTap: () => _showSeasonPicker(context),
              child: Container(
                height: 48.h,
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.r),
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFF12201D), Color(0xFF1F2A28)],
                  ),
                  border: Border.all(color: Colors.white.withAlpha(10), width: 1.w),
                ),
                child: Row(
                  children: [
                    SeedCircleAvatar(seed: '', size: 20, fontSize: 0, borderColor: Colors.white.withAlpha(50)),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        state.selectedSeason,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppTextStyles.sizeBody.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down_rounded, size: 22.r, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 18.h),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22.r),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFF12201D), Color(0xFF1F2A28)],
              ),
              border: Border.all(color: Colors.white.withAlpha(10), width: 1.w),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: const Color(0xFF0F8B67),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('2,083', style: TextStyle(color: Colors.white, fontSize: AppTextStyles.sizeBody.sp, fontWeight: FontWeight.w800)),
                        SizedBox(height: 4.h),
                        Text('Minutes Played', style: TextStyle(color: Colors.white.withAlpha(170), fontSize: AppTextStyles.sizeCaption.sp, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      for (var index = 0; index < state.summaryMetrics.length; index++) ...[
                        Expanded(child: _SummaryMetric(item: state.summaryMetrics[index])),
                        if (index != state.summaryMetrics.length - 1) SizedBox(width: 10.w),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 22.h),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22.r),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFF12201D), Color(0xFF1F2A28)],
              ),
              border: Border.all(color: Colors.white.withAlpha(10), width: 1.w),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
                    color: Colors.white.withAlpha(4),
                  ),
                  child: Text(
                    'Season performance',
                    style: TextStyle(color: Colors.white, fontSize: AppTextStyles.sizeBody.sp, fontWeight: FontWeight.w700),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 18.h),
                  child: Column(
                    children: [
                      for (var sectionIndex = 0; sectionIndex < state.statSections.length; sectionIndex++) ...[
                        _StatSection(item: state.statSections[sectionIndex]),
                        if (sectionIndex != state.statSections.length - 1)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: Container(height: 1.h, color: Colors.white.withAlpha(10)),
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
    return Container(
      height: 60.h,
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r), color: Colors.white.withAlpha(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(item.value, style: TextStyle(color: Colors.white, fontSize: AppTextStyles.sizeBody.sp, fontWeight: FontWeight.w800)),
          SizedBox(height: 4.h),
          Text(item.label, style: TextStyle(color: Colors.white.withAlpha(90), fontSize: AppTextStyles.sizeCaption.sp, fontWeight: FontWeight.w500)),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(item.title, style: TextStyle(color: Colors.white, fontSize: AppTextStyles.sizeBodyLarge.sp, fontWeight: FontWeight.w800)),
        SizedBox(height: 18.h),
        for (var index = 0; index < item.metrics.length; index++) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  item.metrics[index].label,
                  style: TextStyle(color: Colors.white.withAlpha(150), fontSize: AppTextStyles.sizeBody.sp, fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                width: 24.w,
                height: 20.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  color: item.metrics[index].valueColor,
                ),
                alignment: Alignment.center,
                child: Text(
                  item.metrics[index].value,
                  style: TextStyle(color: Colors.black, fontSize: AppTextStyles.sizeCaption.sp, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          if (index != item.metrics.length - 1) SizedBox(height: 16.h),
        ],
      ],
    );
  }
}
