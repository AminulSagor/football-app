import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/connectivity_service.dart';
import 'no_internet_view.dart';

class AppConnectivityGate extends StatelessWidget {
  final Widget child;

  const AppConnectivityGate({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ConnectivityService>()) {
      return child;
    }

    final connectivityService = Get.find<ConnectivityService>();

    return Obx(() {
      final hasInternet = connectivityService.hasInternet.value;

      return Stack(
        children: [
          child,
          if (!hasInternet)
            Positioned.fill(
              child: NoInternetView(
                isRetrying: connectivityService.isChecking.value,
                onRetry: connectivityService.refresh,
              ),
            ),
        ],
      );
    });
  }
}
