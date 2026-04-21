import 'package:get/get.dart';
import '../matches/matches_controller.dart';
import '../settings/settings_controller.dart';

class BottomNavController extends GetxController {
  final RxInt currentIndex = 0.obs;

  final List<int> pages = const [0, 1, 2, 3, 4];

  void onTabChanged(int index) {
    currentIndex.value = index;
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
    MatchesBinding().dependencies();
    SettingsBinding().dependencies();
  }
}
