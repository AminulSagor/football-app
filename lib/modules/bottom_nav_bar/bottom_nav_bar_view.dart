import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/themes/app_text_styles.dart';
import '../following/following_view.dart';
import '../leagues/leagues_view.dart';
import '../matches/matches_view.dart';
import '../matches/search/matches_search_controller.dart';
import '../matches/search/matches_search_view.dart';
import '../shared/app_bar_view.dart';
import 'bottom_nav_bar_controller.dart';
import '../news/news_view.dart';
import '../settings/settings_view.dart';

class BottomNavBarView extends GetView<BottomNavController> {
  const BottomNavBarView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomNavTheme = theme.bottomNavigationBarTheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (controller.onWillPop() && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Obx(
          () => Stack(
            children: List.generate(controller.pages.length, (index) {
              final isCurrentPage = controller.currentIndex.value == index;
              return Offstage(
                offstage: !isCurrentPage,
                child: TickerMode(
                  enabled: isCurrentPage,
                  child: _tabPage(index),
                ),
              );
            }),
          ),
        ),
        bottomNavigationBar: Obx(
          () => Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: theme.dividerColor, width: 2.w),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: controller.currentIndex.value,
              onTap: controller.onTabChanged,
              type: BottomNavigationBarType.fixed,

              backgroundColor: bottomNavTheme.backgroundColor,
              selectedItemColor: bottomNavTheme.selectedItemColor,
              unselectedItemColor: bottomNavTheme.unselectedItemColor,
              selectedLabelStyle: TextStyle(
                fontSize: AppTextStyles.sizeCaption.sp,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: AppTextStyles.sizeCaption.sp,
                fontWeight: FontWeight.w500,
              ),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.sports_soccer_outlined),
                  activeIcon: Icon(Icons.sports_soccer),
                  label: 'Matches',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.emoji_events_outlined),
                  activeIcon: Icon(Icons.emoji_events),
                  label: 'Leagues',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.star_border),
                  activeIcon: Icon(Icons.star),
                  label: 'Following',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.newspaper_outlined),
                  activeIcon: Icon(Icons.newspaper),
                  label: 'News',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  activeIcon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _tabPage(int index) {
  return switch (index) {
    0 => const _GetNavigator(
      id: 0,
      page: _BottomNavSharedAppBarWrapper(child: MatchesView()),
    ),
    1 => const _GetNavigator(
      id: 1,
      page: _BottomNavSharedAppBarWrapper(child: LeaguesView()),
    ),
    2 => const _GetNavigator(
      id: 2,
      page: _BottomNavSharedAppBarWrapper(child: FollowingView()),
    ),
    3 => const _GetNavigator(
      id: 3,
      page: _BottomNavSharedAppBarWrapper(child: NewsView()),
    ),
    4 => const _GetNavigator(id: 4, page: SettingsView()),
    _ => const _GetNavigator(id: 4, page: SettingsView()),
  };
}

class _BottomNavSharedAppBarWrapper extends StatelessWidget {
  final Widget child;

  const _BottomNavSharedAppBarWrapper({required this.child});

  void _openSearch(BuildContext context) {
    final searchController = Get.find<MatchesSearchController>();
    searchController.reset();

    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const MatchesSearchView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          CustomAppBar(
            title: 'KICSCORE',
            isBrandTitle: true,
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
            titleStyle: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: AppTextStyles.sizeHeading.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.25,
            ),
            actions: [
              CustomAppBarIconButton(
                icon: Icons.notifications,
                size: 20.r,
                color: theme.colorScheme.onSurface.withAlpha(180),
                onTap: () {},
              ),
              CustomAppBarIconButton(
                icon: Icons.search,
                size: 22.r,
                color: theme.colorScheme.onSurface.withAlpha(180),
                onTap: () => _openSearch(context),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _GetNavigator extends StatelessWidget {
  final int id;
  final Widget page;
  const _GetNavigator({Key? key, required this.id, required this.page})
    : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Get.nestedKey(id),
      onGenerateRoute: (settings) =>
          MaterialPageRoute(builder: (context) => page),
    );
  }
}
