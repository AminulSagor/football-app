import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'widgets/widgets.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/themes/app_colors.dart';
import '../match_details_controller.dart';
import '../models/match_details_model.dart';
class MatchDetailsStatsPage extends GetView<MatchDetailsController> {
  const MatchDetailsStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state.value;

      if (state.statsSections.isEmpty) {
        return ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 26.h, 16.w, 28.h),
          children: const [
            _StatsEmptyState(),
          ],
        );
      }

      return ListView.separated(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
        physics: const BouncingScrollPhysics(),
        itemCount: state.statsSections.length,
        separatorBuilder: (context, index) => SizedBox(height: 16.h),
        itemBuilder: (context, index) {
          final section = state.statsSections[index];
          return _StatsSectionCard(section: section);
        },
      );
    });
  }
}

class _StatsEmptyState extends StatelessWidget {
  const _StatsEmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 26.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: AppColors.surface,
        border: Border.all(color: theme.dividerColor, width: 1.w),
      ),
      child: Column(
        children: [
          Icon(
            Icons.query_stats_rounded,
            size: 34.r,
            color: theme.colorScheme.onSurface.withAlpha(120),
          ),
          SizedBox(height: 12.h),
          Text(
            'Stats not available yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: AppTextStyles.sizeBody.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Detailed match statistics will show here once the provider publishes them.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withAlpha(145),
              fontSize: AppTextStyles.sizeBodySmall.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsSectionCard extends StatelessWidget {
  final MatchDetailsStatSectionUiModel section;
  // final bool showHeader;
  const _StatsSectionCard({required this.section});

  BoxDecoration _cardDecoration(BuildContext context) {
    final theme = Theme.of(context);

    return BoxDecoration(
      borderRadius: BorderRadius.circular(18.r),
      color: AppColors.surface,
      border: Border.all(color: theme.dividerColor, width: 1.w),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppColors.palette(theme.brightness);
    return Container(
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(section.title != '')
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: palette.surfaceMuted, //theme.colorScheme.surface.withAlpha(6),
              borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
            ),
            child: Text(
              section.title,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: AppTextStyles.sizeBodySmall.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (section.showPossessionBar) ...[
                  PossessionBar(row: section.rows.first),
                  SizedBox(height: 16.h),
                  ...section.rows.skip(1).map((row) => _StatRow(row: row)),
                ] else
                  ...section.rows.map((row) => _StatRow(row: row)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final MatchDetailsStatRowUiModel row;

  const _StatRow({required this.row});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    int homeVal = int.tryParse(row.homeValue.replaceAll('%', '')) ?? 0;
    int awayVal = int.tryParse(row.awayValue.replaceAll('%', '')) ?? 0;
    final isPercentage = row.homeValue.contains('%');

    final bool homeIsBetter = !isPercentage && homeVal > awayVal;
    final bool awayIsBetter = !isPercentage && awayVal > homeVal;
    final Color highlight = theme.colorScheme.primary;
    final Color defaultText = theme.colorScheme.onSurface;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: homeIsBetter ? highlight.withOpacity(0.15) : Colors.transparent,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              row.homeValue,
              style: AppTextStyles.label.copyWith(
                color: homeIsBetter ? highlight : defaultText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              row.label,
              textAlign: TextAlign.center,
              style: AppTextStyles.label.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(178),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: awayIsBetter ? highlight.withAlpha(45) : Colors.transparent,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              row.awayValue,
              style: AppTextStyles.label.copyWith(
                color: awayIsBetter ? highlight : defaultText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
