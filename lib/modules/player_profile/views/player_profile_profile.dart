import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/themes/app_text_styles.dart';
import '../../shared/following_ui.dart';
import '../player_profile_controller.dart';
import '../player_profile_model.dart';

class PlayerProfileSummaryPage extends GetView<PlayerProfileController> {
  const PlayerProfileSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state.value;
      return ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 28.h),
        children: [
          _ProfileCard(state: state),
          SizedBox(height: 24.h),
          _TraitsCard(traits: state.traits),
          SizedBox(height: 24.h),
          _TrophiesCard(items: state.trophies),
        ],
      );
    });
  }
}

class _ProfileCard extends StatelessWidget {
  final PlayerProfileViewModel state;

  const _ProfileCard({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _FactTile(item: state.facts[0])),
                SizedBox(width: 10.w),
                Expanded(child: _FactTile(item: state.facts[1])),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(child: _FactTile(item: state.facts[2])),
                SizedBox(width: 10.w),
                Expanded(child: _FactTile(item: state.facts[3])),
              ],
            ),
            SizedBox(height: 10.h),
            _FactTile(item: state.facts[4], isWide: true),
            SizedBox(height: 16.h),
            Container(height: 1.h, color: Colors.white.withAlpha(10)),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20.r,
                  height: 20.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withAlpha(55), width: 1.w),
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  state.selectedSeason,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppTextStyles.sizeBody.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 18.h),
            Row(
              children: [
                for (var index = 0; index < state.summaryMetrics.length; index++) ...[
                  Expanded(child: _SmallMetricCard(item: state.summaryMetrics[index])),
                  if (index != state.summaryMetrics.length - 1) SizedBox(width: 10.w),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FactTile extends StatelessWidget {
  final PlayerProfileFactUiModel item;
  final bool isWide;

  const _FactTile({required this.item, this.isWide = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isWide ? 58.h : 56.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: item.isHighlighted ? const Color(0xFF0F8B67) : Colors.white.withAlpha(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item.value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            item.label,
            style: TextStyle(
              color: Colors.white.withAlpha(150),
              fontSize: AppTextStyles.sizeCaption.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallMetricCard extends StatelessWidget {
  final PlayerProfileMetricUiModel item;

  const _SmallMetricCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Colors.white.withAlpha(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item.value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            item.label,
            style: TextStyle(
              color: Colors.white.withAlpha(90),
              fontSize: AppTextStyles.sizeCaption.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _TraitsCard extends StatelessWidget {
  final List<PlayerProfileTraitUiModel> traits;

  const _TraitsCard({required this.traits});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration,
      child: Column(
        children: [
          _CardHeader(title: 'Player traits'),
          SizedBox(
            height: 350.h,
            child: Stack(
              children: [
                Center(child: CustomPaint(size: Size(230.w, 230.w), painter: _RadarPainter())),
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 24.h),
                    child: Stack(
                      children: [
                        for (final trait in traits)
                          Align(
                            alignment: trait.alignment,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  trait.label,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white.withAlpha(165),
                                    fontSize: AppTextStyles.sizeCaption.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  trait.value,
                                  style: TextStyle(
                                    color: const Color(0xFF13C79A),
                                    fontSize: AppTextStyles.sizeBodySmall.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.42;
    final ringPaint = Paint()
      ..color = Colors.white.withAlpha(45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final axisPaint = Paint()
      ..color = Colors.white.withAlpha(32)
      ..strokeWidth = 1;
    const sides = 6;

    for (var ring = 1; ring <= 4; ring++) {
      final path = Path();
      for (var i = 0; i < sides; i++) {
        final angle = (-math.pi / 2) + (2 * math.pi * i / sides);
        final point = Offset(
          center.dx + math.cos(angle) * radius * ring / 4,
          center.dy + math.sin(angle) * radius * ring / 4,
        );
        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      path.close();
      canvas.drawPath(path, ringPaint);
    }

    for (var i = 0; i < sides; i++) {
      final angle = (-math.pi / 2) + (2 * math.pi * i / sides);
      final point = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
      canvas.drawLine(center, point, axisPaint);
    }

    final values = <double>[0.02, 1.0, 1.0, 0.38, 0.41, 0.18];
    final fillPath = Path();
    for (var i = 0; i < sides; i++) {
      final angle = (-math.pi / 2) + (2 * math.pi * i / sides);
      final point = Offset(
        center.dx + math.cos(angle) * radius * values[i],
        center.dy + math.sin(angle) * radius * values[i],
      );
      if (i == 0) {
        fillPath.moveTo(point.dx, point.dy);
      } else {
        fillPath.lineTo(point.dx, point.dy);
      }
    }
    fillPath.close();
    canvas.drawPath(
      fillPath,
      Paint()..color = const Color(0xFF0DB488).withAlpha(70),
    );
    canvas.drawPath(
      fillPath,
      Paint()
        ..color = const Color(0xFF0DB488)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TrophiesCard extends StatelessWidget {
  final List<PlayerProfileTrophyUiModel> items;

  const _TrophiesCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration,
      child: Column(
        children: [
          _CardHeader(title: 'Trophies'),
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
  final PlayerProfileTrophyUiModel item;

  const _TrophyTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: Colors.white.withAlpha(6),
      ),
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
                    Text(
                      item.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppTextStyles.sizeBodyLarge.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      item.country,
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
          SizedBox(height: 12.h),
          Container(height: 1.h, color: Colors.white.withAlpha(10)),
          SizedBox(height: 12.h),
          Row(
            children: [
              SeedCircleAvatar(seed: '', size: 22, fontSize: 0, borderColor: Colors.white.withAlpha(35)),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  item.season,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppTextStyles.sizeBody.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                item.result,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppTextStyles.sizeBody.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  final String title;

  const _CardHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

final BoxDecoration _cardDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(22.r),
  gradient: const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF12201D), Color(0xFF1F2A28)],
  ),
  border: Border.all(color: Colors.white.withAlpha(10), width: 1.w),
);
