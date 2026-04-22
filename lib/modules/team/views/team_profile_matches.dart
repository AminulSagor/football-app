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
          ),
          SizedBox(height: 24.h),
          _MatchesSectionCard(
            title: 'Upcoming matches',
            items: state.visibleUpcomingMatchItems,
            canLoadMore: state.canLoadMoreUpcomingMatches,
            onLoadMore: controller.loadMoreUpcomingMatches,
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

  const _MatchesSectionCard({
    required this.title,
    required this.items,
    required this.canLoadMore,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF12201D), Color(0xFF1F2A28)],
        ),
        border: Border.all(color: Colors.white.withAlpha(10), width: 1.w),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
              color: Colors.white.withAlpha(4),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: AppTextStyles.sizeBody.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 16.h),
            child: Column(
              children: [
                for (var index = 0; index < items.length; index++)
                  Padding(
                    padding: EdgeInsets.only(bottom: index == items.length - 1 ? 0 : 8.h),
                    child: _MatchRow(item: items[index]),
                  ),
                SizedBox(height: 18.h),
                if (canLoadMore)
                  _LoadMoreButton(onTap: onLoadMore),
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

  const _MatchRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.h,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withAlpha(6), width: 1.w),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 52.w,
            child: Text(
              item.dateLabel,
              style: TextStyle(
                color: Colors.white.withAlpha(118),
                fontSize: AppTextStyles.sizeBodySmall.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.homeTeam.name,
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppTextStyles.sizeBody.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                _TinyBadge(),
                SizedBox(width: 10.w),
                _CenterLabel(label: item.centerLabel, isUpcoming: item.isUpcoming),
                SizedBox(width: 10.w),
                _TinyBadge(),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    item.awayTeam.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppTextStyles.sizeBody.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          SizedBox(
            width: 90.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    item.competitionLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.white.withAlpha(118),
                      fontSize: AppTextStyles.sizeBodySmall.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: 6.w),
                _TinyBadge(size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CenterLabel extends StatelessWidget {
  final String label;
  final bool isUpcoming;

  const _CenterLabel({
    required this.label,
    required this.isUpcoming,
  });

  @override
  Widget build(BuildContext context) {
    if (!isUpcoming) {
      return Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: AppTextStyles.sizeHeading.sp,
          fontWeight: FontWeight.w800,
        ),
      );
    }

    return Container(
      height: 22.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        color: Colors.white.withAlpha(8),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white.withAlpha(118),
          fontSize: AppTextStyles.sizeBodySmall.sp,
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
          height: 38.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: const Color(0xFF0D8F67),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Load More',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppTextStyles.sizeBody.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18.r,
                color: Colors.white,
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

  const _TinyBadge({this.size = 20});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF171D24),
        border: Border.all(color: const Color(0xFF596C95), width: 1.w),
      ),
    );
  }
}
