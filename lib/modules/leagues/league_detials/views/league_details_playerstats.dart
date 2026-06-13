import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/widgets/app_cached_network_image.dart';
import '../../../../core/widgets/facebook_native_ad_widget.dart';
import '../league_details_controller.dart';

class LeagueDetailsPlayerStatsPage extends GetView<LeagueDetailsController> {
  const LeagueDetailsPlayerStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = LeagueDetailsController.playerStatsCategories;

    return Obx(() {
      final state = controller.state.value;
      if (controller.isPlayerStatsTabActive &&
          !state.hasLoadedPlayerStats &&
          !state.isPlayerStatsLoading &&
          !state.isLoading) {
        Future.microtask(() => controller.ensurePlayerStatsLoaded());
      }
      final isStatsLoading = state.isLoading || state.isPlayerStatsLoading;
      final visibleCategories = isStatsLoading
          ? <_VisiblePlayerStatsCategoryData>[
              for (final category in categories)
                _VisiblePlayerStatsCategoryData(
                  title: category.title,
                  cards: _visibleCardsFor(category, showAll: true),
                ),
            ]
          : _visiblePlayerStatsCategoriesFromState(state);
      final filterSections = _filterSectionsFromPlayerCategories(
        visibleCategories,
      );

      return Skeletonizer(
        enabled: isStatsLoading,
        effect: _solidSkeletonEffect(Theme.of(context)),
        child: RefreshIndicator(
          onRefresh: () => controller.ensurePlayerStatsLoaded(
            force: true,
            showLoading: false,
          ),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 28.h),
            children: _buildStatsListChildren(
              visibleCategories: visibleCategories,
              filterSections: filterSections,
              isStatsLoading: isStatsLoading,
            ),
          ),
        ),
      );
    });
  }

  List<Widget> _buildStatsListChildren({
    required List<_VisiblePlayerStatsCategoryData> visibleCategories,
    required List<_FilterSectionData> filterSections,
    required bool isStatsLoading,
  }) {
    if (!isStatsLoading && visibleCategories.isEmpty) {
      return const <Widget>[
        _LeagueDetailsEmptyMessage(
          message: 'No player stats found for this league season.',
        ),
      ];
    }

    final children = <Widget>[];
    var renderedCardCount = 0;

    for (
      var categoryIndex = 0;
      categoryIndex < visibleCategories.length;
      categoryIndex++
    ) {
      final category = visibleCategories[categoryIndex];
      children.add(_StatsSectionTitle(title: category.title));
      children.add(SizedBox(height: 14.h));

      for (var cardIndex = 0; cardIndex < category.cards.length; cardIndex++) {
        children.add(
          _PlayerStatsCard(
            data: category.cards[cardIndex],
            filterSections: filterSections,
          ),
        );
        renderedCardCount++;

        final isLastCardInCategory = cardIndex == category.cards.length - 1;
        if (!isStatsLoading && renderedCardCount == 2) {
          children.add(SizedBox(height: 12.h));
          children.add(const FacebookNativeAdWidget());
          if (!isLastCardInCategory) children.add(SizedBox(height: 12.h));
        } else if (!isLastCardInCategory) {
          children.add(SizedBox(height: 12.h));
        }
      }

      if (categoryIndex != visibleCategories.length - 1) {
        children.add(SizedBox(height: 28.h));
      }
    }

    return children;
  }
}

class _VisiblePlayerStatsCategoryData {
  final String title;
  final List<LeagueDetailsPlayerStatsCardData> cards;

  const _VisiblePlayerStatsCategoryData({
    required this.title,
    required this.cards,
  });
}

List<_VisiblePlayerStatsCategoryData> _visiblePlayerStatsCategoriesFromState(
  dynamic state,
) {
  final grouped = <String, List<LeagueDetailsPlayerStatsCardData>>{};

  void addCard(String categoryTitle, String title, String filterLabel) {
    final cleanTitle = title.trim();
    final cleanFilter = filterLabel.trim();
    if (cleanTitle.isEmpty || cleanFilter.isEmpty) {
      return;
    }
    final cards = grouped.putIfAbsent(
      categoryTitle,
      () => <LeagueDetailsPlayerStatsCardData>[],
    );
    final normalized = cleanFilter.toLowerCase();
    if (cards.any((card) => card.filterLabel.toLowerCase() == normalized)) {
      return;
    }
    cards.add(
      LeagueDetailsPlayerStatsCardData(
        title: cleanTitle,
        filterLabel: cleanFilter,
      ),
    );
  }

  if (state.topScorersRows.isNotEmpty) {
    addCard('Top Stats', 'Top Scorers', 'Top scorer');
  }
  if (state.topAssistsRows.isNotEmpty) {
    addCard('Top Stats', 'Top Assists', 'Assists');
  }
  if (state.topScorersRows.isNotEmpty || state.topAssistsRows.isNotEmpty) {
    addCard('Top Stats', 'Goals + Assists', 'Goals + Assists');
  }

  for (final section in state.playerStatsSections) {
    if (section.rows.isEmpty) {
      continue;
    }
    addCard(
      _playerStatsCategoryTitle(section.category),
      section.title,
      section.title,
    );
  }

  return grouped.entries
      .where((entry) => entry.value.isNotEmpty)
      .map(
        (entry) => _VisiblePlayerStatsCategoryData(
          title: entry.key,
          cards: entry.value,
        ),
      )
      .toList(growable: false);
}

String _playerStatsCategoryTitle(String category) {
  final normalized = category.trim().toLowerCase();
  switch (normalized) {
    case 'minutes':
    case 'topstats':
    case 'top_stats':
      return 'Top Stats';
    case 'attack':
      return 'Attack';
    case 'defense':
      return 'Defense';
    case 'goalkeeping':
      return 'Goalkeeping';
    case 'discipline':
      return 'Discipline';
  }
  if (category.trim().isEmpty) {
    return 'Stats';
  }
  return category.trim();
}

List<_FilterSectionData> _filterSectionsFromPlayerCategories(
  List<_VisiblePlayerStatsCategoryData> categories,
) {
  return categories
      .map(
        (category) => _FilterSectionData(
          title: category.title,
          options: category.cards.map((card) => card.filterLabel).toList(),
        ),
      )
      .where((section) => section.options.isNotEmpty)
      .toList(growable: false);
}

List<LeagueDetailsPlayerStatsCardData> _visibleCardsFor(
  LeagueDetailsPlayerStatsCategoryData category, {
  required bool showAll,
}) {
  if (showAll) {
    return category.cards;
  }

  return category.cards
      .where(
        (card) => LeagueDetailsController.playerStatsPreviewRowsFor(
          card.filterLabel,
        ).isNotEmpty,
      )
      .toList(growable: false);
}

class _PlayerStatsCard extends StatelessWidget {
  final LeagueDetailsPlayerStatsCardData data;
  final List<_FilterSectionData> filterSections;

  const _PlayerStatsCard({required this.data, required this.filterSections});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rows = LeagueDetailsController.playerStatsPreviewRowsFor(
      data.filterLabel,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22.r),
        onTap: () => _showPlayerStatsDetails(
          context,
          initialFilter: data.filterLabel,
          filterSections: filterSections,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.r),
            color: theme.colorScheme.surface.withAlpha(255),
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
                  child: Column(
                    children: [
                      for (var index = 0; index < rows.length; index++) ...[
                        _PlayerStatsPreviewRow(row: rows[index]),
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

Future<void> _showPlayerStatsDetails(
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
            LeagueDetailsController.playerStatsDetailRowsFor(
              selectedFilter,
            ).isEmpty) {
          return;
        }
        isLoadingMore = true;
        rebuild();
        final didLoadMore = await controller.loadMorePlayerStatsForFilter(
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
          final rows = LeagueDetailsController.playerStatsDetailRowsFor(
            selectedFilter,
          );

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
                              child: _PlayerStatsDetailsTable(
                                rows: rows,
                                subtitleLabel:
                                    LeagueDetailsController.playerStatsSubtitleLabelFor(
                                      selectedFilter,
                                    ),
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
                          child: _PlayerStatsFilterMenu(
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

class _PlayerStatsDetailsTable extends StatelessWidget {
  final List<LeagueDetailsPlayerStatsDetailRowData> rows;
  final String subtitleLabel;
  final bool isLoadingMore;

  const _PlayerStatsDetailsTable({
    required this.rows,
    required this.subtitleLabel,
    required this.isLoadingMore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor, width: 1.w),
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
                    child: Text('PLAYER', style: _detailHeaderStyle(theme)),
                  ),
                  Text('STATS', style: _detailHeaderStyle(theme)),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
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
                    return _PlayerStatsSkeletonRow(
                      subtitleLabel: subtitleLabel,
                    );
                  }

                  final row = rows[index];

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Get.find<LeagueDetailsController>()
                          .openPlayerProfileById(
                            playerId: row.playerId,
                            playerName: row.name,
                            teamId: row.teamId,
                            teamName: row.teamName,
                          ),
                      child: SizedBox(
                        height: 74.h,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 24.w,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
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
                            ),
                            SizedBox(width: 12.w),
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                _CircleImage(
                                  imageUrl: row.playerImageUrl,
                                  fallbackText: row.name,
                                  size: 48.r,
                                  borderColor: theme.colorScheme.secondary,
                                ),
                                Positioned(
                                  right: -2.w,
                                  bottom: -2.h,
                                  child: _CircleImage(
                                    imageUrl: row.teamLogoUrl,
                                    fallbackText: '',
                                    size: 16.r,
                                    borderColor: theme.colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    row.name,
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
                                    '$subtitleLabel: ${row.subtitleValue}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface
                                          .withAlpha(108),
                                      fontSize: AppTextStyles.sizeBodySmall.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
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
                      ),
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

class _PlayerStatsSkeletonRow extends StatelessWidget {
  final String subtitleLabel;

  const _PlayerStatsSkeletonRow({required this.subtitleLabel});

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
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 48.r,
                  height: 48.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.onSurface.withAlpha(44),
                  ),
                ),
                Positioned(
                  right: -2.w,
                  bottom: -2.h,
                  child: Container(
                    width: 16.r,
                    height: 16.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.onSurface.withAlpha(44),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Player Name',
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
                    '$subtitleLabel: 000',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withAlpha(108),
                      fontSize: AppTextStyles.sizeBodySmall.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
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

class _PlayerStatsPreviewRow extends StatelessWidget {
  final LeagueDetailsPlayerStatsPreviewRowData row;

  const _PlayerStatsPreviewRow({required this.row});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: () => Get.find<LeagueDetailsController>().openPlayerProfileById(
          playerId: row.playerId,
          playerName: row.name,
          teamId: row.teamId,
          teamName: row.teamName,
        ),
        child: Container(
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
              _CircleImage(
                imageUrl: row.playerImageUrl,
                fallbackText: row.name,
                size: 40.r,
                borderColor: theme.colorScheme.secondary.withAlpha(220),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      row.name,
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
                      row.teamName.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withAlpha(96),
                        fontSize: AppTextStyles.sizeOverline.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
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
        ),
      ),
    );
  }
}

class _CircleImage extends StatelessWidget {
  final String imageUrl;
  final String fallbackText;
  final double size;
  final Color borderColor;

  const _CircleImage({
    required this.imageUrl,
    required this.fallbackText,
    required this.size,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fallback = fallbackText.trim().isEmpty
        ? Icons.emoji_events_rounded
        : null;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.surface,
        border: Border.all(color: borderColor, width: 1.w),
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: imageUrl.trim().isEmpty
          ? fallback == null
                ? Text(
                    fallbackText.trim().substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: (size * 0.34).sp,
                      fontWeight: FontWeight.w800,
                    ),
                  )
                : Icon(
                    fallback,
                    size: size * 0.54,
                    color: theme.colorScheme.secondary,
                  )
          : AppCachedNetworkImage(
              imageUrl: imageUrl,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (context) => fallback == null
                  ? Text(
                      fallbackText.trim().substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontSize: (size * 0.34).sp,
                        fontWeight: FontWeight.w800,
                      ),
                    )
                  : Icon(
                      fallback,
                      size: size * 0.54,
                      color: theme.colorScheme.secondary,
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
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppTextStyles.sizeBodySmall.sp,
                  fontWeight: FontWeight.w700,
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

class _PlayerStatsFilterMenu extends StatelessWidget {
  final List<_FilterSectionData> sections;
  final String selectedValue;
  final ValueChanged<String> onSelected;

  const _PlayerStatsFilterMenu({
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
        constraints: BoxConstraints(maxHeight: 540.h),
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

class _FilterSectionData {
  final String title;
  final List<String> options;

  const _FilterSectionData({required this.title, required this.options});
}

ShimmerEffect _solidSkeletonEffect(ThemeData theme) {
  final color = theme.colorScheme.onSurface.withAlpha(
    theme.brightness == Brightness.dark ? 28 : 18,
  );
  return ShimmerEffect(baseColor: color, highlightColor: color);
}

class _LeagueDetailsEmptyMessage extends StatelessWidget {
  final String message;

  const _LeagueDetailsEmptyMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(top: 80.h),
      child: Center(
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
