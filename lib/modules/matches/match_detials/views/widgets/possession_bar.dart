import 'package:flutter/material.dart';
import 'package:fotgram/core/themes/themes.dart';
import '../../models/match_details_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PossessionBar extends StatelessWidget {
  final MatchDetailsStatRowUiModel row;

  const PossessionBar({required this.row});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final home = double.tryParse(row.homeValue.replaceAll('%', '')) ?? 50;
    final away = double.tryParse(row.awayValue.replaceAll('%', '')) ?? 50;
    final total = home + away;
    final flexHome = total == 0 ? 50 : (home / total * 1000).round();
    final flexAway = total == 0 ? 50 : (away / total * 1000).round();

    final palette = AppColors.palette(theme.brightness);
    final rightColor = theme.brightness == Brightness.dark
        ? palette.surfaceMuted
        : theme.colorScheme.surface.withAlpha(120);

    return Container(
      height: 32.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: theme.brightness == Brightness.dark
            ? null
            : Border.all(
                color: theme.colorScheme.onSurface.withAlpha(60),
                width: 1.w,
              ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Expanded(
            flex: flexHome,
            child: Container(
              color: AppColors.primaryAlt,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              alignment: Alignment.centerLeft,
              child: Text(
                row.homeValue,
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontSize: AppTextStyles.sizeBodySmall.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          Expanded(
            flex: flexAway,
            child: Container(
              color: rightColor,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Text(
                row.awayValue,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: AppTextStyles.sizeBodySmall.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}