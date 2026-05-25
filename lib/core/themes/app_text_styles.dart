import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const double sizeDisplay = 38;
  static const double sizeHero = 24;
  static const double sizeTitle = 18;
  static const double sizeHeading = 14;
  static const double sizeBodyLarge = 14;
  static const double sizeBody = 13;
  static const double sizeBodySmall = 12;
  static const double sizeLabel = 11;
  static const double sizeCaption = 10;
  static const double sizeOverline = 9;
  static const double sizeTiny = 8;

  static TextStyle get brand =>
      TextStyle(color: AppColors.brand, fontWeight: FontWeight.w700);

  static TextStyle get headline =>
      TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w800);

  static TextStyle get body =>
      TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500);

  static TextStyle get bodyStrong =>
      TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700);

  static TextStyle get muted =>
      TextStyle(color: AppColors.textSubtle, fontWeight: FontWeight.w500);

  static TextStyle get label =>
      TextStyle(color: AppColors.textLabel, fontWeight: FontWeight.w700);

  static TextStyle get input =>
      TextStyle(color: AppColors.inputText, fontWeight: FontWeight.w500);

  static TextStyle get inputHint =>
      TextStyle(color: AppColors.textHint, fontWeight: FontWeight.w500);

  static TextStyle get button =>
      TextStyle(color: AppColors.textOnPrimary, fontWeight: FontWeight.w700);

  static TextStyle get link =>
      TextStyle(color: AppColors.link, fontWeight: FontWeight.w600);

  static TextStyle get error =>
      TextStyle(color: AppColors.error, fontWeight: FontWeight.w500);
}
