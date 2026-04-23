import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/themes/app_text_styles.dart';
import '../../shared/following_ui.dart';
import '../player_profile_controller.dart';
import '../player_profile_model.dart';

class PlayerProfileMatchesPage extends GetView<PlayerProfileController> {
  const PlayerProfileMatchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final groups = controller.state.value.matchGroups;
      return ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 28.h),
        children: [
          for (var index = 0; index < groups.length; index++) ...[
            _MatchGroupCard(item: groups[index]),
            if (index != groups.length - 1) SizedBox(height: 18.h),
          ],
          SizedBox(height: 18.h),
          Center(child: _LoadMoreButton(onTap: () {})),
        ],
      );
    });
  }
}

class _MatchGroupCard extends StatelessWidget {
  final PlayerProfileMatchGroupUiModel item;

  const _MatchGroupCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final isPlaceholder = item.title == 'Placeholder';

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
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 16.h),
        child: Column(
          children: [
            Row(
              children: [
                SeedCircleAvatar(seed: isPlaceholder ? '' : item.title.substring(0, 2).toUpperCase(), size: 34, fontSize: AppTextStyles.sizeTiny),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: isPlaceholder ? 92.w : null,
                        height: isPlaceholder ? 10.h : null,
                        decoration: isPlaceholder
                            ? BoxDecoration(
                                color: Colors.white.withAlpha(180),
                                borderRadius: BorderRadius.circular(8.r),
                              )
                            : null,
                        child: isPlaceholder
                            ? null
                            : Text(
                                item.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: AppTextStyles.sizeBodyLarge.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                      SizedBox(height: 4.h),
                      if (isPlaceholder)
                        Container(
                          width: 56.w,
                          height: 8.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(170),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        )
                      else
                        Text(
                          item.subtitle,
                          style: TextStyle(
                            color: Colors.white.withAlpha(90),
                            fontSize: AppTextStyles.sizeCaption.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Container(height: 1.h, color: Colors.white.withAlpha(10)),
            SizedBox(height: 14.h),
            if (isPlaceholder)
              Column(
                children: List.generate(
                  2,
                  (index) => Padding(
                    padding: EdgeInsets.only(bottom: index == 1 ? 0 : 12.h),
                    child: _PlaceholderFixtureTile(),
                  ),
                ),
              )
            else
              Column(
                children: [
                  for (var index = 0; index < item.matches.length; index++) ...[
                    _MatchFixtureTile(item: item.matches[index]),
                    if (index != item.matches.length - 1) SizedBox(height: 12.h),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _MatchFixtureTile extends StatelessWidget {
  final PlayerProfileMatchItemUiModel item;

  const _MatchFixtureTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: Colors.white.withAlpha(6),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                item.dateLabel,
                style: TextStyle(
                  color: const Color(0xFF39E0B3),
                  fontSize: AppTextStyles.sizeOverline.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: const Color(0xFF0D8F67),
                ),
                child: Text(
                  item.competitionLabel,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppTextStyles.sizeCaption.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SeedCircleAvatar(seed: '', size: 22, fontSize: 0, borderColor: Colors.white.withAlpha(32)),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.opponentName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppTextStyles.sizeBody.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            item.scoreLabel,
                            style: TextStyle(
                              color: Colors.white.withAlpha(110),
                              fontSize: AppTextStyles.sizeBodySmall.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(width: 1.w, height: 42.h, color: Colors.white.withAlpha(8)),
              SizedBox(width: 12.w),
              Container(
                width: 68.w,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  color: const Color(0xFF0D8F67),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.statLabel,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppTextStyles.sizeBodySmall.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      item.minuteLabel,
                      style: TextStyle(
                        color: Colors.white.withAlpha(180),
                        fontSize: AppTextStyles.sizeCaption.sp,
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
}

class _PlaceholderFixtureTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: Colors.white.withAlpha(6),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 94.w, height: 8.h, decoration: BoxDecoration(color: Colors.white.withAlpha(200), borderRadius: BorderRadius.circular(8.r))),
                SizedBox(height: 10.h),
                Container(width: 42.w, height: 6.h, decoration: BoxDecoration(color: Colors.white.withAlpha(180), borderRadius: BorderRadius.circular(8.r))),
              ],
            ),
          ),
          Container(width: 52.w, height: 26.h, decoration: BoxDecoration(color: const Color(0xFF42D8AF), borderRadius: BorderRadius.circular(10.r))),
        ],
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
              Icon(Icons.keyboard_arrow_down_rounded, size: 18.r, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
