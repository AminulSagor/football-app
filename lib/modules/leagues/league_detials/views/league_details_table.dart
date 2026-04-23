import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/themes/app_text_styles.dart';
import '../league_detials_model.dart';
import '../league_details_controller.dart';

class LeagueDetailsTablePage extends GetView<LeagueDetailsController> {
  const LeagueDetailsTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final rows = controller.state.value.standingsRows;
      final isWorldCup = controller.isWorldCup;

      if (!isWorldCup && rows.isEmpty) {
        return LeagueDetailsPlaceholderPage(
          title: controller.tableTitle,
          message: controller.tableMessage,
        );
      }

      if (isWorldCup) {
        final groups = controller.worldCupGroups;
        return ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
          children: [
            for (var index = 0; index < groups.length; index++) ...[
              _WorldCupGroupCard(group: groups[index]),
              if (index != groups.length - 1) SizedBox(height: 16.h),
            ],
          ],
        );
      }

      return ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
        children: [
          _StandingsTableCard(rows: rows),
          SizedBox(height: 22.h),
          const _TableLegend(),
        ],
      );
    });
  }
}


class _WorldCupGroupCard extends StatelessWidget {
  final LeagueDetailsWorldCupGroupUiModel group;

  const _WorldCupGroupCard({required this.group});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF12201D), Color(0xFF1F2A28)],
        ),
        border: Border.all(color: Colors.white.withAlpha(10), width: 1.w),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Column(
          children: [
            Container(
              height: 52.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(8),
                border: Border(
                  bottom: BorderSide(
                    color: theme.dividerColor.withAlpha(70),
                    width: 1.w,
                  ),
                ),
              ),
              child: Text(
                group.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppTextStyles.sizeBody.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            _StandingsTableHeader(),
            for (var index = 0; index < group.rows.length; index++) ...[
              _StandingsTableRow(item: group.rows[index]),
              if (index != group.rows.length - 1)
                Divider(
                  height: 1.h,
                  thickness: 1,
                  color: theme.dividerColor.withAlpha(60),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StandingsTableCard extends StatelessWidget {
  final List<LeagueDetailsStandingsRowUiModel> rows;

  const _StandingsTableCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface.withAlpha(210),
            theme.colorScheme.surface.withAlpha(132),
          ],
        ),
        border: Border.all(
          color: theme.dividerColor.withAlpha(150),
          width: 1.w,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.r),
        child: Column(
          children: [
            _StandingsTableHeader(),
            for (var index = 0; index < rows.length; index++) ...[
              _StandingsTableRow(item: rows[index]),
              if (index != rows.length - 1)
                Divider(
                  height: 1.h,
                  thickness: 1,
                  color: theme.dividerColor.withAlpha(70),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StandingsTableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 46.h,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(18),
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor.withAlpha(150),
            width: 1.w,
          ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 3.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                children: [
                  SizedBox(
                    width: 20.w,
                    child: Text('#', style: _headerStyle(theme)),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    flex: 8,
                    child: Text('TEAM', style: _headerStyle(theme)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'PL',
                      textAlign: TextAlign.center,
                      style: _headerStyle(theme),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'GD',
                      textAlign: TextAlign.center,
                      style: _headerStyle(theme),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'PTS',
                      textAlign: TextAlign.right,
                      style: _headerStyle(theme),
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

  TextStyle _headerStyle(ThemeData theme) {
    return TextStyle(
      color: theme.colorScheme.onSurface.withAlpha(88),
      fontSize: AppTextStyles.sizeOverline.sp,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.25,
    );
  }
}

class _StandingsTableRow extends StatelessWidget {
  final LeagueDetailsStandingsRowUiModel item;

  const _StandingsTableRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rank = int.tryParse(item.rank) ?? 0;

    return Container(
      height: 60.h,
      decoration: BoxDecoration(color: Colors.white.withAlpha(6)),
      child: Row(
        children: [
          Container(width: 3.w, color: _zoneColor(theme, rank)),
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
                              color: Colors.white.withAlpha(32),
                              width: 0.8.w,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            item.badgeSeed,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppTextStyles.sizeTiny.sp,
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
                              fontSize: AppTextStyles.sizeBodySmall.sp,
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
                      style: _valueStyle(theme),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      item.goalDifference,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _goalDifferenceColor(theme, item.goalDifference),
                        fontSize: AppTextStyles.sizeBodySmall.sp,
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
                        color: _pointsColor(theme, rank),
                        fontSize: AppTextStyles.sizeBody.sp,
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

  TextStyle _valueStyle(ThemeData theme) {
    return TextStyle(
      color: theme.colorScheme.onSurface.withAlpha(210),
      fontSize: AppTextStyles.sizeBodySmall.sp,
      fontWeight: FontWeight.w600,
    );
  }

  Color _zoneColor(ThemeData theme, int rank) {
    if (rank >= 18) {
      return _relegationColor;
    }

    if (rank >= 6 && rank <= 7) {
      return _europaLeagueColor;
    }

    if (rank >= 1 && rank <= 5) {
      return theme.colorScheme.secondary;
    }

    return theme.dividerColor.withAlpha(36);
  }

  Color _goalDifferenceColor(ThemeData theme, String value) {
    final normalized = value.trim();

    if (normalized.startsWith('-')) {
      return _relegationColor;
    }

    if (normalized.startsWith('+')) {
      return theme.colorScheme.secondary;
    }

    return theme.colorScheme.onSurface.withAlpha(190);
  }

  Color _pointsColor(ThemeData theme, int rank) {
    if (rank >= 1 && rank <= 4) {
      return theme.colorScheme.secondary;
    }

    return theme.colorScheme.onSurface;
  }
}

class _TableLegend extends StatelessWidget {
  const _TableLegend();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: Wrap(
        spacing: 18.w,
        runSpacing: 10.h,
        children: [
          _TableLegendItem(
            color: theme.colorScheme.secondary,
            label: 'CHAMPIONS LEAGUE',
          ),
          const _TableLegendItem(
            color: _europaLeagueColor,
            label: 'EUROPA LEAGUE',
          ),
          const _TableLegendItem(color: _relegationColor, label: 'RELEGATION'),
        ],
      ),
    );
  }
}

class _TableLegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _TableLegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            color: theme.colorScheme.onSurface.withAlpha(138),
            fontSize: AppTextStyles.sizeOverline.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.3,
          ),
        ),
      ],
    );
  }
}

const Color _europaLeagueColor = Color(0xFF4AA3FF);
const Color _relegationColor = Color(0xFFFF6B6B);

class LeagueDetailsPlaceholderPage extends StatelessWidget {
  final String title;
  final String message;

  const LeagueDetailsPlaceholderPage({
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      children: [
        Container(
          height: 220.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.r),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                theme.colorScheme.surface.withAlpha(210),
                theme.colorScheme.surface.withAlpha(132),
              ],
            ),
            border: Border.all(
              color: theme.dividerColor.withAlpha(150),
              width: 1.w,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: AppTextStyles.sizeHeading.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  message,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withAlpha(130),
                    fontSize: AppTextStyles.sizeBody.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
