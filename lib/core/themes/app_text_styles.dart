import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Shared text styles and font-size tokens.
class AppTextStyles {
  AppTextStyles._();

  // Size tokens (use with .sp where responsive scaling is needed).
  static const double sizeDisplay = 44;
  static const double sizeHero = 30;
  static const double sizeTitle = 24;
  static const double sizeHeading = 20;
  static const double sizeBodyLarge = 18;
  static const double sizeBody = 16;
  static const double sizeBodySmall = 14;
  static const double sizeLabel = 13;
  static const double sizeCaption = 12;
  static const double sizeOverline = 11;
  static const double sizeTiny = 10;

  static TextStyle get brand => TextStyle(
    color: AppColors.brand,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get headline => TextStyle(
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w800,
  );

  static TextStyle get body => TextStyle(
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get bodyStrong => TextStyle(
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get muted => TextStyle(
    color: AppColors.textSubtle,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get label => TextStyle(
    color: AppColors.textLabel,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get input => TextStyle(
    color: AppColors.inputText,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get inputHint => TextStyle(
    color: AppColors.textHint,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get button => TextStyle(
    color: AppColors.textOnPrimary,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get link => TextStyle(
    color: AppColors.link,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get error => TextStyle(
    color: AppColors.error,
    fontWeight: FontWeight.w500,
  );
}
