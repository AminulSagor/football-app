import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/themes/app_text_styles.dart';
import '../settings/settings_controller.dart';
import '../shared/following_ui.dart';
import 'following_controller.dart';
import 'following_model.dart';

class FollowingView extends GetView<FollowingController> {
  const FollowingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settingsController = Get.find<SettingsController>();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.scaffoldBackgroundColor,
            theme.colorScheme.surface.withAlpha(
              theme.brightness == Brightness.dark ? 34 : 16,
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: Obx(() {
          final settingsState = settingsController.state.value;
          if (settingsState.isRestoringSession) {
            return Center(
              child: SizedBox(
                width: 26.r,
                height: 26.r,
                child: CircularProgressIndicator(
                  strokeWidth: 2.3.w,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.secondary,
                  ),
                ),
              ),
            );
          }

          if (!settingsState.isLoggedIn) {
            return _GuestView(
              onSignInTap: () => settingsController.openSignInModal(context),
            );
          }

          return Obx(() {
            final state = controller.state.value;
            final section = state.activeSection;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: _FollowingTabs(
                    selectedTab: state.selectedTab,
                    onTap: controller.selectTab,
                  ),
                ),
                SizedBox(height: 18.h),
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 22.h),
                    children: [
                      _SectionTitle(label: 'Following'),
                      SizedBox(height: 14.h),
                      for (var index = 0; index < section.followingItems.length; index++) ...[
                        _FollowingCard(
                          item: section.followingItems[index],
                          showFollowButton: false,
                          onTap: () => controller.openItem(section.followingItems[index]),
                        ),
                        if (index != section.followingItems.length - 1)
                          SizedBox(height: 12.h),
                      ],
                      SizedBox(height: 24.h),
                      _SectionTitle(label: 'Trending'),
                      SizedBox(height: 14.h),
                      for (var index = 0; index < section.trendingItems.length; index++) ...[
                        _FollowingCard(
                          item: section.trendingItems[index],
                          showFollowButton: true,
                          onTap: () => controller.openItem(section.trendingItems[index]),
                          onFollowTap: () => controller.follow(section.trendingItems[index]),
                        ),
                        if (index != section.trendingItems.length - 1)
                          SizedBox(height: 12.h),
                      ],
                    ],
                  ),
                ),
              ],
            );
          });
        }),
      ),
    );
  }
}

class _FollowingTabs extends StatelessWidget {
  final FollowingTabType selectedTab;
  final ValueChanged<FollowingTabType> onTap;

  const _FollowingTabs({required this.selectedTab, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        _TabItem(
          label: 'Leagues',
          isSelected: selectedTab == FollowingTabType.leagues,
          onTap: () => onTap(FollowingTabType.leagues),
        ),
        _TabItem(
          label: 'Players',
          isSelected: selectedTab == FollowingTabType.players,
          onTap: () => onTap(FollowingTabType.players),
        ),
        _TabItem(
          label: 'Teams',
          isSelected: selectedTab == FollowingTabType.teams,
          onTap: () => onTap(FollowingTabType.teams),
        ),
        _TabItem(
          label: 'Coach',
          isSelected: selectedTab == FollowingTabType.coach,
          onTap: () => onTap(FollowingTabType.coach),
        ),
        Expanded(child: Container(height: 1.h, color: Colors.transparent)),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 24.w),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurface.withAlpha(130),
                    fontSize: AppTextStyles.sizeBody.sp,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  width: 62.w,
                  height: 2.h,
                  color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String label;

  const _SectionTitle({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: AppTextStyles.sizeBody.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _FollowingCard extends StatelessWidget {
  final FollowingItemUiModel item;
  final bool showFollowButton;
  final VoidCallback onTap;
  final VoidCallback? onFollowTap;

  const _FollowingCard({
    required this.item,
    required this.showFollowButton,
    required this.onTap,
    this.onFollowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22.r),
        onTap: onTap,
        child: Container(
          height: 74.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.r),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Theme.of(context).colorScheme.surface, Theme.of(context).scaffoldBackgroundColor],
            ),
            border: Border.all(color: Theme.of(context).colorScheme.onSurface.withAlpha(10), width: 1.w),
          ),
          child: Row(
            children: [
              SeedCircleAvatar(seed: item.seed, size: 46, fontSize: AppTextStyles.sizeTiny),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: AppTextStyles.sizeBody.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (item.subtitle.isNotEmpty) ...[
                      SizedBox(height: 3.h),
                      Text(
                        item.subtitle,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
                          fontSize: AppTextStyles.sizeBodySmall.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (showFollowButton)
                FollowToggleButton(isFollowing: false, onTap: onFollowTap ?? () {})
              else
                Icon(
                  Icons.chevron_right_rounded,
                  size: 22.r,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(135),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuestView extends StatelessWidget {
  final VoidCallback onSignInTap;

  const _GuestView({required this.onSignInTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: const _FollowingTabs(
            selectedTab: FollowingTabType.leagues,
            onTap: _noopTabChange,
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 22.h),
            child: Column(
              children: [
                const Spacer(),
                Text(
                  'Sign in required',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(34),
                    fontSize: AppTextStyles.sizeTitle.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 26.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28.r),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Theme.of(context).colorScheme.surface, Theme.of(context).scaffoldBackgroundColor],
                    ),
                    border: Border.all(color: Theme.of(context).colorScheme.onSurface.withAlpha(10), width: 1.w),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Experience More',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: AppTextStyles.sizeTitle.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Sign in to sync your favorites across devices\nand get personalized match updates.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
                          fontSize: AppTextStyles.sizeBody.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.55,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      SizedBox(
                        width: double.infinity,
                        height: 54.h,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(18.r),
                            onTap: onSignInTap,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18.r),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontSize: AppTextStyles.sizeBodyLarge.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Center(
                        child: Text(
                          'New to Fotgram? Join Fotgram',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary.withAlpha(220),
                            fontSize: AppTextStyles.sizeBody.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

void _noopTabChange(FollowingTabType value) {}
