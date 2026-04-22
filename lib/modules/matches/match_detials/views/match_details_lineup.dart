import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/themes/app_text_styles.dart';
import '../match_details_controller.dart';
import '../match_details_model.dart';

class MatchDetailsLineupPage extends GetView<MatchDetailsController> {
  const MatchDetailsLineupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final lineup = controller.state.value.lineup;

      return ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
        children: [
          _LineupPitchCard(lineup: lineup),
          SizedBox(height: 18.h),
          _LineupPeopleCard(title: 'Coach', people: lineup.coaches),
          SizedBox(height: 18.h),
          _LineupPeopleCard(title: 'Substitutes', people: lineup.substitutes),
          SizedBox(height: 18.h),
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

    return Container(
      decoration: _cardDecoration(context),
      child: Column(
        children: [
          if (lineup.isPredicted)
            Padding(
              padding: EdgeInsets.only(top: 14.h),
              child: Text(
                'Predicted Lineup',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: AppTextStyles.sizeBody.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          _TeamStrip(
            teamName: lineup.home.teamName,
            formation: lineup.home.formation,
            topRadius: lineup.isPredicted,
          ),
          AspectRatio(
            aspectRatio: 0.82,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF0E1B1C), Color(0xFF111D1D)],
                ),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      CustomPaint(
                        size: Size(constraints.maxWidth, constraints.maxHeight),
                        painter: _PitchPainter(lineColor: theme.colorScheme.onSurface.withAlpha(25)),
                      ),
                      for (final player in lineup.home.players)
                        _PitchPlayer(
                          x: player.x,
                          y: player.y,
                          name: player.name,
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
          Container(height: 1.h, color: theme.colorScheme.onSurface.withAlpha(10)),
          AspectRatio(
            aspectRatio: 0.82,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF0E1B1C), Color(0xFF111D1D)],
                ),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      CustomPaint(
                        size: Size(constraints.maxWidth, constraints.maxHeight),
                        painter: _PitchBottomPainter(lineColor: theme.colorScheme.onSurface.withAlpha(25)),
                      ),
                      for (final player in lineup.away.players)
                        _PitchPlayer(
                          x: player.x,
                          y: player.y,
                          name: player.name,
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
}

class _TeamStrip extends StatelessWidget {
  final String teamName;
  final String formation;
  final bool isBottom;
  final bool topRadius;

  const _TeamStrip({
    required this.teamName,
    required this.formation,
    this.isBottom = false,
    this.topRadius = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withAlpha(7),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topRadius ? 18.r : 0),
          topRight: Radius.circular(topRadius ? 18.r : 0),
          bottomLeft: Radius.circular(isBottom ? 18.r : 0),
          bottomRight: Radius.circular(isBottom ? 18.r : 0),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 28.r,
            height: 28.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF20E0B4), width: 1.w),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
              child: Text(
              teamName,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: AppTextStyles.sizeBody.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: const Color(0xFF39D3A5),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Text(
              formation,
              style: TextStyle(
                color: Colors.black,
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

  const _PitchPlayer({
    required this.x,
    required this.y,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: null,
      right: null,
      top: null,
      bottom: null,
      child: LayoutBuilder(
        builder: (context, constraints) => const SizedBox.shrink(),
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

    return Container(
      decoration: _cardDecoration(context),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withAlpha(6),
              borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: AppTextStyles.sizeBodySmall.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 18.h),
            child: Wrap(
              alignment: WrapAlignment.spaceAround,
              runAlignment: WrapAlignment.spaceAround,
              spacing: 40.w,
              runSpacing: 28.h,
              children: people
                  .map(
                    (person) => SizedBox(
                      width: 100.w,
                      child: Column(
                        children: [
                          Container(
                            width: 48.r,
                            height: 48.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF20E0B4),
                                width: 1.w,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            person.name,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: AppTextStyles.sizeBodySmall.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (person.subtitle.isNotEmpty)
                            Text(
                              person.subtitle,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface.withAlpha(110),
                                fontSize: AppTextStyles.sizeCaption.sp,
                              ),
                            ),
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

class _PitchPainter extends CustomPainter {
  final Color lineColor;

  const _PitchPainter({this.lineColor = const Color(0xFFFFFFFF)});
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 1;

    final centerX = size.width / 2;

    canvas.drawRect(Offset.zero & size, linePaint..style = PaintingStyle.stroke);
    canvas.drawCircle(Offset(centerX, size.height), 48.r, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PitchBottomPainter extends CustomPainter {
  final Color lineColor;

  const _PitchBottomPainter({this.lineColor = const Color(0xFFFFFFFF)});
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    canvas.drawRect(Offset.zero & size, linePaint);
    canvas.drawCircle(Offset(centerX, 0), 48.r, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PitchPlayerMarker extends StatelessWidget {
  final double x;
  final double y;
  final String name;

  const _PitchPlayerMarker({
    required this.x,
    required this.y,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Positioned(
                left: constraints.maxWidth * x - 24.r,
                top: constraints.maxHeight * y - 24.r,
                child: Column(
                  children: [
                    Container(
                      width: 48.r,
                      height: 48.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF20E0B4), width: 1.w),
                      ),
                    ),
                    SizedBox(height: 6.h),
                      SizedBox(
                      width: 70.w,
                      child: Text(
                        name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: AppTextStyles.sizeCaption.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PitchStack extends StatelessWidget {
  final List<MatchDetailsLineupPlayerUiModel> players;
  final bool isTop;

  const _PitchStack({
    required this.players,
    required this.isTop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: players
              .map(
                (player) => Positioned(
                  left: constraints.maxWidth * player.x - 24.r,
                  top: constraints.maxHeight * player.y - 24.r,
                  child: Column(
                    children: [
                      Container(
                        width: 48.r,
                        height: 48.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF20E0B4),
                            width: 1.w,
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        player.name,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: AppTextStyles.sizeCaption.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(growable: false),
        );
      },
    );
  }
}

class _PitchArea extends StatelessWidget {
  final List<MatchDetailsLineupPlayerUiModel> players;
  final bool isTop;

  const _PitchArea({
    required this.players,
    required this.isTop,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420.h,
      child: Stack(
        children: [
          for (final player in players)
            _PitchPlayerMarker(
              x: player.x,
              y: player.y,
              name: player.name,
            ),
        ],
      ),
    );
  }
}

BoxDecoration _cardDecoration(BuildContext context) {
  final theme = Theme.of(context);

  return BoxDecoration(
    borderRadius: BorderRadius.circular(18.r),
    gradient: const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xFF0E1A1C), Color(0xFF111B1D)],
    ),
    border: Border.all(color: theme.colorScheme.onSurface.withAlpha(14), width: 1.w),
  );
}