import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/widgets/ads/admob_native_ad.dart';
import '../league_details_controller.dart';
import 'package:fotgram/core/widgets/app_cached_network_image.dart';

class LeagueDetailsTeamStatsPage extends GetView<LeagueDetailsController> {
  const LeagueDetailsTeamStatsPage({super.key});

  static const List<_TeamStatsCategoryData>
  _categories = <_TeamStatsCategoryData>[
    _TeamStatsCategoryData(
      title: 'Top Stats',
      availableFilters: <String>[
        'Goals per Match',
        'Goals Conceded per Match',
        'Clean Sheets',
        'Wins',
        'Failed to Score',
        'Average possession',
        'Attendance',
      ],
      cards: <_TeamStatsCardData>[
        _TeamStatsCardData(
          title: 'Goals per Match',
          filterLabel: 'Goals per Match',
        ),
        _TeamStatsCardData(
          title: 'Goals Conceded per Match',
          filterLabel: 'Goals Conceded per Match',
        ),
        _TeamStatsCardData(title: 'Clean Sheets', filterLabel: 'Clean Sheets'),
        _TeamStatsCardData(title: 'Wins', filterLabel: 'Wins'),
        _TeamStatsCardData(
          title: 'Failed to Score',
          filterLabel: 'Failed to Score',
        ),
        _TeamStatsCardData(
          title: 'Average possession',
          filterLabel: 'Average possession',
        ),
        _TeamStatsCardData(title: 'Attendance', filterLabel: 'Attendance'),
      ],
    ),
    _TeamStatsCategoryData(
      title: 'Attack',
      availableFilters: <String>[
        'Shot Attempts',
        'Shots on Target',
        'Key Passes',
        'Penalty Scored',
        'Penalty Missed',
        'Big chances',
        'Big chances missed',
        'Accurate passes per match',
        'Accurate long balls per match',
        'Accurate crosses per match',
        'Penalties awarded',
        'Touches in opposition box',
        'Corners',
        'Set piece goals',
      ],
      cards: <_TeamStatsCardData>[
        _TeamStatsCardData(
          title: 'Shot Attempts',
          filterLabel: 'Shot Attempts',
        ),
        _TeamStatsCardData(
          title: 'Shots on Target',
          filterLabel: 'Shots on Target',
        ),
        _TeamStatsCardData(title: 'Key Passes', filterLabel: 'Key Passes'),
        _TeamStatsCardData(
          title: 'Penalty Scored',
          filterLabel: 'Penalty Scored',
        ),
        _TeamStatsCardData(
          title: 'Penalty Missed',
          filterLabel: 'Penalty Missed',
        ),
        _TeamStatsCardData(title: 'Big chances', filterLabel: 'Big chances'),
        _TeamStatsCardData(
          title: 'Big chances missed',
          filterLabel: 'Big chances missed',
        ),
        _TeamStatsCardData(
          title: 'Accurate passes per match',
          filterLabel: 'Accurate passes per match',
        ),
        _TeamStatsCardData(
          title: 'Penalties awarded',
          filterLabel: 'Penalties awarded',
        ),
        _TeamStatsCardData(title: 'Corners', filterLabel: 'Corners'),
      ],
    ),
    _TeamStatsCategoryData(
      title: 'Defense',
      availableFilters: <String>[
        'Tackles',
        'Interceptions',
        'Blocks',
        'Saves',
        'Goals Conceded',
        'Interceptions per match',
        'Tackles per match',
        'Clearances per match',
        'Possession won final 3rd per match',
        'Set piece goals conceded',
        'Penalties conceded',
        'Saves per match',
      ],
      cards: <_TeamStatsCardData>[
        _TeamStatsCardData(title: 'Tackles', filterLabel: 'Tackles'),
        _TeamStatsCardData(
          title: 'Interceptions',
          filterLabel: 'Interceptions',
        ),
        _TeamStatsCardData(title: 'Blocks', filterLabel: 'Blocks'),
        _TeamStatsCardData(title: 'Saves', filterLabel: 'Saves'),
        _TeamStatsCardData(
          title: 'Goals Conceded',
          filterLabel: 'Goals Conceded',
        ),
        _TeamStatsCardData(
          title: 'Clearances per match',
          filterLabel: 'Clearances per match',
        ),
        _TeamStatsCardData(
          title: 'Penalties conceded',
          filterLabel: 'Penalties conceded',
        ),
      ],
    ),
    _TeamStatsCategoryData(
      title: 'Discipline',
      availableFilters: <String>[
        'Yellow Cards',
        'Red Cards',
        'Fouls Committed',
        'Fouls Drawn',
        'Fouls per match',
      ],
      cards: <_TeamStatsCardData>[
        _TeamStatsCardData(title: 'Yellow Cards', filterLabel: 'Yellow Cards'),
        _TeamStatsCardData(title: 'Red Cards', filterLabel: 'Red Cards'),
        _TeamStatsCardData(
          title: 'Fouls Committed',
          filterLabel: 'Fouls Committed',
        ),
        _TeamStatsCardData(title: 'Fouls Drawn', filterLabel: 'Fouls Drawn'),
        _TeamStatsCardData(
          title: 'Fouls per match',
          filterLabel: 'Fouls per match',
        ),
      ],
    ),
  ];

  static final List<_FilterSectionData> _allFilterSections = _categories
      .map(
        (category) => _FilterSectionData(
          title: category.title,
          options: category.availableFilters,
        ),
      )
      .toList(growable: false);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state.value;
      if (controller.isTeamStatsTabActive &&
          !state.hasLoadedTeamStats &&
          !state.isTeamStatsLoading &&
          !state.isLoading) {
        Future.microtask(() => controller.ensureTeamStatsLoaded());
      }

      final isStatsLoading = state.isLoading || state.isTeamStatsLoading;
      final visibleCategories = <_VisibleTeamStatsCategoryData>[
        for (final category in _categories)
          _VisibleTeamStatsCategoryData(
            title: category.title,
            cards: _visibleTeamStatsCardsFor(
              category,
              showAll: isStatsLoading,
            ),
          ),
      ].where((category) => category.cards.isNotEmpty).toList(growable: false);

      return Skeletonizer(
        enabled: isStatsLoading,
        effect: _solidSkeletonEffect(Theme.of(context)),
        child: RefreshIndicator(
          onRefresh: () => controller.ensureTeamStatsLoaded(force: true),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 28.h),
            children: [
              if (!isStatsLoading && visibleCategories.isEmpty)
                const _NoRowsMessage(
                  message: 'No team stats found for this league season.',
                )
              else
                for (
                  var categoryIndex = 0;
                  categoryIndex < visibleCategories.length;
                  categoryIndex++
                ) ...[
                  _StatsSectionTitle(
                    title: visibleCategories[categoryIndex].title,
                  ),
                  SizedBox(height: 14.h),
                  for (
                    var cardIndex = 0;
                    cardIndex < visibleCategories[categoryIndex].cards.length;
                    cardIndex++
                  ) ...[
                    _TeamStatsCard(
                      data: visibleCategories[categoryIndex].cards[cardIndex],
                      filterSections: _allFilterSections,
                    ),
                    if (cardIndex !=
                        visibleCategories[categoryIndex].cards.length - 1)
                      SizedBox(height: 12.h),
                  ],
                  if (!isStatsLoading)
                    AdMobNativeAd(
                      key: ValueKey('league_team_stats_native_ad_$categoryIndex'),
                      height: 280.h,
                      margin: EdgeInsets.only(top: 18.h),
                    ),
                  if (categoryIndex != visibleCategories.length - 1)
                    SizedBox(height: 28.h),
                ],
            ],
          ),
        ),
      );
    });
  }
}


class _VisibleTeamStatsCategoryData {
  final String title;
  final List<_TeamStatsCardData> cards;

  const _VisibleTeamStatsCategoryData({
    required this.title,
    required this.cards,
  });
}

List<_TeamStatsCardData> _visibleTeamStatsCardsFor(
  _TeamStatsCategoryData category, {
  required bool showAll,
}) {
  if (showAll) {
    return category.cards;
  }

  return category.cards
      .where((card) => _teamPreviewRowsFor(card.filterLabel).isNotEmpty)
      .toList(growable: false);
}

class _TeamStatsCard extends StatelessWidget {
  final _TeamStatsCardData data;
  final List<_FilterSectionData> filterSections;

  const _TeamStatsCard({required this.data, required this.filterSections});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rows = _teamPreviewRowsFor(data.filterLabel);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22.r),
        onTap: () => _showTeamStatsDetails(
          context,
          initialFilter: data.filterLabel,
          filterSections: filterSections,
        ),
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
                          data.title,
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
                  child: rows.isEmpty
                      ? const _NoRowsMessage(message: 'No data from API yet')
                      : Column(
                          children: [
                            for (
                              var index = 0;
                              index < rows.length;
                              index++
                            ) ...[
                              _TeamStatsPreviewRow(row: rows[index]),
                              if (index != rows.length - 1)
                                SizedBox(height: 10.h),
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

Future<void> _showTeamStatsDetails(
  BuildContext context, {
  required String initialFilter,
  required List<_FilterSectionData> filterSections,
}) async {
  final theme = Theme.of(context);
  final controller = Get.find<LeagueDetailsController>();

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: theme.colorScheme.surface,
    builder: (sheetContext) {
      var selectedFilter = initialFilter;
      var isFilterMenuOpen = false;
      var isLoadingMore = false;
      var hasMoreRows = true;

      Future<void> handleLoadMore(VoidCallback rebuild) async {
        if (isLoadingMore ||
            !hasMoreRows ||
            _teamDetailRowsFor(selectedFilter).isEmpty) {
          return;
        }
        isLoadingMore = true;
        rebuild();
        final didLoadMore = await controller.loadMoreTeamStatsForFilter(
          selectedFilter,
        );
        if (!didLoadMore) {
          hasMoreRows = false;
        }
        if (!sheetContext.mounted) {
          return;
        }
        isLoadingMore = false;
        rebuild();
      }

      return StatefulBuilder(
        builder: (context, setModalState) {
          final rows = _teamDetailRowsFor(selectedFilter);

          return SafeArea(
            top: false,
            child: FractionallySizedBox(
              heightFactor: 0.84,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30.r),
                  ),
                  color: theme.colorScheme.surface,
                  border: Border.all(color: theme.dividerColor, width: 1.w),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 18.h),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: _FilledSelectChip(
                              label: selectedFilter,
                              isExpanded: isFilterMenuOpen,
                              onTap: () {
                                setModalState(() {
                                  isFilterMenuOpen = !isFilterMenuOpen;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Expanded(
                            child: NotificationListener<ScrollNotification>(
                              onNotification: (notification) {
                                if (notification.metrics.pixels >=
                                    notification.metrics.maxScrollExtent - 60) {
                                  handleLoadMore(() => setModalState(() {}));
                                }
                                return false;
                              },
                              child: _TeamStatsDetailsTable(
                                rows: rows,
                                isLoadingMore: isLoadingMore,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (isFilterMenuOpen)
                        Positioned.fill(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              setModalState(() => isFilterMenuOpen = false);
                            },
                          ),
                        ),
                      if (isFilterMenuOpen)
                        Positioned(
                          top: 50.h,
                          left: 0,
                          child: _TeamStatsFilterMenu(
                            sections: filterSections,
                            selectedValue: selectedFilter,
                            onSelected: (value) {
                              setModalState(() {
                                selectedFilter = value;
                                hasMoreRows = true;
                                isFilterMenuOpen = false;
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

class _TeamStatsDetailsTable extends StatelessWidget {
  final List<_TeamDetailRowData> rows;
  final bool isLoadingMore;

  const _TeamStatsDetailsTable({
    required this.rows,
    required this.isLoadingMore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor.withAlpha(90), width: 1.w),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Column(
          children: [
            Container(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              color: Colors.white.withAlpha(8),
              child: Row(
                children: [
                  SizedBox(
                    width: 24.w,
                    child: Text('#', style: _detailHeaderStyle(theme)),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text('TEAM', style: _detailHeaderStyle(theme)),
                  ),
                  Text('STATS', style: _detailHeaderStyle(theme)),
                ],
              ),
            ),
            Expanded(
              child: rows.isEmpty && !isLoadingMore
                  ? const _NoRowsMessage(
                      message: 'No data found for this stat yet',
                    )
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
                      itemCount: rows.length + (isLoadingMore ? 10 : 0),
                      separatorBuilder: (_, __) => Padding(
                        padding: EdgeInsets.only(left: 60.w),
                        child: Container(
                          height: 1.h,
                          color: theme.dividerColor.withAlpha(70),
                        ),
                      ),
                      itemBuilder: (context, index) {
                        if (index >= rows.length) {
                          return const _TeamStatsSkeletonRow();
                        }

                        final row = rows[index];

                        return SizedBox(
                          height: 74.h,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 24.w,
                                child: Text(
                                  row.rank,
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface
                                        .withAlpha(150),
                                    fontSize: AppTextStyles.sizeBodySmall.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              _TeamLogoCircle(
                                imageUrl: row.logoUrl,
                                size: 48.r,
                                fallbackText: row.name,
                              ),
                              SizedBox(width: 14.w),
                              Expanded(
                                child: Text(
                                  row.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface,
                                    fontSize: AppTextStyles.sizeBody.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                row.value,
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                  fontSize: AppTextStyles.sizeBody.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _detailHeaderStyle(ThemeData theme) {
    return TextStyle(
      color: theme.colorScheme.onSurface.withAlpha(82),
      fontSize: AppTextStyles.sizeOverline.sp,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.2,
    );
  }
}

class _TeamStatsSkeletonRow extends StatelessWidget {
  const _TeamStatsSkeletonRow();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Skeletonizer(
      enabled: true,
      effect: _solidSkeletonEffect(theme),
      child: SizedBox(
        height: 74.h,
        child: Row(
          children: [
            SizedBox(
              width: 24.w,
              child: Text(
                '00',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withAlpha(150),
                  fontSize: AppTextStyles.sizeBodySmall.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.onSurface.withAlpha(44),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                'Team Name',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: AppTextStyles.sizeBody.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              '000',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: AppTextStyles.sizeBody.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamStatsPreviewRow extends StatelessWidget {
  final _TeamPreviewRowData row;

  const _TeamStatsPreviewRow({required this.row});

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
          SizedBox(
            width: 24.w,
            child: Text(
              row.rank,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withAlpha(132),
                fontSize: AppTextStyles.sizeBodySmall.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 2.w),
          _TeamLogoCircle(
            imageUrl: row.logoUrl,
            size: 40.r,
            fallbackText: row.name,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              row.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: AppTextStyles.sizeBody.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            row.value,
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

class _TeamLogoCircle extends StatelessWidget {
  final String imageUrl;
  final String fallbackText;
  final double size;

  const _TeamLogoCircle({
    required this.imageUrl,
    required this.fallbackText,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initial = fallbackText.trim().isEmpty
        ? ''
        : fallbackText.trim().substring(0, 1).toUpperCase();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.surface,
        // border: Border.all(
        //   color: theme.colorScheme.secondary.withAlpha(220),
        //   width: 1.w,
        // ),
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: imageUrl.trim().isEmpty
          ? initial.isEmpty
                ? Icon(
                    Icons.shield_rounded,
                    size: size * 0.54,
                    color: theme.colorScheme.secondary,
                  )
                : Text(
                    initial,
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: (size * 0.34).sp,
                      fontWeight: FontWeight.w800,
                    ),
                  )
          : AppCachedNetworkImage(
  imageUrl: imageUrl,
  width: size * 0.72,
  height: size * 0.72,
  fit: BoxFit.contain,
  errorBuilder: (context) => initial.isEmpty
                  ? Icon(
                      Icons.shield_rounded,
                      size: size * 0.54,
                      color: theme.colorScheme.secondary,
                    )
                  : Text(
                      initial,
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontSize: (size * 0.34).sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
),
    );
  }
}

class _FilledSelectChip extends StatelessWidget {
  final String label;
  final bool isExpanded;
  final VoidCallback onTap;

  const _FilledSelectChip({
    required this.label,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.r),
        onTap: onTap,
        child: Container(
          height: 40.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: const Color(0xFF0F8C63),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppTextStyles.sizeBodySmall.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              AnimatedRotation(
                turns: isExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 180),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18.r,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TeamStatsFilterMenu extends StatelessWidget {
  final List<_FilterSectionData> sections;
  final String selectedValue;
  final ValueChanged<String> onSelected;

  const _TeamStatsFilterMenu({
    required this.sections,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 255.w,
        constraints: BoxConstraints(maxHeight: 520.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: const Color(0xFF0F8C63),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 12.h),
            shrinkWrap: true,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedValue,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppTextStyles.sizeBodySmall.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18.r,
                    color: Colors.white,
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              for (
                var sectionIndex = 0;
                sectionIndex < sections.length;
                sectionIndex++
              ) ...[
                if (sectionIndex != 0) SizedBox(height: 14.h),
                if (sectionIndex != 0)
                  Text(
                    sections[sectionIndex].title,
                    style: TextStyle(
                      color: Colors.white.withAlpha(215),
                      fontSize: AppTextStyles.sizeBodySmall.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                if (sectionIndex != 0) SizedBox(height: 8.h),
                for (final option in sections[sectionIndex].options)
                  Padding(
                    padding: EdgeInsets.only(bottom: 6.h),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8.r),
                        onTap: () => onSelected(option),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          child: Text(
                            option,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppTextStyles.sizeBody.sp,
                              fontWeight: option == selectedValue
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsSectionTitle extends StatelessWidget {
  final String title;

  const _StatsSectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: TextStyle(
        color: theme.colorScheme.onSurface,
        fontSize: AppTextStyles.sizeBodyLarge.sp,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _NoRowsMessage extends StatelessWidget {
  final String message;

  const _NoRowsMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 10.w),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: theme.colorScheme.onSurface.withAlpha(140),
            fontSize: AppTextStyles.sizeBodySmall.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _TeamStatsCategoryData {
  final String title;
  final List<String> availableFilters;
  final List<_TeamStatsCardData> cards;

  const _TeamStatsCategoryData({
    required this.title,
    required this.availableFilters,
    required this.cards,
  });
}

class _TeamStatsCardData {
  final String title;
  final String filterLabel;

  const _TeamStatsCardData({required this.title, required this.filterLabel});
}

class _FilterSectionData {
  final String title;
  final List<String> options;

  const _FilterSectionData({required this.title, required this.options});
}

class _TeamPreviewRowData {
  final String rank;
  final String name;
  final String value;
  final String logoUrl;

  const _TeamPreviewRowData({
    required this.rank,
    required this.name,
    required this.value,
    required this.logoUrl,
  });
}

class _TeamDetailRowData {
  final String rank;
  final String name;
  final String value;
  final String logoUrl;

  const _TeamDetailRowData({
    required this.rank,
    required this.name,
    required this.value,
    required this.logoUrl,
  });
}

List<_TeamPreviewRowData> _teamPreviewRowsFor(String filterLabel) {
  final rows = LeagueDetailsController.teamStatsRowsFor(
    filterLabel,
  ).take(3).toList(growable: false);
  return rows
      .map(
        (row) => _TeamPreviewRowData(
          rank: row.rank,
          name: row.teamName.isEmpty ? row.name : row.teamName,
          value: row.value,
          logoUrl: row.teamLogoUrl,
        ),
      )
      .toList(growable: false);
}

List<_TeamDetailRowData> _teamDetailRowsFor(String filterLabel) {
  final rows = LeagueDetailsController.teamStatsRowsFor(filterLabel);
  return rows
      .map(
        (row) => _TeamDetailRowData(
          rank: row.rank.replaceAll('.', ''),
          name: row.teamName.isEmpty ? row.name : row.teamName,
          value: row.value,
          logoUrl: row.teamLogoUrl,
        ),
      )
      .toList(growable: false);
}

ShimmerEffect _solidSkeletonEffect(ThemeData theme) {
  final color = theme.colorScheme.onSurface.withAlpha(
    theme.brightness == Brightness.dark ? 28 : 18,
  );
  return ShimmerEffect(baseColor: color, highlightColor: color);
}
