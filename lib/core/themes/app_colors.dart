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

/// Centralized app color tokens derived from auth (sign-in/sign-up) palette.
class AppColors {
  AppColors._();

  static const AppColorPalette _dark = AppColorPalette(
    background: Color(0xFF0B0F0D),
    shellBackground: Color(0xFF0B0F0D),
    surface: Color(0xFF141B18),
    surfaceSoft: Color(0xFF10201C),
    surfaceMuted: Color(0xFF232D2B),
    inputFill: Color(0xFF0E1816),
    brand: Color(0xFF6AD9B0),
    primary: Color(0xFF02724F),
    primaryAlt: Color(0xFF0D8E66),
    primarySoft: Color(0xFF5FD9AF),
    link: Color(0xFF91F4D0),
    linkStrong: Color(0xFFCCFCEB),
    textPrimary: Color(0xFFE7EFEC),
    textPrimarySoft: Color(0xFFE4ECE9),
    textStrong: Color(0xFFE8F8F1),
    textSecondary: Color(0xFFA6B9B2),
    textSecondarySoft: Color(0xFF70AFA0),
    textMuted: Color(0xFF8DA29B),
    textMutedSoft: Color(0xFF76B7A5),
    textSubtle: Color(0xFF6F827C),
    textSubtleSoft: Color(0xFF84B9AB),
    textSubtleAlt: Color(0xFF86B6AA),
    textLabel: Color(0xFFC9D7D2),
    textHint: Color(0xFF4D5D58),
    textOnPrimary: Color(0xFFE9F7F2),
    inputText: Color(0xFFE0EBE6),
    inputGradientStart: Color(0xFF24312E),
    inputGradientEnd: Color(0xFF2A3532),
    inputIcon: Color(0xFF008861),
    actionDisabled: Color(0xFF355650),
    border: Color(0x4D185143),
    borderSoft: Color(0x33185143),
    borderMuted: Color(0xFF1F322D),
    divider: Color(0xFF1F322D),
    error: Color(0xFFD26E6E),
    errorStrong: Color.fromARGB(255, 243, 61, 61),
    overlay: Color(0x9F000000),
    shadow: Color(0x80000000),
    iconCircleBackground: Color(0xFF18332D),
    iconCircleForeground: Color(0xFF8DB8AD),
    navUnselected: Color(0xFF90A49D),
    navBorder: Color.fromARGB(132, 31, 50, 45),
    switchTrackActive: Color(0xFF79DAB7),
    switchThumbActive: Color(0xFFF3F8F6),
    switchTrackInactive: Color(0xFF2B3F39),
    switchThumbInactive: Color(0xFFB8C8C2),
    snackbarBackground: Color(0xFF141B18),
    snackbarText: Color(0xFFE8F8F1),
  );

  static const AppColorPalette _light = AppColorPalette(
    background: Color(0xFFF4FAF7),
    shellBackground: Color(0xFFEAF4F0),
    surface: Color(0xFFFFFFFF),
    surfaceSoft: Color.fromARGB(255, 205, 247, 226),
    surfaceMuted: Color(0xFFE2EEE8),
    inputFill: Color(0xFFF3F8F5),
    brand: Color(0xFF0B8D66),
    primary: Color(0xFF02724F),
    primaryAlt: Color(0xFF0A805C),
    primarySoft: Color(0xFF1AA77B),
    link: Color(0xFF0B8D66),
    linkStrong: Color(0xFF056247),
    textPrimary: Color(0xFF10221C),
    textPrimarySoft: Color(0xFF19312A),
    textStrong: Color(0xFFF4FCF8),
    textSecondary: Color(0xFF4D655E),
    textSecondarySoft: Color(0xFF58756D),
    textMuted: Color(0xFF6E857D),
    textMutedSoft: Color(0xFF5A756E),
    textSubtle: Color(0xFF7A9089),
    textSubtleSoft: Color(0xFF6C8780),
    textSubtleAlt: Color(0xFF5F7A72),
    textLabel: Color(0xFF294139),
    textHint: Color(0xFF8CA29B),
    textOnPrimary: Color(0xFFF4FCF8),
    inputText: Color(0xFF1A332C),
    inputGradientStart: Color(0xFFF4F9F6),
    inputGradientEnd: Color(0xFFEAF4F0),
    inputIcon: Color(0xFF0A8A63),
    actionDisabled: Color(0xFFA8BFB7),
    border: Color(0x3321715A),
    borderSoft: Color(0x1A21715A),
    borderMuted: Color(0xFFD3E2DC),
    divider: Color.fromARGB(190, 175, 194, 184),
    error: Color(0xFFB54F4F),
    errorStrong: Color(0xFF9E4343),
    overlay: Color(0x66000000),
    shadow: Color(0x29000000),
    iconCircleBackground: Color(0xFFE0ECE7),
    iconCircleForeground: Color(0xFF3D5F56),
    navUnselected: Color(0xFF718882),
    navBorder: Color.fromARGB(90, 132, 160, 151),
    switchTrackActive: Color(0xFF68CFAE),
    switchThumbActive: Color(0xFFFFFFFF),
    switchTrackInactive: Color(0xFFC1D2CC),
    switchThumbInactive: Color(0xFF8AA39A),
    snackbarBackground: Color(0xFF02724F),
    snackbarText: Color(0xFFF4FCF8),
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
