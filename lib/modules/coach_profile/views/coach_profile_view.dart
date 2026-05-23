import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/themes/app_text_styles.dart';
import '../../../core/widgets/following_ui.dart';
import '../coach_profile_controller.dart';
import 'coach_profile_career.dart';
import 'coach_profile_profile.dart';
import 'package:fotgram/core/widgets/app_cached_network_image.dart';

class CoachProfileView extends GetView<CoachProfileController> {
  const CoachProfileView({super.key});

  Future<void> _handleFollowTap(BuildContext context, bool isFollowing) async {
    if (!isFollowing) {
      await controller.follow();
      return;
    }

    final shouldUnfollow = await showUnfollowConfirmationDialog(
      context,
      subjectLabel: 'Coach',
      helperText: 'You won’t get any notification\nabout this coach afterwards',
    );

    if (shouldUnfollow == true) {
      await controller.unfollow();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
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
                            _CoachAvatar(
                              imageUrl: state.photo,
                              seed: state.avatarSeed,
                              size: 56,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _LoadingText(
                                    isLoading: state.isLoading,
                                    width: 120,
                                    height: 14,
                                    child: Text(
                                      state.coachName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: theme.colorScheme.onSurface,
                                        fontSize:
                                            AppTextStyles.sizeBodyLarge.sp,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  _LoadingText(
                                    isLoading: state.isLoading,
                                    width: 92,
                                    height: 10,
                                    child: Text(
                                      state.teamName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: theme.colorScheme.onSurface
                                            .withAlpha(88),
                                        fontSize:
                                            AppTextStyles.sizeBodySmall.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 12.w),
                            if (!state.isLoading)
                              FollowToggleButton(
                                isFollowing: state.isFollowing,
                                onTap: () => _handleFollowTap(
                                  context,
                                  state.isFollowing,
                                ),
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
                            overlayColor: WidgetStateProperty.all(
                              Colors.transparent,
                            ),
                            dividerColor: Colors.transparent,
                            labelColor: theme.colorScheme.onSurface,
                            unselectedLabelColor: theme.colorScheme.onSurface
                                .withAlpha(130),
                            labelStyle: TextStyle(
                              fontSize: AppTextStyles.sizeBody.sp,
                              fontWeight: FontWeight.w700,
                              height: 1.1,
                            ),
                            unselectedLabelStyle: TextStyle(
                              fontSize: AppTextStyles.sizeBody.sp,
                              fontWeight: FontWeight.w600,
                              height: 1.1,
                            ),
                            tabs: const [
                              Tab(text: 'Profile'),
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
                      CoachProfileSummaryPage(),
                      CoachProfileCareerPage(),
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

class _CoachAvatar extends StatelessWidget {
  final String imageUrl;
  final String seed;
  final double size;

  const _CoachAvatar({
    required this.imageUrl,
    required this.seed,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final cleanImageUrl = imageUrl.trim();

    if (cleanImageUrl.isEmpty) {
      return SeedCircleAvatar(
        seed: seed,
        size: size,
        fontSize: AppTextStyles.sizeTiny,
      );
    }

    return ClipOval(
      child: AppCachedNetworkImage(
  imageUrl: cleanImageUrl,
  width: size.w,
  height: size.w,
  fit: BoxFit.cover,
  errorBuilder: (context) {
          return SeedCircleAvatar(
            seed: seed,
            size: size,
            fontSize: AppTextStyles.sizeTiny,
          );
        },
),
    );
  }
}

class _LoadingText extends StatelessWidget {
  final bool isLoading;
  final double width;
  final double height;
  final Widget child;

  const _LoadingText({
    required this.isLoading,
    required this.width,
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!isLoading) {
      return child;
    }

    return Container(
      width: width.w,
      height: height.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withAlpha(24),
        borderRadius: BorderRadius.circular(999.r),
      ),
    );
  }
}
