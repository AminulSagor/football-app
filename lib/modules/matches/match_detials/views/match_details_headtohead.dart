import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/themes/app_colors.dart';
import '../match_details_controller.dart';
import '../match_details_model.dart';
import 'match_details_facts.dart';

class MatchDetailsHeadToHeadPage extends GetView<MatchDetailsController> {
  const MatchDetailsHeadToHeadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state.value;
      final summary = state.headToHeadSummary;
      final matches = state.headToHeadMatches;

      return ListView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
        physics: const BouncingScrollPhysics(),
        children: [
          _H2HOverviewCard(summary: summary),
          SizedBox(height: 16.h),
          _H2HMatchesCard(matches: matches),
        ],
      );
    });
  }
}

BoxDecoration _sharedCardDecoration(BuildContext context) {
  final theme = Theme.of(context);
  final palette = AppColors.palette(theme.brightness);

  return BoxDecoration(
    borderRadius: BorderRadius.circular(18.r),
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [palette.surfaceSoft, palette.surface],
    ),
    border: Border.all(color: theme.dividerColor, width: 1.w),
  );
}

class _H2HOverviewCard extends StatelessWidget {
  final MatchDetailsHeadToHeadSummaryUiModel summary;

  const _H2HOverviewCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: _sharedCardDecoration(context),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'H2H Overview',
            style: AppTextStyles.label.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _SummaryBox(
                showTeamLogo: true,
                value: summary.homeWins.toString(),
                label: 'Wins',
                backgroundColor: Theme.of(context).colorScheme.primary,
                textColor: Theme.of(context).colorScheme.onPrimary,
              ),
              _SummaryBox(
                showTeamLogo: false,
                value: summary.draws.toString(),
                label: 'Draws',
                backgroundColor: Theme.of(context).colorScheme.onSurface.withAlpha(26),
                textColor: Theme.of(context).colorScheme.onSurface,
              ),
              _SummaryBox(
                showTeamLogo: true,
                value: summary.awayWins.toString(),
                label: 'Wins',
                backgroundColor: Theme.of(context).colorScheme.primary,
                textColor: Theme.of(context).colorScheme.onPrimary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryBox extends StatelessWidget {
  final String value;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final bool showTeamLogo;

  const _SummaryBox({
    required this.value,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.showTeamLogo,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [

        // Placeholder for team logos or icons
        if (showTeamLogo)
        Container(
          width: 52.w,
          height: 52.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: theme.colorScheme.primary, width: 1.w),
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: 64.w,
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          alignment: Alignment.center,
          child: Text(
            value,
            style: AppTextStyles.headline.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: AppTextStyles.label.copyWith(color: Theme.of(context).colorScheme.onSurface.withAlpha(178)),
        ),
      ],
    );
  }
}

class _H2HMatchesCard extends StatelessWidget {
  final List<MatchDetailsHeadToHeadMatchUiModel> matches;

  const _H2HMatchesCard({required this.matches});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: _sharedCardDecoration(context),
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'H2H Matches Overview',
              style: AppTextStyles.label.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          ...matches.map((match) => _MatchRow(match: match)),
          SizedBox(height: 8.h),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Load More',
                      style: AppTextStyles.label.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.keyboard_arrow_down,
                      color: theme.colorScheme.onPrimary,
                    size: 16.sp,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchRow extends StatelessWidget {
  final MatchDetailsHeadToHeadMatchUiModel match;

  const _MatchRow({required this.match});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.onSurface.withAlpha(13), width: 1.w),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                match.dateLabel,
                style: AppTextStyles.label.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(140),
                  fontSize: AppTextStyles.sizeOverline.sp,
                ),
              ),
              Row(
                children: [
                  Text(
                    match.competitionLabel,
                    style: AppTextStyles.label.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(140),
                      fontSize: AppTextStyles.sizeOverline.sp,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    width: 14.w,
                    height: 14.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: theme.colorScheme.onSurface.withAlpha(51)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  match.homeTeamName,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.label.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: match.isUpcoming
                        ? FontWeight.normal
                        : FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.colorScheme.onSurface.withAlpha(51)),
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                padding: match.isUpcoming
                    ? EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h)
                    : EdgeInsets.zero,
                decoration: match.isUpcoming
                    ? BoxDecoration(
                        color: theme.colorScheme.onSurface.withAlpha(26),
                        borderRadius: BorderRadius.circular(4.r),
                      )
                    : null,
                child: Text(
                  match.centerLabel,
                  style: match.isUpcoming
                      ? AppTextStyles.label.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(140),
                          fontWeight: FontWeight.w500,
                        )
                      : AppTextStyles.headline.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.colorScheme.onSurface.withAlpha(51)),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  match.awayTeamName,
                  textAlign: TextAlign.left,
                  style: AppTextStyles.label.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: match.isUpcoming
                        ? FontWeight.normal
                        : FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
