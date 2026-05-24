import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'bootstrap_controller.dart';

class BootstrapView extends GetView<BootstrapController> {
  const BootstrapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
