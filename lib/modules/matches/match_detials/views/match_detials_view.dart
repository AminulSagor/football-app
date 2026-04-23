import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/themes/app_colors.dart';
import '../match_details_controller.dart';
import '../models/match_details_model.dart';
import 'match_details_facts.dart';
import 'match_details_headtohead.dart';
import 'match_details_knockout.dart';
import 'match_details_lineup.dart';
import 'match_details_stats.dart';
import 'match_detials_preview.dart';

class MatchDetialsView extends GetView<MatchDetailsController> {
  const MatchDetialsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state.value;
      final theme = Theme.of(context);

      return DefaultTabController(
        length: state.visibleTabs.length,
        child: Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0.h),
                        child: _MatchHeaderSection(state: state, controller: controller),
                      ),
                      SizedBox(height: 16.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: const _FollowButton(),
                      ),
                      SizedBox(height: 14.h),
                      _MatchTabBar(tabs: state.visibleTabs),
                      Expanded(
                        child: TabBarView(
                          physics: const BouncingScrollPhysics(),
                          children: state.visibleTabs
                              .map(_buildTabPage)
                              .toList(growable: false),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTabPage(MatchDetailsTabType type) {
    switch (type) {
      case MatchDetailsTabType.preview:
        return const MatchDetialsPreviewPage();
      case MatchDetailsTabType.facts:
        return const MatchDetailsFactsPage();
      case MatchDetailsTabType.lineup:
        return const MatchDetailsLineupPage();
      case MatchDetailsTabType.knockout:
        return const MatchDetailsKnockoutPage();
      case MatchDetailsTabType.stats:
        return const MatchDetailsStatsPage();
      case MatchDetailsTabType.headToHead:
        return const MatchDetailsHeadToHeadPage();
    }
  }
}

class _MatchHeaderSection extends StatelessWidget {
  final MatchDetailsScreenUiModel state;
  final MatchDetailsController controller;
  const _MatchHeaderSection({required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final header = state.header;

    return Column(
      children: [
        Row(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18.r),
                onTap: Get.back,
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: theme.colorScheme.onSurface,
                    size: 24.r,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 18.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(child: Expanded(child: _TeamHeader(team: header.homeTeam, alignEnd: false)), onTap: controller.onTeamNameTap),
            Expanded(
              child: Column(
                children: [
                  _StatusChip(label: header.statusChipLabel),
                  SizedBox(height: 12.h),
                  Text(
                    header.scoreOrTimeLabel,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: AppTextStyles.sizeHero.sp,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                  if (header.statusText.isNotEmpty) ...[
                    SizedBox(height: 8.h),
                    Text(
                      header.statusText,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withAlpha(170),
                        fontSize: AppTextStyles.sizeBodySmall.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            GestureDetector(child: Expanded(child: _TeamHeader(team: header.awayTeam, alignEnd: true)), onTap: controller.onTeamNameTap),
          ],
        ),
        SizedBox(height: 14.h),
        Container(
          height: 1.h,
          color: theme.dividerColor,
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _MetaLabel(
              icon: Icons.calendar_today_outlined,
              label: header.metaDateTime,
            ),
            SizedBox(width: 18.w),
            _MetaLabel(
              icon: Icons.emoji_events_outlined,
              label: header.metaCompetition,
            ),
          ],
        ),
      ],
    );
  }
}

class _TeamHeader extends StatelessWidget {
  final MatchDetailsTeamUiModel team;
  final bool alignEnd;

  const _TeamHeader({
    required this.team,
    required this.alignEnd,
  });

  @override
  Widget build(BuildContext context) {
    final crossAxisAlignment = alignEnd
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Container(
          width: 54.r,
          height: 54.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.surface,
            border: Border.all(
              color: theme.colorScheme.primary.withAlpha(200),
              width: 1.w,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          team.name,
          textAlign: alignEnd ? TextAlign.right : TextAlign.left,
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontSize: AppTextStyles.sizeBody.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;

  const _StatusChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final isLive = label.toLowerCase() == 'live';
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: isLive ? theme.colorScheme.error : theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(7.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isLive ? theme.colorScheme.onError : theme.colorScheme.onSecondary,
          fontSize: AppTextStyles.sizeCaption.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MetaLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaLabel({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 14.r, color: theme.colorScheme.onSurface.withAlpha(150)),
        SizedBox(width: 5.w),
        Text(
          label,
          style: TextStyle(
            color: theme.colorScheme.onSurface.withAlpha(150),
            fontSize: AppTextStyles.sizeCaption.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _FollowButton extends StatelessWidget {
  const _FollowButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 42.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(16.r),
      ),
      alignment: Alignment.center,
      child: Text(
        'Follow',
        style: TextStyle(
          color: theme.colorScheme.onSecondary,
          fontSize: AppTextStyles.sizeBodySmall.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _MatchTabBar extends StatelessWidget {
  final List<MatchDetailsTabType> tabs;

  const _MatchTabBar({required this.tabs});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: theme.dividerColor, width: 1.w),
          bottom: BorderSide(color: theme.dividerColor, width: 1.w),
        ),
      ),
      child: TabBar(
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicatorColor: theme.colorScheme.secondary,
        indicatorWeight: 2.h,
        labelPadding: EdgeInsets.symmetric(horizontal: 16.w),
        labelColor: theme.colorScheme.onSurface,
        unselectedLabelColor: theme.colorScheme.onSurface.withAlpha(120),
        dividerColor: Colors.transparent,
        labelStyle: TextStyle(
          fontSize: AppTextStyles.sizeBodySmall.sp,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: AppTextStyles.sizeBodySmall.sp,
          fontWeight: FontWeight.w600,
        ),
        tabs: tabs
            .map(
              (tab) => Tab(
                text: switch (tab) {
                  MatchDetailsTabType.preview => 'Preview',
                  MatchDetailsTabType.facts => 'Facts',
                  MatchDetailsTabType.lineup => 'Lineup',
                  MatchDetailsTabType.knockout => 'Knockout',
                  MatchDetailsTabType.stats => 'Stats',
                  MatchDetailsTabType.headToHead => 'Head-to-head',
                },
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}