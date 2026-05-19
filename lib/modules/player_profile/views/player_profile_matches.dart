// lib/modules/player_profile/views/player_profile_matches.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/themes/app_colors.dart';
import '../../../core/widgets/following_ui.dart';
import '../model/player_profile_model.dart';
import '../player_profile_controller.dart';

class PlayerProfileMatchesPage extends GetView<PlayerProfileController> {
  const PlayerProfileMatchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state.value;
      final theme = Theme.of(context);
      final palette = AppColors.palette(theme.brightness);

      if (state.matchGroups.isEmpty) {
        return ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 30.h),
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(18.w, 22.h, 18.w, 22.h),
              decoration: _groupDecoration(context),
              child: Column(
                children: [
                  Icon(
                    Icons.sports_soccer_rounded,
                    size: 34.r,
                    color: const Color(0xFF39E0B3),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Match data unavailable',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: palette.textPrimary,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'The current player API does not return reliable match history yet.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: palette.textMuted,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }

      return ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 30.h),
        children: [
          for (var i = 0; i < state.matchGroups.length; i++) ...[
            _MatchGroupCard(
              group: state.matchGroups[i],
              isSkeletonHeader: false,
              isLargeSkeleton: false,
            ),
            if (i != state.matchGroups.length - 1) SizedBox(height: 18.h),
          ],
        ],
      );
    });
  }
}

class _MatchGroupCard extends StatelessWidget {
  final PlayerProfileMatchGroupUiModel group;
  final bool isSkeletonHeader;
  final bool isLargeSkeleton;

  const _MatchGroupCard({
    required this.group,
    this.isSkeletonHeader = false,
    this.isLargeSkeleton = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppColors.palette(theme.brightness);

    return Container(
      decoration: _groupDecoration(context),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
        child: Column(
          children: [
            Row(
              children: [
                SeedCircleAvatar(
                  seed: isSkeletonHeader ? '' : group.title.characters.first,
                  size: 22,
                  fontSize: 9,
                  borderColor: isSkeletonHeader
                      ? palette.textPrimary.withAlpha(220)
                      : const Color(0xFF84F3D0),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: isSkeletonHeader
                      ? const _SkeletonHeader()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              group.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: palette.textPrimary,
                                fontSize: 11.7.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              group.subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: palette.textMuted,
                                fontSize: 8.6.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Container(height: 1.h, color: palette.divider.withAlpha(110)),
            SizedBox(height: 14.h),
            if (!isSkeletonHeader) ...[
              for (var i = 0; i < group.matches.length; i++) ...[
                _MatchItemCard(item: group.matches[i]),
                if (i != group.matches.length - 1) SizedBox(height: 10.h),
              ],
            ] else ...[
              for (var i = 0; i < (isLargeSkeleton ? 3 : 1); i++) ...[
                _SkeletonMatchItem(dense: !isLargeSkeleton),
                if (i != (isLargeSkeleton ? 3 : 1) - 1) SizedBox(height: 10.h),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _MatchItemCard extends StatelessWidget {
  final PlayerProfileMatchItemUiModel item;

  const _MatchItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppColors.palette(theme.brightness);

    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Colors.white.withAlpha(7),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                item.dateLabel,
                style: TextStyle(
                  color: const Color(0xFF17C797),
                  fontSize: 8.2.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
              SizedBox(width: 10.w),
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999.r),
                    color: const Color(0xFF108B65),
                  ),
                  child: Text(
                    item.competitionLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8.1.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              SeedCircleAvatar(
                seed: '',
                size: 18,
                fontSize: 8,
                borderColor: palette.textMuted.withAlpha(120),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.opponentName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: palette.textPrimary,
                        fontSize: 10.2.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      item.scoreLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: palette.textMuted,
                        fontSize: 8.7.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1.w,
                height: 42.h,
                color: palette.divider.withAlpha(100),
              ),
              SizedBox(width: 12.w),
              Container(
                width: 68.w,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: const Color(0xFF108B65),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.statLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: item.isGoalPositive
                            ? Colors.white
                            : Colors.white,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (!item.isGoalPositive) SizedBox(height: 4.h),
                    if (!item.isGoalPositive)
                      Row(
                        children: [
                          _smallEventDot(const Color(0xFFF0C419)),
                          SizedBox(width: 3.w),
                          _smallEventDot(const Color(0xFFFF6F61)),
                        ],
                      ),
                    SizedBox(height: 4.h),
                    Text(
                      item.minuteLabel,
                      style: TextStyle(
                        color: Colors.white.withAlpha(185),
                        fontSize: 8.4.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _smallEventDot(Color color) {
    return Container(
      width: 6.w,
      height: 8.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(1.5.r),
      ),
    );
  }
}

class _SkeletonHeader extends StatelessWidget {
  const _SkeletonHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64.w,
          height: 10.h,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(220),
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: 54.w,
          height: 6.h,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(220),
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ],
    );
  }
}

class _SkeletonMatchItem extends StatelessWidget {
  final bool dense;

  const _SkeletonMatchItem({required this.dense});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppColors.palette(theme.brightness);

    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Colors.white.withAlpha(7),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 54.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(220),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Container(
                  height: 10.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999.r),
                    color: const Color(0xFF108B65),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              SeedCircleAvatar(
                seed: '',
                size: 18,
                fontSize: 8,
                borderColor: palette.textPrimary.withAlpha(220),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: dense ? 34.w : 60.w,
                      height: 7.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(220),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      width: dense ? 26.w : 52.w,
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(220),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1.w,
                height: 40.h,
                color: palette.divider.withAlpha(90),
              ),
              SizedBox(width: 12.w),
              Container(
                width: 58.w,
                height: 42.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: const Color(0xFF108B65),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 26.w,
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(220),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Container(
                            width: 6.w,
                            height: 8.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0C419),
                              borderRadius: BorderRadius.circular(1.5.r),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Container(
                            width: 6.w,
                            height: 8.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6F61),
                              borderRadius: BorderRadius.circular(1.5.r),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Container(
                        width: 14.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(220),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ],
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

BoxDecoration _groupDecoration(BuildContext context) {
  final theme = Theme.of(context);
  final palette = AppColors.palette(theme.brightness);

  return BoxDecoration(
    borderRadius: BorderRadius.circular(22.r),
    color: palette.surface,
    border: Border.all(color: palette.divider.withAlpha(85), width: 1.w),
  );
}
