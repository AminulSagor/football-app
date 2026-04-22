import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/themes/app_text_styles.dart';
import '../../shared/following_ui.dart';
import '../player_profile_controller.dart';
import 'player_profile_career.dart';
import 'player_profile_matches.dart';
import 'player_profile_profile.dart';
import 'player_profile_stats.dart';

class PlayerProfileView extends GetView<PlayerProfileController> {
  const PlayerProfileView({super.key});

  Future<void> _handleFollowTap(BuildContext context, bool isFollowing) async {
    if (!isFollowing) {
      controller.follow();
      return;
    }

    final shouldUnfollow = await showUnfollowConfirmationDialog(
      context,
      subjectLabel: 'Player',
      helperText: 'You won’t get any notification\nabout this player afterwards',
    );

    if (shouldUnfollow == true) {
      controller.unfollow();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 4,
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
                          children: [
                            SeedCircleAvatar(seed: state.avatarSeed, size: 56, fontSize: 9),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.playerName,
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
                                    state.teamName,
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
                            FollowToggleButton(
                              isFollowing: state.isFollowing,
                              onTap: () => _handleFollowTap(context, state.isFollowing),
                            ),
                          ],
                        ),
                        SizedBox(height: 14.h),
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
                              Tab(text: 'Profile'),
                              Tab(text: 'Matches'),
                              Tab(text: 'Stats'),
                              Tab(text: 'Career'),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                SizedBox(height: 10.h),
                Container(height: 1.h, color: theme.dividerColor),
                const Expanded(
                  child: TabBarView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      PlayerProfileSummaryPage(),
                      PlayerProfileMatchesPage(),
                      PlayerProfileStatsPage(),
                      PlayerProfileCareerPage(),
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
