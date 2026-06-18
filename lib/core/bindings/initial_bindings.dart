import 'package:get/get.dart';
import '../bootstrap/bootstrap_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<BootstrapController>()) {
      Get.put<BootstrapController>(BootstrapController(), permanent: true);
    }
  }
}
