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

  final List<int> pages = const [0, 1, 2, 3, 4];

  void onTabChanged(int index) {
    currentIndex.value = index;
  }

  void openSearch(BuildContext context) {
    final searchController = Get.find<MatchesSearchController>();
    searchController.reset();

    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const MatchesSearchView()),
    );
  }

  void openNotifications(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const NotificationView()),
    );
  }

  bool onWillPop() {
    if (currentIndex.value != 0) {
      currentIndex.value = 0;
      return false;
    }
    return true;
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
