import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/themes/app_text_styles.dart';
import '../league_details_controller.dart';

class LeagueDetailsPlayerStatsPage extends GetView<LeagueDetailsController> {
  const LeagueDetailsPlayerStatsPage({super.key});

  static final List<_FilterSectionData> _allFilterSections =
      LeagueDetailsController.playerStatsCategories
          .map(
            (category) => _FilterSectionData(
              title: category.title,
              options: category.availableFilters,
            ),
          )
          .toList(growable: false);

  @override
  Widget build(BuildContext context) {
    final categories = LeagueDetailsController.playerStatsCategories;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 28.h),
      children: [
        for (
          var categoryIndex = 0;
          categoryIndex < categories.length;
          categoryIndex++
        ) ...[
          _StatsSectionTitle(title: categories[categoryIndex].title),
          SizedBox(height: 14.h),
          for (
            var cardIndex = 0;
            cardIndex < categories[categoryIndex].cards.length;
            cardIndex++
          ) ...[
            _PlayerStatsCard(
              data: categories[categoryIndex].cards[cardIndex],
              filterSections: _allFilterSections,
            ),
            if (cardIndex != categories[categoryIndex].cards.length - 1)
              SizedBox(height: 12.h),
          ],
          if (categoryIndex != categories.length - 1) SizedBox(height: 28.h),
        ],
      ],
    );
  }
}

class _PlayerStatsCard extends StatelessWidget {
  final LeagueDetailsPlayerStatsCardData data;
  final List<_FilterSectionData> filterSections;

  const _PlayerStatsCard({
    required this.data,
    required this.filterSections,
  });

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
            // gradient: LinearGradient(
            //   begin: Alignment.centerLeft,
            //   end: Alignment.centerRight,
            //   colors: [
            //     theme.colorScheme.surface.withAlpha(218),
            //     theme.colorScheme.surface.withAlpha(140),
            //   ],
            // ),
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

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: theme.colorScheme.surface,
    builder: (sheetContext) {
      var selectedFilter = initialFilter;
      var isFilterMenuOpen = false;

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
                  border: Border.all(
                    color: theme.dividerColor,
                    width: 1.w,
                  ),
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
                            child: _PlayerStatsDetailsTable(
                              rows: rows,
                              subtitleLabel:
                                  LeagueDetailsController.playerStatsSubtitleLabelFor(
                                selectedFilter,
                              ),
                            ),
                          ),
                          SizedBox(height: 18.h),
                          const _LoadMoreButton(),
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

  const _PlayerStatsDetailsTable({
    required this.rows,
    required this.subtitleLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.dividerColor,
          width: 1.w,
        ),
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
                itemCount: rows.length,
                separatorBuilder: (_, __) => Padding(
                  padding: EdgeInsets.only(left: 60.w),
                  child: Container(
                    height: 1.h,
                    color: theme.dividerColor.withAlpha(70),
                  ),
                ),
                itemBuilder: (context, index) {
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
                                border: Border.all(
                                  color: theme.colorScheme.secondary,
                                  width: 1.w,
                                ),
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
                                  color: theme.colorScheme.surface,
                                    border: Border.all(
                                      color: theme.colorScheme.secondary,
                                      width: 1.w,
                                    ),
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
                                  color: theme.colorScheme.onSurface.withAlpha(
                                    108,
                                  ),
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

class _PlayerStatsPreviewRow extends StatelessWidget {
  final LeagueDetailsPlayerStatsPreviewRowData row;

  const _PlayerStatsPreviewRow({required this.row});

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
            physics: const BouncingScrollPhysics(),
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
              for (var sectionIndex = 0;
                  sectionIndex < sections.length;
                  sectionIndex++) ...[
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

class _LoadMoreButton extends StatelessWidget {
  const _LoadMoreButton();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10.r),
          onTap: () {},
          child: Container(
            height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: const Color(0xFF0F8C63),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Load More',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppTextStyles.sizeBodySmall.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 6.w),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18.r,
                  color: Colors.white,
                ),
              ],
            ),
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

  const _FilterSectionData({
    required this.title,
    required this.options,
  });
}