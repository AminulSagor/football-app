import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/themes/app_text_styles.dart';
import '../../../core/themes/app_colors.dart';
import '../team_profile_controller.dart';
import '../team_profile_model.dart';
import 'package:fotgram/core/widgets/app_cached_network_image.dart';

class TeamProfileTablePage extends GetView<TeamProfileController> {
  const TeamProfileTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = Theme.of(context);
      final state = controller.state.value;
      final rows = state.isStandingsLoading && state.standingRows.isEmpty
          ? _skeletonStandingRows()
          : state.standingRows;
      return Skeletonizer(
        enabled: state.isStandingsLoading && state.standingRows.isEmpty,
        effect: _solidSkeletonEffect(theme),
        child: ListView(
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 14.h,
                      ),
                      color: theme.colorScheme.surface.withAlpha(40),
                      child: Row(
                        children: const [
                          _HeaderLabel(width: 28, text: '#'),
                          Expanded(flex: 8, child: _HeaderLabel(text: 'TEAM')),
                          Expanded(
                            flex: 2,
                            child: _HeaderLabel(
                              text: 'PL',
                              align: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: _HeaderLabel(
                              text: 'GD',
                              align: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: _HeaderLabel(
                              text: 'PTS',
                              align: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (rows.isEmpty)
                      _TableMessage(
                        text: 'No standings found for this team league.',
                      )
                    else
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
                _LegendItem(
                  color: AppColors.primaryAlt,
                  label: 'EUROPA LEAGUE',
                ),
                _LegendItem(color: AppColors.error, label: 'RELEGATION'),
              ],
            ),
          ],
        ),
      );
    });
  }
}

ShimmerEffect _solidSkeletonEffect(ThemeData theme) {
  final color = theme.colorScheme.onSurface.withAlpha(
    theme.brightness == Brightness.dark ? 28 : 18,
  );
  return ShimmerEffect(baseColor: color, highlightColor: color);
}

List<FootballStandingRowModel> _skeletonStandingRows() {
  return List<FootballStandingRowModel>.generate(
    6,
    (index) => FootballStandingRowModel(
      rank: index + 1,
      team: const FootballStandingTeamModel(name: 'Team name'),
      points: 40,
      goalsDiff: 10,
      all: const FootballStandingRecordModel(
        played: 20,
        goals: FootballStandingGoalsModel(goalsFor: 40, against: 20),
      ),
    ),
  );
}

class _StandingsTableRow extends StatelessWidget {
  final FootballStandingRowModel item;
  final bool showDivider;

  const _StandingsTableRow({required this.item, required this.showDivider});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rank = item.rank ?? 0;
    final goalDifference = item.goalsDiff == null ? '-' : '${item.goalsDiff}';

    return Container(
      height: 65.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withAlpha(4),
        border: showDivider
            ? Border(
                bottom: BorderSide(color: theme.dividerColor, width: 1.w),
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
                      '${item.rank ?? '-'}',
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
                        _TeamLogo(
                          seed: _seedFromName(item.team.name),
                          logoUrl: item.team.logo,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            item.team.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: AppTextStyles.sizeBodySmall.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '${item.all.played ?? '-'}',
                      textAlign: TextAlign.center,
                      style: _valueStyle(),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      goalDifference,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _goalDifferenceColor(
                          goalDifference,
                          Theme.of(context),
                        ),
                        fontSize: AppTextStyles.sizeBody.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '${item.points ?? '-'}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: rank <= 5
                            ? AppColors.brand
                            : Theme.of(context).colorScheme.onSurface,
                        fontSize: AppTextStyles.sizeBody.sp,
                        fontWeight: FontWeight.w700,
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
      fontWeight: FontWeight.w400,
    );
  }
}

class _TableMessage extends StatelessWidget {
  final String text;

  const _TableMessage({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 22.h),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: theme.colorScheme.onSurface.withAlpha(140),
          fontSize: AppTextStyles.sizeBodySmall.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _TeamLogo extends StatelessWidget {
  final String seed;
  final String logoUrl;

  const _TeamLogo({required this.seed, required this.logoUrl});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 24.r,
      height: 24.r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.r),
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.colorScheme.onSurface.withAlpha(28),
          width: .8.w,
        ),
      ),
      alignment: Alignment.center,
      child: logoUrl.isEmpty
          ? Text(
              seed,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: AppTextStyles.sizeTiny.sp,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(7.r),
              child: AppCachedNetworkImage(
                imageUrl: logoUrl,
                width: 20.r,
                height: 20.r,
                fit: BoxFit.contain,
                errorBuilder: (context) => Text(
                  seed,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: AppTextStyles.sizeTiny.sp,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ),
            ),
    );
  }
}

String _seedFromName(String value) {
  final clean = value.trim();
  if (clean.isEmpty) return '?';
  final parts = clean.split(RegExp(r'\s+'));
  if (parts.length == 1) {
    return clean
        .substring(0, clean.length < 3 ? clean.length : 3)
        .toUpperCase();
  }
  return parts.take(3).map((part) => part[0]).join().toUpperCase();
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

  const _LegendItem({required this.color, required this.label});

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
