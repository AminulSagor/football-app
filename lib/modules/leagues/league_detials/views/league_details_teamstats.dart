import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/themes/app_text_styles.dart';
import '../league_details_controller.dart';

class LeagueDetailsTeamStatsPage extends GetView<LeagueDetailsController> {
  const LeagueDetailsTeamStatsPage({super.key});

  static const List<_TeamStatsCategoryData>
  _categories = <_TeamStatsCategoryData>[
    _TeamStatsCategoryData(
      title: 'Top Stats',
      availableFilters: <String>[
        'Goals per match',
        'Goals conceded per match',
        'Average possession',
        'Clean sheets',
        'Attendance',
      ],
      cards: <_TeamStatsCardData>[
        _TeamStatsCardData(
          title: 'Goals per match',
          filterLabel: 'Goals per match',
        ),
        _TeamStatsCardData(
          title: 'Goals conceded per match',
          filterLabel: 'Goals conceded per match',
        ),
        _TeamStatsCardData(
          title: 'Avg. possession',
          filterLabel: 'Average possession',
        ),
        _TeamStatsCardData(title: 'Clean sheets', filterLabel: 'Clean sheets'),
        _TeamStatsCardData(title: 'Attendance', filterLabel: 'Attendance'),
      ],
    ),
    _TeamStatsCategoryData(
      title: 'Attack',
      availableFilters: <String>[
        'Shots on target per match',
        'Big chances',
        'Big Chances Missed',
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
          title: 'Shots on target per match',
          filterLabel: 'Shots on target per match',
        ),
        _TeamStatsCardData(title: 'Big chances', filterLabel: 'Big chances'),
        _TeamStatsCardData(
          title: 'Big Chances Missed',
          filterLabel: 'Big Chances Missed',
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
      title: 'Defence',
      availableFilters: <String>[
        'Interceptions per match',
        'Tackles per match',
        'Clearances per match',
        'Possession won final 3rd per match',
        'Set piece goals conceded',
        'Penalties conceded',
        'Saves per match',
      ],
      cards: <_TeamStatsCardData>[
        _TeamStatsCardData(
          title: 'Interceptions per match',
          filterLabel: 'Interceptions per match',
        ),
        _TeamStatsCardData(
          title: 'Tackles per match',
          filterLabel: 'Tackles per match',
        ),
        _TeamStatsCardData(
          title: 'Clearance per match',
          filterLabel: 'Clearances per match',
        ),
        _TeamStatsCardData(
          title: 'Penalties conceded',
          filterLabel: 'Penalties conceded',
        ),
        _TeamStatsCardData(
          title: 'Save per match',
          filterLabel: 'Saves per match',
        ),
      ],
    ),
    _TeamStatsCategoryData(
      title: 'Discipline',
      availableFilters: <String>[
        'Fouls per match',
        'Yellow cards',
        'Red cards',
      ],
      cards: <_TeamStatsCardData>[
        _TeamStatsCardData(
          title: 'Fouls committed per match',
          filterLabel: 'Fouls per match',
        ),
        _TeamStatsCardData(title: 'Yellow cards', filterLabel: 'Yellow cards'),
        _TeamStatsCardData(title: 'Red cards', filterLabel: 'Red cards'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 28.h),
      children: [
        for (
          var categoryIndex = 0;
          categoryIndex < _categories.length;
          categoryIndex++
        ) ...[
          _StatsSectionTitle(title: _categories[categoryIndex].title),
          SizedBox(height: 14.h),
          for (
            var cardIndex = 0;
            cardIndex < _categories[categoryIndex].cards.length;
            cardIndex++
          ) ...[
            _TeamStatsCard(
              data: _categories[categoryIndex].cards[cardIndex],
              availableFilters: _categories[categoryIndex].availableFilters,
            ),
            if (cardIndex != _categories[categoryIndex].cards.length - 1)
              SizedBox(height: 12.h),
          ],
          if (categoryIndex != _categories.length - 1) SizedBox(height: 28.h),
        ],
      ],
    );
  }
}

class _TeamStatsCard extends StatelessWidget {
  final _TeamStatsCardData data;
  final List<String> availableFilters;

  const _TeamStatsCard({required this.data, required this.availableFilters});

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
                        _TeamStatsPreviewRow(row: rows[index]),
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

Future<void> _showTeamStatsDetails(
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
          final rows = _teamDetailRowsFor(selectedFilter);

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
                      Expanded(child: _TeamStatsDetailsTable(rows: rows)),
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

class _TeamStatsDetailsTable extends StatelessWidget {
  final List<_TeamDetailRowData> rows;

  const _TeamStatsDetailsTable({required this.rows});

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
                    child: Text('TEAM', style: _detailHeaderStyle(theme)),
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
                        Container(
                          width: 48.r,
                          height: 48.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.secondary.withAlpha(220),
                              width: 1.w,
                            ),
                          ),
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
      color: theme.colorScheme.onSurface.withAlpha(96),
      fontSize: AppTextStyles.sizeOverline.sp,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.25,
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

class _TeamPreviewRowData {
  final String rank;
  final String name;
  final String value;

  const _TeamPreviewRowData({
    required this.rank,
    required this.name,
    required this.value,
  });
}

class _TeamDetailRowData {
  final String rank;
  final String name;
  final String value;

  const _TeamDetailRowData({
    required this.rank,
    required this.name,
    required this.value,
  });
}

List<_TeamPreviewRowData> _teamPreviewRowsFor(String filterLabel) {
  final normalized = filterLabel.toLowerCase();
  final isAttendance = normalized == 'attendance';

  return <_TeamPreviewRowData>[
    _TeamPreviewRowData(
      rank: '1.',
      name: 'Manchester City',
      value: isAttendance ? '2112' : '2.0',
    ),
    _TeamPreviewRowData(
      rank: '2.',
      name: 'Arsenal',
      value: isAttendance ? '2100' : '1.9',
    ),
    _TeamPreviewRowData(
      rank: '3.',
      name: 'Manchester United',
      value: isAttendance ? '1800' : '1.8',
    ),
  ];
}

List<_TeamDetailRowData> _teamDetailRowsFor(String filterLabel) {
  final values = _teamValuesFor(filterLabel);

  const names = <String>[
    'Manchester City',
    'Arsenal',
    'Manchester United',
    'Liverpool',
    'Chelsea',
    'Tottenham',
    'Newcastle',
    'Aston Villa',
  ];

  return List<_TeamDetailRowData>.generate(
    names.length,
    (index) => _TeamDetailRowData(
      rank: '${index + 1}',
      name: names[index],
      value: values[index],
    ),
  );
}

List<String> _teamValuesFor(String filterLabel) {
  final normalized = filterLabel.toLowerCase();

  if (normalized == 'attendance') {
    return const <String>[
      '42112',
      '40680',
      '38995',
      '37640',
      '35890',
      '34210',
      '32980',
      '31840',
    ];
  }

  if (normalized == 'average possession') {
    return const <String>[
      '61.3%',
      '59.8%',
      '58.2%',
      '57.6%',
      '56.8%',
      '55.9%',
      '54.7%',
      '53.9%',
    ];
  }

  if (normalized.contains('passes')) {
    return const <String>[
      '612',
      '590',
      '578',
      '565',
      '548',
      '531',
      '520',
      '508',
    ];
  }

  if (normalized.contains('long balls')) {
    return const <String>[
      '36.2',
      '35.1',
      '34.6',
      '33.8',
      '33.1',
      '32.6',
      '31.9',
      '31.1',
    ];
  }

  if (normalized.contains('crosses')) {
    return const <String>[
      '6.8',
      '6.4',
      '6.2',
      '6.0',
      '5.8',
      '5.6',
      '5.4',
      '5.2',
    ];
  }

  if (normalized == 'clean sheets' ||
      normalized == 'big chances' ||
      normalized == 'big chances missed' ||
      normalized == 'penalties awarded' ||
      normalized == 'set piece goals' ||
      normalized == 'set piece goals conceded' ||
      normalized == 'penalties conceded' ||
      normalized == 'yellow cards' ||
      normalized == 'red cards') {
    return const <String>['18', '16', '15', '14', '13', '12', '11', '10'];
  }

  if (normalized == 'fouls per match') {
    return const <String>[
      '10.8',
      '11.1',
      '11.4',
      '11.6',
      '11.9',
      '12.0',
      '12.2',
      '12.4',
    ];
  }

  if (normalized == 'goals conceded per match') {
    return const <String>[
      '0.8',
      '0.9',
      '1.0',
      '1.1',
      '1.1',
      '1.2',
      '1.2',
      '1.3',
    ];
  }

  if (normalized == 'saves per match') {
    return const <String>[
      '3.6',
      '3.4',
      '3.2',
      '3.0',
      '2.9',
      '2.8',
      '2.7',
      '2.6',
    ];
  }

  if (normalized == 'corners') {
    return const <String>[
      '7.4',
      '7.1',
      '6.8',
      '6.5',
      '6.3',
      '6.1',
      '5.9',
      '5.7',
    ];
  }

  if (normalized == 'touches in opposition box') {
    return const <String>[
      '31.2',
      '29.8',
      '28.4',
      '27.6',
      '26.9',
      '25.7',
      '24.8',
      '23.9',
    ];
  }

  if (normalized == 'interceptions per match' ||
      normalized == 'tackles per match' ||
      normalized == 'clearances per match' ||
      normalized == 'possession won final 3rd per match') {
    return const <String>[
      '17.8',
      '17.2',
      '16.8',
      '16.2',
      '15.9',
      '15.4',
      '15.0',
      '14.6',
    ];
  }

  return const <String>['2.2', '2.0', '1.9', '1.8', '1.7', '1.6', '1.5', '1.4'];
}
