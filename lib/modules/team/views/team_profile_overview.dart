import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/themes/app_text_styles.dart';
import '../../../core/themes/app_colors.dart';
import '../../leagues/model/leagues_models.dart';
import '../team_profile_controller.dart';
import '../team_profile_model.dart';
import 'package:fotgram/core/widgets/app_cached_network_image.dart';

class TeamProfileOverviewPage extends GetView<TeamProfileController> {
  const TeamProfileOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppColors.palette(theme.brightness);

    return Obx(() {
      final state = controller.state.value;
      final isInitialLoading =
          state.isTeamInfoLoading && state.team.name.isEmpty;
      final overview = isInitialLoading ? _skeletonOverview() : state.overview;

      return Skeletonizer(
        enabled: isInitialLoading,
        effect: _solidSkeletonEffect(theme),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 28.h),
          children: [
            if (overview.nextMatches.isNotEmpty) ...[
              _SectionTitle(title: 'Next match'),
              SizedBox(height: 12.h),
              SizedBox(
                height: 166.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: overview.nextMatches.length,
                  separatorBuilder: (_, _) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    final match = overview.nextMatches[index];
                    return _NextMatchCard(
                      item: match,
                      palette: palette,
                      onTap: () =>
                          controller.openMatchDetailsFromNextMatch(match),
                    );
                  },
                ),
              ),
              SizedBox(height: 26.h),
            ],
            _LastSixMatchesCard(
              leftResults: overview.leftResults,
              rightResults: overview.rightResults,
              onMatchTap: controller.openMatchDetailsFromFormResult,
            ),
            SizedBox(height: 24.h),
            _TopPlayersCard(
              players: controller.topPlayers,
              leagueId: state.domesticLeague?.league.id,
              isLoading: state.isPlayersLoading,
              palette: palette,
              onPlayerTap: controller.openPlayerProfile,
            ),
            SizedBox(height: 24.h),
            _TopThreeTableCard(
              title: controller.domesticLeagueTitle,
              rows: state.standingRows.take(3).toList(growable: false),
              isLoading: state.isStandingsLoading,
              palette: palette,
              onLeagueTap: controller.openDomesticLeagueDetails,
            ),
            SizedBox(height: 24.h),
            _LeaguesCard(
              items: state.visibleTeamLeagueItems,
              isLoading: state.isTeamLeaguesLoading,
              canToggle: state.canToggleTeamLeagues,
              isExpanded: state.isTeamLeaguesExpanded,
              palette: palette,
              onToggle: controller.toggleTeamLeaguesExpanded,
              onLeagueTap: controller.openLeagueDetails,
            ),
            SizedBox(height: 24.h),
            _VenueCard(venue: overview.venue, palette: palette),
            SizedBox(height: 24.h),
            _AboutCard(
              text: overview.aboutText,
              isExpanded: state.isAboutExpanded,
              palette: palette,
              onToggle: controller.toggleAboutExpanded,
            ),
          ],
        ),
      );
    });
  }
}

TeamProfileOverviewUiModel _skeletonOverview() {
  const teamA = TeamProfileTeamUiModel(
    name: 'Home Team',
    country: '',
    badgeSeed: 'HM',
    badgeColor: Colors.transparent,
  );
  const teamB = TeamProfileTeamUiModel(
    name: 'Away Team',
    country: '',
    badgeSeed: 'AW',
    badgeColor: Colors.transparent,
  );
  return const TeamProfileOverviewUiModel(
    nextMatches: <TeamProfileNextMatchUiModel>[
      TeamProfileNextMatchUiModel(
        competitionLabel: 'Competition',
        timeLabel: '20:00',
        statusLabel: 'Tomorrow',
        homeTeam: teamA,
        awayTeam: teamB,
      ),
      TeamProfileNextMatchUiModel(
        competitionLabel: 'Competition',
        timeLabel: '20:00',
        statusLabel: 'Tomorrow',
        homeTeam: teamA,
        awayTeam: teamB,
      ),
    ],
    leftResults: <TeamProfileFormResultUiModel>[
      TeamProfileFormResultUiModel(scoreLabel: '1 - 0', isPositive: true),
      TeamProfileFormResultUiModel(scoreLabel: '2 - 1', isPositive: true),
      TeamProfileFormResultUiModel(
        scoreLabel: '0 - 0',
        isPositive: false,
        isDraw: true,
      ),
    ],
    rightResults: <TeamProfileFormResultUiModel>[
      TeamProfileFormResultUiModel(
        scoreLabel: '1 - 1',
        isPositive: false,
        isDraw: true,
      ),
      TeamProfileFormResultUiModel(scoreLabel: '0 - 2', isPositive: false),
      TeamProfileFormResultUiModel(scoreLabel: '3 - 0', isPositive: true),
    ],
    venue: TeamProfileVenueUiModel(
      stadiumName: 'Stadium name',
      city: 'City',
      capacity: '50000',
      surface: 'grass',
      opened: '1900',
    ),
    aboutText:
        'Team overview information will appear here after loading from API.',
  );
}

ShimmerEffect _solidSkeletonEffect(ThemeData theme) {
  final color = theme.colorScheme.onSurface.withAlpha(
    theme.brightness == Brightness.dark ? 28 : 18,
  );
  return ShimmerEffect(baseColor: color, highlightColor: color);
}

class _SmartEmptyText extends StatelessWidget {
  final String text;

  const _SmartEmptyText({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: theme.colorScheme.onSurface.withAlpha(120),
          fontSize: AppTextStyles.sizeBodySmall.sp,
          fontWeight: FontWeight.w600,
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

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: TextStyle(
        color: theme.colorScheme.onSurface,
        fontSize: AppTextStyles.sizeBody.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final EdgeInsets? childPadding;

  const _SectionCard({
    required this.title,
    required this.child,
    this.childPadding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [theme.colorScheme.surface, theme.scaffoldBackgroundColor],
        ),
        border: Border.all(
          color: theme.colorScheme.onSurface.withAlpha(10),
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
              color: theme.colorScheme.onSurface.withAlpha(4),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: AppTextStyles.sizeBody.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding:
                childPadding ?? EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _NextMatchCard extends StatelessWidget {
  final TeamProfileNextMatchUiModel item;
  final AppColorPalette palette;
  final VoidCallback? onTap;

  const _NextMatchCard({required this.item, required this.palette, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final content = Container(
      width: 280.w,
      padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [theme.colorScheme.surface, theme.scaffoldBackgroundColor],
        ),
        border: Border.all(
          color: theme.colorScheme.onSurface.withAlpha(10),
          width: 1.w,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  item.competitionLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: palette.textMuted,
                    fontSize: AppTextStyles.sizeBodySmall.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 8.r,
                height: 8.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: palette.textMuted.withAlpha(180),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _MatchTeamBlock(team: item.homeTeam, alignEnd: false),
              ),
              SizedBox(width: 12.w),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.timeLabel,
                    style: TextStyle(
                      color: palette.textPrimary,
                      fontSize: AppTextStyles.sizeHeading.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    item.statusLabel,
                    style: TextStyle(
                      color: palette.textMuted,
                      fontSize: AppTextStyles.sizeBodySmall.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _MatchTeamBlock(team: item.awayTeam, alignEnd: true),
              ),
            ],
          ),
        ],
      ),
    );

    if (onTap == null) {
      return content;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: onTap,
        child: content,
      ),
    );
  }
}

class _MatchTeamBlock extends StatelessWidget {
  final TeamProfileTeamUiModel team;
  final bool alignEnd;

  const _MatchTeamBlock({required this.team, required this.alignEnd});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        _BadgeCircle(
          seed: team.badgeSeed,
          color: team.badgeColor,
          size: 44,
          imageUrl: team.logoUrl,
        ),
        SizedBox(height: 8.h),
        Text(
          team.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: alignEnd ? TextAlign.right : TextAlign.left,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: AppTextStyles.sizeBodySmall.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _LastSixMatchesCard extends StatelessWidget {
  final List<TeamProfileFormResultUiModel> leftResults;
  final List<TeamProfileFormResultUiModel> rightResults;
  final void Function(TeamProfileFormResultUiModel) onMatchTap;

  const _LastSixMatchesCard({
    required this.leftResults,
    required this.rightResults,
    required this.onMatchTap,
  });

  @override
  Widget build(BuildContext context) {
    final rowCount = leftResults.length > rightResults.length
        ? leftResults.length
        : rightResults.length;

    return _SectionCard(
      title: 'Last 6 matches',
      childPadding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 14.h),
      child: rowCount == 0
          ? const _EmptySectionMessage(message: 'No previous form found.')
          : Column(
              children: List.generate(rowCount > 3 ? 3 : rowCount, (index) {
                final left = index < leftResults.length
                    ? leftResults[index]
                    : null;
                final right = index < rightResults.length
                    ? rightResults[index]
                    : null;

                return Padding(
                  padding: EdgeInsets.only(bottom: index == 2 ? 0 : 16.h),
                  child: Row(
                    children: [
                      if (left != null) ...[
                        _FormResultSide(
                          item: left,
                          onTap: () => onMatchTap(left),
                        ),
                      ] else
                        const Spacer(),
                      const Spacer(),
                      if (right != null) ...[
                        _FormResultSide(
                          item: right,
                          onTap: () => onMatchTap(right),
                        ),
                      ] else
                        const Spacer(),
                    ],
                  ),
                );
              }),
            ),
    );
  }
}

class _FormResultSide extends StatelessWidget {
  final TeamProfileFormResultUiModel item;
  final VoidCallback? onTap;

  const _FormResultSide({required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final leftLogo = item.homeLogoUrl.isNotEmpty
        ? item.homeLogoUrl
        : item.logoUrl;
    final rightLogo = item.awayLogoUrl.isNotEmpty
        ? item.awayLogoUrl
        : item.logoUrl;

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _TinyBadge(imageUrl: leftLogo),
        SizedBox(width: 14.w),
        _ResultChip(item: item),
        SizedBox(width: 14.w),
        _TinyBadge(imageUrl: rightLogo),
      ],
    );

    if (onTap == null) {
      return content;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.r),
        onTap: onTap,
        child: content,
      ),
    );
  }
}

class _TopPlayersCard extends StatelessWidget {
  final List<FootballTeamPlayerItemModel> players;
  final int? leagueId;
  final bool isLoading;
  final AppColorPalette palette;
  final void Function(FootballTeamPlayerItemModel) onPlayerTap;

  const _TopPlayersCard({
    required this.players,
    required this.leagueId,
    required this.isLoading,
    required this.palette,
    required this.onPlayerTap,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Top players',
      childPadding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 16.h),
      child: Column(
        children: [
          if (isLoading && players.isEmpty)
            _SmartEmptyText(text: 'Loading top players...')
          else if (players.isEmpty)
            _SmartEmptyText(text: 'No player data found for this season.')
          else
            for (var index = 0; index < players.length; index++)
              Padding(
                padding: EdgeInsets.only(
                  bottom: index == players.length - 1 ? 0 : 12.h,
                ),
                child: _TopPlayerRow(
                  item: players[index],
                  leagueId: leagueId,
                  palette: palette,
                  onTap: () => onPlayerTap(players[index]),
                ),
              ),
        ],
      ),
    );
  }
}

class _TopThreeTableCard extends StatelessWidget {
  final String title;
  final List<FootballStandingRowModel> rows;
  final bool isLoading;
  final AppColorPalette palette;
  final VoidCallback? onLeagueTap;

  const _TopThreeTableCard({
    required this.title,
    required this.rows,
    required this.isLoading,
    required this.palette,
    this.onLeagueTap,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: title,
      childPadding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 16.h),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              children: [
                SizedBox(width: 28.w),
                Expanded(flex: 9, child: _ColumnLabel(text: '# TEAM')),
                Expanded(
                  flex: 2,
                  child: _ColumnLabel(text: 'PL', align: TextAlign.center),
                ),
                Expanded(
                  flex: 3,
                  child: _ColumnLabel(text: '+/-', align: TextAlign.center),
                ),
                Expanded(
                  flex: 2,
                  child: _ColumnLabel(text: 'GD', align: TextAlign.center),
                ),
                Expanded(
                  flex: 2,
                  child: _ColumnLabel(text: 'PTS', align: TextAlign.right),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          if (isLoading && rows.isEmpty)
            _SmartEmptyText(text: 'Loading standings...')
          else if (rows.isEmpty)
            _SmartEmptyText(text: 'No standings found for this league.')
          else
            for (var index = 0; index < rows.length; index++)
              Padding(
                padding: EdgeInsets.only(
                  bottom: index == rows.length - 1 ? 0 : 10.h,
                ),
                child: _MiniStandingRow(
                  item: rows[index],
                  palette: palette,
                  onTap: onLeagueTap,
                ),
              ),
        ],
      ),
    );
  }
}

class _LeaguesCard extends StatelessWidget {
  final List<FootballLeagueApiItemModel> items;
  final bool isLoading;
  final bool canToggle;
  final bool isExpanded;
  final AppColorPalette palette;
  final VoidCallback onToggle;
  final void Function(FootballLeagueApiItemModel) onLeagueTap;

  const _LeaguesCard({
    required this.items,
    required this.isLoading,
    required this.canToggle,
    required this.isExpanded,
    required this.palette,
    required this.onToggle,
    required this.onLeagueTap,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Leagues',
      childPadding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 16.h),
      child: Column(
        children: [
          if (isLoading && items.isEmpty)
            _SmartEmptyText(text: 'Loading leagues...')
          else if (items.isEmpty)
            _SmartEmptyText(text: 'No league data found for this season.')
          else ...[
            for (var index = 0; index < items.length; index++)
              Padding(
                padding: EdgeInsets.only(
                  bottom: index == items.length - 1 ? 0 : 12.h,
                ),
                child: _LeagueRow(
                  item: items[index],
                  palette: palette,
                  onTap: () => onLeagueTap(items[index]),
                ),
              ),
            if (canToggle) ...[
              SizedBox(height: 14.h),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: onToggle,
                  child: Text(
                    isExpanded ? 'See less' : 'See all',
                    style: TextStyle(
                      color: palette.brand,
                      fontSize: AppTextStyles.sizeBodySmall.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _VenueCard extends StatelessWidget {
  final TeamProfileVenueUiModel venue;
  final AppColorPalette palette;

  const _VenueCard({required this.venue, required this.palette});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 18.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [theme.colorScheme.surface, theme.scaffoldBackgroundColor],
        ),
        border: Border.all(
          color: theme.colorScheme.onSurface.withAlpha(10),
          width: 1.w,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 30.r,
                height: 30.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: palette.iconCircleBackground,
                ),
                child: Icon(
                  Icons.stadium_outlined,
                  size: 16.r,
                  color: palette.iconCircleForeground,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      venue.stadiumName,
                      style: TextStyle(
                        color: palette.textPrimary,
                        fontSize: AppTextStyles.sizeBody.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      venue.city,
                      style: TextStyle(
                        color: palette.textMuted,
                        fontSize: AppTextStyles.sizeBodySmall.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 30.r,
                height: 30.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: palette.surface,
                ),
                child: Icon(
                  Icons.location_on_outlined,
                  size: 16.r,
                  color: palette.brand,
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          Row(
            children: [
              Expanded(
                child: _VenueInfoItem(
                  icon: Icons.groups_2_outlined,
                  label: 'Capacity',
                  value: venue.capacity,
                ),
              ),
              Expanded(
                child: _VenueInfoItem(
                  icon: Icons.grid_view_rounded,
                  label: 'Surface',
                  value: venue.surface,
                ),
              ),
              Expanded(
                child: _VenueInfoItem(
                  icon: Icons.calendar_today_outlined,
                  label: 'Opened',
                  value: venue.opened,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  final String text;
  final bool isExpanded;
  final AppColorPalette palette;
  final VoidCallback onToggle;

  const _AboutCard({
    required this.text,
    required this.isExpanded,
    required this.palette,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'About',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text.trim().isEmpty ? 'No team about information found.' : text,
            maxLines: isExpanded ? null : 2,
            overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: AppTextStyles.sizeBodySmall.sp,
              fontWeight: FontWeight.w500,
              height: 1.62,
            ),
          ),
          SizedBox(height: 20.h),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10.r),
              onTap: onToggle,
              child: Container(
                height: 36.h,
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: palette.brand,
                ),
                alignment: Alignment.center,
                child: Text(
                  isExpanded ? 'Collapse' : 'Expand',
                  style: TextStyle(
                    color: palette.textOnPrimary,
                    fontSize: AppTextStyles.sizeBody.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopPlayerRow extends StatelessWidget {
  final FootballTeamPlayerItemModel item;
  final int? leagueId;
  final AppColorPalette palette;
  final VoidCallback? onTap;

  const _TopPlayerRow({
    required this.item,
    required this.leagueId,
    required this.palette,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final stat = item.statisticForLeague(leagueId);
    final rating = stat?.games.rating;
    final position = stat?.games.position ?? '-';
    final goals = stat?.goals.total ?? 0;
    final assists = stat?.goals.assists ?? 0;

    final content = Container(
      height: 64.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: palette.surfaceSoft.withAlpha(40),
      ),
      child: Row(
        children: [
          _BadgeCircle(
            seed: _seedFromName(item.player.name),
            color: palette.iconCircleBackground,
            size: 40,
            imageUrl: item.player.photo,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.player.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: palette.textPrimary,
                    fontSize: AppTextStyles.sizeBody.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '$position • G $goals • A $assists',
                  style: TextStyle(
                    color: palette.textMuted,
                    fontSize: AppTextStyles.sizeBodySmall.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Text(
            rating == null || rating.isEmpty
                ? '-'
                : double.tryParse(rating)?.toStringAsFixed(1) ?? rating,
            style: TextStyle(
              color: palette.brand,
              fontSize: AppTextStyles.sizeBodyLarge.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) {
      return content;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: onTap,
        child: content,
      ),
    );
  }
}

TextStyle _miniTableValueStyle() {
  return TextStyle(
    color: AppColors.textSecondary,
    fontSize: AppTextStyles.sizeBodySmall.sp,
    fontWeight: FontWeight.w700,
  );
}

Color _goalDifferenceColor(String value, AppColorPalette palette) {
  final parsed = int.tryParse(value);
  if (parsed == null || parsed == 0) {
    return palette.textMuted;
  }
  return parsed > 0 ? palette.brand : palette.error;
}

class _MiniStandingRow extends StatelessWidget {
  final FootballStandingRowModel item;
  final AppColorPalette palette;
  final VoidCallback? onTap;

  const _MiniStandingRow({
    required this.item,
    required this.palette,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final goalsFor = item.all.goals.goalsFor ?? 0;
    final goalsAgainst = item.all.goals.against ?? 0;
    final goalDifference = item.goalsDiff == null ? '-' : '${item.goalsDiff}';

    final content = Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        color: palette.surfaceSoft.withAlpha(40),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20.w,
            child: Text(
              '${item.rank ?? '-'}',
              style: TextStyle(
                color: palette.textPrimary,
                fontSize: AppTextStyles.sizeBodySmall.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            flex: 9,
            child: Row(
              children: [
                _SquareBadge(
                  seed: _seedFromName(item.team.name),
                  color: palette.iconCircleBackground,
                  size: 18,
                  imageUrl: item.team.logo,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    item.team.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: palette.textPrimary,
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
              '${item.all.played ?? '-'}',
              textAlign: TextAlign.center,
              style: _miniTableValueStyle(),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              '$goalsFor-$goalsAgainst',
              textAlign: TextAlign.center,
              style: _miniTableValueStyle(),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              goalDifference,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _goalDifferenceColor(goalDifference, palette),
                fontSize: AppTextStyles.sizeBodySmall.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${item.points ?? '-'}',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: palette.brand,
                fontSize: AppTextStyles.sizeBodySmall.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );

    if (onTap == null) {
      return content;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24.r),
        onTap: onTap,
        child: content,
      ),
    );
  }
}

class _LeagueRow extends StatelessWidget {
  final FootballLeagueApiItemModel item;
  final AppColorPalette palette;
  final VoidCallback? onTap;

  const _LeagueRow({required this.item, required this.palette, this.onTap});

  @override
  Widget build(BuildContext context) {
    final season = item.currentSeasonYear;
    final subtitle = [
      if (item.country.name.isNotEmpty) item.country.name,
      if (season != null) '$season',
      if (item.league.type.isNotEmpty) item.league.type,
    ].join(' • ');

    final content = Container(
      height: 72.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: palette.surfaceSoft.withAlpha(40),
      ),
      child: Row(
        children: [
          _BadgeCircle(
            seed: _seedFromName(item.league.name),
            color: palette.iconCircleBackground,
            size: 40,
            imageUrl: item.league.logo,
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.league.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: palette.textPrimary,
                    fontSize: AppTextStyles.sizeBody.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle.isEmpty ? '-' : subtitle,
                  style: TextStyle(
                    color: palette.textMuted,
                    fontSize: AppTextStyles.sizeBodySmall.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (onTap == null) {
      return content;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: onTap,
        child: content,
      ),
    );
  }
}

class _VenueInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _VenueInfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icon, size: 16.r, color: theme.colorScheme.onSurface),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: AppTextStyles.sizeBodySmall.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: AppTextStyles.sizeBody.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ColumnLabel extends StatelessWidget {
  final String text;
  final TextAlign align;

  const _ColumnLabel({required this.text, this.align = TextAlign.left});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        color: theme.colorScheme.onSurface,
        fontSize: AppTextStyles.sizeOverline.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.25,
      ),
    );
  }
}

class _ResultChip extends StatelessWidget {
  final TeamProfileFormResultUiModel item;

  const _ResultChip({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 22.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        color: item.isDraw
            ? theme.colorScheme.onSurface.withAlpha(70)
            : item.isPositive
            ? theme.colorScheme.secondary
            : theme.colorScheme.error,
      ),
      alignment: Alignment.center,
      child: Text(
        item.scoreLabel,
        style: TextStyle(
          color: theme.colorScheme.onSecondary,
          fontSize: AppTextStyles.sizeBodySmall.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _TinyBadge extends StatelessWidget {
  final String imageUrl;

  const _TinyBadge({this.imageUrl = ''});

  @override
  Widget build(BuildContext context) {
    final palette = AppColors.palette(Theme.of(context).brightness);

    return Container(
      width: 24.r,
      height: 24.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: palette.iconCircleBackground,
        border: Border.all(color: palette.borderMuted, width: 1.w),
      ),
      child: imageUrl.isNotEmpty
          ? ClipOval(
              child: AppCachedNetworkImage(
                width: 24.r,
                height: 24.r,
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context) => const SizedBox.shrink(),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

class _EmptySectionMessage extends StatelessWidget {
  final String message;

  const _EmptySectionMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: theme.colorScheme.onSurface.withAlpha(120),
          fontSize: AppTextStyles.sizeBodySmall.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _BadgeCircle extends StatelessWidget {
  final String seed;
  final Color color;
  final double size;
  final String imageUrl;

  const _BadgeCircle({
    required this.seed,
    required this.color,
    this.size = 38,
    this.imageUrl = '',
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppColors.palette(Theme.of(context).brightness);

    return Container(
      width: size.r,
      height: size.r,
      padding: EdgeInsets.all(2.r),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color == Colors.transparent
            ? palette.iconCircleBackground
            : color,
      ),
      alignment: Alignment.center,
      child: imageUrl.isNotEmpty
          ? ClipOval(
              child: AppCachedNetworkImage(
                width: size.r,
                height: size.r,
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context) => _BadgeFallback(seed: seed),
              ),
            )
          : _BadgeFallback(seed: seed),
    );
  }
}

class _BadgeFallback extends StatelessWidget {
  final String seed;

  const _BadgeFallback({required this.seed});

  @override
  Widget build(BuildContext context) {
    final palette = AppColors.palette(Theme.of(context).brightness);

    return Text(
      seed,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: palette.textPrimary,
        fontSize: AppTextStyles.sizeTiny.sp,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _SquareBadge extends StatelessWidget {
  final String seed;
  final Color color;
  final double size;
  final String imageUrl;

  const _SquareBadge({
    required this.seed,
    required this.color,
    this.size = 18,
    this.imageUrl = '',
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppColors.palette(Theme.of(context).brightness);

    return Container(
      width: size.r,
      height: size.r,
      padding: EdgeInsets.all(2.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        color: color,
        border: Border.all(color: palette.borderMuted, width: .8.w),
      ),
      alignment: Alignment.center,
      child: imageUrl.isNotEmpty
          ? AppCachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context) => _BadgeFallback(seed: seed),
            )
          : _BadgeFallback(seed: seed),
    );
  }
}
