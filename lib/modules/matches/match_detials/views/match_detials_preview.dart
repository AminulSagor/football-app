import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/themes/app_colors.dart';
import '../match_details_controller.dart';
import '../match_details_model.dart';

class MatchDetialsPreviewPage extends GetView<MatchDetailsController> {
  const MatchDetialsPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state.value;

      final theme = Theme.of(context);

      return ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
        children: [
          _SectionCard(
            child: _VenueCard(venue: state.venue),
          ),
          SizedBox(height: 16.h),
          _SectionCard(
            child: _MetaCard(meta: state.meta),
          ),
          if (state.topScorers != null) ...[
            SizedBox(height: 16.h),
            _SectionCard(
              title: state.topScorers!.title,
              child: _TopScorersCompareCard(model: state.topScorers!),
            ),
          ],
          SizedBox(height: 16.h),
          _SectionCard(
            title: state.teamForm.title,
            child: _TeamFormCard(teamForm: state.teamForm),
          ),
          if (state.header.scenario == MatchDetailsScenario.live) ...[
            SizedBox(height: 16.h),
          ] else ...[
            SizedBox(height: 16.h),
            _SectionCard(
              title: 'About the match',
              child: _AboutMatchCard(text: state.aboutText),
            ),
          ],
        ],
      );
    });
  }
}

class _SectionCard extends StatelessWidget {
  final String? title;
  final Widget child;

  const _SectionCard({
    this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withAlpha(6),
                borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
              ),
              child: Text(
                title!,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: AppTextStyles.sizeBodySmall.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _VenueCard extends StatelessWidget {
  final MatchDetailsVenueUiModel venue;

  const _VenueCard({required this.venue});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(Icons.stadium_outlined, color: theme.colorScheme.onSurface.withAlpha(160), size: 18.r),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                venue.stadiumName,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: AppTextStyles.sizeBody.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                venue.city,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withAlpha(150),
                  fontSize: AppTextStyles.sizeCaption.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 14.h),
              Row(
                children: [
                    Icon(Icons.grid_view_rounded,
                      color: theme.colorScheme.onSurface.withAlpha(140), size: 16.r),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Surface',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withAlpha(120),
                          fontSize: AppTextStyles.sizeCaption.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        venue.surface,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: AppTextStyles.sizeBodySmall.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: 34.r,
          height: 34.r,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.location_on_outlined,
            color: theme.colorScheme.primary,
            size: 18.r,
          ),
        ),
      ],
    );
  }
}

class _MetaCard extends StatelessWidget {
  final MatchDetailsMetaInfoUiModel meta;

  const _MetaCard({required this.meta});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        _MetaInfoRow(
          icon: Icons.calendar_today_outlined,
          label: meta.dateTime,
        ),
        SizedBox(height: 18.h),
        _MetaInfoRow(
          icon: Icons.sports_soccer_outlined,
          label: meta.competition,
        ),
        SizedBox(height: 18.h),
        _MetaInfoRow(
          icon: Icons.flag_circle_outlined,
          label: meta.referee,
          leadingFlag: true,
        ),
      ],
    );
  }
}

class _MetaInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool leadingFlag;

  const _MetaInfoRow({
    required this.icon,
    required this.label,
    this.leadingFlag = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.onSurface.withAlpha(170), size: 18.r),
        SizedBox(width: 14.w),
        if (leadingFlag)
          Container(
            width: 14.w,
            height: 10.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.r),
              gradient: const LinearGradient(
                colors: [Color(0xFF0033A0), Color(0xFFFCD116), Color(0xFFCE1126)],
              ),
            ),
          ),
        if (leadingFlag) SizedBox(width: 8.w),
            Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: AppTextStyles.sizeBody.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _TopScorersCompareCard extends StatelessWidget {
  final MatchDetailsTopScorerCompareUiModel model;

  const _TopScorersCompareCard({required this.model});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          model.competitionLabel,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: AppTextStyles.sizeBodyLarge.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 20.h),
        Row(
          children: [
            Expanded(child: _ComparePlayer(name: model.homePlayerName)),
            Expanded(child: _ComparePlayer(name: model.awayPlayerName, alignEnd: true)),
          ],
        ),
        SizedBox(height: 18.h),
        for (var i = 0; i < model.metrics.length; i++) ...[
          _CompareMetricBar(metric: model.metrics[i]),
          if (i != model.metrics.length - 1) SizedBox(height: 14.h),
        ],
      ],
    );
  }
}

class _ComparePlayer extends StatelessWidget {
  final String name;
  final bool alignEnd;

  const _ComparePlayer({
    required this.name,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          width: 58.r,
          height: 58.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.brand,
              width: 1.w,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          name,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: AppTextStyles.sizeBody.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _CompareMetricBar extends StatelessWidget {
  final MatchDetailsCompareMetricUiModel metric;

  const _CompareMetricBar({required this.metric});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          metric.label,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: AppTextStyles.sizeBodySmall.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          height: 36.h,
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurface.withAlpha(8),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    metric.homeValue,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: AppTextStyles.sizeBodyLarge.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              Container(width: 1.w, color: theme.colorScheme.onSurface.withAlpha(12)),
              Expanded(
                child: Center(
                  child: Text(
                    metric.awayValue,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: AppTextStyles.sizeBodyLarge.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TeamFormCard extends StatelessWidget {
  final MatchDetailsTeamFormUiModel teamForm;

  const _TeamFormCard({required this.teamForm});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(child: _FormColumn(results: teamForm.homeResults, isHome: true)),
        SizedBox(width: 26.w),
        Expanded(child: _FormColumn(results: teamForm.awayResults, isHome: false)),
      ],
    );
  }
}

class _FormColumn extends StatelessWidget {
  final List<String> results;
  final bool isHome;

  const _FormColumn({
    required this.results,
    required this.isHome,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: results
          .map(
            (result) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                children: [
                  Container(
                    width: 22.r,
                    height: 22.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                                  border: Border.all(
                                  color: theme.colorScheme.onSurface.withAlpha(60),
                                  width: 1.w,
                                ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: isHome ? theme.colorScheme.primary : theme.colorScheme.error,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      result,
                      style: TextStyle(
                        color: isHome ? theme.colorScheme.onPrimary : theme.colorScheme.onError,
                        fontSize: AppTextStyles.sizeCaption.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _AboutMatchCard extends StatelessWidget {
  final String text;

  const _AboutMatchCard({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: AppTextStyles.sizeBody.sp,
            fontWeight: FontWeight.w500,
            height: 1.65,
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: const Color(0xFF119166),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            'Expand',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: AppTextStyles.sizeBodySmall.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

BoxDecoration _cardDecoration(BuildContext context) {
  final theme = Theme.of(context);

  return BoxDecoration(
    borderRadius: BorderRadius.circular(18.r),
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [AppColors.surfaceSoft, AppColors.surface],
    ),
    border: Border.all(
      color: theme.dividerColor,
      width: 1.w,
    ),
  );
}