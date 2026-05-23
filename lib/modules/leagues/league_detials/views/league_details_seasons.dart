import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/themes/app_text_styles.dart';
import '../models/league_detials_model.dart';
import '../league_details_controller.dart';
import 'package:fotgram/core/widgets/app_cached_network_image.dart';

class LeagueDetailsSeasonsPage extends GetView<LeagueDetailsController> {
  const LeagueDetailsSeasonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state.value;
      final theme = Theme.of(context);

      if (controller.isWorldCup) {
        final history =
            state.isSeasonHistoryLoading && state.seasonHistory.isEmpty
            ? _skeletonSeasonHistory()
            : state.seasonHistory;

        return Skeletonizer(
          enabled: state.isSeasonHistoryLoading && state.seasonHistory.isEmpty,
          effect: _solidSkeletonEffect(theme),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 28.h),
            children: [
              Text(
                'Completed Seasons',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: AppTextStyles.sizeBodyLarge.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 14.h),
              if (!state.isSeasonHistoryLoading && history.isEmpty)
                Text(
                  'No completed season history found.',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withAlpha(150),
                    fontSize: AppTextStyles.sizeBody.sp,
                    fontWeight: FontWeight.w600,
                  ),
                )
              else
                for (var index = 0; index < history.length; index++) ...[
                  _WorldCupSeasonHistoryCard(history: history[index]),
                  if (index != history.length - 1) SizedBox(height: 12.h),
                ],
            ],
          ),
        );
      }

      final seasons = state.isLoading && state.seasons.isEmpty
          ? const <String>['2026', '2025', '2024', '2023']
          : state.seasons;

      return Skeletonizer(
        enabled: state.isLoading,
        effect: _solidSkeletonEffect(theme),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 28.h),
          children: [
            Text(
              'All Seasons',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: AppTextStyles.sizeBodyLarge.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 14.h),
            if (!state.isLoading && seasons.isEmpty)
              Text(
                'No seasons found for this league.',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withAlpha(150),
                  fontSize: AppTextStyles.sizeBody.sp,
                  fontWeight: FontWeight.w600,
                ),
              )
            else
              for (var index = 0; index < seasons.length; index++) ...[
                _SeasonCard(
                  label: _seasonLabelWithVenue(seasons[index]),
                  onTap: () => controller.selectSeason(seasons[index]),
                ),
                if (index != seasons.length - 1) SizedBox(height: 12.h),
              ],
          ],
        ),
      );
    });
  }
}

class _WorldCupSeasonHistoryCard extends StatelessWidget {
  final LeagueDetailsSeasonHistoryUiModel history;

  const _WorldCupSeasonHistoryCard({required this.history});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.dividerColor.withAlpha(110),
          width: 1.w,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.r),
        child: Column(
          children: [
            Container(
              height: 42.h,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              color: Colors.white.withAlpha(10),
              alignment: Alignment.centerLeft,
              child: Text(
                history.season,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: AppTextStyles.sizeBodySmall.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
              child: Column(
                children: [
                  _SeasonTeamResultRow(
                    team: history.winner,
                    resultLabel: 'Winner',
                  ),
                  SizedBox(height: 10.h),
                  _SeasonTeamResultRow(
                    team: history.runnerUp,
                    resultLabel: 'Runner-Up',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SeasonTeamResultRow extends StatelessWidget {
  final LeagueDetailsSeasonTeamUiModel team;
  final String resultLabel;

  const _SeasonTeamResultRow({required this.team, required this.resultLabel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 62.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: Colors.white.withAlpha(7),
      ),
      child: Row(
        children: [
          _TeamLogoCircle(team: team),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  team.name.isEmpty ? 'Unknown' : team.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: AppTextStyles.sizeBody.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  resultLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withAlpha(120),
                    fontSize: AppTextStyles.sizeBodySmall.sp,
                    fontWeight: FontWeight.w500,
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

class _TeamLogoCircle extends StatelessWidget {
  final LeagueDetailsSeasonTeamUiModel team;

  const _TeamLogoCircle({required this.team});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logo = team.logoUrl.trim();

    return Container(
      width: 40.r,
      height: 40.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // border: Border.all(
        //   color: theme.colorScheme.secondary.withAlpha(220),
        //   width: 1.w,
        // ),
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: logo.isEmpty
          ? Text(
              _seedFromName(team.name),
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: AppTextStyles.sizeCaption.sp,
                fontWeight: FontWeight.w800,
              ),
            )
          : AppCachedNetworkImage(
  imageUrl: logo,
  width: 28.r,
  height: 28.r,
  fit: BoxFit.cover,
  errorBuilder: (context) => Text(
                _seedFromName(team.name),
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: AppTextStyles.sizeCaption.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
),
    );
  }
}

class _SeasonCard extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SeasonCard({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rows = _seasonRowsFor(label);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22.r),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.r),
            color: theme.colorScheme.surface,
            border: Border.all(
              color: theme.dividerColor.withAlpha(110),
              width: 1.w,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22.r),
            child: Column(
              children: [
                Container(
                  height: 42.h,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  color: Colors.white.withAlpha(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: AppTextStyles.sizeBodySmall.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 18.r,
                        color: theme.colorScheme.onSurface,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
                  child: Column(
                    children: [
                      for (var index = 0; index < rows.length; index++) ...[
                        _SeasonResultRow(row: rows[index]),
                        if (index != rows.length - 1) SizedBox(height: 10.h),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SeasonResultRow extends StatelessWidget {
  final _SeasonResultRowData row;

  const _SeasonResultRow({required this.row});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 62.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: Colors.white.withAlpha(7),
      ),
      child: Row(
        children: [
          Container(
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
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.country,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: AppTextStyles.sizeBody.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  row.resultLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withAlpha(120),
                    fontSize: AppTextStyles.sizeBodySmall.sp,
                    fontWeight: FontWeight.w500,
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

class _SeasonResultRowData {
  final String country;
  final String resultLabel;

  const _SeasonResultRowData({
    required this.country,
    required this.resultLabel,
  });
}

const Map<String, String> _worldCupVenueBySeason = <String, String>{
  '2026': 'Mexico',
  '2022': 'Qatar',
  '2018': 'Russia',
  '2014': 'Brazil',
  '2010': 'South Africa',
  '2006': 'Germany',
  '2002': 'Japan/South Korea',
};

String _seasonLabelWithVenue(String season) {
  final venue = _worldCupVenueBySeason[season];

  if (venue == null) {
    return season;
  }

  return '$season $venue';
}

List<_SeasonResultRowData> _seasonRowsFor(String _) {
  return const <_SeasonResultRowData>[
    _SeasonResultRowData(country: 'Country name', resultLabel: 'Winner'),
    _SeasonResultRowData(country: 'Country name', resultLabel: 'Runner-Up'),
  ];
}

List<LeagueDetailsSeasonHistoryUiModel> _skeletonSeasonHistory() {
  return const <LeagueDetailsSeasonHistoryUiModel>[
    LeagueDetailsSeasonHistoryUiModel(
      season: '2022',
      winner: LeagueDetailsSeasonTeamUiModel(name: 'Winner team'),
      runnerUp: LeagueDetailsSeasonTeamUiModel(name: 'Runner-up team'),
    ),
    LeagueDetailsSeasonHistoryUiModel(
      season: '2018',
      winner: LeagueDetailsSeasonTeamUiModel(name: 'Winner team'),
      runnerUp: LeagueDetailsSeasonTeamUiModel(name: 'Runner-up team'),
    ),
    LeagueDetailsSeasonHistoryUiModel(
      season: '2014',
      winner: LeagueDetailsSeasonTeamUiModel(name: 'Winner team'),
      runnerUp: LeagueDetailsSeasonTeamUiModel(name: 'Runner-up team'),
    ),
  ];
}

String _seedFromName(String name) {
  final normalized = name.trim();
  if (normalized.isEmpty) {
    return 'T';
  }
  final parts = normalized
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList(growable: false);
  if (parts.length == 1) {
    return parts.first
        .substring(0, parts.first.length < 2 ? 1 : 2)
        .toUpperCase();
  }
  return parts.take(2).map((part) => part[0].toUpperCase()).join();
}

ShimmerEffect _solidSkeletonEffect(ThemeData theme) {
  final color = theme.colorScheme.onSurface.withAlpha(
    theme.brightness == Brightness.dark ? 28 : 18,
  );
  return ShimmerEffect(baseColor: color, highlightColor: color);
}
