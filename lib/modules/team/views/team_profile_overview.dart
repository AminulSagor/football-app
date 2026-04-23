import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/themes/app_text_styles.dart';
import '../team_profile_controller.dart';
import '../team_profile_model.dart';

class TeamProfileOverviewPage extends GetView<TeamProfileController> {
  const TeamProfileOverviewPage({super.key});

  Future<void> _showSeasonPicker(BuildContext context) async {
    final state = controller.state.value;
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(18.w, 14.h, 18.w, 18.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withAlpha(120),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                SizedBox(height: 18.h),
                for (final season in state.seasons)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16.r),
                        onTap: () => Navigator.of(context).pop(season),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 14.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: season == state.selectedSeason
                                ? theme.colorScheme.primary.withAlpha(24)
                                : theme.colorScheme.onSurface.withAlpha(6),
                            border: Border.all(
                              color: season == state.selectedSeason
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface.withAlpha(18),
                              width: 1.w,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  season,
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface,
                                    fontSize: AppTextStyles.sizeBody.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              if (season == state.selectedSeason)
                                Icon(
                                  Icons.check_rounded,
                                  size: 18.r,
                                  color: theme.colorScheme.primary,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null) {
      controller.selectSeason(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final state = controller.state.value;
      final overview = state.overview;

      return ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 28.h),
        children: [
          _SectionTitle(title: 'Next match'),
          SizedBox(height: 12.h),
          SizedBox(
            height: 166.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: overview.nextMatches.length,
              separatorBuilder: (_, __) => SizedBox(width: 12.w),
              itemBuilder: (context, index) {
                return _NextMatchCard(item: overview.nextMatches[index]);
              },
            ),
          ),
          SizedBox(height: 26.h),
          _LastSixMatchesCard(
            leftResults: overview.leftResults,
            rightResults: overview.rightResults,
          ),
          SizedBox(height: 24.h),
          _TopPlayersCard(players: overview.topPlayers),
          SizedBox(height: 24.h),
          _TopThreeTableCard(
            rows: state.standings.take(3).toList(growable: false),
          ),
          SizedBox(height: 24.h),
          _LeaguesCard(items: overview.leagues),
          SizedBox(height: 24.h),
          _RankingsCard(
            items: overview.rankings,
            season: state.selectedSeason,
            onSeasonTap: () => _showSeasonPicker(context),
          ),
          SizedBox(height: 24.h),
          _VenueCard(venue: overview.venue),
          SizedBox(height: 24.h),
          _AboutCard(
            text: overview.aboutText,
            isExpanded: state.isAboutExpanded,
            onToggle: controller.toggleAboutExpanded,
          ),
        ],
      );
    });
  }
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
        border: Border.all(color: theme.colorScheme.onSurface.withAlpha(10), width: 1.w),
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

  const _NextMatchCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 280.w,
      padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [theme.colorScheme.surface, theme.scaffoldBackgroundColor],
        ),
        border: Border.all(color: theme.colorScheme.onSurface.withAlpha(10), width: 1.w),
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
                    color: theme.colorScheme.onSurface.withAlpha(168),
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
                  color: theme.colorScheme.onSurface.withAlpha(180),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _MatchTeamBlock(
                  team: item.homeTeam,
                  alignEnd: false,
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.timeLabel,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: AppTextStyles.sizeHeading.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    item.statusLabel,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withAlpha(130),
                      fontSize: AppTextStyles.sizeBodySmall.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _MatchTeamBlock(
                  team: item.awayTeam,
                  alignEnd: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MatchTeamBlock extends StatelessWidget {
  final TeamProfileTeamUiModel team;
  final bool alignEnd;

  const _MatchTeamBlock({
    required this.team,
    required this.alignEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        _BadgeCircle(seed: team.badgeSeed, color: team.badgeColor, size: 44),
        SizedBox(height: 8.h),
        Text(
          team.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: alignEnd ? TextAlign.right : TextAlign.left,
          style: TextStyle(
            color: Colors.white,
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

  const _LastSixMatchesCard({
    required this.leftResults,
    required this.rightResults,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Last 6 matches',
      childPadding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 14.h),
      child: Column(
        children: List.generate(3, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: index == 2 ? 0 : 16.h),
            child: Row(
              children: [
                _TinyBadge(),
                SizedBox(width: 22.w),
                _ResultChip(item: leftResults[index]),
                const Spacer(),
                _TinyBadge(),
                SizedBox(width: 22.w),
                _ResultChip(item: rightResults[index]),
                SizedBox(width: 22.w),
                _TinyBadge(),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _TopPlayersCard extends StatelessWidget {
  final List<TeamProfileTopPlayerUiModel> players;

  const _TopPlayersCard({required this.players});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Top players',
      childPadding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 16.h),
      child: Column(
        children: [
          for (var index = 0; index < players.length; index++)
            Padding(
              padding: EdgeInsets.only(
                bottom: index == players.length - 1 ? 0 : 12.h,
              ),
              child: _TopPlayerRow(item: players[index]),
            ),
        ],
      ),
    );
  }
}

class _TopThreeTableCard extends StatelessWidget {
  final List<TeamProfileStandingsRowUiModel> rows;

  const _TopThreeTableCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Premier League',
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
                  child: _ColumnLabel(
                    text: 'PL',
                    align: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _ColumnLabel(
                    text: '+/-',
                    align: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _ColumnLabel(
                    text: 'GD',
                    align: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _ColumnLabel(
                    text: 'PTS',
                    align: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          for (var index = 0; index < rows.length; index++)
            Padding(
              padding:
                  EdgeInsets.only(bottom: index == rows.length - 1 ? 0 : 10.h),
              child: _MiniStandingRow(item: rows[index]),
            ),
        ],
      ),
    );
  }
}

class _LeaguesCard extends StatelessWidget {
  final List<TeamProfileLeagueItemUiModel> items;

  const _LeaguesCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Leagues',
      childPadding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 16.h),
      child: Column(
        children: [
          for (var index = 0; index < items.length; index++)
            Padding(
              padding:
                  EdgeInsets.only(bottom: index == items.length - 1 ? 0 : 12.h),
              child: _LeagueRow(item: items[index]),
            ),
        ],
      ),
    );
  }
}

class _RankingsCard extends StatelessWidget {
  final List<TeamProfileRankingItemUiModel> items;
  final String season;
  final VoidCallback onSeasonTap;

  const _RankingsCard({
    required this.items,
    required this.season,
    required this.onSeasonTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _SectionCard(
      title: 'Rankings',
      childPadding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 16.h),
      child: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(18.r),
                  onTap: onSeasonTap,
                  child: Container(
                    height: 34.h,
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.r),
                      color: theme.colorScheme.surface,
                      border: Border.all(
                        color: theme.colorScheme.onSurface.withAlpha(16),
                        width: 1.w,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          season,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: AppTextStyles.sizeBodySmall.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 18.r,
                          color: theme.colorScheme.onSurface,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          for (var index = 0; index < items.length; index++)
            Padding(
              padding:
                  EdgeInsets.only(bottom: index == items.length - 1 ? 0 : 12.h),
              child: _RankingRow(item: items[index]),
            ),
        ],
      ),
    );
  }
}

class _VenueCard extends StatelessWidget {
  final TeamProfileVenueUiModel venue;

  const _VenueCard({required this.venue});

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
        border: Border.all(color: theme.colorScheme.onSurface.withAlpha(10), width: 1.w),
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
                  color: theme.colorScheme.onSurface.withAlpha(6),
                ),
                child: Icon(
                  Icons.stadium_outlined,
                  size: 16.r,
                  color: theme.colorScheme.onSurface.withAlpha(170),
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
                        color: theme.colorScheme.onSurface,
                        fontSize: AppTextStyles.sizeBody.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      venue.city,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withAlpha(118),
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
                  color: theme.colorScheme.surface,
                ),
                child: Icon(
                  Icons.location_on_outlined,
                  size: 16.r,
                  color: theme.colorScheme.primary,
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
  final VoidCallback onToggle;

  const _AboutCard({
    required this.text,
    required this.isExpanded,
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
            text,
            maxLines: isExpanded ? null : 10,
            overflow:
                isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withAlpha(228),
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
                  color: const Color(0xFF0D8F67),
                ),
                alignment: Alignment.center,
                child: Text(
                  isExpanded ? 'Collapse' : 'Expand',
                  style: TextStyle(
                    color: Colors.white,
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
  final TeamProfileTopPlayerUiModel item;

  const _TopPlayerRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: Colors.white.withAlpha(6),
      ),
      child: Row(
        children: [
          _BadgeCircle(seed: item.badgeSeed, color: item.badgeColor, size: 40),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppTextStyles.sizeBody.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  item.subtitle,
                  style: TextStyle(
                    color: Colors.white.withAlpha(100),
                    fontSize: AppTextStyles.sizeBodySmall.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Text(
            item.value,
            style: TextStyle(
              color: const Color(0xFF39E0B3),
              fontSize: AppTextStyles.sizeTitle.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStandingRow extends StatelessWidget {
  final TeamProfileStandingsRowUiModel item;

  const _MiniStandingRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        color: Colors.white.withAlpha(6),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20.w,
            child: Text(
              item.rank,
              style: TextStyle(
                color: Colors.white,
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
                  seed: item.badgeSeed,
                  color: item.badgeColor,
                  size: 18,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    item.teamName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
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
              style: _tableValueStyle(),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              item.plusMinus,
              textAlign: TextAlign.center,
              style: _tableValueStyle(),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item.goalDifference,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _goalColor(item.goalDifference),
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
                color: Colors.white,
                fontSize: AppTextStyles.sizeBody.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _tableValueStyle() {
    return TextStyle(
      color: Colors.white.withAlpha(180),
      fontSize: AppTextStyles.sizeBodySmall.sp,
      fontWeight: FontWeight.w500,
    );
  }

  Color _goalColor(String value) {
    return value.startsWith('-')
        ? const Color(0xFFFF6E6E)
        : const Color(0xFF39E0B3);
  }
}

class _LeagueRow extends StatelessWidget {
  final TeamProfileLeagueItemUiModel item;

  const _LeagueRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: Colors.white.withAlpha(6),
      ),
      child: Row(
        children: [
          _BadgeCircle(seed: item.badgeSeed, color: item.badgeColor, size: 40),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppTextStyles.sizeBody.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  item.seasonLabel,
                  style: TextStyle(
                    color: Colors.white.withAlpha(90),
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
  }
}

class _RankingRow extends StatelessWidget {
  final TeamProfileRankingItemUiModel item;

  const _RankingRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: Colors.white.withAlpha(6),
      ),
      child: Row(
        children: [
          _BadgeCircle(seed: item.badgeSeed, color: item.badgeColor, size: 34),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: AppTextStyles.sizeBody.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            item.value,
            style: TextStyle(
              color: const Color(0xFF39E0B3),
              fontSize: AppTextStyles.sizeHeading.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
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
    return Column(
      children: [
        Icon(icon, size: 16.r, color: Colors.white.withAlpha(168)),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withAlpha(118),
            fontSize: AppTextStyles.sizeBodySmall.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
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

  const _ColumnLabel({
    required this.text,
    this.align = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        color: Colors.white.withAlpha(82),
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
    return Container(
      height: 22.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        color: item.isPositive
            ? const Color(0xFF39E0B3)
            : const Color(0xFFFC5C5C),
      ),
      alignment: Alignment.center,
      child: Text(
        item.scoreLabel,
        style: TextStyle(
          color: Colors.black,
          fontSize: AppTextStyles.sizeBodySmall.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _TinyBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.r,
      height: 20.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF171D24),
        border: Border.all(color: const Color(0xFF596C95), width: 1.w),
      ),
    );
  }
}

class _BadgeCircle extends StatelessWidget {
  final String seed;
  final Color color;
  final double size;

  const _BadgeCircle({
    required this.seed,
    required this.color,
    this.size = 38,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF232830),
        border: Border.all(color: const Color(0xFF6CE6C1), width: 1.w),
      ),
      alignment: Alignment.center,
      child: Text(
        seed,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: AppTextStyles.sizeTiny.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _SquareBadge extends StatelessWidget {
  final String seed;
  final Color color;
  final double size;

  const _SquareBadge({
    required this.seed,
    required this.color,
    this.size = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        color: color,
        border: Border.all(color: Colors.white.withAlpha(32), width: .8.w),
      ),
      alignment: Alignment.center,
      child: Text(
        seed,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: AppTextStyles.sizeTiny.sp,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
    );
  }
}