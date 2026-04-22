import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/themes/app_text_styles.dart';
import '../../shared/following_ui.dart';
import '../team_profile_controller.dart';
import '../team_profile_model.dart';
import 'team_profile_matches.dart';
import 'team_profile_overview.dart';
import 'team_profile_squad.dart';
import 'team_profile_table.dart';
import 'team_profile_trophies.dart';

class TeamProfileView extends GetView<TeamProfileController> {
  const TeamProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 5,
      initialIndex: controller.initialTabIndex,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.scaffoldBackgroundColor,
                theme.colorScheme.surface.withAlpha(
                  theme.brightness == Brightness.dark ? 40 : 14,
                ),
                theme.scaffoldBackgroundColor,
              ],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
                  child: Obx(() {
                    final state = controller.state.value;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _HeaderSection(state: state, controller: controller),
                        SizedBox(height: 14.h),
                        _TabBar(theme: theme),
                      ],
                    );
                  }),
                ),
                SizedBox(height: 10.h),
                const Expanded(
                  child: TabBarView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      TeamProfileOverviewPage(),
                      TeamProfileTablePage(),
                      TeamProfileMatchesPage(),
                      TeamProfileSquadPage(),
                      TeamProfileTrophiesPage(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final TeamProfileViewModel state;
  final TeamProfileController controller;

  const _HeaderSection({
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20.r),
                onTap: () => Navigator.of(context).maybePop(),
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    size: 24.r,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _TeamAvatar(
              seed: state.team.badgeSeed,
              color: state.team.badgeColor,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.team.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: theme.colorScheme.onSurface,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    state.team.country,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: theme.colorScheme.onSurface.withAlpha(88),
                      fontSize: AppTextStyles.sizeBodySmall.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            _FollowButton(
              isFollowing: state.isFollowing,
              onTap: () async {
                if (!state.isFollowing) {
                  controller.follow();
                  return;
                }

                final shouldUnfollow = await showUnfollowConfirmationDialog(
                  context,
                  subjectLabel: 'Team',
                  helperText:
                      'You won’t get any notification\nabout this team afterwards',
                );

                if (shouldUnfollow == true) {
                  controller.unfollow();
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _TabBar extends StatelessWidget {
  final ThemeData theme;

  const _TabBar({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TabBar(
            isScrollable: true,
            labelPadding: EdgeInsets.only(right: 28.w),
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: theme.colorScheme.secondary,
            indicatorWeight: 2.2.h,
            splashFactory: NoSplash.splashFactory,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            dividerColor: Colors.transparent,
            labelColor: theme.colorScheme.onSurface,
            unselectedLabelColor: theme.colorScheme.onSurface.withAlpha(130),
            labelStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              height: 1.1,
            ),
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Table'),
              Tab(text: 'Matches'),
              Tab(text: 'Squad'),
              Tab(text: 'Trophies'),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        Container(height: 1.h, color: theme.dividerColor),
      ],
    );
  }
}

class _FollowButton extends StatelessWidget {
  final bool isFollowing;
  final VoidCallback onTap;

  const _FollowButton({
    required this.isFollowing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = isFollowing ? 'Following' : 'Follow';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: onTap,
        child: Container(
          height: 32.h,
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            color: isFollowing ? Colors.transparent : theme.colorScheme.secondary,
            border: Border.all(
              color: theme.colorScheme.secondary,
              width: 1.2.w,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isFollowing ? theme.colorScheme.secondary : theme.colorScheme.onSecondary,
              fontSize: AppTextStyles.sizeBodySmall.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _TeamAvatar extends StatelessWidget {
  final String seed;
  final Color color;
  final double size;

  const _TeamAvatar({
    required this.seed,
    required this.color,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.surface,
        border: Border.all(color: color, width: 1.w),
      ),
      alignment: Alignment.center,
      child: Text(
        seed,
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: 10.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}