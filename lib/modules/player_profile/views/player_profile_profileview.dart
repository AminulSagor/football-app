// lib/modules/player_profile/views/player_profile_profileview.dart

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/themes/app_colors.dart';
import '../../shared/following_ui.dart';
import '../model/player_profile_model.dart';
import '../player_profile_controller.dart';

class PlayerProfileSummaryPage extends GetView<PlayerProfileController> {
  const PlayerProfileSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppColors.palette(theme.brightness);

    return Obx(() {
      final state = controller.state.value;

      return ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 28.h),
        children: [
          _InfoSummaryCard(state: state),
          SizedBox(height: 18.h),
          _TraitsCard(traits: state.traits),
          SizedBox(height: 18.h),
          _TrophiesCard(items: state.trophies),
          SizedBox(height: 8.h),
        ],
      );
    });
  }
}

class _InfoSummaryCard extends StatelessWidget {
  final PlayerProfileViewModel state;

  const _InfoSummaryCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppColors.palette(theme.brightness);

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: _cardDecoration(context),
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
          SizedBox(height: 14.h),
          Container(height: 1.h, color: palette.divider.withAlpha(120)),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 18.r,
                height: 18.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: palette.textMuted.withAlpha(110),
                    width: 1.w,
                  ),
                ),
              ),
              SizedBox(width: 9.w),
              Flexible(
                child: Text(
                  state.selectedSeason,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: palette.textPrimary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              for (var i = 0; i < state.summaryMetrics.length; i++) ...[
                Expanded(child: _SmallMetricCard(item: state.summaryMetrics[i])),
                if (i != state.summaryMetrics.length - 1) SizedBox(width: 10.w),
              ],
            ],
          ),
        ],
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
    final theme = Theme.of(context);
    final palette = AppColors.palette(theme.brightness);

    return Container(
      constraints: BoxConstraints(minHeight: isWide ? 58.h : 54.h),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: item.isHighlighted ? const Color(0xFF108B65) : Colors.white.withAlpha(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: 10.6.sp,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: palette.textMuted.withAlpha(175),
              fontSize: 9.sp,
              fontWeight: FontWeight.w500,
              height: 1.1,
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
    final theme = Theme.of(context);
    final palette = AppColors.palette(theme.brightness);

    return Container(
      constraints: BoxConstraints(minHeight: 58.h),
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: 10.8.sp,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: palette.textMuted.withAlpha(150),
              fontSize: 8.8.sp,
              fontWeight: FontWeight.w500,
              height: 1.1,
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
    final theme = Theme.of(context);
    final palette = AppColors.palette(theme.brightness);

    return Container(
      decoration: _cardDecoration(context),
      child: Column(
        children: [
          _CardHeader(title: 'Player traits'),
          SizedBox(
            height: 340.h,
            child: Stack(
              children: [
                Center(
                  child: CustomPaint(
                    size: Size(222.w, 222.w),
                    painter: _RadarPainter(
                      gridColor: palette.textMuted.withAlpha(52),
                      axisColor: palette.textMuted.withAlpha(36),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 28.h),
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
                                    color: palette.textMuted.withAlpha(170),
                                    fontSize: 8.7.sp,
                                    fontWeight: FontWeight.w700,
                                    height: 1.15,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  trait.value,
                                  style: TextStyle(
                                    color: const Color(0xFF14C89A),
                                    fontSize: 9.6.sp,
                                    fontWeight: FontWeight.w700,
                                    height: 1.1,
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
  final Color gridColor;
  final Color axisColor;

  const _RadarPainter({
    required this.gridColor,
    required this.axisColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.42;
    final ringPaint = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final axisPaint = Paint()
      ..color = axisColor
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
      Paint()..color = const Color(0xFF0DB488).withAlpha(64),
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
  bool shouldRepaint(covariant _RadarPainter oldDelegate) {
    return oldDelegate.gridColor != gridColor || oldDelegate.axisColor != axisColor;
  }
}

class _TrophiesCard extends StatelessWidget {
  final List<PlayerProfileTrophyUiModel> items;

  const _TrophiesCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration(context),
      child: Column(
        children: [
          const _CardHeader(title: 'Trophies'),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
            child: Column(
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  _TrophyItem(item: items[i]),
                  if (i != items.length - 1) SizedBox(height: 10.h),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrophyItem extends StatelessWidget {
  final PlayerProfileTrophyUiModel item;

  const _TrophyItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppColors.palette(theme.brightness);

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
              SeedCircleAvatar(
                seed: item.seed,
                size: 22,
                fontSize: 9,
                borderColor: const Color(0xFF84F3D0),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: palette.textPrimary,
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      item.country,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: palette.textMuted,
                        fontSize: 8.6.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(height: 1.h, color: palette.divider.withAlpha(120)),
          SizedBox(height: 12.h),
          Row(
            children: [
              SeedCircleAvatar(
                seed: '',
                size: 18,
                fontSize: 8,
                borderColor: palette.textMuted.withAlpha(110),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  item.season,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: palette.textPrimary,
                    fontSize: 10.2.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                item.result,
                style: TextStyle(
                  color: palette.textPrimary,
                  fontSize: 10.4.sp,
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
    final theme = Theme.of(context);
    final palette = AppColors.palette(theme.brightness);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
        color: palette.textHint.withAlpha(60),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: palette.textPrimary,
          fontSize: 11.5.sp,
          fontWeight: FontWeight.w700,
          height: 1.1,
        ),
      ),
    );
  }
}

BoxDecoration _cardDecoration(BuildContext context) {
  final theme = Theme.of(context);
  final palette = AppColors.palette(theme.brightness);

  return BoxDecoration(
    borderRadius: BorderRadius.circular(22.r),
    color: palette.surface,
    border: Border.all(
      color: palette.divider.withAlpha(85),
      width: 1.w,
    ),
  );
}