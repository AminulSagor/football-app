import 'package:get/get.dart';
import '../bootstrap/bootstrap_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<BootstrapController>(BootstrapController());
  }
}
