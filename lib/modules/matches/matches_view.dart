import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/themes/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../bottom_nav_bar/search/matches_search_controller.dart';
import '../bottom_nav_bar/search/matches_search_view.dart';
import 'matches_controller.dart';
import 'model/matches_models.dart';

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
              SizedBox(height: 14.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: _SportSelector(
                  selectedSportCode: state.selectedSportCode,
                  onSportSelected: controller.onSportSelected,
                ),
              ),
              SizedBox(height: 14.h),

              if (state.isFootballSelected)
                Expanded(
                  child: _FootballTimelineContent(
                    state: state,
                    leagues: controller.filteredLeagues(),
                    onLeagueToggle: controller.toggleLeagueExpanded,
                    onDateSelected: controller.onDateSelected,
                    onClearFilter: controller.clearDateFilter,
                    onRefresh: controller.refreshFootballPage,
                    onLoadMoreLeagues: controller.loadMoreLeagueFixtures,
                    onLoadMoreLiveMatches: controller.loadMoreLiveMatches,
                  ),
                )
              else
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
      height: 40.h,
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
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999.r),
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
                  size: 14.r,
                  color: isSelected
                      ? theme.colorScheme.secondary
                      : theme.colorScheme.onSurface.withAlpha(128),
                ),
              ),
              SizedBox(width: 4.w),
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

DateTime _normalizedDate(DateTime value) {
  return DateTime(value.year, value.month, value.day);
}

DateTime? _parseDayDate(String? value) {
  if (value == null) return null;
  final parsed = DateTime.tryParse(value);
  if (parsed == null) return null;
  return _normalizedDate(parsed);
}

class _LiveNowSection extends StatelessWidget {
  final List<MatchesLiveMatchUiModel> matches;
  final String title;
  final bool isRefreshing;
  final bool canLoadMore;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;

  const _LiveNowSection({
    required this.matches,
    required this.title,
    required this.isRefreshing,
    required this.canLoadMore,
    required this.isLoadingMore,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (matches.isEmpty && !isRefreshing) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: AppTextStyles.sizeHeading.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (isRefreshing) ...[
              SizedBox(width: 8.w),
              SizedBox(
                width: 14.r,
                height: 14.r,
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 10.h),
        if (matches.isNotEmpty)
          SizedBox(
            height: 172.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: matches.length,
              separatorBuilder: (_, _) => SizedBox(width: 10.w),
              itemBuilder: (context, index) {
                return _LiveMatchCard(match: matches[index]);
              },
            ),
          ),
        if (canLoadMore || isLoadingMore) ...[
          SizedBox(height: 10.h),
          Center(
            child: SizedBox(
              height: 34.h,
              child: OutlinedButton(
                onPressed: isLoadingMore ? null : onLoadMore,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: theme.colorScheme.secondary.withAlpha(190),
                    width: 1.w,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                ),
                child: isLoadingMore
                    ? SizedBox(
                        width: 14.r,
                        height: 14.r,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.w,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.secondary,
                          ),
                        ),
                      )
                    : Text(
                        'Load more',
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontSize: AppTextStyles.sizeBodySmall.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _LiveMatchCard extends StatelessWidget {
  final MatchesLiveMatchUiModel match;

  const _LiveMatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8.r),
        onTap: () {
          Get.toNamed(
            AppRoutes.matchDetails,
            arguments: <String, dynamic>{
              'scenario': match.isUpcoming ? 'upcoming' : 'live',
              'fixtureId': match.matchId,
              'homeTeamId': match.homeTeam.teamId,
              'awayTeamId': match.awayTeam.teamId,
              'homeTeamName': match.homeTeam.teamName,
              'awayTeamName': match.awayTeam.teamName,
            },
          );
        },
        child: Container(
          width: 228.w,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: theme.colorScheme.surface.withAlpha(230),
            border: Border.all(
              color: theme.dividerColor.withAlpha(120),
              width: 1.w,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(18),
                blurRadius: 10.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: match.isUpcoming
              ? _UpcomingMatchCardContent(match: match)
              : _LiveMatchCardContent(match: match),
        ),
      ),
    );
  }
}

class _LiveMatchCardContent extends StatelessWidget {
  final MatchesLiveMatchUiModel match;

  const _LiveMatchCardContent({required this.match});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              width: 6.r,
              height: 6.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.error,
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              match.statusLabel,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withAlpha(170),
                fontSize: AppTextStyles.sizeTiny.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
            const Spacer(),
            Text(
              match.minuteLabel,
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: AppTextStyles.sizeCaption.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _LiveTeamScoreRow(team: match.homeTeam, score: match.homeScore),
        SizedBox(height: 10.h),
        _LiveTeamScoreRow(team: match.awayTeam, score: match.awayScore),
        SizedBox(height: 12.h),
        Divider(
          height: 1.h,
          thickness: 1.h,
          color: theme.dividerColor.withAlpha(90),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: Text(
                '${match.homeTeam.shortName} vs ${match.awayTeam.shortName}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withAlpha(140),
                  fontSize: AppTextStyles.sizeTiny.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              'Live',
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: AppTextStyles.sizeTiny.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _UpcomingMatchCardContent extends StatelessWidget {
  final MatchesLiveMatchUiModel match;

  const _UpcomingMatchCardContent({required this.match});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              width: 6.r,
              height: 6.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.secondary,
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              'UPCOMING',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withAlpha(170),
                fontSize: AppTextStyles.sizeTiny.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
            const Spacer(),
            Text(
              match.dateLabel,
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: AppTextStyles.sizeCaption.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        Row(
          children: [
            Expanded(child: _UpcomingTeamColumn(team: match.homeTeam)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                match.startTimeLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: AppTextStyles.sizeBodyLarge.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Expanded(child: _UpcomingTeamColumn(team: match.awayTeam)),
          ],
        ),
        SizedBox(height: 12.h),
        Divider(
          height: 1.h,
          thickness: 1.h,
          color: theme.dividerColor.withAlpha(90),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: Text(
                match.leagueLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withAlpha(140),
                  fontSize: AppTextStyles.sizeTiny.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              'Upcoming',
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: AppTextStyles.sizeTiny.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _UpcomingTeamColumn extends StatelessWidget {
  final MatchesTeamUiModel team;

  const _UpcomingTeamColumn({required this.team});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        _TeamLogo(team: team, size: 30.r),
        SizedBox(height: 6.h),
        Text(
          team.shortName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: AppTextStyles.sizeBodySmall.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _LiveTeamScoreRow extends StatelessWidget {
  final MatchesTeamUiModel team;
  final int? score;

  const _LiveTeamScoreRow({required this.team, required this.score});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        _TeamLogo(team: team, size: 22.r),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            team.teamName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: AppTextStyles.sizeBodySmall.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          score == null ? '-' : '$score',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: AppTextStyles.sizeBodySmall.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

Color _textColorForBadge(Color color) {
  final brightness = ThemeData.estimateBrightnessForColor(color);
  return brightness == Brightness.dark ? Colors.white : Colors.black;
}

class _TeamLogo extends StatelessWidget {
  final MatchesTeamUiModel team;
  final double size;

  const _TeamLogo({required this.team, required this.size});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badgeColor = _colorFromHex(team.badgeHex, theme.colorScheme.primary);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: badgeColor.withAlpha(220),
        border: Border.all(
          color: theme.dividerColor.withAlpha(100),
          width: 1.w,
        ),
      ),
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      child: _RemoteLogo(
        imageUrl: team.logoUrl,
        fallbackText: team.shortName,
        size: size * 0.72,
        fallbackColor: badgeColor,
        textColor: _textColorForBadge(badgeColor),
      ),
    );
  }
}

class _RemoteLogo extends StatelessWidget {
  final String? imageUrl;
  final String fallbackText;
  final double size;
  final Color fallbackColor;
  final Color textColor;

  const _RemoteLogo({
    required this.imageUrl,
    required this.fallbackText,
    required this.size,
    required this.fallbackColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final safeFallback = fallbackText.length > 3
        ? fallbackText.substring(0, 3)
        : fallbackText;

    final url = imageUrl?.trim();
    if (url == null || url.isEmpty) {
      return _LogoFallback(
        text: safeFallback,
        size: size,
        color: fallbackColor,
        textColor: textColor,
      );
    }

    return Image.network(
      url,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) {
        return _LogoFallback(
          text: safeFallback,
          size: size,
          color: fallbackColor,
          textColor: textColor,
        );
      },
    );
  }
}

class _LogoFallback extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final Color textColor;

  const _LogoFallback({
    required this.text,
    required this.size,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: textColor,
            fontSize: AppTextStyles.sizeTiny.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _LiveTeamVertical extends StatelessWidget {
  final MatchesTeamUiModel team;

  const _LiveTeamVertical({required this.team});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        _TeamLogo(team: team, size: 34.r),
        SizedBox(height: 6.h),
        Text(
          team.teamName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: AppTextStyles.sizeBodySmall.sp,
            fontWeight: FontWeight.w800,
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

class _FootballTimelineContent extends StatelessWidget {
  final MatchesViewModel state;
  final List<MatchesLeagueUiModel> leagues;
  final ValueChanged<String> onLeagueToggle;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onClearFilter;
  final Future<void> Function() onRefresh;
  final VoidCallback onLoadMoreLeagues;
  final VoidCallback onLoadMoreLiveMatches;

  const _FootballTimelineContent({
    required this.state,
    required this.leagues,
    required this.onLeagueToggle,
    required this.onDateSelected,
    required this.onClearFilter,
    required this.onRefresh,
    required this.onLoadMoreLeagues,
    required this.onLoadMoreLiveMatches,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedDate = _parseDayDate(state.selectedDay?.dayId);
    final showInitialSkeleton = state.isLoading && state.schedule == null;
    final displayMatches = showInitialSkeleton
        ? _skeletonLiveMatches()
        : state.liveMatches ?? const <MatchesLiveMatchUiModel>[];
    final displayLeagues = showInitialSkeleton ? _skeletonLeagues() : leagues;

    if (state.errorCode != null &&
        state.schedule == null &&
        !showInitialSkeleton) {
      return RefreshIndicator(
        color: theme.colorScheme.secondary,
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 90.h, 16.w, 22.h),
          children: [
            Text(
              'Unable to load matches. Pull down to try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withAlpha(170),
                fontSize: AppTextStyles.sizeBody.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: theme.colorScheme.secondary,
      onRefresh: onRefresh,
      child: Skeletonizer(
        enabled: showInitialSkeleton,
        effect: _solidSkeletonEffect(theme),
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.pixels >=
                notification.metrics.maxScrollExtent - 260.h) {
              onLoadMoreLeagues();
            }
            return false;
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 22.h),
            children: [
              _LiveNowSection(
                matches: displayMatches,
                title: showInitialSkeleton ? 'Live Now' : state.liveSectionTitle,
                isRefreshing: !showInitialSkeleton && state.isLiveMatchesRefreshing,
                canLoadMore: !showInitialSkeleton && state.canLoadMoreLiveMatches,
                isLoadingMore: !showInitialSkeleton && state.isLoadingMoreLiveMatches,
                onLoadMore: onLoadMoreLiveMatches,
              ),
              SizedBox(height: 16.h),

              Row(
                children: [
                  Text(
                    'Matches by leagues',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: AppTextStyles.sizeHeading.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    state.selectedDay?.displayDate ?? 'Filter by date',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withAlpha(170),
                      fontSize: AppTextStyles.sizeTiny.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16.r),
                      onTap: showInitialSkeleton
                          ? null
                          : () => _openDatePicker(context, selectedDate),
                      onLongPress: state.selectedDay == null
                          ? null
                          : onClearFilter,
                      child: Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Icon(
                          Icons.filter_list,
                          size: 18.r,
                          color: state.selectedDay == null
                              ? theme.colorScheme.onSurface.withAlpha(170)
                              : theme.colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),

              if (state.isLeagueListLoading && !showInitialSkeleton)
                Skeletonizer(
                  enabled: true,
                  effect: _solidSkeletonEffect(theme),
                  child: Column(
                    children: _skeletonLeagues()
                        .map(
                          (league) => _LeagueSection(
                            league: league,
                            isExpanded: true,
                            expandable: false,
                            onToggle: null,
                          ),
                        )
                        .toList(growable: false),
                  ),
                )
              else if (displayLeagues.isEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 40.h),
                  child: Text(
                    _emptyText(state.selectedDay?.dayLabelCode),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withAlpha(120),
                      fontSize: AppTextStyles.sizeHero.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.08,
                    ),
                  ),
                )
              else
                for (final league in displayLeagues)
                  _LeagueSection(
                    league: league,
                    isExpanded: showInitialSkeleton
                        ? true
                        : state.expandedLeagueIds.contains(league.leagueId),
                    expandable: !showInitialSkeleton,
                    onToggle: showInitialSkeleton
                        ? null
                        : () => onLeagueToggle(league.leagueId),
                  ),

              if (state.isLoadingMoreLeagues && !showInitialSkeleton)
                Skeletonizer(
                  enabled: true,
                  effect: _solidSkeletonEffect(theme),
                  child: Column(
                    children: _skeletonLeagues()
                        .take(1)
                        .map(
                          (league) => _LeagueSection(
                            league: league,
                            isExpanded: true,
                            expandable: false,
                            onToggle: null,
                          ),
                        )
                        .toList(growable: false),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<MatchesLiveMatchUiModel> _skeletonLiveMatches() {
    final home = const MatchesTeamUiModel(
      teamId: 'home',
      teamName: 'Home Team',
      shortName: 'HOM',
      badgeHex: '#2A4FB4',
    );
    final away = const MatchesTeamUiModel(
      teamId: 'away',
      teamName: 'Away Team',
      shortName: 'AWY',
      badgeHex: '#0D8662',
    );

    return List<MatchesLiveMatchUiModel>.generate(
      3,
      (index) => MatchesLiveMatchUiModel(
        matchId: 'skeleton_$index',
        homeTeam: home,
        awayTeam: away,
        homeScore: 0,
        awayScore: 0,
        minuteLabel: "45'",
        statusLabel: 'LIVE',
        leagueLabel: 'League',
      ),
    );
  }

  List<MatchesLeagueUiModel> _skeletonLeagues() {
    final home = const MatchesTeamUiModel(
      teamId: 'home',
      teamName: 'Home Team',
      shortName: 'HOM',
      badgeHex: '#2A4FB4',
    );
    final away = const MatchesTeamUiModel(
      teamId: 'away',
      teamName: 'Away Team',
      shortName: 'AWY',
      badgeHex: '#0D8662',
    );
    final fixtures = List<MatchesFixtureUiModel>.generate(
      2,
      (index) => MatchesFixtureUiModel(
        fixtureId: 'skeleton_fixture_$index',
        homeTeam: home,
        awayTeam: away,
        homeScore: index,
        awayScore: index,
        statusCode: MatchesFixtureStatusCodes.live,
        statusLabel: 'LIVE',
        statusDetail: "45'",
        kickoffOrder: index,
        visibleInOngoing: true,
      ),
    );

    return List<MatchesLeagueUiModel>.generate(
      3,
      (index) => MatchesLeagueUiModel(
        leagueId: 'skeleton_league_$index',
        leagueName: 'League Name',
        stageName: 'Regular Season',
        badgeSeed: 'LG',
        fixtureCount: fixtures.length,
        fixtures: fixtures,
      ),
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

  Future<void> _openDatePicker(
    BuildContext context,
    DateTime? currentDate,
  ) async {
    final theme = Theme.of(context);
    final initialDate = currentDate ?? DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        final colorScheme = theme.colorScheme;
        return Theme(
          data: theme.copyWith(
            colorScheme: colorScheme.copyWith(
              primary: colorScheme.secondary,
              onPrimary: colorScheme.onSecondary,
              surface: colorScheme.surface,
              onSurface: colorScheme.onSurface,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (picked == null) return;

    onDateSelected(_normalizedDate(picked));
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
          decoration: !isExpanded
              ? BoxDecoration(
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
                )
              : null,
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              _LeagueBadge(
                leagueId: league.leagueId,
                badgeSeed: league.badgeSeed,
                logoUrl: league.logoUrl,
              ),
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
              if (!isExpanded)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
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
  final String leagueId;
  final String badgeSeed;
  final String? logoUrl;

  const _LeagueBadge({
    required this.leagueId,
    required this.badgeSeed,
    required this.logoUrl,
  });

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
      clipBehavior: Clip.antiAlias,
      child: _RemoteLogo(
        imageUrl: logoUrl,
        fallbackText: badgeSeed,
        size: 25.r,
        fallbackColor: theme.colorScheme.onSurface.withAlpha(190),
        textColor: theme.colorScheme.onSurface.withAlpha(190),
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
    final isUpcoming = fixture.statusCode == MatchesFixtureStatusCodes.upcoming;
    final accentColor = fixture.isLive || isUpcoming
        ? theme.colorScheme.secondary
        : theme.colorScheme.onSurface.withAlpha(120);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22.r),
        onTap: () {
          final scenario = fixture.isLive
              ? 'live'
              : isUpcoming
              ? 'upcoming'
              : 'finished';

          Get.toNamed(
            AppRoutes.matchDetails,
            arguments: <String, dynamic>{
              'scenario': scenario,
              'fixtureId': fixture.fixtureId,
              'homeTeamId': fixture.homeTeam.teamId,
              'awayTeamId': fixture.awayTeam.teamId,
              'homeTeamName': fixture.homeTeam.teamName,
              'awayTeamName': fixture.awayTeam.teamName,
            },
          );
        },
        child: Container(
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
        ),
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

    return Row(
      children: [
        _TeamLogo(team: team, size: 20.r),
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
