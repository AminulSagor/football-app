import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/themes/app_text_styles.dart';
import '../../shared/following_ui.dart';
import '../coach_profile_controller.dart';
import '../coach_profile_model.dart';

class CoachProfileSummaryPage extends GetView<CoachProfileController> {
  const CoachProfileSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state.value;
      return ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 28.h),
        children: [
          _FactsCard(state: state),
          SizedBox(height: 24.h),
          _TrophiesCard(items: state.trophies),
        ],
      );
    });
  }
}

class _FactsCard extends StatelessWidget {
  final CoachProfileViewModel state;

  const _FactsCard({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: _cardDecoration,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
            child: Row(
              children: [
                Expanded(child: _FactTile(item: state.facts[0])),
                SizedBox(width: 10.w),
                Expanded(child: _FactTile(item: state.facts[1])),
              ],
            ),
          ),
        ),
        SizedBox(height: 24.h),
        Container(
          decoration: _cardDecoration,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 18.h),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SeedCircleAvatar(seed: 'ATM', size: 22, fontSize: 6),
                    SizedBox(width: 10.w),
                    Text(
                      state.currentClub,
                      style: TextStyle(color: Colors.white, fontSize: AppTextStyles.sizeBodyLarge.sp, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 92.h,
                        padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18.r), color: Colors.white.withAlpha(8)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(state.matches, style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.w800)),
                            SizedBox(height: 4.h),
                            Text('Matches', style: TextStyle(color: Colors.white.withAlpha(90), fontSize: AppTextStyles.sizeCaption.sp, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          for (var index = 0; index < state.records.length; index++) ...[
                            _ProgressRow(item: state.records[index]),
                            if (index != state.records.length - 1) SizedBox(height: 8.h),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FactTile extends StatelessWidget {
  final CoachProfileFactUiModel item;

  const _FactTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: item.highlighted ? const Color(0xFF0F8B67) : Colors.white.withAlpha(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.value, style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w800)),
          SizedBox(height: 4.h),
          Text(item.label, style: TextStyle(color: Colors.white.withAlpha(150), fontSize: AppTextStyles.sizeCaption.sp, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final CoachProfileRecordUiModel item;

  const _ProgressRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 64.w,
          child: Text(item.title, style: TextStyle(color: Colors.white.withAlpha(150), fontSize: AppTextStyles.sizeCaption.sp, fontWeight: FontWeight.w500)),
        ),
        SizedBox(
          width: 32.w,
          child: Text(item.value, style: TextStyle(color: Colors.white, fontSize: AppTextStyles.sizeCaption.sp, fontWeight: FontWeight.w700)),
        ),
        Expanded(
          child: Container(
            height: 10.h,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(999.r), color: Colors.white.withAlpha(10)),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: item.progress,
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(999.r), color: item.color),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TrophiesCard extends StatelessWidget {
  final List<CoachProfileTrophyUiModel> items;

  const _TrophiesCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)), color: Colors.white.withAlpha(4)),
            child: Text('Trophies', style: TextStyle(color: Colors.white, fontSize: AppTextStyles.sizeBody.sp, fontWeight: FontWeight.w700)),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
            child: Column(
              children: [
                for (var index = 0; index < items.length; index++) ...[
                  _TrophyTile(item: items[index]),
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

class _TrophyTile extends StatelessWidget {
  final CoachProfileTrophyUiModel item;

  const _TrophyTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18.r), color: Colors.white.withAlpha(6)),
      child: Column(
        children: [
          Row(
            children: [
              SeedCircleAvatar(seed: item.seed, size: 32, fontSize: 7),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: TextStyle(color: Colors.white, fontSize: AppTextStyles.sizeBodyLarge.sp, fontWeight: FontWeight.w700)),
                    SizedBox(height: 4.h),
                    Text(item.country, style: TextStyle(color: Colors.white.withAlpha(90), fontSize: AppTextStyles.sizeCaption.sp, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(height: 1.h, color: Colors.white.withAlpha(10)),
          SizedBox(height: 12.h),
          Row(
            children: [
              SeedCircleAvatar(seed: '', size: 22, fontSize: 0, borderColor: Colors.white.withAlpha(35)),
              SizedBox(width: 8.w),
              Expanded(child: Text(item.season, style: TextStyle(color: Colors.white, fontSize: AppTextStyles.sizeBody.sp, fontWeight: FontWeight.w500))),
              Text(item.result, style: TextStyle(color: Colors.white, fontSize: AppTextStyles.sizeBody.sp, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}

final BoxDecoration _cardDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(22.r),
  gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color(0xFF12201D), Color(0xFF1F2A28)]),
  border: Border.all(color: Colors.white.withAlpha(10), width: 1.w),
);
