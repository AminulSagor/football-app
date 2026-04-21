import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

/// App-level Material theme configuration.
class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return _buildTheme(Brightness.dark);
  }

  static ThemeData get lightTheme {
    return _buildTheme(Brightness.light);
  }

  static ThemeData _buildTheme(Brightness brightness) {
    final colors = AppColors.palette(brightness);

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: colors.primary,
      onPrimary: colors.textOnPrimary,
      secondary: colors.brand,
      onSecondary: colors.textOnPrimary,
      error: colors.error,
      onError: colors.textOnPrimary,
      surface: colors.surface,
      onSurface: colors.textPrimary,
    );

    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: colors.background,
      colorScheme: colorScheme,
      dividerColor: colors.divider,
    );

    return baseTheme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: colors.shellBackground,
        foregroundColor: colors.textPrimary,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        shadowColor: colors.shadow,
      ),
      dialogTheme: DialogThemeData(backgroundColor: colors.surface),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.shellBackground,
        selectedItemColor: colors.brand,
        unselectedItemColor: colors.navUnselected,
        type: BottomNavigationBarType.fixed,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.snackbarBackground,
        contentTextStyle: TextStyle(color: colors.snackbarText),
        behavior: SnackBarBehavior.floating,
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? colors.switchTrackActive
              : colors.switchTrackInactive;
        }),
        thumbColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? colors.switchThumbActive
              : colors.switchThumbInactive;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.textOnPrimary,
          elevation: 0,
          textStyle: TextStyle(
            fontSize: AppTextStyles.sizeBody,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      textTheme: baseTheme.textTheme.copyWith(
        titleLarge: TextStyle(
          color: colors.textPrimary,
          fontSize: AppTextStyles.sizeHero,
          fontWeight: FontWeight.w800,
        ),
        titleMedium: TextStyle(
          color: colors.textPrimary,
          fontSize: AppTextStyles.sizeTitle,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: TextStyle(
          color: colors.textSecondary,
          fontSize: AppTextStyles.sizeBody,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: TextStyle(
          color: colors.textSecondary,
          fontSize: AppTextStyles.sizeBodySmall,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          color: colors.textLabel,
          fontSize: AppTextStyles.sizeCaption,
          fontWeight: FontWeight.w700,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        fillColor: colors.inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colors.primary, width: 1.2),
        ),
      ),
    );
  }
}
