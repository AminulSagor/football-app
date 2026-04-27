import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/themes/app_text_styles.dart';
import '../team_profile_controller.dart';
import '../team_profile_model.dart';

class TeamProfileMatchesPage extends GetView<TeamProfileController> {
  const TeamProfileMatchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state.value;

      return ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 28.h),
        children: [
          _MatchesSectionCard(
            title: 'Previous matches',
            items: state.visiblePreviousMatchItems,
            canLoadMore: state.canLoadMorePreviousMatches,
            onLoadMore: controller.loadMorePreviousMatches,
            focusTeamName: state.team.name,
          ),
          SizedBox(height: 24.h),
          _MatchesSectionCard(
            title: 'Upcoming matches',
            items: state.visibleUpcomingMatchItems,
            canLoadMore: state.canLoadMoreUpcomingMatches,
            onLoadMore: controller.loadMoreUpcomingMatches,
            focusTeamName: state.team.name,
          ),
        ],
      );
    });
  }
}

class _MatchesSectionCard extends StatelessWidget {
  final String title;
  final List<TeamProfileMatchRowUiModel> items;
  final bool canLoadMore;
  final VoidCallback onLoadMore;
  final String focusTeamName;

  const _MatchesSectionCard({
    required this.title,
    required this.items,
    required this.canLoadMore,
    required this.onLoadMore,
    required this.focusTeamName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [theme.colorScheme.surface, theme.scaffoldBackgroundColor],
        ),
        border: Border.all(
          color: theme.colorScheme.onSurface.withAlpha(12),
          width: 1.w,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              color: theme.colorScheme.onSurface.withAlpha(5),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: AppTextStyles.sizeBodySmall.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 14.h),
            child: Column(
              children: [
                for (var index = 0; index < items.length; index++)
                  _MatchRow(item: items[index], focusTeamName: focusTeamName),
                SizedBox(height: 14.h),
                if (canLoadMore) _LoadMoreButton(onTap: onLoadMore),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchRow extends StatelessWidget {
  final TeamProfileMatchRowUiModel item;
  final String focusTeamName;

  const _MatchRow({required this.item, required this.focusTeamName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final normalizedFocusName = focusTeamName.trim().toLowerCase();
    final homeIsFocus =
        normalizedFocusName.isNotEmpty &&
        item.homeTeam.name.trim().toLowerCase() == normalizedFocusName;
    final awayIsFocus =
        normalizedFocusName.isNotEmpty &&
        item.awayTeam.name.trim().toLowerCase() == normalizedFocusName;

    return Container(
      padding: EdgeInsets.fromLTRB(1.w, 6.h, 1.w, 8.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.onSurface.withAlpha(10),
            width: 1.w,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.dateLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withAlpha(118),
                    fontSize: AppTextStyles.sizeTiny.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              SizedBox(
                width: 120.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        item.competitionLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withAlpha(118),
                          fontSize: AppTextStyles.sizeTiny.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    _TinyBadge(size: 13),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  item.homeTeam.name,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: AppTextStyles.sizeCaption.sp,
                    fontWeight: homeIsFocus ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              _TinyBadge(size: 13),
              SizedBox(width: 5.w),
              SizedBox(
                width: item.isUpcoming ? 42.w : 36.w,
                child: Center(
                  child: _CenterLabel(
                    label: item.centerLabel,
                    isUpcoming: item.isUpcoming,
                  ),
                ),
              ),
              SizedBox(width: 5.w),
              _TinyBadge(size: 13),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  item.awayTeam.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: AppTextStyles.sizeCaption.sp,
                    fontWeight: awayIsFocus ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CenterLabel extends StatelessWidget {
  final String label;
  final bool isUpcoming;

  const _CenterLabel({required this.label, required this.isUpcoming});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!isUpcoming) {
      return Text(
        label,
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: AppTextStyles.sizeLabel.sp,
          fontWeight: FontWeight.w800,
        ),
      );
    }

    return Container(
      height: 20.h,
      padding: EdgeInsets.symmetric(horizontal: 7.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        color: theme.colorScheme.onSurface.withAlpha(8),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: theme.colorScheme.onSurface.withAlpha(118),
          fontSize: AppTextStyles.sizeTiny.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _LoadMoreButton extends StatelessWidget {
  final VoidCallback onTap;

  const _LoadMoreButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.r),
        onTap: onTap,
        child: Container(
          height: 34.h,
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Load More',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: AppTextStyles.sizeCaption.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 16.r,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TinyBadge extends StatelessWidget {
  final double size;

  const _TinyBadge({this.size = 14});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.colorScheme.onSurface.withAlpha(190),
          width: 1.w,
        ),
      ),
    );
  }
}
