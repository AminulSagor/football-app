import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../match_details_controller.dart';
import '../models/match_details_model.dart';

class MatchDetailsLineupPage extends GetView<MatchDetailsController> {
  const MatchDetailsLineupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final lineup = controller.state.value.lineup;

      return ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 28.h),
        children: [
          _LineupPitchCard(lineup: lineup),
          SizedBox(height: 22.h),
          _LineupPeopleCard(title: 'Coach', people: lineup.coaches),
          SizedBox(height: 22.h),
          _LineupPeopleCard(title: 'Substitutes', people: lineup.substitutes),
          SizedBox(height: 22.h),
          _LineupPeopleCard(title: 'Bench', people: lineup.bench),
        ],
      );
    });
  }
}

class _LineupPitchCard extends StatelessWidget {
  final MatchDetailsLineupUiModel lineup;

  const _LineupPitchCard({required this.lineup});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppColors.palette(theme.brightness);

    return Container(
      decoration: _cardDecoration(context),
      child: Column(
        children: [
          _TeamStrip(
            teamName: lineup.home.teamName,
            formation: lineup.home.formation,
            isTop: true,
          ),
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: palette.border.withAlpha(130), width: 0.6.w),
                bottom: BorderSide(color: palette.border.withAlpha(130), width: 0.6.w),
              ),
            ),
            child: AspectRatio(
              aspectRatio: 0.38,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                palette.surfaceSoft.withAlpha(130),
                                palette.inputFill,
                              ],
                            ),
                          ),
                        ),
                      ),
                      CustomPaint(
                        size: Size(constraints.maxWidth, constraints.maxHeight),
                        painter: _FullPitchPainter(
                          lineColor: palette.borderMuted.withAlpha(170),
                        ),
                      ),
                      for (final player in lineup.home.players)
                        _PitchPlayer(
                          x: player.x,
                          y: _mapHomeY(player.y),
                          name: player.name,
                          labelColor: palette.textPrimary,
                          circleColor: palette.primarySoft,
                        ),
                      for (final player in lineup.away.players)
                        _PitchPlayer(
                          x: player.x,
                          y: _mapAwayY(player.y),
                          name: player.name,
                          labelColor: palette.textPrimary,
                          circleColor: palette.primarySoft,
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
          _TeamStrip(
            teamName: lineup.away.teamName,
            formation: lineup.away.formation,
            isBottom: true,
          ),
        ],
      ),
    );
  }

  double _mapHomeY(double y) {
    return 0.06 + (y * 0.58);
  }

  double _mapAwayY(double y) {
    return 0.55 + (y * 0.34);
  }
}

class _TeamStrip extends StatelessWidget {
  final String teamName;
  final String formation;
  final bool isTop;
  final bool isBottom;

  const _TeamStrip({
    required this.teamName,
    required this.formation,
    this.isTop = false,
    this.isBottom = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppColors.palette(theme.brightness);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            palette.surfaceMuted.withAlpha(235),
            palette.surface.withAlpha(210),
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isTop ? 16.r : 0),
          topRight: Radius.circular(isTop ? 16.r : 0),
          bottomLeft: Radius.circular(isBottom ? 16.r : 0),
          bottomRight: Radius.circular(isBottom ? 16.r : 0),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 24.r,
            height: 24.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: palette.primarySoft, width: 1.2.w),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              teamName,
              style: TextStyle(
                color: palette.textPrimary,
                fontSize: AppTextStyles.sizeBody.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: palette.primarySoft,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Text(
              formation,
              style: TextStyle(
                color: const Color(0xFF0B0F0D),
                fontSize: AppTextStyles.sizeBodySmall.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PitchPlayer extends StatelessWidget {
  final double x;
  final double y;
  final String name;
  final Color labelColor;
  final Color circleColor;

  const _PitchPlayer({
    required this.x,
    required this.y,
    required this.name,
    required this.labelColor,
    required this.circleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final circleSize = 40.r;
          final left = (constraints.maxWidth * x) - (circleSize / 2);
          final top = (constraints.maxHeight * y) - (circleSize / 2);

          return Stack(
            children: [
              Positioned(
                left: left.clamp(0, constraints.maxWidth - circleSize),
                top: top.clamp(0, constraints.maxHeight - (circleSize + 24.h)),
                child: SizedBox(
                  width: 58.w,
                  child: Column(
                    children: [
                      Container(
                        width: circleSize,
                        height: circleSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: circleColor, width: 1.3.w),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        name,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: labelColor,
                          fontSize: AppTextStyles.sizeCaption.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LineupPeopleCard extends StatelessWidget {
  final String title;
  final List<MatchDetailsLineupPlayerUiModel> people;

  const _LineupPeopleCard({
    required this.title,
    required this.people,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppColors.palette(theme.brightness);

    return Container(
      decoration: _cardDecoration(context),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  palette.surfaceMuted.withAlpha(230),
                  palette.surface.withAlpha(205),
                ],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: palette.textPrimary,
                fontSize: AppTextStyles.sizeBodySmall.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 18.h),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              runSpacing: 24.h,
              spacing: 24.w,
              children: people
                  .map(
                    (person) => SizedBox(
                      width: 118.w,
                      child: Column(
                        children: [
                          Container(
                            width: 40.r,
                            height: 40.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: palette.primarySoft,
                                width: 1.2.w,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            person.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: palette.textPrimary,
                              fontSize: AppTextStyles.sizeBodySmall.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (person.subtitle.isNotEmpty) ...[
                            SizedBox(height: 2.h),
                            Text(
                              person.subtitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: palette.textSubtle,
                                fontSize: AppTextStyles.sizeCaption.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
        ],
      ),
    );
  }
}

class _FullPitchPainter extends CustomPainter {
  final Color lineColor;

  const _FullPitchPainter({required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final midY = size.height / 2;
    final center = Offset(size.width / 2, midY);
    final radius = size.width * 0.13;

    canvas.drawRect(Offset.zero & size, paint);
    canvas.drawLine(Offset(0, midY), Offset(size.width, midY), paint);
    canvas.drawCircle(center, radius, paint);

    final penaltyWidth = size.width * 0.46;
    final penaltyX = (size.width - penaltyWidth) / 2;
    final penaltyHeight = size.height * 0.16;

    canvas.drawRect(
      Rect.fromLTWH(penaltyX, 0, penaltyWidth, penaltyHeight),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(penaltyX, size.height - penaltyHeight, penaltyWidth, penaltyHeight),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _FullPitchPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor;
  }
}

BoxDecoration _cardDecoration(BuildContext context) {
  final theme = Theme.of(context);
  final palette = AppColors.palette(theme.brightness);

  return BoxDecoration(
    borderRadius: BorderRadius.circular(16.r),
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        palette.surface.withAlpha(245),
        palette.inputFill.withAlpha(245),
      ],
    ),
    border: Border.all(color: palette.border.withAlpha(145), width: 1.w),
  );
}
