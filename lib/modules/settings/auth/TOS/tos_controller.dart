import 'package:get/get.dart';

import 'models/legal_models.dart';
import 'service/legal_content_service.dart';

class LegalController extends GetxController {
  final LegalContentService _service;

  late final PrivacyPolicyUiModel privacyPolicy;
  late final TermsAndConditionUiModel termsAndCondition;

  LegalController({LegalContentService? service})
    : _service = service ?? const LegalContentService();

  @override
  void onInit() {
    super.onInit();
    privacyPolicy = _service.getPrivacyPolicy();
    termsAndCondition = _service.getTermsAndCondition();
  }
}

class LegalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LegalController>(() => LegalController());
  }
}
