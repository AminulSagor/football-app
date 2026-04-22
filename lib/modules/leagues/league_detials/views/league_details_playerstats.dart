import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/themes/app_text_styles.dart';
import '../league_details_controller.dart';

class LeagueDetailsPlayerStatsPage extends GetView<LeagueDetailsController> {
  const LeagueDetailsPlayerStatsPage({super.key});

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
              availableFilters: categories[categoryIndex].availableFilters,
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
  final List<String> availableFilters;

  const _PlayerStatsCard({required this.data, required this.availableFilters});

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
          availableFilters: availableFilters,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.r),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                theme.colorScheme.surface.withAlpha(210),
                theme.colorScheme.surface.withAlpha(132),
              ],
            ),
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
                  color: Colors.white.withAlpha(18),
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
                  padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
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
  required List<String> availableFilters,
}) async {
  final theme = Theme.of(context);

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      var selectedFilter = initialFilter;

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
                    top: Radius.circular(28.r),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.surface.withAlpha(228),
                      theme.colorScheme.surface.withAlpha(144),
                    ],
                  ),
                  border: Border.all(
                    color: theme.dividerColor.withAlpha(150),
                    width: 1.w,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 18.h),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _FilledSelectChip(
                          label: selectedFilter,
                          onTap: () async {
                            final selected = await _showSelectOptionsDialog(
                              context,
                              selectedValue: selectedFilter,
                              options: availableFilters,
                            );

                            if (selected == null) {
                              return;
                            }

                            setModalState(() => selectedFilter = selected);
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
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Future<String?> _showSelectOptionsDialog(
  BuildContext context, {
  required String selectedValue,
  required List<String> options,
}) {
  final theme = Theme.of(context);

  return showGeneralDialog<String>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black.withAlpha(130),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      return SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: FractionallySizedBox(
              widthFactor: 0.94,
              heightFactor: 0.82,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28.r),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.surface.withAlpha(228),
                        theme.colorScheme.surface.withAlpha(144),
                      ],
                    ),
                    border: Border.all(
                      color: theme.dividerColor.withAlpha(150),
                      width: 1.w,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28.r),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 12.h),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  selectedValue,
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface,
                                    fontSize: AppTextStyles.sizeBodyLarge.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 22.r,
                                color: theme.colorScheme.onSurface,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.fromLTRB(18.w, 0, 18.w, 18.h),
                            itemCount: options.length,
                            separatorBuilder: (_, __) => SizedBox(height: 4.h),
                            itemBuilder: (context, index) {
                              final option = options[index];
                              final isSelected = option == selectedValue;

                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(14.r),
                                  onTap: () =>
                                      Navigator.of(dialogContext).pop(option),
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 14.w,
                                      vertical: 13.h,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14.r),
                                      color: isSelected
                                          ? theme.colorScheme.secondary
                                                .withAlpha(22)
                                          : Colors.transparent,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            option,
                                            style: TextStyle(
                                              color:
                                                  theme.colorScheme.onSurface,
                                              fontSize:
                                                  AppTextStyles.sizeBody.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        if (isSelected)
                                          Icon(
                                            Icons.check_rounded,
                                            size: 18.r,
                                            color: theme.colorScheme.secondary,
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
                ),
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );

      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
          child: child,
        ),
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
        borderRadius: BorderRadius.circular(22.r),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            theme.colorScheme.surface.withAlpha(210),
            theme.colorScheme.surface.withAlpha(132),
          ],
        ),
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
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              color: Colors.white.withAlpha(18),
              child: Row(
                children: [
                  SizedBox(
                    width: 24.w,
                    child: Text('#', style: _detailHeaderStyle(theme)),
                  ),
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
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                itemCount: rows.length,
                separatorBuilder: (_, __) => Container(
                  height: 1.h,
                  color: theme.dividerColor.withAlpha(90),
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
                                  color: theme.colorScheme.secondary.withAlpha(
                                    220,
                                  ),
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
                                    color: theme.colorScheme.secondary
                                        .withAlpha(220),
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
      color: theme.colorScheme.onSurface.withAlpha(96),
      fontSize: AppTextStyles.sizeOverline.sp,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.25,
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
        color: Colors.white.withAlpha(8),
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
                    letterSpacing: 1.2,
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
  final VoidCallback onTap;

  const _FilledSelectChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Container(
          height: 36.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: theme.colorScheme.secondary.withAlpha(190),
            border: Border.all(
              color: theme.colorScheme.secondary.withAlpha(220),
              width: 1.w,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppTextStyles.sizeBodySmall.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 4.w),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white,
              ),
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
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: () {},
        child: Container(
          height: 36.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: theme.colorScheme.secondary.withAlpha(190),
            border: Border.all(
              color: theme.colorScheme.secondary.withAlpha(220),
              width: 1.w,
            ),
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
              SizedBox(width: 4.w),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white,
              ),
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
