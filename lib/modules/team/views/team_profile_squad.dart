import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/themes/app_text_styles.dart';
import '../team_profile_controller.dart';
import '../team_profile_model.dart';

class TeamProfileSquadPage extends GetView<TeamProfileController> {
  const TeamProfileSquadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state.value;

      return ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 28.h),
        children: [
          _SquadSectionCard(
            title: 'Coach',
            child: _CoachRow(item: state.coach),
          ),
          SizedBox(height: 24.h),
          for (var index = 0; index < state.squadSections.length; index++) ...[
            _SquadSectionCard(
              title: state.squadSections[index].title,
              child: Column(
                children: [
                  for (var playerIndex = 0;
                      playerIndex < state.squadSections[index].players.length;
                      playerIndex++)
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: playerIndex == state.squadSections[index].players.length - 1
                            ? 0
                            : 12.h,
                      ),
                      child: _PlayerRow(item: state.squadSections[index].players[playerIndex]),
                    ),
                ],
              ),
            ),
            if (index != state.squadSections.length - 1) SizedBox(height: 24.h),
          ],
        ],
      );
    });
  }
}

class _SquadSectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SquadSectionCard({
    required this.title,
    required this.child,
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
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _CoachRow extends StatelessWidget {
  final TeamProfileSquadPersonUiModel item;

  const _CoachRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: Colors.white.withAlpha(6),
      ),
      child: Row(
        children: [
          _BadgeCircle(seed: item.badgeSeed),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppTextStyles.sizeBody.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Text(item.countryFlag, style: TextStyle(fontSize: 12.sp)),
                    SizedBox(width: 6.w),
                    Text(
                      item.countryName,
                      style: TextStyle(
                        color: Colors.white.withAlpha(94),
                        fontSize: AppTextStyles.sizeBodySmall.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'AGE',
                style: TextStyle(
                  color: Colors.white.withAlpha(90),
                  fontSize: AppTextStyles.sizeBodySmall.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                item.age,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppTextStyles.sizeHeading.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlayerRow extends StatelessWidget {
  final TeamProfileSquadPersonUiModel item;

  const _PlayerRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: Colors.white.withAlpha(6),
      ),
      child: Row(
        children: [
          _BadgeCircle(seed: item.badgeSeed),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppTextStyles.sizeBody.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Text(item.countryFlag, style: TextStyle(fontSize: 12.sp)),
                    SizedBox(width: 6.w),
                    Text(
                      item.countryName,
                      style: TextStyle(
                        color: Colors.white.withAlpha(94),
                        fontSize: AppTextStyles.sizeBodySmall.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 14.w),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'NO',
                style: TextStyle(
                  color: Colors.white.withAlpha(90),
                  fontSize: AppTextStyles.sizeBodySmall.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                item.shirtNumber,
                style: TextStyle(
                  color: const Color(0xFF39E0B3),
                  fontSize: AppTextStyles.sizeHeading.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(width: 24.w),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'AGE',
                style: TextStyle(
                  color: Colors.white.withAlpha(90),
                  fontSize: AppTextStyles.sizeBodySmall.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                item.age,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppTextStyles.sizeHeading.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
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
      width: 40.r,
      height: 40.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF232830),
        border: Border.all(color: const Color(0xFF6CE6C1), width: 1.w),
      ),
      alignment: Alignment.center,
      child: Text(
        seed,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 8.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
