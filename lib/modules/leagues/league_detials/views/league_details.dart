import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/themes/app_text_styles.dart';
import '../../../shared/following_ui.dart';
import '../league_details_controller.dart';
import 'league_details_fixture.dart';
import 'league_details_knockout.dart';
import 'league_details_overview.dart';
import 'league_details_playerstats.dart';
import 'league_details_seasons.dart';
import 'league_details_table.dart';
import 'league_details_teamstats.dart';

class LeagueDetailsPage extends GetView<LeagueDetailsController> {
  const LeagueDetailsPage({super.key});

  Future<void> _handleFollowTap(BuildContext context, bool isFollowing) async {
    if (!isFollowing) {
      controller.follow();
      return;
    }

    final shouldUnfollow = await showUnfollowConfirmationDialog(
      context,
      subjectLabel: 'League',
      helperText: 'You won’t get any notification\nabout this league afterwards',
    );

    if (shouldUnfollow == true) {
      controller.unfollow();
    }
  }

  Future<void> _showSeasonPicker(BuildContext context) async {
    final theme = Theme.of(context);
    final currentState = controller.state.value;

    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: theme.colorScheme.surface,
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
                    color: theme.dividerColor.withAlpha(160),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                SizedBox(height: 18.h),
                for (final season in currentState.seasons)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16.r),
                        onTap: () => Navigator.of(context).pop(season),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 14.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: season == currentState.selectedSeason
                                ? theme.colorScheme.secondary.withAlpha(28)
                                : theme.colorScheme.surface.withAlpha(120),
                            border: Border.all(
                              color: season == currentState.selectedSeason
                                  ? theme.colorScheme.secondary
                                  : theme.dividerColor.withAlpha(150),
                              width: 1.w,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  season,
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface,
                                    fontSize: AppTextStyles.sizeBody.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              if (season == currentState.selectedSeason)
                                Icon(
                                  Icons.check_rounded,
                                  size: 18.r,
                                  color: theme.colorScheme.secondary,
                                ),
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

    if (selected == null || !context.mounted) {
      return;
    }

    controller.selectSeason(selected);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: controller.isWorldCup ? 4 : 5,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: theme.brightness == Brightness.light ?BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [theme.scaffoldBackgroundColor, const Color.fromARGB(255, 170, 253, 226)],
            ),
          ) : null,
          child: SafeArea(
            bottom: false,
            child: Obx(() {
              final state = controller.state.value;

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 0),
                    child: Column(
                      children: [
                        _LeagueDetailsHeader(
                          title: state.leagueName,
                          onBackTap: () => Navigator.of(context).maybePop(),
                        ),
                        SizedBox(height: 18.h),
                        Row(
                          children: [
                            _SeasonButton(
                              season: state.selectedSeason,
                              onTap: () => _showSeasonPicker(context),
                            ),
                            SizedBox(width: 10.w),
                            _FollowButton(
                              isFollowing: state.isFollowing,
                              onTap: () => _handleFollowTap(context, state.isFollowing),
                            ),
                          ],
                        ),
                        SizedBox(height: 18.h),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TabBar(
                            isScrollable: true,
                            labelPadding: EdgeInsets.only(right: 24.w),
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorColor: theme.colorScheme.secondary,
                            indicatorWeight: 2.2.h,
                            splashFactory: NoSplash.splashFactory,
                            overlayColor: WidgetStateProperty.all(
                              Colors.transparent,
                            ),
                            labelColor: theme.colorScheme.onSurface,
                            unselectedLabelColor: theme.colorScheme.onSurface
                                .withAlpha(118),
                            labelStyle: TextStyle(
                              fontSize: AppTextStyles.sizeBody.sp,
                              fontWeight: FontWeight.w700,
                              height: 1.1,
                            ),
                            unselectedLabelStyle: TextStyle(
                              fontSize: AppTextStyles.sizeBody.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.1,
                            ),
                            tabs: controller.isWorldCup
                                ? const [
                                    Tab(text: 'Table'),
                                    Tab(text: 'Knockout'),
                                    Tab(text: 'Fixtures'),
                                    Tab(text: 'Seasons'),
                                  ]
                                : const [
                                    Tab(text: 'Overview'),
                                    Tab(text: 'Table'),
                                    Tab(text: 'Fixtures'),
                                    Tab(text: 'Player stats'),
                                    Tab(text: 'Team stats'),
                                  ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Expanded(
                    child: TabBarView(
                      physics: const BouncingScrollPhysics(),
                      children: controller.isWorldCup
                          ? const [
                              LeagueDetailsTablePage(),
                              LeagueDetailsKnockoutPage(),
                              LeagueDetailsFixturesPage(),
                              LeagueDetailsSeasonsPage(),
                            ]
                          : const [
                              LeagueDetailsOverviewPage(),
                              LeagueDetailsTablePage(),
                              LeagueDetailsFixturesPage(),
                              LeagueDetailsPlayerStatsPage(),
                              LeagueDetailsTeamStatsPage(),
                            ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _LeagueDetailsHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBackTap;

  const _LeagueDetailsHeader({required this.title, required this.onBackTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18.r),
            onTap: onBackTap,
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Icon(
                Icons.arrow_back_rounded,
                size: 24.r,
                color: theme.colorScheme.onSurface.withAlpha(230),
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.secondary.withAlpha(188),
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.emoji_events_rounded,
            size: 20.r,
            color: theme.scaffoldBackgroundColor,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: AppTextStyles.sizeBody.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ],
    );
  }
}

class _SeasonButton extends StatelessWidget {
  final String season;
  final VoidCallback onTap;

  const _SeasonButton({required this.season, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: onTap,
        child: Container(
          height: 38.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            color: theme.colorScheme.surface.withAlpha(104),
            border: Border.all(
              color: theme.dividerColor.withAlpha(170),
              width: 1.w,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                season,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: AppTextStyles.sizeBodySmall.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 6.w),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18.r,
                color: theme.colorScheme.onSurface.withAlpha(190),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FollowButton extends StatelessWidget {
  final bool isFollowing;
  final VoidCallback onTap;

  const _FollowButton({required this.isFollowing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          height: 32.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            color: isFollowing
                ? Colors.transparent
                : theme.colorScheme.secondary,
            border: Border.all(
              color: theme.colorScheme.secondary,
              width: 1.w,
            ),
            boxShadow: isFollowing
                ? const <BoxShadow>[]
                : [
                    BoxShadow(
                      color: theme.colorScheme.secondary.withAlpha(32),
                      blurRadius: 18.r,
                      offset: Offset(0, 8.h),
                    ),
                  ],
          ),
          alignment: Alignment.center,
          child: Text(
            isFollowing ? 'Following' : 'Follow',
            style: TextStyle(
              color: isFollowing
                  ? theme.colorScheme.secondary
                  : const Color(0xFF05110D),
              fontSize: AppTextStyles.sizeBodySmall.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
