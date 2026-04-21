import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/themes/app_text_styles.dart';
import 'search/matches_search_controller.dart';
import 'search/matches_search_view.dart';
import 'matches_controller.dart';
import 'matches_models.dart';

class MatchesView extends GetView<MatchesController> {
  const MatchesView({super.key});

  void _openSearch(BuildContext context) {
    final searchController = Get.find<MatchesSearchController>();
    searchController.reset();

    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const MatchesSearchView()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.scaffoldBackgroundColor,
            theme.colorScheme.surface.withAlpha(
              theme.brightness == Brightness.dark ? 34 : 16,
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: Obx(() {
          final state = controller.state.value;

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                child: _TopHeader(onSearchTap: () => _openSearch(context)),
              ),
              SizedBox(height: 14.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: _SportSelector(
                  selectedSportCode: state.selectedSportCode,
                  onSportSelected: controller.onSportSelected,
                ),
              ),
              SizedBox(height: 14.h),
              if (state.isFootballSelected) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: _DateFilterCard(
                    day: state.selectedDay,
                    timelineFilter: state.timelineFilter,
                    showOngoingTimeline: state.shouldShowOngoingTimelineFilter,
                    canGoPrevious: state.canGoPreviousDay,
                    canGoNext: state.canGoNextDay,
                    onPreviousDay: controller.showPreviousDay,
                    onNextDay: controller.showNextDay,
                    onTimelineChanged: controller.onTimelineFilterChanged,
                  ),
                ),
                SizedBox(height: 14.h),
                Expanded(
                  child: _FootballTimelineContent(
                    state: state,
                    leagues: controller.filteredLeagues(),
                    previewLeagues: controller.nextDayPreviewLeagues(),
                    onLeagueToggle: controller.toggleLeagueExpanded,
                  ),
                ),
              ] else
                const Expanded(child: _FeatureComingSoonView()),
            ],
          );
        }),
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  final VoidCallback onSearchTap;

  const _TopHeader({required this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            'KICSCORE',
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w700,
              fontSize: AppTextStyles.sizeHeading.sp,
              letterSpacing: 0.2,
            ),
          ),
        ),
        Icon(
          Icons.notifications,
          color: theme.colorScheme.onSurface.withAlpha(180),
          size: 20.r,
        ),
        SizedBox(width: 14.w),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18.r),
            onTap: onSearchTap,
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Icon(
                Icons.search,
                color: theme.colorScheme.onSurface.withAlpha(180),
                size: 22.r,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SportSelector extends StatelessWidget {
  final String selectedSportCode;
  final ValueChanged<String> onSportSelected;

  const _SportSelector({
    required this.selectedSportCode,
    required this.onSportSelected,
  });

  @override
  Widget build(BuildContext context) {
    const items = <_SportItemData>[
      _SportItemData(
        code: MatchesSportCodes.football,
        label: 'Football',
        icon: Icons.sports_soccer,
      ),
      _SportItemData(
        code: MatchesSportCodes.cricket,
        label: 'Cricket',
        icon: Icons.sports_cricket,
      ),
      _SportItemData(
        code: MatchesSportCodes.basketball,
        label: 'Basketball',
        icon: Icons.sports_basketball,
      ),
    ];

    return SizedBox(
      height: 44.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = item.code == selectedSportCode;

          return _SportTabChip(
            item: item,
            isSelected: isSelected,
            onTap: () => onSportSelected(item.code),
          );
        },
      ),
    );
  }
}

class _SportTabChip extends StatelessWidget {
  final _SportItemData item;
  final bool isSelected;
  final VoidCallback onTap;

  const _SportTabChip({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22.r),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.r),
            color: theme.colorScheme.surface.withAlpha(isSelected ? 165 : 118),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.secondary
                  : theme.dividerColor.withAlpha(135),
              width: isSelected ? 1.4.w : 1.w,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: theme.colorScheme.secondary.withAlpha(30),
                      blurRadius: 20.r,
                      spreadRadius: 0,
                      offset: Offset(0, 8.h),
                    ),
                  ]
                : const <BoxShadow>[],
          ),
          child: Row(
            children: [
              Container(
                width: 22.r,
                height: 22.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.surface.withAlpha(125),
                  border: Border.all(
                    color: theme.dividerColor.withAlpha(160),
                    width: 1.w,
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  item.icon,
                  size: 13.r,
                  color: isSelected
                      ? theme.colorScheme.secondary
                      : theme.colorScheme.onSurface.withAlpha(128),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                item.label,
                style: TextStyle(
                  color: isSelected
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurface.withAlpha(148),
                  fontSize: AppTextStyles.sizeBodySmall.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateFilterCard extends StatelessWidget {
  final MatchesDayUiModel? day;
  final MatchesTimelineFilter timelineFilter;
  final bool showOngoingTimeline;
  final bool canGoPrevious;
  final bool canGoNext;
  final VoidCallback onPreviousDay;
  final VoidCallback onNextDay;
  final ValueChanged<MatchesTimelineFilter> onTimelineChanged;

  const _DateFilterCard({
    required this.day,
    required this.timelineFilter,
    required this.showOngoingTimeline,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.onPreviousDay,
    required this.onNextDay,
    required this.onTimelineChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedDay = day;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface.withAlpha(220),
            theme.colorScheme.surface.withAlpha(140),
          ],
        ),
        border: Border.all(
          color: theme.dividerColor.withAlpha(160),
          width: 1.w,
        ),
      ),
      padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 14.h),
      child: Column(
        children: [
          Row(
            children: [
              _DateArrowButton(
                icon: Icons.chevron_left,
                enabled: canGoPrevious,
                onTap: onPreviousDay,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      _dayLabel(selectedDay?.dayLabelCode),
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w700,
                        fontSize: AppTextStyles.sizeLabel.sp,
                        letterSpacing: 1.8,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      selectedDay?.displayDate ?? '--',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: AppTextStyles.sizeHeading.sp,
                      ),
                    ),
                  ],
                ),
              ),
              _DateArrowButton(
                icon: Icons.chevron_right,
                enabled: canGoNext,
                onTap: onNextDay,
              ),
            ],
          ),
          SizedBox(height: 14.h),
          _TimelineToggle(
            selected: timelineFilter,
            showOngoing: showOngoingTimeline,
            onChanged: onTimelineChanged,
          ),
        ],
      ),
    );
  }

  String _dayLabel(String? dayCode) {
    switch (dayCode) {
      case MatchesDayLabelCodes.today:
        return 'TODAY';
      case MatchesDayLabelCodes.tomorrow:
        return 'TOMORROW';
      case MatchesDayLabelCodes.old:
        return 'OLD';
      default:
        return 'DAY';
    }
  }
}

class _DateArrowButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _DateArrowButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.surface.withAlpha(enabled ? 140 : 70),
            border: Border.all(
              color: theme.dividerColor.withAlpha(enabled ? 170 : 90),
              width: 1.w,
            ),
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 20.r,
            color: theme.colorScheme.onSurface.withAlpha(enabled ? 190 : 90),
          ),
        ),
      ),
    );
  }
}

class _TimelineToggle extends StatelessWidget {
  final MatchesTimelineFilter selected;
  final bool showOngoing;
  final ValueChanged<MatchesTimelineFilter> onChanged;

  const _TimelineToggle({
    required this.selected,
    required this.showOngoing,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showOngoing)
          Expanded(
            child: _TimelineButton(
              label: 'Ongoing',
              selected: selected == MatchesTimelineFilter.ongoing,
              onTap: () => onChanged(MatchesTimelineFilter.ongoing),
            ),
          ),
        if (showOngoing) SizedBox(width: 8.w),
        Expanded(
          child: _TimelineButton(
            label: 'By time',
            selected: showOngoing
                ? selected == MatchesTimelineFilter.byTime
                : true,
            onTap: () => onChanged(MatchesTimelineFilter.byTime),
          ),
        ),
      ],
    );
  }
}

class _TimelineButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TimelineButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 36.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          color: selected
              ? const Color(0xFF84D8B4) // selected green like image
              : theme.colorScheme.surface.withAlpha(160),
          border: Border.all(
            color: selected
                ? const Color(0xFF84D8B4)
                : theme.dividerColor.withAlpha(135),
            width: 1.w,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFF84D8B4).withAlpha(90),
                    blurRadius: 7.r,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: selected
                ? const Color(0xFF0E3B2C)
                : theme.textTheme.bodyMedium?.color,
          ),
        ),
      ),
    );
  }
}

class _TimelineOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TimelineOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: selected
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.secondary.withAlpha(235),
                      theme.colorScheme.secondary.withAlpha(198),
                    ],
                  )
                : null,
            color: selected ? null : Colors.transparent,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected
                  ? theme.colorScheme.onSecondary
                  : theme.colorScheme.onSurface.withAlpha(165),
              fontSize: AppTextStyles.sizeBodySmall.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _FootballTimelineContent extends StatelessWidget {
  final MatchesViewModel state;
  final List<MatchesLeagueUiModel> leagues;
  final List<MatchesLeagueUiModel> previewLeagues;
  final ValueChanged<String> onLeagueToggle;

  const _FootballTimelineContent({
    required this.state,
    required this.leagues,
    required this.previewLeagues,
    required this.onLeagueToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (state.isLoading) {
      return Center(
        child: SizedBox(
          width: 26.r,
          height: 26.r,
          child: CircularProgressIndicator(
            strokeWidth: 2.3.w,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.secondary,
            ),
          ),
        ),
      );
    }

    if (state.errorCode != null) {
      return Center(
        child: Text(
          'Unable to load matches',
          style: TextStyle(
            color: theme.colorScheme.onSurface.withAlpha(170),
            fontSize: AppTextStyles.sizeBody.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    if (leagues.isEmpty) {
      final nextDay = state.nextDay;

      return ListView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
        children: [
          SizedBox(height: 42.h),
          Text(
            _emptyText(state.selectedDay?.dayLabelCode),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withAlpha(120),
              fontSize: AppTextStyles.sizeTitle.sp,
              height: 1.15,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (nextDay != null && previewLeagues.isNotEmpty) ...[
            SizedBox(height: 48.h),
            Text(
              _upcomingTitle(nextDay.dayLabelCode),
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: AppTextStyles.sizeHeading.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 14.h),
            for (final league in previewLeagues)
              _LeagueSection(
                league: league,
                isExpanded: false,
                expandable: false,
                onToggle: null,
              ),
          ],
        ],
      );
    }

    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 22.h),
      children: [
        for (final league in leagues)
          _LeagueSection(
            league: league,
            isExpanded: state.expandedLeagueIds.contains(league.leagueId),
            expandable: true,
            onToggle: () => onLeagueToggle(league.leagueId),
          ),
      ],
    );
  }

  String _emptyText(String? dayCode) {
    if (dayCode == MatchesDayLabelCodes.today) {
      return 'No match\nscheduled today';
    }
    if (dayCode == MatchesDayLabelCodes.tomorrow) {
      return 'No match\nscheduled tomorrow';
    }
    return 'No match\nscheduled for this date';
  }

  String _upcomingTitle(String dayCode) {
    if (dayCode == MatchesDayLabelCodes.tomorrow) {
      return 'Tomorrow';
    }
    if (dayCode == MatchesDayLabelCodes.today) {
      return 'Today';
    }
    return 'Upcoming';
  }
}

class _LeagueSection extends StatelessWidget {
  final MatchesLeagueUiModel league;
  final bool isExpanded;
  final bool expandable;
  final VoidCallback? onToggle;

  const _LeagueSection({
    required this.league,
    required this.isExpanded,
    required this.expandable,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        children: [
          _LeagueHeaderCard(
            league: league,
            isExpanded: isExpanded,
            expandable: expandable,
            onTap: onToggle,
          ),
          if (isExpanded) ...[
            SizedBox(height: 10.h),
            for (final fixture in league.fixtures)
              Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: _FixtureCard(fixture: fixture),
              ),
          ],
        ],
      ),
    );
  }
}

class _LeagueHeaderCard extends StatelessWidget {
  final MatchesLeagueUiModel league;
  final bool isExpanded;
  final bool expandable;
  final VoidCallback? onTap;

  const _LeagueHeaderCard({
    required this.league,
    required this.isExpanded,
    required this.expandable,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22.r),
        onTap: onTap,
        child: Container(
          decoration: !isExpanded ?BoxDecoration(
            borderRadius: BorderRadius.circular(22.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.surface.withAlpha(228),
                theme.colorScheme.surface.withAlpha(140),
              ],
            ),
            border: Border.all(
              color: theme.dividerColor.withAlpha(130),
              width: 1.w,
            ),
          ) : null,
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              _LeagueBadge(seed: league.badgeSeed),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      league.leagueName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: AppTextStyles.sizeBodySmall.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      league.stageName,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withAlpha(150),
                        fontSize: AppTextStyles.sizeTiny.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              if(!isExpanded)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: theme.colorScheme.secondary.withAlpha(32),
                  border: Border.all(
                    color: theme.colorScheme.secondary.withAlpha(65),
                    width: 1.w,
                  ),
                ),
                child: Text(
                  _countLabel(league.fixtureCount),
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontSize: AppTextStyles.sizeCaption.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              AnimatedRotation(
                turns: expandable && isExpanded ? 0.25 : 0,
                duration: const Duration(milliseconds: 180),
                child: Icon(
                  Icons.chevron_right,
                  size: 22.r,
                  color: theme.colorScheme.onSurface.withAlpha(170),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _countLabel(int count) {
    final suffix = count == 1 ? 'Match' : 'Matches';
    return '$count $suffix';
  }
}

class _LeagueBadge extends StatelessWidget {
  final String seed;

  const _LeagueBadge({required this.seed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 38.r,
      height: 38.r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface.withAlpha(200),
            theme.colorScheme.surface.withAlpha(115),
          ],
        ),
        border: Border.all(
          color: theme.dividerColor.withAlpha(120),
          width: 1.w,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        seed,
        style: TextStyle(
          color: theme.colorScheme.onSurface.withAlpha(190),
          fontSize: AppTextStyles.sizeTiny.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _FixtureCard extends StatelessWidget {
  final MatchesFixtureUiModel fixture;

  const _FixtureCard({required this.fixture});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = fixture.isLive
        ? theme.colorScheme.secondary
        : theme.colorScheme.onSurface.withAlpha(120);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface.withAlpha(228),
            theme.colorScheme.surface.withAlpha(145),
          ],
        ),
        border: Border.all(
          color: theme.dividerColor.withAlpha(120),
          width: 1.w,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 90.h,
            decoration: BoxDecoration(
              color: fixture.isLive
                  ? theme.colorScheme.secondary
                  : Colors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(22.r),
                bottomLeft: Radius.circular(22.r),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.w, 14.h, 12.w, 14.h),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _TeamRow(team: fixture.homeTeam),
                        SizedBox(height: 10.h),
                        _TeamRow(team: fixture.awayTeam),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  _ScoreColumn(
                    topScore: _scoreText(fixture.homeScore),
                    bottomScore: _scoreText(fixture.awayScore),
                  ),
                  SizedBox(width: 12.w),
                  Container(
                    width: 1.w,
                    height: 56.h,
                    color: theme.dividerColor.withAlpha(180),
                  ),
                  SizedBox(width: 12.w),
                  SizedBox(
                    width: 48.w,
                    child: _StatusColumn(
                      statusLabel: fixture.statusLabel,
                      statusDetail: fixture.statusDetail,
                      color: accentColor,
                      isLive: fixture.isLive,
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

  String _scoreText(int? score) {
    return score == null ? '-' : '$score';
  }
}

class _TeamRow extends StatelessWidget {
  final MatchesTeamUiModel team;

  const _TeamRow({required this.team});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badgeColor = _colorFromHex(team.badgeHex, theme.colorScheme.primary);

    return Row(
      children: [
        Container(
          width: 20.r,
          height: 20.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: badgeColor.withAlpha(210),
            border: Border.all(color: Colors.white.withAlpha(25), width: 1.w),
          ),
          alignment: Alignment.center,
          child: Text(
            team.shortName,
            style: TextStyle(
              color: Colors.white.withAlpha(220),
              fontSize: AppTextStyles.sizeTiny.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            team.teamName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: AppTextStyles.sizeBody.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _ScoreColumn extends StatelessWidget {
  final String topScore;
  final String bottomScore;

  const _ScoreColumn({required this.topScore, required this.bottomScore});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 18.w,
      child: Column(
        children: [
          Text(
            topScore,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: AppTextStyles.sizeBodyLarge.sp,
              height: 1,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            bottomScore,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: AppTextStyles.sizeBodyLarge.sp,
              height: 1,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusColumn extends StatelessWidget {
  final String statusLabel;
  final String statusDetail;
  final Color color;
  final bool isLive;

  const _StatusColumn({
    required this.statusLabel,
    required this.statusDetail,
    required this.color,
    required this.isLive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (statusDetail.isEmpty) {
      return Center(
        child: Text(
          statusLabel,
          style: TextStyle(
            color: isLive ? color : theme.colorScheme.onSurface.withAlpha(155),
            fontSize: AppTextStyles.sizeBodySmall.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          statusLabel,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: color,
            fontSize: AppTextStyles.sizeBodySmall.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          statusDetail,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: color,
            fontSize: AppTextStyles.sizeBodySmall.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _FeatureComingSoonView extends StatelessWidget {
  const _FeatureComingSoonView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Text(
        'Feature\ncoming soon',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: theme.colorScheme.onSurface.withAlpha(110),
          fontSize: AppTextStyles.sizeHero.sp,
          fontWeight: FontWeight.w700,
          height: 1.08,
        ),
      ),
    );
  }
}

class _SportItemData {
  final String code;
  final String label;
  final IconData icon;

  const _SportItemData({
    required this.code,
    required this.label,
    required this.icon,
  });
}

Color _colorFromHex(String value, Color fallback) {
  final hex = value.replaceAll('#', '').trim();
  if (hex.length != 6 && hex.length != 8) {
    return fallback;
  }

  final normalized = hex.length == 6 ? 'FF$hex' : hex;
  final parsed = int.tryParse(normalized, radix: 16);
  if (parsed == null) {
    return fallback;
  }

  return Color(parsed);
}
