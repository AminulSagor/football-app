import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/themes/app_text_styles.dart';
import '../../shared/following_ui.dart';
import '../player_profile_controller.dart';
import '../player_profile_model.dart';

class PlayerProfileCareerPage extends GetView<PlayerProfileController> {
  const PlayerProfileCareerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state.value;
      return ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 28.h),
        children: [
          _CareerSection(title: 'Senior Career', items: state.seniorCareer),
          SizedBox(height: 20.h),
          _CareerSection(title: 'National Team', items: state.nationalCareer),
        ],
      );
    });
  }
}

class _CareerSection extends StatelessWidget {
  final String title;
  final List<PlayerCareerClubUiModel> items;

  const _CareerSection({required this.title, required this.items});

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
            child: Text(title, style: TextStyle(color: Colors.white, fontSize: AppTextStyles.sizeBody.sp, fontWeight: FontWeight.w700)),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 16.h),
            child: Column(
              children: [
                for (var index = 0; index < items.length; index++) ...[
                  _CareerCard(item: items[index], isPlaceholder: title == 'Senior Career' && index >= 3),
                  if (index != items.length - 1) SizedBox(height: 12.h),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CareerCard extends StatelessWidget {
  final PlayerCareerClubUiModel item;
  final bool isPlaceholder;

  const _CareerCard({required this.item, required this.isPlaceholder});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18.r), color: Colors.white.withAlpha(6)),
      child: Row(
        children: [
          SeedCircleAvatar(seed: isPlaceholder ? '' : item.seed, size: 22, fontSize: 6, borderColor: Colors.white.withAlpha(55)),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isPlaceholder)
                  Container(width: 82.w, height: 10.h, decoration: BoxDecoration(color: Colors.white.withAlpha(180), borderRadius: BorderRadius.circular(10.r)))
                else
                  Text(item.title, style: TextStyle(color: Colors.white, fontSize: AppTextStyles.sizeBodyLarge.sp, fontWeight: FontWeight.w700)),
                SizedBox(height: 4.h),
                if (isPlaceholder)
                  Container(width: 110.w, height: 7.h, decoration: BoxDecoration(color: const Color(0xFF39E0B3), borderRadius: BorderRadius.circular(8.r)))
                else
                  Text(item.rangeLabel, style: TextStyle(color: const Color(0xFF39E0B3), fontSize: AppTextStyles.sizeCaption.sp, fontWeight: FontWeight.w600)),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(child: Text('MATCHES PLAYED', style: TextStyle(color: Colors.white.withAlpha(150), fontSize: AppTextStyles.sizeBodySmall.sp, fontWeight: FontWeight.w700))),
                    _ValuePill(label: item.matches, isPlaceholder: isPlaceholder),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(child: Text('GOALS', style: TextStyle(color: Colors.white.withAlpha(150), fontSize: AppTextStyles.sizeBodySmall.sp, fontWeight: FontWeight.w700))),
                    _ValuePill(label: item.goals, isPlaceholder: isPlaceholder),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ValuePill extends StatelessWidget {
  final String label;
  final bool isPlaceholder;

  const _ValuePill({required this.label, required this.isPlaceholder});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34.w,
      height: 22.h,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.r), color: const Color(0xFF39E0B3)),
      alignment: Alignment.center,
      child: isPlaceholder
          ? null
          : Text(label, style: TextStyle(color: Colors.black, fontSize: AppTextStyles.sizeBodySmall.sp, fontWeight: FontWeight.w800)),
    );
  }
}
