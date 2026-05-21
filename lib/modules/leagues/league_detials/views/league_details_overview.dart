import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/themes/app_text_styles.dart';
import '../../../../routes/app_routes.dart';
import '../league_details_controller.dart';
import '../models/league_detials_model.dart';

void _openPlayerProfile({String? teamId}) {
  final arguments = <String, dynamic>{
    'playerId': '874',
    'season': '2025',
    'playerName': 'Cristiano Ronaldo',
  };

  final cleanTeamId = teamId?.trim();
  if (cleanTeamId != null && cleanTeamId.isNotEmpty) {
    arguments['teamId'] = cleanTeamId;
  }

  Get.toNamed(AppRoutes.playerProfile, arguments: arguments);
}

void _openTeamProfile([String teamId = '']) {
  if (teamId.trim().isEmpty) {
    return;
  }
  Get.toNamed(
    AppRoutes.teamProfile,
    arguments: <String, dynamic>{'teamId': teamId},
  );
}

PaintingEffect _solidSkeletonEffect(ThemeData theme) {
  return ShimmerEffect(
    baseColor: theme.colorScheme.onSurface.withAlpha(22),
    highlightColor: theme.colorScheme.onSurface.withAlpha(48),
    duration: const Duration(milliseconds: 1100),
  );
}

LeagueDetailsOverviewUiModel _skeletonOverview() {
  return LeagueDetailsOverviewUiModel(
    teamName: 'Team name',
    roundLabel: 'Round 31',
    topThreeRows: const <LeagueDetailsStandingsRowUiModel>[
      LeagueDetailsStandingsRowUiModel(
        rank: '1',
        teamName: 'Arsenal',
        badgeSeed: 'ARS',
        badgeColor: Color(0xFFBD1D28),
        played: '32',
        plusMinus: '62-24',
        goalDifference: '+38',
        points: '70',
      ),
      LeagueDetailsStandingsRowUiModel(
        rank: '2',
        teamName: 'Man City',
        badgeSeed: 'MCI',
        badgeColor: Color(0xFF5CB9FF),
        played: '30',
        plusMinus: '60-28',
        goalDifference: '+32',
        points: '61',
      ),
      LeagueDetailsStandingsRowUiModel(
        rank: '3',
        teamName: 'Man United',
        badgeSeed: 'MUN',
        badgeColor: Color(0xFFC13329),
        played: '31',
        plusMinus: '56-43',
        goalDifference: '+13',
        points: '55',
      ),
    ],
    topScorers: <LeagueDetailsPlayerStatRowUiModel>[
      LeagueDetailsPlayerStatRowUiModel(
        rank: '1.',
        name: 'Player name',
        teamName: 'Team name',
        value: '0',
      ),
      LeagueDetailsPlayerStatRowUiModel(
        rank: '2.',
        name: 'Player name',
        teamName: 'Team name',
        value: '0',
      ),
      LeagueDetailsPlayerStatRowUiModel(
        rank: '3.',
        name: 'Player name',
        teamName: 'Team name',
        value: '0',
      ),
    ],
    topAssists: <LeagueDetailsPlayerStatRowUiModel>[
      LeagueDetailsPlayerStatRowUiModel(
        rank: '1.',
        name: 'Player name',
        teamName: 'Team name',
        value: '0',
      ),
      LeagueDetailsPlayerStatRowUiModel(
        rank: '2.',
        name: 'Player name',
        teamName: 'Team name',
        value: '0',
      ),
      LeagueDetailsPlayerStatRowUiModel(
        rank: '3.',
        name: 'Player name',
        teamName: 'Team name',
        value: '0',
      ),
    ],
    teamOfTheWeekPlayers: const <LeagueDetailsPitchPlayerPositionUiModel>[
      LeagueDetailsPitchPlayerPositionUiModel(
        x: 0.26,
        y: 0.12,
        label: 'Player',
      ),
      LeagueDetailsPitchPlayerPositionUiModel(
        x: 0.77,
        y: 0.12,
        label: 'Player',
      ),
      LeagueDetailsPitchPlayerPositionUiModel(
        x: 0.52,
        y: 0.33,
        label: 'Player',
      ),
      LeagueDetailsPitchPlayerPositionUiModel(
        x: 0.18,
        y: 0.46,
        label: 'Player',
      ),
      LeagueDetailsPitchPlayerPositionUiModel(
        x: 0.52,
        y: 0.56,
        label: 'Player',
      ),
      LeagueDetailsPitchPlayerPositionUiModel(
        x: 0.84,
        y: 0.46,
        label: 'Player',
      ),
      LeagueDetailsPitchPlayerPositionUiModel(
        x: 0.18,
        y: 0.74,
        label: 'Player',
      ),
      LeagueDetailsPitchPlayerPositionUiModel(
        x: 0.39,
        y: 0.74,
        label: 'Player',
      ),
      LeagueDetailsPitchPlayerPositionUiModel(
        x: 0.57,
        y: 0.74,
        label: 'Player',
      ),
      LeagueDetailsPitchPlayerPositionUiModel(
        x: 0.83,
        y: 0.74,
        label: 'Player',
      ),
      LeagueDetailsPitchPlayerPositionUiModel(
        x: 0.52,
        y: 0.92,
        label: 'Player',
      ),
    ],
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
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
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
            _TopThreeSection(rows: overview.topThreeRows),
            const _SectionGap(),
            _TopScorersSection(rows: overview.topScorers),
            const _SectionGap(),
            _TopAssistsSection(rows: overview.topAssists),
            const _SectionGap(),
            _TeamOfTheWeekSection(overview: overview),
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

  const _TopThreeSection({required this.rows});

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
              child: _StandingsRow(item: rows[index]),
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

  const _TopScorersSection({required this.rows});

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
              child: _PlayerStatRow(item: rows[index]),
            ),
        ],
      ),
    );
  }
}

class _TopAssistsSection extends StatelessWidget {
  final List<LeagueDetailsPlayerStatRowUiModel> rows;

  const _TopAssistsSection({required this.rows});

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
              child: _PlayerStatRow(item: rows[index]),
            ),
        ],
      ),
    );
  }
}

class _TeamOfTheWeekSection extends StatelessWidget {
  final LeagueDetailsOverviewUiModel overview;

  const _TeamOfTheWeekSection({required this.overview});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _LeagueOverviewSectionCard(
      title: 'Team of the Week',
      child: Padding(
        padding: EdgeInsets.only(top: 4.h),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _openTeamProfile(),
              child: Text(
                overview.teamName,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: AppTextStyles.sizeBody.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            _RoundSelector(theme: theme, label: overview.roundLabel),
            SizedBox(height: 18.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: AspectRatio(
                aspectRatio: 0.86,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26.r),
                    // gradient: LinearGradient(
                    //   begin: Alignment.centerLeft,
                    //   end: Alignment.centerRight,
                    //   colors: [
                    //     theme.colorScheme.surface.withAlpha(148),
                    //     theme.colorScheme.surface.withAlpha(112),
                    //   ],
                    // ),
                    border: Border.all(
                      color: theme.dividerColor.withAlpha(160),
                      width: 1.w,
                    ),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CustomPaint(
                            size: Size(
                              constraints.maxWidth,
                              constraints.maxHeight,
                            ),
                            painter: _PitchPainter(
                              lineColor: Colors.white.withAlpha(70),
                            ),
                          ),
                          for (final player in overview.teamOfTheWeekPlayers)
                            _PitchPlayerMarker(
                              x: player.x,
                              y: player.y,
                              label: player.label,
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
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
        // gradient: LinearGradient(
        //   begin: Alignment.centerLeft,
        //   end: Alignment.centerRight,
        //   colors: [
        //     theme.colorScheme.surface.withAlpha(210),
        //     theme.colorScheme.surface.withAlpha(132),
        //   ],
        // ),
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

  const _StandingsRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24.r),
        onTap: () => _openTeamProfile(item.teamId),
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

  const _PlayerStatRow({required this.item});

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
            onTap: () => _openPlayerProfile(teamId: item.teamId),
            child: Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.secondary.withAlpha(220),
                  width: 1.w,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _openPlayerProfile(teamId: item.teamId),
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
                  onTap: () => _openTeamProfile(item.teamId ?? ''),
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
        color: color,
        border: Border.all(color: Colors.white.withAlpha(30), width: 0.8.w),
      ),
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: logoUrl.isEmpty
            ? _SeedText(seed: seed)
            : Image.network(
                logoUrl,
                width: size,
                height: size,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    _SeedText(seed: seed),
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
            : Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _SeedText(seed: seed),
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

class _RoundSelector extends StatelessWidget {
  final ThemeData theme;
  final String label;

  const _RoundSelector({required this.theme, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _RoundArrowButton(icon: Icons.chevron_left_rounded, theme: theme),
        SizedBox(width: 8.w),
        Container(
          height: 34.h,
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            color: Colors.white.withAlpha(9),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: AppTextStyles.sizeBody.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        _RoundArrowButton(icon: Icons.chevron_right_rounded, theme: theme),
      ],
    );
  }
}

class _RoundArrowButton extends StatelessWidget {
  final IconData icon;
  final ThemeData theme;

  const _RoundArrowButton({required this.icon, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24.r,
      height: 24.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withAlpha(9),
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: 16.r,
        color: theme.colorScheme.onSurface.withAlpha(160),
      ),
    );
  }
}

class _PitchPlayerMarker extends StatelessWidget {
  final double x;
  final double y;
  final String label;

  const _PitchPlayerMarker({
    required this.x,
    required this.y,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment((x * 2) - 1, (y * 2) - 1),
      child: Transform.translate(
        offset: Offset(0, -20.h),
        child: GestureDetector(
          onTap: _openPlayerProfile,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.secondary,
                    width: 1.1.w,
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withAlpha(220),
                  fontSize: AppTextStyles.sizeOverline.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PitchPainter extends CustomPainter {
  final Color lineColor;

  const _PitchPainter({required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final innerRect = Rect.fromLTWH(16, 16, size.width - 32, size.height - 32);

    canvas.drawRRect(
      RRect.fromRectAndRadius(innerRect, const Radius.circular(6)),
      paint,
    );

    final halfwayY = innerRect.top + (innerRect.height / 2);
    canvas.drawLine(
      Offset(innerRect.left, halfwayY),
      Offset(innerRect.right, halfwayY),
      paint,
    );

    final center = Offset(innerRect.center.dx, halfwayY);
    final circleRadius = math.min(innerRect.width, innerRect.height) * 0.095;
    canvas.drawCircle(center, circleRadius, paint);

    final topPenaltyWidth = innerRect.width * 0.24;
    final topPenaltyHeight = innerRect.height * 0.12;
    final bottomPenaltyWidth = innerRect.width * 0.24;
    final bottomPenaltyHeight = innerRect.height * 0.12;

    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(
          innerRect.center.dx,
          innerRect.top + (topPenaltyHeight / 2),
        ),
        width: topPenaltyWidth,
        height: topPenaltyHeight,
      ),
      paint,
    );

    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(
          innerRect.center.dx,
          innerRect.bottom - (bottomPenaltyHeight / 2),
        ),
        width: bottomPenaltyWidth,
        height: bottomPenaltyHeight,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _PitchPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor;
  }
}
