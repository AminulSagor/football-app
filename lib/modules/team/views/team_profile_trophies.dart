import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/themes/app_text_styles.dart';
import '../team_profile_controller.dart';
import '../team_profile_model.dart';

class TeamProfileTrophiesPage extends GetView<TeamProfileController> {
  const TeamProfileTrophiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state.value;

      return ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 28.h),
        children: [
          for (var index = 0; index < state.visibleTrophyItems.length; index++) ...[
            _TrophySectionCard(item: state.visibleTrophyItems[index]),
            if (index != state.visibleTrophyItems.length - 1) SizedBox(height: 24.h),
          ],
          if (state.canLoadMoreTrophies) ...[
            SizedBox(height: 26.h),
            Center(
              child: _LoadMoreButton(onTap: controller.loadMoreTrophies),
            ),
          ],
        ],
      );
    });
  }
}

class _TrophySectionCard extends StatelessWidget {
  final TeamProfileTrophySectionUiModel item;

  const _TrophySectionCard({required this.item});

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
            child: Row(
              children: [
                _BadgeCircle(seed: item.badgeSeed),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    item.title,
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
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
            child: Column(
              children: [
                for (var index = 0; index < item.entries.length; index++)
                  Padding(
                    padding: EdgeInsets.only(bottom: index == item.entries.length - 1 ? 0 : 12.h),
                    child: _TrophyEntryRow(item: item.entries[index]),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrophyEntryRow extends StatelessWidget {
  final TeamProfileTrophyEntryUiModel item;

  const _TrophyEntryRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: Colors.white.withAlpha(6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 46.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.count,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  item.label,
                  style: TextStyle(
                    color: Colors.white.withAlpha(100),
                    fontSize: AppTextStyles.sizeBodySmall.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              item.years,
              style: TextStyle(
                color: Colors.white.withAlpha(108),
                fontSize: AppTextStyles.sizeBodySmall.sp,
                fontWeight: FontWeight.w500,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeCircle extends StatelessWidget {
  final String seed;

  const _BadgeCircle({required this.seed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24.r,
      height: 24.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF171D24),
        border: Border.all(color: const Color(0xFF596C95), width: 1.w),
      ),
      alignment: Alignment.center,
      child: Text(
        seed,
        style: TextStyle(
          color: Colors.white,
          fontSize: 6.5.sp,
          fontWeight: FontWeight.w800,
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
