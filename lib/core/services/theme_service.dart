import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _isDarkThemeKey = 'is_dark_theme';

  Future<ThemeMode> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_isDarkThemeKey) ?? true;
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkThemeKey, mode == ThemeMode.dark);
  }
}