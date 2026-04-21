import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/theme_service.dart';

class ThemeController extends GetxController {
  ThemeController({required ThemeService themeService})
    : _themeService = themeService;

  final ThemeService _themeService;

  final Rx<ThemeMode> _themeMode = ThemeMode.dark.obs;

  ThemeMode get themeMode => _themeMode.value;
  bool get isDarkMode => _themeMode.value == ThemeMode.dark;

  Future<void> loadSavedTheme() async {
    _themeMode.value = await _themeService.loadThemeMode();
  }

  Future<void> toggleTheme() async {
    final nextMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(nextMode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode.value = mode;
    Get.changeThemeMode(mode);
    await _themeService.saveThemeMode(mode);
  }
}