import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../leagues/leagues_controller.dart';
import '../matches/matches_controller.dart';
import '../following/following_controller.dart';
import '../news/news_controller.dart';
import '../settings/settings_controller.dart';
import 'notification/notification_controller.dart';
import 'notification/notification_view.dart';
import 'search/matches_search_controller.dart';
import 'search/matches_search_view.dart';

class BottomNavController extends GetxController {
  final RxInt currentIndex = 0.obs;
  final RxSet<int> visitedPageIndexes = <int>{0}.obs;

  final List<int> pages = const [0, 1, 2, 3, 4];

  bool _hasStartedBackgroundWarmup = false;

  @override
  void onReady() {
    super.onReady();
    _startBackgroundWarmup();
  }

  void onTabChanged(int index) {
    visitedPageIndexes.add(index);
    currentIndex.value = index;

    if (Get.isRegistered<MatchesController>()) {
      Get.find<MatchesController>().onBottomTabVisibilityChanged(index == 0);
    }

    if (index == 1) {
      unawaited(_refreshLeaguesTab());
    }

    if (index == 2) {
      unawaited(_refreshFollowingTab());
    }

    if (index == 3) {
      unawaited(_refreshNewsTab());
    }
  }

  void openSearch(BuildContext context) {
    final searchController = Get.find<MatchesSearchController>();
    searchController.reset();

    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const MatchesSearchView()));
  }

  void openNotifications(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const NotificationView()));
  }

  bool onWillPop() {
    if (currentIndex.value != 0) {
      currentIndex.value = 0;
      if (Get.isRegistered<MatchesController>()) {
        Get.find<MatchesController>().onBottomTabVisibilityChanged(true);
      }
      return false;
    }
    return true;
  }

  void _startBackgroundWarmup() {
    if (_hasStartedBackgroundWarmup) return;

    _hasStartedBackgroundWarmup = true;
    unawaited(_warmUpInactiveTabs());
  }

  Future<void> _warmUpInactiveTabs() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (isClosed) return;
    unawaited(_refreshLeaguesTab(isWarmup: true));

    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (isClosed) return;
    unawaited(_refreshNewsTab(isWarmup: true));

    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (isClosed) return;
    unawaited(_refreshFollowingTab(isWarmup: true));
  }

  Future<void> _refreshLeaguesTab({bool isWarmup = false}) async {
    final LeaguesController leaguesController;
    try {
      leaguesController = Get.find<LeaguesController>();
    } catch (_) {
      return;
    }
    if (isWarmup) {
      await leaguesController.ensureLoaded();
      return;
    }

    await leaguesController.refreshSilentlyIfStale();
  }

  Future<void> _refreshFollowingTab({bool isWarmup = false}) async {
    final FollowingController followingController;
    try {
      followingController = Get.find<FollowingController>();
    } catch (_) {
      return;
    }
    if (isWarmup) {
      await followingController.ensureLoaded();
      return;
    }

    await followingController.refreshSilentlyIfStale();
  }

  Future<void> _refreshNewsTab({bool isWarmup = false}) async {
    final NewsController newsController;
    try {
      newsController = Get.find<NewsController>();
    } catch (_) {
      return;
    }
    if (isWarmup) {
      await newsController.ensureLoaded();
      return;
    }

    await newsController.refreshSilentlyIfStale();
  }
}

class BottomNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavController>(() => BottomNavController());
    NotificationBinding().dependencies();
    MatchesBinding().dependencies();
    LeaguesBinding().dependencies();
    FollowingBinding().dependencies();
    NewsBinding().dependencies();
    SettingsBinding().dependencies();
  }
}
