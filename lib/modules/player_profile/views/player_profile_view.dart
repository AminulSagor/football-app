import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../core/widgets/following_ui.dart';
import '../player_profile_controller.dart';
import 'player_profile_career.dart';
import 'player_profile_matches.dart';
import 'player_profile_profileview.dart';
import 'player_profile_stats.dart';
import 'widgets/player_profile_skeletonizer.dart';
import 'widgets/player_profile_network_avatar.dart';

class PlayerProfileView extends GetView<PlayerProfileController> {
  const PlayerProfileView({super.key});

  static const double _profileTextScaleFactor = 1.0;

  Future<void> _handleFollowTap(BuildContext context, bool isFollowing) async {
    if (!isFollowing) {
      await controller.follow();
      return;
    }

    final shouldUnfollow = await showUnfollowConfirmationDialog(
      context,
      subjectLabel: 'Player',
      helperText:
          'You won’t get any notification\nabout this player afterwards',
    );

    if (shouldUnfollow == true) {
      await controller.unfollow();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppColors.palette(theme.brightness);
    final mediaQuery = MediaQuery.of(context);
    final scaledTextTheme = theme.textTheme.apply(
      fontSizeFactor: _profileTextScaleFactor,
    );
    final currentScale = mediaQuery.textScaler.scale(1);

    return Theme(
      data: theme.copyWith(textTheme: scaledTextTheme),
      child: MediaQuery(
        data: mediaQuery.copyWith(
          textScaler: TextScaler.linear(currentScale * _profileTextScaleFactor),
        ),
        child: DefaultTabController(
          length: 4,
          child: Scaffold(
            backgroundColor: palette.background,
            body: Obx(() {
              final state = controller.state.value;
              final viewState = state.skeletonized;

              return PlayerProfileSkeletonizer(
                enabled: state.shouldSkeletonize,
                child: Container(
                  decoration: BoxDecoration(color: palette.background),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20.r),
                                      onTap: () =>
                                          Navigator.of(context).maybePop(),
                                      child: Padding(
                                        padding: EdgeInsets.all(4.w),
                                        child: Icon(
                                          Icons.arrow_back_rounded,
                                          size: 23.r,
                                          color: palette.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 14.h),
                              Row(
                                children: [
                                  PlayerProfileNetworkAvatar(
                                    imageUrl: viewState.avatarImageUrl,
                                    seed: viewState.avatarSeed,
                                    size: 58,
                                    fontSize: AppTextStyles.sizeTiny,
                                    borderColor: const Color(0xFF23D5A8),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          viewState.playerName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: palette.textPrimary,
                                            fontSize:
                                                AppTextStyles.sizeHeading.sp,
                                            fontWeight: FontWeight.w800,
                                            height: 1.12,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Row(
                                          children: [
                                            if (viewState
                                                .teamLogoUrl
                                                .isNotEmpty) ...[
                                              PlayerProfileNetworkAvatar(
                                                imageUrl: viewState.teamLogoUrl,
                                                seed: viewState.teamName,
                                                size: 16,
                                                fontSize:
                                                    AppTextStyles.sizeBodySmall,
                                                borderColor: palette.textMuted
                                                    .withAlpha(100),
                                                backgroundColor: Colors.white,
                                                fit: BoxFit.contain,
                                              ),
                                              SizedBox(width: 6.w),
                                            ],
                                            Expanded(
                                              child: Text(
                                                viewState.teamName.isEmpty
                                                    ? 'Club unavailable'
                                                    : viewState.teamName,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: palette.textMuted,
                                                  fontSize: AppTextStyles
                                                      .sizeCaption
                                                      .sp,
                                                  fontWeight: FontWeight.w500,
                                                  height: 1.1,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  FollowToggleButton(
                                    isFollowing: viewState.isFollowing,
                                    onTap: () => _handleFollowTap(
                                      context,
                                      viewState.isFollowing,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.h),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TabBar(
                                  isScrollable: true,
                                  labelPadding: EdgeInsets.only(right: 28.w),
                                  indicatorSize: TabBarIndicatorSize.label,
                                  indicatorColor: const Color(0xFF26E0B0),
                                  indicatorWeight: 2.2.h,
                                  splashFactory: NoSplash.splashFactory,
                                  overlayColor: WidgetStateProperty.all(
                                    Colors.transparent,
                                  ),
                                  dividerColor: Colors.transparent,
                                  tabAlignment: TabAlignment.start,
                                  labelColor: palette.textPrimary,
                                  unselectedLabelColor: palette.textMuted,
                                  labelStyle: TextStyle(
                                    fontSize: AppTextStyles.sizeBodySmall.sp,
                                    fontWeight: FontWeight.w700,
                                    height: 1.1,
                                  ),
                                  unselectedLabelStyle: TextStyle(
                                    fontSize: AppTextStyles.sizeBodySmall.sp,
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
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          height: 1.h,
                          color: palette.divider.withAlpha(130),
                        ),
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
              );
            }),
          ),
        ),
      ),
    );
  }
}
