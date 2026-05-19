import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppColorPalette {
  final Color background;
  final Color shellBackground;
  final Color surface;
  final Color surfaceSoft;
  final Color surfaceMuted;
  final Color inputFill;

  final Color brand;
  final Color primary;
  final Color primaryAlt;
  final Color primarySoft;
  final Color link;
  final Color linkStrong;

  final Color textPrimary;
  final Color textPrimarySoft;
  final Color textStrong;
  final Color textSecondary;
  final Color textSecondarySoft;
  final Color textMuted;
  final Color textMutedSoft;
  final Color textSubtle;
  final Color textSubtleSoft;
  final Color textSubtleAlt;
  final Color textLabel;
  final Color textHint;
  final Color textOnPrimary;

  final Color inputText;
  final Color inputGradientStart;
  final Color inputGradientEnd;
  final Color inputIcon;
  final Color actionDisabled;

  final Color border;
  final Color borderSoft;
  final Color borderMuted;
  final Color divider;

  final Color error;
  final Color errorStrong;

  final Color overlay;
  final Color shadow;

  final Color iconCircleBackground;
  final Color iconCircleForeground;
  final Color navUnselected;
  final Color navBorder;

  final Color switchTrackActive;
  final Color switchThumbActive;
  final Color switchTrackInactive;
  final Color switchThumbInactive;

  final Color snackbarBackground;
  final Color snackbarText;

  const AppColorPalette({
    required this.background,
    required this.shellBackground,
    required this.surface,
    required this.surfaceSoft,
    required this.surfaceMuted,
    required this.inputFill,
    required this.brand,
    required this.primary,
    required this.primaryAlt,
    required this.primarySoft,
    required this.link,
    required this.linkStrong,
    required this.textPrimary,
    required this.textPrimarySoft,
    required this.textStrong,
    required this.textSecondary,
    required this.textSecondarySoft,
    required this.textMuted,
    required this.textMutedSoft,
    required this.textSubtle,
    required this.textSubtleSoft,
    required this.textSubtleAlt,
    required this.textLabel,
    required this.textHint,
    required this.textOnPrimary,
    required this.inputText,
    required this.inputGradientStart,
    required this.inputGradientEnd,
    required this.inputIcon,
    required this.actionDisabled,
    required this.border,
    required this.borderSoft,
    required this.borderMuted,
    required this.divider,
    required this.error,
    required this.errorStrong,
    required this.overlay,
    required this.shadow,
    required this.iconCircleBackground,
    required this.iconCircleForeground,
    required this.navUnselected,
    required this.navBorder,
    required this.switchTrackActive,
    required this.switchThumbActive,
    required this.switchTrackInactive,
    required this.switchThumbInactive,
    required this.snackbarBackground,
    required this.snackbarText,
  });
}

/// Centralized app color tokens using a subtle FIFA World Cup 2026 inspired palette.
class AppColors {
  AppColors._();

  static const AppColorPalette _dark = AppColorPalette(
    background: Color(0xFF070A18),
    shellBackground: Color(0xFF0D122A),
    surface: Color(0xFF121A33),
    surfaceSoft: Color(0xFF16244A),
    surfaceMuted: Color(0xFF202A42),
    inputFill: Color(0xFF11192E),
    brand: Color(0xFF50C950),
    primary: Color(0xFF4B5FD3),
    primaryAlt: Color(0xFF6577F0),
    primarySoft: Color(0xFF7F8EFF),
    link: Color(0xFF73D973),
    linkStrong: Color(0xFFD8FFE0),
    textPrimary: Color(0xFFF3F6FF),
    textPrimarySoft: Color(0xFFEAF0FF),
    textStrong: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFC0C8DE),
    textSecondarySoft: Color(0xFFA8B5DC),
    textMuted: Color(0xFF94A0BD),
    textMutedSoft: Color(0xFF9AB1D9),
    textSubtle: Color(0xFF77829D),
    textSubtleSoft: Color(0xFF88A0C5),
    textSubtleAlt: Color(0xFF8EA6CB),
    textLabel: Color(0xFFD8DDF0),
    textHint: Color(0xFF6F7895),
    textOnPrimary: Color(0xFFFFFFFF),
    inputText: Color(0xFFF0F4FF),
    inputGradientStart: Color(0xFF162143),
    inputGradientEnd: Color(0xFF101936),
    inputIcon: Color(0xFF73D973),
    actionDisabled: Color(0xFF39445F),
    border: Color(0x4D4B5FD3),
    borderSoft: Color(0x334B5FD3),
    borderMuted: Color(0xFF26304C),
    divider: Color(0xFF26304C),
    error: Color(0xFFFF6A70),
    errorStrong: Color(0xFFE61D25),
    overlay: Color(0xA6000000),
    shadow: Color(0x99000000),
    iconCircleBackground: Color(0xFF1A2446),
    iconCircleForeground: Color(0xFFC4CBDF),
    navUnselected: Color(0xFF8D96B1),
    navBorder: Color(0x8026304C),
    switchTrackActive: Color(0xFF50C950),
    switchThumbActive: Color(0xFFFFFFFF),
    switchTrackInactive: Color(0xFF303A55),
    switchThumbInactive: Color(0xFFB8C0D4),
    snackbarBackground: Color(0xFF172052),
    snackbarText: Color(0xFFFFFFFF),
  );

  static const AppColorPalette _light = AppColorPalette(
    background: Color(0xFFF6F8FC),
    shellBackground: Color(0xFFEEF3FB),
    surface: Color(0xFFFFFFFF),
    surfaceSoft: Color(0xFFEAF0FF),
    surfaceMuted: Color(0xFFE9EEF7),
    inputFill: Color(0xFFF1F5FB),
    brand: Color(0xFF3CAC3B),
    primary: Color(0xFF2A398D),
    primaryAlt: Color(0xFF3449B4),
    primarySoft: Color(0xFF5266D6),
    link: Color(0xFF2A398D),
    linkStrong: Color(0xFF1E2A70),
    textPrimary: Color(0xFF101833),
    textPrimarySoft: Color(0xFF1B2546),
    textStrong: Color(0xFFFFFFFF),
    textSecondary: Color(0xFF4B5674),
    textSecondarySoft: Color(0xFF5A6683),
    textMuted: Color(0xFF6D7891),
    textMutedSoft: Color(0xFF627089),
    textSubtle: Color(0xFF7A8497),
    textSubtleSoft: Color(0xFF6E7890),
    textSubtleAlt: Color(0xFF65708A),
    textLabel: Color(0xFF263154),
    textHint: Color(0xFF8E98AC),
    textOnPrimary: Color(0xFFFFFFFF),
    inputText: Color(0xFF17213F),
    inputGradientStart: Color(0xFFFFFFFF),
    inputGradientEnd: Color(0xFFF0F4FB),
    inputIcon: Color(0xFF2A398D),
    actionDisabled: Color(0xFFAEB7C9),
    border: Color(0x332A398D),
    borderSoft: Color(0x1A2A398D),
    borderMuted: Color(0xFFD7DEE9),
    divider: Color(0xFFDCE3EE),
    error: Color(0xFFE61D25),
    errorStrong: Color(0xFFB9141A),
    overlay: Color(0x66000000),
    shadow: Color(0x29081734),
    iconCircleBackground: Color(0xFFE7ECF8),
    iconCircleForeground: Color(0xFF405077),
    navUnselected: Color(0xFF707B92),
    navBorder: Color(0x5CD7DEE9),
    switchTrackActive: Color(0xFF3CAC3B),
    switchThumbActive: Color(0xFFFFFFFF),
    switchTrackInactive: Color(0xFFC8D1DF),
    switchThumbInactive: Color(0xFF7C879D),
    snackbarBackground: Color(0xFF2A398D),
    snackbarText: Color(0xFFFFFFFF),
  );

  static AppColorPalette palette(Brightness brightness) {
    return brightness == Brightness.dark ? _dark : _light;
  }

  static AppColorPalette get _active {
    return Get.isDarkMode ? _dark : _light;
  }

  static Color get background => _active.background;
  static Color get shellBackground => _active.shellBackground;
  static Color get surface => _active.surface;
  static Color get surfaceSoft => _active.surfaceSoft;
  static Color get surfaceMuted => _active.surfaceMuted;
  static Color get inputFill => _active.inputFill;

  static Color get brand => _active.brand;
  static Color get primary => _active.primary;
  static Color get primaryAlt => _active.primaryAlt;
  static Color get primarySoft => _active.primarySoft;
  static Color get link => _active.link;
  static Color get linkStrong => _active.linkStrong;

  static Color get textPrimary => _active.textPrimary;
  static Color get textPrimarySoft => _active.textPrimarySoft;
  static Color get textStrong => _active.textStrong;
  static Color get textSecondary => _active.textSecondary;
  static Color get textSecondarySoft => _active.textSecondarySoft;
  static Color get textMuted => _active.textMuted;
  static Color get textMutedSoft => _active.textMutedSoft;
  static Color get textSubtle => _active.textSubtle;
  static Color get textSubtleSoft => _active.textSubtleSoft;
  static Color get textSubtleAlt => _active.textSubtleAlt;
  static Color get textLabel => _active.textLabel;
  static Color get textHint => _active.textHint;
  static Color get textOnPrimary => _active.textOnPrimary;

  static Color get inputText => _active.inputText;
  static Color get inputGradientStart => _active.inputGradientStart;
  static Color get inputGradientEnd => _active.inputGradientEnd;
  static Color get inputIcon => _active.inputIcon;
  static Color get actionDisabled => _active.actionDisabled;

  static Color get border => _active.border;
  static Color get borderSoft => _active.borderSoft;
  static Color get borderMuted => _active.borderMuted;
  static Color get divider => _active.divider;

  static Color get error => _active.error;
  static Color get errorStrong => _active.errorStrong;

  static Color get overlay => _active.overlay;
  static Color get shadow => _active.shadow;

  static Color get iconCircleBackground => _active.iconCircleBackground;
  static Color get iconCircleForeground => _active.iconCircleForeground;
  static Color get navUnselected => _active.navUnselected;
  static Color get navBorder => _active.navBorder;

  static Color get switchTrackActive => _active.switchTrackActive;
  static Color get switchThumbActive => _active.switchThumbActive;
  static Color get switchTrackInactive => _active.switchTrackInactive;
  static Color get switchThumbInactive => _active.switchThumbInactive;

  static Color get snackbarBackground => _active.snackbarBackground;
  static Color get snackbarText => _active.snackbarText;
}
