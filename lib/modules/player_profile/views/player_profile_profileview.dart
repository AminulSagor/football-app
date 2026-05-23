// lib/modules/player_profile/views/player_profile_profileview.dart

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/themes/app_colors.dart';
import '../../../core/widgets/following_ui.dart';
import '../model/player_profile_model.dart';
import '../player_profile_controller.dart';
import 'widgets/player_profile_network_avatar.dart';

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
              PlayerProfileNetworkAvatar(
                imageUrl: state.leagueLogoUrl.isNotEmpty
                    ? state.leagueLogoUrl
                    : state.leagueFlagUrl,
                seed: state.leagueName.isNotEmpty
                    ? state.leagueName
                    : state.teamName,
                size: 18,
                fontSize: 6.5,
                borderColor: palette.textMuted.withAlpha(110),
                backgroundColor: Colors.white,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 9.w),
              Flexible(
                child: Text(
                  state.leagueName.isEmpty
                      ? state.selectedSeason
                      : '${state.selectedSeason} • ${state.leagueName}',
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
                Expanded(
                  child: _SmallMetricCard(item: state.summaryMetrics[i]),
                ),
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
        color: item.isHighlighted
            ? const Color(0xFF108B65)
            : Colors.white.withAlpha(8),
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
    final radarValues = _buildRadarValues(traits);

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
                      values: radarValues,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 28.h,
                    ),
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

List<double> _buildRadarValues(List<PlayerProfileTraitUiModel> traits) {
  final values = List<double>.filled(6, 0.0);

  for (final trait in traits) {
    final index = _alignmentIndex(trait.alignment);
    if (index == null) continue;

    values[index] = _parseTraitPercent(trait.value);
  }

  return values;
}

int? _alignmentIndex(Alignment alignment) {
  // Painter angle order:
  // 0 = right, 1 = bottom-right, 2 = bottom-left,
  // 3 = left, 4 = top-left, 5 = top-right.
  if (alignment == Alignment.centerRight) return 0;
  if (alignment == Alignment.bottomRight) return 1;
  if (alignment == Alignment.bottomLeft) return 2;
  if (alignment == Alignment.centerLeft) return 3;
  if (alignment == Alignment.topLeft) return 4;
  if (alignment == Alignment.topRight) return 5;

  return null;
}

double _parseTraitPercent(String value) {
  final cleaned = value.replaceAll('%', '').trim();
  final parsed = double.tryParse(cleaned);

  if (parsed == null) return 0.0;

  if (value.contains('%')) {
    return (parsed / 100).clamp(0.0, 1.0).toDouble();
  }

  if (parsed <= 1.0) {
    return parsed.clamp(0.0, 1.0).toDouble();
  }

  return (parsed / 100).clamp(0.0, 1.0).toDouble();
}

class _RadarPainter extends CustomPainter {
  final Color gridColor;
  final Color axisColor;
  final List<double> values;

  const _RadarPainter({
    required this.gridColor,
    required this.axisColor,
    required this.values,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.42;
    final ringPaint = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final axisPaint = Paint()
      ..color = axisColor
      ..strokeWidth = 1;
    final fillPaint = Paint()
      ..color = const Color(0xFF0DB488).withAlpha(56)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = const Color(0xFF0DB488)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    final dotPaint = Paint()..color = const Color(0xFF14C89A);
    final dotGlowPaint = Paint()..color = const Color(0xFF14C89A).withAlpha(90);
    final dotRadius = size.width * 0.012;
    final dotGlowRadius = dotRadius * 1.8;

    const sides = 6;
    const startAngle = 0.0;
    final safeValues = _normalizeValues(values, sides);

    for (var ring = 1; ring <= 4; ring++) {
      final path = Path();
      for (var i = 0; i < sides; i++) {
        final angle = startAngle + (2 * math.pi * i / sides);
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
      final angle = startAngle + (2 * math.pi * i / sides);
      final point = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
      canvas.drawLine(center, point, axisPaint);
    }
    final fillPath = Path();
    final points = <Offset>[];
    for (var i = 0; i < sides; i++) {
      final angle = startAngle + (2 * math.pi * i / sides);
      final point = Offset(
        center.dx + math.cos(angle) * radius * safeValues[i],
        center.dy + math.sin(angle) * radius * safeValues[i],
      );
      points.add(point);
      if (i == 0) {
        fillPath.moveTo(point.dx, point.dy);
      } else {
        fillPath.lineTo(point.dx, point.dy);
      }
    }
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(fillPath, strokePaint);

    for (var i = 0; i < points.length; i++) {
      if (safeValues[i] <= 0) continue;
      canvas.drawCircle(points[i], dotGlowRadius, dotGlowPaint);
      canvas.drawCircle(points[i], dotRadius, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) {
    if (oldDelegate.gridColor != gridColor ||
        oldDelegate.axisColor != axisColor) {
      return true;
    }

    if (oldDelegate.values.length != values.length) return true;

    for (var i = 0; i < values.length; i++) {
      if (oldDelegate.values[i] != values[i]) return true;
    }

    return false;
  }
}

List<double> _normalizeValues(List<double> values, int sides) {
  final normalized = List<double>.filled(sides, 0.0);
  final length = values.length < sides ? values.length : sides;

  for (var i = 0; i < length; i++) {
    final value = values[i];
    normalized[i] = value.isNaN ? 0.0 : value.clamp(0.0, 1.0).toDouble();
  }

  return normalized;
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
    border: Border.all(color: palette.divider.withAlpha(85), width: 1.w),
  );
}
