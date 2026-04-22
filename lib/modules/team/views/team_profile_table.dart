import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/themes/app_text_styles.dart';
import '../../../core/themes/app_colors.dart';
import '../team_profile_controller.dart';
import '../team_profile_model.dart';

class TeamProfileTablePage extends GetView<TeamProfileController> {
  const TeamProfileTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = Theme.of(context);
      final rows = controller.state.value.standings;
      return ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 28.h),
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22.r),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  theme.scaffoldBackgroundColor,
                  theme.colorScheme.surface.withAlpha(
                    theme.brightness == Brightness.dark ? 40 : 14,
                  ),
                ],
              ),
              border: Border.all(color: theme.dividerColor, width: 1.w),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22.r),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                    color: theme.colorScheme.surface.withAlpha(40),
                    child: Row(
                      children: const [
                        _HeaderLabel(width: 28, text: '#'),
                        Expanded(flex: 8, child: _HeaderLabel(text: 'TEAM')),
                        Expanded(flex: 2, child: _HeaderLabel(text: 'PL', align: TextAlign.center)),
                        Expanded(flex: 2, child: _HeaderLabel(text: 'GD', align: TextAlign.center)),
                        Expanded(flex: 2, child: _HeaderLabel(text: 'PTS', align: TextAlign.right)),
                      ],
                    ),
                  ),
                  for (var index = 0; index < rows.length; index++)
                    _StandingsTableRow(
                      item: rows[index],
                      showDivider: index != rows.length - 1,
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: 18.h),
          Wrap(
            spacing: 18.w,
            runSpacing: 12.h,
            children: [
              _LegendItem(color: AppColors.brand, label: 'CHAMPIONS LEAGUE'),
              _LegendItem(color: AppColors.primaryAlt, label: 'EUROPA LEAGUE'),
              _LegendItem(color: AppColors.error, label: 'RELEGATION'),
            ],
          ),
        ],
      );
    });
  }
}

class _StandingsTableRow extends StatelessWidget {
  final TeamProfileStandingsRowUiModel item;
  final bool showDivider;

  const _StandingsTableRow({
    required this.item,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rank = int.tryParse(item.rank) ?? 0;

    return Container(
      height: 65.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withAlpha(4),
        border: showDivider
            ? Border(
                bottom: BorderSide(
                  color: theme.dividerColor,
                  width: 1.w,
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          Container(width: 3.w, color: _zoneColor(rank)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                children: [
                  SizedBox(
                    width: 20.w,
                    child: Text(
                      item.rank,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: AppTextStyles.sizeBodySmall.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    flex: 8,
                    child: Row(
                      children: [
                        Container(
                          width: 24.r,
                          height: 24.r,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.r),
                            color: item.badgeColor,
                            border: Border.all(
                              color: theme.colorScheme.onSurface.withAlpha(28),
                              width: .8.w,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            item.badgeSeed,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 6.4.sp,
                              fontWeight: FontWeight.w800,
                              height: 1,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            item.teamName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: AppTextStyles.sizeBody.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      item.played,
                      textAlign: TextAlign.center,
                      style: _valueStyle(),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      item.goalDifference,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _goalDifferenceColor(item.goalDifference, Theme.of(context)),
                        fontSize: AppTextStyles.sizeBody.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      item.points,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: rank <= 5 ? AppColors.brand : Theme.of(context).colorScheme.onSurface,
                        fontSize: AppTextStyles.sizeHeading.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _zoneColor(int rank) {
    if (rank >= 1 && rank <= 5) {
      return AppColors.brand;
    }
    if (rank >= 6 && rank <= 9) {
      return AppColors.primaryAlt;
    }
    if (rank >= 18) {
      return AppColors.error;
    }
    return Colors.transparent;
  }

  Color _goalDifferenceColor(String value, ThemeData theme) {
    return value.startsWith('-') ? AppColors.error : AppColors.brand;
  }

  TextStyle _valueStyle() {
    final theme = Theme.of(Get.context!);
    return TextStyle(
      color: theme.colorScheme.onSurface.withAlpha(180),
      fontSize: AppTextStyles.sizeBody.sp,
      fontWeight: FontWeight.w500,
    );
  }
}

class _HeaderLabel extends StatelessWidget {
  final String text;
  final double? width;
  final TextAlign align;

  const _HeaderLabel({
    required this.text,
    this.width,
    this.align = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = Text(
      text,
      textAlign: align,
      style: TextStyle(
        color: theme.colorScheme.onSurface.withAlpha(82),
        fontSize: AppTextStyles.sizeOverline.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.25,
      ),
    );

    if (width == null) {
      return label;
    }

    return SizedBox(width: width!.w, child: label);
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8.r,
          height: 8.r,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(88),
            fontSize: AppTextStyles.sizeOverline.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.25,
          ),
        ),
      ],
    );
  }
}
