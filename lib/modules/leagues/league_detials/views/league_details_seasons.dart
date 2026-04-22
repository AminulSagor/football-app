import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/themes/app_text_styles.dart';
import '../league_details_controller.dart';

class LeagueDetailsSeasonsPage extends GetView<LeagueDetailsController> {
  const LeagueDetailsSeasonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state.value;
      return ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 28.h),
        children: [
          Text(
            'All Seasons',
            style: TextStyle(
              color: Colors.white,
              fontSize: AppTextStyles.sizeBodyLarge.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 14.h),
          for (var index = 0; index < state.seasons.length; index++) ...[
            _SeasonCard(
              label: state.seasons[index],
              isSelected: state.seasons[index] == state.selectedSeason,
              onTap: () => controller.selectSeason(state.seasons[index]),
            ),
            if (index != state.seasons.length - 1) SizedBox(height: 12.h),
          ],
        ],
      );
    });
  }
}

class _SeasonCard extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SeasonCard({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF12201D), Color(0xFF1F2A28)],
            ),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF39E0B3)
                  : Colors.white.withAlpha(10),
              width: 1.w,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppTextStyles.sizeBody.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (isSelected)
                Icon(Icons.check_rounded, size: 20.r, color: const Color(0xFF39E0B3))
              else
                Icon(Icons.chevron_right_rounded, size: 22.r, color: Colors.white.withAlpha(110)),
            ],
          ),
        ),
      ),
    );
  }
}
