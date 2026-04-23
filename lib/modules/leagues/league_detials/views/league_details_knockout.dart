import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/themes/app_text_styles.dart';
import '../../../shared/following_ui.dart';
import '../models/league_detials_model.dart';
import '../league_details_controller.dart';

class LeagueDetailsKnockoutPage extends GetView<LeagueDetailsController> {
  const LeagueDetailsKnockoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 28.h),
      children: [
        _BracketSection(
          title: 'Round of 16',
          items: controller.worldCupTopOpeningMatches,
        ),
        SizedBox(height: 20.h),
        _BracketSection(
          title: 'Quarter-final',
          items: <LeagueDetailsKnockoutMatchUiModel>[
            ...controller.worldCupTopQuarterMatches,
            ...controller.worldCupBottomQuarterMatches,
          ],
        ),
        SizedBox(height: 20.h),
        _BracketSection(
          title: 'Semi-final',
          items: <LeagueDetailsKnockoutMatchUiModel>[
            controller.worldCupTopSemiMatch,
            controller.worldCupBottomSemiMatch,
          ],
        ),
        SizedBox(height: 20.h),
        _FinalSection(item: controller.worldCupFinalMatch),
      ],
    );
  }
}

class _BracketSection extends StatelessWidget {
  final String title;
  final List<LeagueDetailsKnockoutMatchUiModel> items;

  const _BracketSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF12201D), Color(0xFF1F2A28)],
        ),
        border: Border.all(color: Colors.white.withAlpha(10), width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: AppTextStyles.sizeBody.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 14.h),
          for (var index = 0; index < items.length; index++) ...[
            _KnockoutMatchTile(item: items[index]),
            if (index != items.length - 1) SizedBox(height: 10.h),
          ],
        ],
      ),
    );
  }
}

class _FinalSection extends StatelessWidget {
  final LeagueDetailsKnockoutMatchUiModel item;

  const _FinalSection({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 18.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        color: const Color(0xFF0E8B67),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0E8B67).withAlpha(70),
            blurRadius: 24.r,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Final',
            style: TextStyle(
              color: Colors.white,
              fontSize: AppTextStyles.sizeBody.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 16.h),
          _KnockoutMatchTile(item: item, isFinal: true),
        ],
      ),
    );
  }
}

class _KnockoutMatchTile extends StatelessWidget {
  final LeagueDetailsKnockoutMatchUiModel item;
  final bool isFinal;

  const _KnockoutMatchTile({required this.item, this.isFinal = false});

  @override
  Widget build(BuildContext context) {
    final background = isFinal
        ? Colors.white.withAlpha(18)
        : item.isHighlighted
            ? const Color(0x1939E0B3)
            : Colors.white.withAlpha(6);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: background,
        border: Border.all(
          color: item.isHighlighted || isFinal
              ? const Color(0xFF39E0B3).withAlpha(130)
              : Colors.white.withAlpha(8),
          width: 1.w,
        ),
      ),
      child: Column(
        children: [
          _TeamRow(seed: item.homeSeed, label: item.homeLabel),
          SizedBox(height: 10.h),
          _TeamRow(
            seed: item.awaySeed,
            label: item.awayLabel,
            showChampionMark: item.showChampionMark,
          ),
          SizedBox(height: 12.h),
          Text(
            item.dateLabel,
            style: TextStyle(
              color: Colors.white.withAlpha(145),
              fontSize: AppTextStyles.sizeCaption.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamRow extends StatelessWidget {
  final String seed;
  final String label;
  final bool showChampionMark;

  const _TeamRow({
    required this.seed,
    required this.label,
    this.showChampionMark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SeedCircleAvatar(seed: seed, size: 28, fontSize: AppTextStyles.sizeTiny),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: AppTextStyles.sizeBodySmall.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (showChampionMark)
          Icon(Icons.emoji_events_rounded, size: 16.r, color: const Color(0xFFFFC045)),
      ],
    );
  }
}
