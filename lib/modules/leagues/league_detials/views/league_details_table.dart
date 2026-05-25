import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/themes/app_text_styles.dart';
import '../league_details_controller.dart';
import '../models/league_detials_model.dart';
import 'package:fotgram/core/widgets/app_cached_network_image.dart';

class LeagueDetailsTablePage extends GetView<LeagueDetailsController> {
  const LeagueDetailsTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state.value;
      final rows = state.isLoading
          ? _skeletonStandingsRows()
          : state.standingsRows;
      final isWorldCup = controller.isWorldCup;

      if (!state.isLoading && !isWorldCup && rows.isEmpty) {
        return const _LeagueDetailsEmptyMessage(
          message: 'No standings found for this league season.',
        );
      }

      if (isWorldCup) {
        final groups = state.isLoading
            ? _skeletonWorldCupGroups()
            : controller.worldCupGroups;
        if (!state.isLoading && groups.isEmpty) {
          return const _LeagueDetailsEmptyMessage(
            message: 'No World Cup group standings found for this season.',
          );
        }

        return Skeletonizer(
          enabled: state.isLoading,
          effect: _solidSkeletonEffect(Theme.of(context)),
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 160.h) {
                controller.loadMoreWorldCupStandings();
              }
              return false;
            },
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
              children: [
                for (var index = 0; index < groups.length; index++) ...[
                  _WorldCupGroupCard(
                    group: groups[index],
                    onTeamTap: controller.openTeamProfile,
                  ),
                  if (index != groups.length - 1) SizedBox(height: 16.h),
                ],
                if (state.isStandingsLoadingMore) ...[
                  SizedBox(height: 16.h),
                  Skeletonizer(
                    enabled: true,
                    effect: _solidSkeletonEffect(Theme.of(context)),
                    child: Column(
                      children: _skeletonWorldCupGroups(count: 1)
                          .map(
                            (group) => _WorldCupGroupCard(
                              group: group,
                              onTeamTap: controller.openTeamProfile,
                            ),
                          )
                          .toList(growable: false),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }

      return Skeletonizer(
        enabled: state.isLoading,
        effect: _solidSkeletonEffect(Theme.of(context)),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
          children: [
            _StandingsTableCard(
              rows: rows,
              onTeamTap: controller.openTeamProfile,
            ),
          ],
        ),
      );
    });
  }
}

List<LeagueDetailsWorldCupGroupUiModel> _skeletonWorldCupGroups({
  int count = 2,
}) {
  return List<LeagueDetailsWorldCupGroupUiModel>.generate(
    count,
    (groupIndex) => LeagueDetailsWorldCupGroupUiModel(
      title: 'Group ${String.fromCharCode(65 + groupIndex)}',
      rows: _skeletonStandingsRows().take(4).toList(growable: false),
    ),
  );
}

class _WorldCupGroupCard extends StatelessWidget {
  final LeagueDetailsWorldCupGroupUiModel group;
  final ValueChanged<String> onTeamTap;

  const _WorldCupGroupCard({required this.group, required this.onTeamTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface.withAlpha(
              theme.brightness == Brightness.dark ? 228 : 255,
            ),
            theme.colorScheme.surface.withAlpha(
              theme.brightness == Brightness.dark ? 150 : 235,
            ),
          ],
        ),
        border: Border.all(
          color: theme.dividerColor.withAlpha(
            theme.brightness == Brightness.dark ? 110 : 180,
          ),
          width: 1.w,
        ),
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
                color: _worldCupGroupHeaderColor(theme),
                border: Border(
                  bottom: BorderSide(
                    color: theme.dividerColor.withAlpha(
                      theme.brightness == Brightness.dark ? 90 : 150,
                    ),
                    width: 1.w,
                  ),
                ),
              ),
              child: Text(
                group.title,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: AppTextStyles.sizeBody.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            _StandingsTableHeader(),
            for (var index = 0; index < group.rows.length; index++) ...[
              _StandingsTableRow(
                item: group.rows[index],
                onTeamTap: onTeamTap,
                useWorldCupPromotionZone: true,
              ),
              if (index != group.rows.length - 1)
                Divider(
                  height: 1.h,
                  thickness: 1,
                  color: theme.dividerColor.withAlpha(
                    theme.brightness == Brightness.dark ? 70 : 150,
                  ),
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
  final ValueChanged<String> onTeamTap;

  const _StandingsTableCard({required this.rows, required this.onTeamTap});

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
              _StandingsTableRow(item: rows[index], onTeamTap: onTeamTap),
              if (index != rows.length - 1)
                Divider(
                  height: 1.h,
                  thickness: 1,
                  color: theme.dividerColor.withAlpha(200),
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
        color: _tableHeaderColor(theme),
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor.withAlpha(
              theme.brightness == Brightness.dark ? 130 : 180,
            ),
            width: 1.w,
          ),
        ),
      ),
      child: Row(
        children: [
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
      color: theme.colorScheme.onSurface.withAlpha(
        theme.brightness == Brightness.dark ? 104 : 126,
      ),
      fontSize: AppTextStyles.sizeOverline.sp,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.25,
    );
  }
}

class _StandingsTableRow extends StatelessWidget {
  final LeagueDetailsStandingsRowUiModel item;
  final bool useWorldCupPromotionZone;
  final ValueChanged<String> onTeamTap;

  const _StandingsTableRow({
    required this.item,
    required this.onTeamTap,
    this.useWorldCupPromotionZone = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rank = int.tryParse(item.rank) ?? 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTeamTap(item.teamId),
        child: Container(
          height: 60.h,
          decoration: BoxDecoration(color: _tableRowColor(theme)),
          child: Row(
            children: [
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
                            _TeamLogoBadge(item: item),
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
                            color: _goalDifferenceColor(
                              theme,
                              item.goalDifference,
                            ),
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
        ),
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

class _TeamLogoBadge extends StatelessWidget {
  final LeagueDetailsStandingsRowUiModel item;

  const _TeamLogoBadge({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 24.r,
      height: 24.r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.r),
        color: item.badgeColor,
        border: Border.all(
          color: theme.dividerColor.withAlpha(
            theme.brightness == Brightness.dark ? 120 : 180,
          ),
          width: 0.8.w,
        ),
      ),
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7.r),
        child: item.teamLogoUrl.isEmpty
            ? _SeedBadgeText(seed: item.badgeSeed)
            : AppCachedNetworkImage(
                imageUrl: item.teamLogoUrl,
                width: 22.r,
                height: 22.r,
                fit: BoxFit.contain,
                errorBuilder: (context) => _SeedBadgeText(seed: item.badgeSeed),
              ),
      ),
    );
  }
}

class _SeedBadgeText extends StatelessWidget {
  final String seed;

  const _SeedBadgeText({required this.seed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Text(
        seed,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontSize: AppTextStyles.sizeTiny.sp,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
    );
  }
}

Color _worldCupGroupHeaderColor(ThemeData theme) {
  return theme.brightness == Brightness.dark
      ? theme.colorScheme.secondary.withAlpha(18)
      : theme.colorScheme.secondary.withAlpha(24);
}

Color _tableHeaderColor(ThemeData theme) {
  return theme.brightness == Brightness.dark
      ? theme.colorScheme.onSurface.withAlpha(18)
      : theme.colorScheme.primary.withAlpha(10);
}

Color _tableRowColor(ThemeData theme) {
  return theme.brightness == Brightness.dark
      ? theme.colorScheme.onSurface.withAlpha(6)
      : theme.colorScheme.primary.withAlpha(4);
}

const Color _relegationColor = Color(0xFFFF6B6B);

class LeagueDetailsPlaceholderPage extends StatelessWidget {
  final String title;
  final String message;

  const LeagueDetailsPlaceholderPage({
    super.key,
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

ShimmerEffect _solidSkeletonEffect(ThemeData theme) {
  final color = theme.colorScheme.onSurface.withAlpha(
    theme.brightness == Brightness.dark ? 28 : 18,
  );
  return ShimmerEffect(baseColor: color, highlightColor: color);
}

List<LeagueDetailsStandingsRowUiModel> _skeletonStandingsRows() {
  return List<LeagueDetailsStandingsRowUiModel>.generate(
    10,
    (index) => LeagueDetailsStandingsRowUiModel(
      rank: '${index + 1}',
      teamName: 'Team Name',
      badgeSeed: 'TM',
      badgeColor: const Color(0xFF2D3D39),
      played: '32',
      plusMinus: '40-20',
      goalDifference: '+20',
      points: '70',
    ),
  );
}

class _LeagueDetailsEmptyMessage extends StatelessWidget {
  final String message;

  const _LeagueDetailsEmptyMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: theme.colorScheme.onSurface.withAlpha(150),
            fontSize: AppTextStyles.sizeBody.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
