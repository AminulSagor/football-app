import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/widgets/app_cached_network_image.dart';
import '../../../../core/widgets/facebook_native_ad_widget.dart';
import '../league_details_controller.dart';
import '../models/league_detials_model.dart';

class LeagueDetailsOverviewPage extends GetView<LeagueDetailsController> {
  const LeagueDetailsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state.value;
      final overview = state.isLoading ? _skeletonOverview() : state.overview;

      if (!state.isLoading &&
          overview.topThreeRows.isEmpty &&
          overview.topScorers.isEmpty &&
          overview.topAssists.isEmpty) {
        return const _LeagueDetailsEmptyMessage(
          message: 'No league overview data found for this season.',
        );
      }

      return Skeletonizer(
        enabled: state.isLoading,
        effect: _solidSkeletonEffect(Theme.of(context)),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 26.h),
          children: [
            _TopThreeSection(
              rows: overview.topThreeRows,
              onTeamTap: controller.openTeamProfile,
            ),
            if (!state.isLoading) ...[
              SizedBox(height: 16.h),
              const FacebookNativeAdWidget(),
            ],
            const _SectionGap(),
            _TopScorersSection(
              rows: overview.topScorers,
              onPlayerTap: controller.openPlayerProfile,
              onTeamTap: controller.openTeamProfile,
            ),
            const _SectionGap(),
            _TopAssistsSection(
              rows: overview.topAssists,
              onPlayerTap: controller.openPlayerProfile,
              onTeamTap: controller.openTeamProfile,
            ),
          ],
        ),
      );
    });
  }
}

class _SectionGap extends StatelessWidget {
  const _SectionGap();

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 24.h);
  }
}

class _TopThreeSection extends StatelessWidget {
  final List<LeagueDetailsStandingsRowUiModel> rows;
  final ValueChanged<String> onTeamTap;

  const _TopThreeSection({required this.rows, required this.onTeamTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _LeagueOverviewSectionCard(
      title: 'Top 3',
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 2.h, 16.w, 10.h),
            child: Row(
              children: [
                SizedBox(width: 28.w),
                Expanded(
                  flex: 8,
                  child: Text('# TEAM', style: _columnLabelStyle(theme)),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'PL',
                    textAlign: TextAlign.center,
                    style: _columnLabelStyle(theme),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '+/-',
                    textAlign: TextAlign.center,
                    style: _columnLabelStyle(theme),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'GD',
                    textAlign: TextAlign.center,
                    style: _columnLabelStyle(theme),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'PTS',
                    textAlign: TextAlign.right,
                    style: _columnLabelStyle(theme),
                  ),
                ),
              ],
            ),
          ),
          for (var index = 0; index < rows.length; index++)
            Padding(
              padding: EdgeInsets.only(
                bottom: index == rows.length - 1 ? 0.h : 10.h,
              ),
              child: _StandingsRow(item: rows[index], onTeamTap: onTeamTap),
            ),
        ],
      ),
    );
  }

  TextStyle _columnLabelStyle(ThemeData theme) {
    return TextStyle(
      color: theme.colorScheme.onSurface.withAlpha(88),
      fontSize: AppTextStyles.sizeOverline.sp,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.25,
    );
  }
}

class _TopScorersSection extends StatelessWidget {
  final List<LeagueDetailsPlayerStatRowUiModel> rows;
  final ValueChanged<LeagueDetailsPlayerStatRowUiModel> onPlayerTap;
  final ValueChanged<String> onTeamTap;

  const _TopScorersSection({
    required this.rows,
    required this.onPlayerTap,
    required this.onTeamTap,
  });

  @override
  Widget build(BuildContext context) {
    return _LeagueOverviewSectionCard(
      title: 'Top Scorers',
      child: Column(
        children: [
          for (var index = 0; index < rows.length; index++)
            Padding(
              padding: EdgeInsets.only(
                bottom: index == rows.length - 1 ? 0.h : 10.h,
              ),
              child: _PlayerStatRow(
                item: rows[index],
                onPlayerTap: onPlayerTap,
                onTeamTap: onTeamTap,
              ),
            ),
        ],
      ),
    );
  }
}

class _TopAssistsSection extends StatelessWidget {
  final List<LeagueDetailsPlayerStatRowUiModel> rows;
  final ValueChanged<LeagueDetailsPlayerStatRowUiModel> onPlayerTap;
  final ValueChanged<String> onTeamTap;

  const _TopAssistsSection({
    required this.rows,
    required this.onPlayerTap,
    required this.onTeamTap,
  });

  @override
  Widget build(BuildContext context) {
    return _LeagueOverviewSectionCard(
      title: 'Top Assists',
      child: Column(
        children: [
          for (var index = 0; index < rows.length; index++)
            Padding(
              padding: EdgeInsets.only(
                bottom: index == rows.length - 1 ? 0.h : 10.h,
              ),
              child: _PlayerStatRow(
                item: rows[index],
                onPlayerTap: onPlayerTap,
                onTeamTap: onTeamTap,
              ),
            ),
        ],
      ),
    );
  }
}

class _LeagueOverviewSectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _LeagueOverviewSectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        color: theme.colorScheme.surface.withAlpha(210),
        border: Border.all(
          color: theme.dividerColor.withAlpha(150),
          width: 1.w,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.r),
        child: Column(
          children: [
            Container(
              height: 40.h,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              alignment: Alignment.centerLeft,
              color: Colors.white.withAlpha(18),
              child: Text(
                title,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: AppTextStyles.sizeBodySmall.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class _StandingsRow extends StatelessWidget {
  final LeagueDetailsStandingsRowUiModel item;
  final ValueChanged<String> onTeamTap;

  const _StandingsRow({required this.item, required this.onTeamTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24.r),
        onTap: () => onTeamTap(item.teamId),
        child: Container(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            color: Colors.white.withAlpha(8),
          ),
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
                    _TeamBadge(
                      logoUrl: item.teamLogoUrl,
                      seed: item.badgeSeed,
                      color: item.badgeColor,
                      size: 18.r,
                      radius: 5.r,
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
                  style: _tableValueStyle(theme),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  item.plusMinus,
                  textAlign: TextAlign.center,
                  style: _tableValueStyle(theme),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  item.goalDifference,
                  textAlign: TextAlign.center,
                  style: _tableValueStyle(theme),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  item.points,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: AppTextStyles.sizeBody.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _tableValueStyle(ThemeData theme) {
    return TextStyle(
      color: theme.colorScheme.onSurface.withAlpha(184),
      fontSize: AppTextStyles.sizeBodySmall.sp,
      fontWeight: FontWeight.w500,
    );
  }
}

class _PlayerStatRow extends StatelessWidget {
  final LeagueDetailsPlayerStatRowUiModel item;
  final ValueChanged<LeagueDetailsPlayerStatRowUiModel> onPlayerTap;
  final ValueChanged<String> onTeamTap;

  const _PlayerStatRow({
    required this.item,
    required this.onPlayerTap,
    required this.onTeamTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 62.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: Colors.white.withAlpha(8),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24.w,
            child: Text(
              item.rank,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withAlpha(132),
                fontSize: AppTextStyles.sizeBodySmall.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 2.w),
          GestureDetector(
            onTap: () => onPlayerTap(item),
            child: _PlayerAvatar(
              imageUrl: item.playerImageUrl,
              seed: item.name.isEmpty ? '?' : item.name.substring(0, 1),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => onPlayerTap(item),
                  child: Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: AppTextStyles.sizeBody.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: () => onTeamTap(item.teamId),
                  child: Text(
                    item.teamName.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withAlpha(96),
                      fontSize: AppTextStyles.sizeOverline.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            item.value,
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: AppTextStyles.sizeBodyLarge.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamBadge extends StatelessWidget {
  final String logoUrl;
  final String seed;
  final Color color;
  final double size;
  final double radius;

  const _TeamBadge({
    required this.logoUrl,
    required this.seed,
    required this.color,
    required this.size,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: Colors.white.withValues(alpha: 0.2),
      ),
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: logoUrl.isEmpty
            ? _SeedText(seed: seed)
            : AppCachedNetworkImage(
                imageUrl: logoUrl,
                width: size,
                height: size,
                fit: BoxFit.contain,
                errorBuilder: (context) => _SeedText(seed: seed),
              ),
      ),
    );
  }
}

class _PlayerAvatar extends StatelessWidget {
  final String imageUrl;
  final String seed;

  const _PlayerAvatar({required this.imageUrl, required this.seed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 40.r,
      height: 40.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.surface.withAlpha(180),
        border: Border.all(
          color: theme.colorScheme.secondary.withAlpha(220),
          width: 1.w,
        ),
      ),
      child: ClipOval(
        child: imageUrl.isEmpty
            ? _SeedText(seed: seed)
            : AppCachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context) => _SeedText(seed: seed),
              ),
      ),
    );
  }
}

class _SeedText extends StatelessWidget {
  final String seed;

  const _SeedText({required this.seed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        seed,
        style: TextStyle(
          color: Colors.white,
          fontSize: AppTextStyles.sizeTiny.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

ShimmerEffect _solidSkeletonEffect(ThemeData theme) {
  final color = theme.colorScheme.onSurface.withAlpha(
    theme.brightness == Brightness.dark ? 28 : 18,
  );
  return ShimmerEffect(baseColor: color, highlightColor: color);
}

LeagueDetailsOverviewUiModel _skeletonOverview() {
  final standings = List<LeagueDetailsStandingsRowUiModel>.generate(
    3,
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
  final players = List<LeagueDetailsPlayerStatRowUiModel>.generate(
    3,
    (index) => LeagueDetailsPlayerStatRowUiModel(
      rank: '${index + 1}.',
      name: 'Player Name',
      teamName: 'Team Name',
      value: '12',
    ),
  );
  return LeagueDetailsOverviewUiModel(
    topThreeRows: standings,
    topScorers: players,
    topAssists: players,
    teamName: 'Team name',
    roundLabel: 'Season',
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
