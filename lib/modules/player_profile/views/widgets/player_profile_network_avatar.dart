import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/themes/app_colors.dart';
import 'package:fotgram/core/widgets/app_cached_network_image.dart';

class PlayerProfileNetworkAvatar extends StatelessWidget {
  final String imageUrl;
  final String seed;
  final double size;
  final double fontSize;
  final Color borderColor;
  final Color? backgroundColor;
  final BoxFit fit;

  const PlayerProfileNetworkAvatar({
    super.key,
    required this.imageUrl,
    required this.seed,
    required this.size,
    required this.fontSize,
    required this.borderColor,
    this.backgroundColor,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final cleanUrl = imageUrl.trim();
    final palette = AppColors.palette(Theme.of(context).brightness);

    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? Colors.white.withAlpha(10),
        border: Border.all(color: borderColor, width: 1.w),
      ),
      clipBehavior: Clip.antiAlias,
      child: cleanUrl.startsWith('http')
          ? AppCachedNetworkImage(
  imageUrl: cleanUrl,
  fit: fit,
  errorBuilder: (context) {
                return _SeedFallback(
                  seed: seed,
                  fontSize: fontSize,
                  textColor: palette.textPrimary,
                );
              },
)
          : _SeedFallback(
              seed: seed,
              fontSize: fontSize,
              textColor: palette.textPrimary,
            ),
    );
  }
}

class _SeedFallback extends StatelessWidget {
  final String seed;
  final double fontSize;
  final Color textColor;

  const _SeedFallback({
    required this.seed,
    required this.fontSize,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final cleanSeed = seed.trim().isEmpty ? '-' : seed.trim();

    return Center(
      child: Text(
        cleanSeed.length > 3
            ? cleanSeed.substring(0, 3).toUpperCase()
            : cleanSeed.toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize.sp,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
    );
  }
}
