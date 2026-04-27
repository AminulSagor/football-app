import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/themes/app_text_styles.dart';
import 'model/knockout_page_ui_model.dart';

class SharedKnockoutPage extends StatelessWidget {
  final SharedKnockoutUiModel knockout;

  const SharedKnockoutPage({
    super.key,
    required this.knockout,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 28.h),
      child: Center(
        child: _KnockoutBracketCanvas(knockout: knockout),
      ),
    );
  }
}

class _KnockoutBracketCanvas extends StatelessWidget {
  final SharedKnockoutUiModel knockout;

  const _KnockoutBracketCanvas({
    required this.knockout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double canvasWidth = 358.w;
    final double canvasHeight = 1248.h;

    final double topCardWidth = 83.w;
    final double topCardHeight = 74.h;

    final double semiCardWidth = 118.w;
    final double semiCardHeight = 78.h;

    final double centerCardWidth = 160.w;
    final double centerCardHeight = 102.h;

    final double championWidth = 72.w;
    final double championHeight = 106.h;

    final List<Offset> topRoundOnePositions = [
      Offset(0.w, 18.h),
      Offset(91.w, 18.h),
      Offset(182.w, 18.h),
      Offset(273.w, 18.h),
      Offset(0.w, 107.h),
      Offset(91.w, 107.h),
      Offset(182.w, 107.h),
      Offset(273.w, 107.h),
    ];

    final List<Offset> topRoundTwoPositions = [
      Offset(22.w, 244.h),
      Offset(205.w, 244.h),
    ];

    final List<Offset> bottomRoundTwoPositions = [
      Offset(22.w, 920.h),
      Offset(205.w, 920.h),
    ];

    final List<Offset> bottomRoundOnePositions = [
      Offset(0.w, 1061.h),
      Offset(91.w, 1061.h),
      Offset(182.w, 1061.h),
      Offset(273.w, 1061.h),
      Offset(0.w, 1150.h),
      Offset(91.w, 1150.h),
      Offset(182.w, 1150.h),
      Offset(273.w, 1150.h),
    ];

    final Offset upperCenterPosition = Offset(99.w, 446.h);
    final Offset finalCenterPosition = Offset(99.w, 570.h);
    final Offset lowerCenterPosition = Offset(99.w, 694.h);
    final Offset championPosition = Offset(286.w, 592.h);

    return SizedBox(
      width: canvasWidth,
      height: canvasHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CustomPaint(
            size: Size(canvasWidth, canvasHeight),
            painter: _BracketPainter(
              topRoundOnePositions: topRoundOnePositions,
              topRoundTwoPositions: topRoundTwoPositions,
              bottomRoundTwoPositions: bottomRoundTwoPositions,
              bottomRoundOnePositions: bottomRoundOnePositions,
              upperCenterPosition: upperCenterPosition,
              finalCenterPosition: finalCenterPosition,
              lowerCenterPosition: lowerCenterPosition,
              topCardSize: Size(topCardWidth, topCardHeight),
              semiCardSize: Size(semiCardWidth, semiCardHeight),
              centerCardSize: Size(centerCardWidth, centerCardHeight),
              strokeColor: theme.colorScheme.onSurface.withAlpha(40),
            ),
          ),

          for (int i = 0;
              i < knockout.topRoundOne.length && i < topRoundOnePositions.length;
              i++)
            Positioned(
              left: topRoundOnePositions[i].dx,
              top: topRoundOnePositions[i].dy,
              child: _RoundOneCard(
                node: knockout.topRoundOne[i],
                width: topCardWidth,
                height: topCardHeight,
              ),
            ),

          for (int i = 0;
              i < knockout.topRoundTwo.length && i < topRoundTwoPositions.length;
              i++)
            Positioned(
              left: topRoundTwoPositions[i].dx,
              top: topRoundTwoPositions[i].dy,
              child: _RoundTwoCard(
                node: knockout.topRoundTwo[i],
                width: semiCardWidth,
                height: semiCardHeight,
              ),
            ),

          for (int i = 0;
              i < knockout.bottomRoundTwo.length &&
                  i < bottomRoundTwoPositions.length;
              i++)
            Positioned(
              left: bottomRoundTwoPositions[i].dx,
              top: bottomRoundTwoPositions[i].dy,
              child: _RoundTwoCard(
                node: knockout.bottomRoundTwo[i],
                width: semiCardWidth,
                height: semiCardHeight,
              ),
            ),

          for (int i = 0;
              i < knockout.bottomRoundOne.length &&
                  i < bottomRoundOnePositions.length;
              i++)
            Positioned(
              left: bottomRoundOnePositions[i].dx,
              top: bottomRoundOnePositions[i].dy,
              child: _RoundOneCard(
                node: knockout.bottomRoundOne[i],
                width: topCardWidth,
                height: topCardHeight,
              ),
            ),

          Positioned(
            left: upperCenterPosition.dx,
            top: upperCenterPosition.dy,
            child: _CenterMatchCard(
              item: knockout.upperCenter,
              width: centerCardWidth,
              height: centerCardHeight,
            ),
          ),

          Positioned(
            left: finalCenterPosition.dx,
            top: finalCenterPosition.dy,
            child: _CenterMatchCard(
              item: knockout.finalCenter,
              width: centerCardWidth,
              height: centerCardHeight,
              isFinal: true,
            ),
          ),

          Positioned(
            left: lowerCenterPosition.dx,
            top: lowerCenterPosition.dy,
            child: _CenterMatchCard(
              item: knockout.lowerCenter,
              width: centerCardWidth,
              height: centerCardHeight,
            ),
          ),

          Positioned(
            left: championPosition.dx,
            top: championPosition.dy,
            child: _ChampionBlock(
              width: championWidth,
              height: championHeight,
            ),
          ),
        ],
      ),
    );
  }
}

class _BracketPainter extends CustomPainter {
  final List<Offset> topRoundOnePositions;
  final List<Offset> topRoundTwoPositions;
  final List<Offset> bottomRoundTwoPositions;
  final List<Offset> bottomRoundOnePositions;
  final Offset upperCenterPosition;
  final Offset finalCenterPosition;
  final Offset lowerCenterPosition;
  final Size topCardSize;
  final Size semiCardSize;
  final Size centerCardSize;
  final Color strokeColor;

  const _BracketPainter({
    required this.topRoundOnePositions,
    required this.topRoundTwoPositions,
    required this.bottomRoundTwoPositions,
    required this.bottomRoundOnePositions,
    required this.upperCenterPosition,
    required this.finalCenterPosition,
    required this.lowerCenterPosition,
    required this.topCardSize,
    required this.semiCardSize,
    required this.centerCardSize,
    required this.strokeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = strokeColor
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    void drawTopPairConnector({
      required Offset topLeftCard,
      required Offset bottomLeftCard,
      required Offset targetCard,
      required bool toLeftHalf,
    }) {
      final xFromCards = topLeftCard.dx + (topCardSize.width / 2);
      final topBottomY = topLeftCard.dy + topCardSize.height;
      final bottomTopY = bottomLeftCard.dy;
      final midY = (topBottomY + bottomTopY) / 2;

      canvas.drawLine(
        Offset(xFromCards, topBottomY),
        Offset(xFromCards, midY),
        paint,
      );
      canvas.drawLine(
        Offset(xFromCards, bottomTopY),
        Offset(xFromCards, midY),
        paint,
      );

      final targetCenterX = targetCard.dx + (semiCardSize.width / 2);
      final targetTopY = targetCard.dy;

      final elbowX = toLeftHalf ? targetCenterX - 22.w : targetCenterX + 22.w;

      canvas.drawLine(
        Offset(xFromCards, midY),
        Offset(elbowX, midY),
        paint,
      );
      canvas.drawLine(
        Offset(elbowX, midY),
        Offset(elbowX, targetTopY - 18.h),
        paint,
      );
      canvas.drawLine(
        Offset(elbowX, targetTopY - 18.h),
        Offset(targetCenterX, targetTopY - 18.h),
        paint,
      );
      canvas.drawLine(
        Offset(targetCenterX, targetTopY - 18.h),
        Offset(targetCenterX, targetTopY),
        paint,
      );
    }

    drawTopPairConnector(
      topLeftCard: topRoundOnePositions[0],
      bottomLeftCard: topRoundOnePositions[4],
      targetCard: topRoundTwoPositions[0],
      toLeftHalf: true,
    );

    drawTopPairConnector(
      topLeftCard: topRoundOnePositions[1],
      bottomLeftCard: topRoundOnePositions[5],
      targetCard: topRoundTwoPositions[0],
      toLeftHalf: false,
    );

    drawTopPairConnector(
      topLeftCard: topRoundOnePositions[2],
      bottomLeftCard: topRoundOnePositions[6],
      targetCard: topRoundTwoPositions[1],
      toLeftHalf: true,
    );

    drawTopPairConnector(
      topLeftCard: topRoundOnePositions[3],
      bottomLeftCard: topRoundOnePositions[7],
      targetCard: topRoundTwoPositions[1],
      toLeftHalf: false,
    );

    void drawCenterConnector({
      required Offset sourceCard,
      required Size sourceSize,
      required Offset targetCard,
    }) {
      final sourceCenterX = sourceCard.dx + (sourceSize.width / 2);
      final sourceBottomY = sourceCard.dy + sourceSize.height;
      final targetCenterX = targetCard.dx + (centerCardSize.width / 2);
      final targetTopY = targetCard.dy;

      canvas.drawLine(
        Offset(sourceCenterX, sourceBottomY),
        Offset(sourceCenterX, sourceBottomY + 24.h),
        paint,
      );
      canvas.drawLine(
        Offset(sourceCenterX, sourceBottomY + 24.h),
        Offset(targetCenterX, sourceBottomY + 24.h),
        paint,
      );
      canvas.drawLine(
        Offset(targetCenterX, sourceBottomY + 24.h),
        Offset(targetCenterX, targetTopY),
        paint,
      );
    }

    drawCenterConnector(
      sourceCard: topRoundTwoPositions[0],
      sourceSize: semiCardSize,
      targetCard: upperCenterPosition,
    );

    drawCenterConnector(
      sourceCard: topRoundTwoPositions[1],
      sourceSize: semiCardSize,
      targetCard: upperCenterPosition,
    );

    final upperCenterX = upperCenterPosition.dx + (centerCardSize.width / 2);
    final upperCenterBottomY = upperCenterPosition.dy + centerCardSize.height;
    final finalCenterX = finalCenterPosition.dx + (centerCardSize.width / 2);
    final finalCenterTopY = finalCenterPosition.dy;

    canvas.drawLine(
      Offset(upperCenterX, upperCenterBottomY),
      Offset(finalCenterX, finalCenterTopY),
      paint,
    );

    final finalCenterBottomY = finalCenterPosition.dy + centerCardSize.height;
    final lowerCenterTopY = lowerCenterPosition.dy;

    canvas.drawLine(
      Offset(finalCenterX, finalCenterBottomY),
      Offset(finalCenterX, lowerCenterTopY),
      paint,
    );

    void drawLowerCenterConnector({
      required Offset sourceCard,
      required Offset targetCard,
    }) {
      final sourceCenterX = sourceCard.dx + (centerCardSize.width / 2);
      final sourceBottomY = sourceCard.dy + centerCardSize.height;
      final targetCenterX = targetCard.dx + (semiCardSize.width / 2);
      final targetTopY = targetCard.dy;

      canvas.drawLine(
        Offset(sourceCenterX, sourceBottomY),
        Offset(sourceCenterX, sourceBottomY + 24.h),
        paint,
      );
      canvas.drawLine(
        Offset(sourceCenterX, sourceBottomY + 24.h),
        Offset(targetCenterX, sourceBottomY + 24.h),
        paint,
      );
      canvas.drawLine(
        Offset(targetCenterX, sourceBottomY + 24.h),
        Offset(targetCenterX, targetTopY),
        paint,
      );
    }

    drawLowerCenterConnector(
      sourceCard: lowerCenterPosition,
      targetCard: bottomRoundTwoPositions[0],
    );

    drawLowerCenterConnector(
      sourceCard: lowerCenterPosition,
      targetCard: bottomRoundTwoPositions[1],
    );

    void drawBottomPairConnector({
      required Offset upperCard,
      required Offset lowerCard,
      required Offset targetCard,
      required bool toLeftHalf,
    }) {
      final xFromCards = upperCard.dx + (topCardSize.width / 2);
      final upperBottomY = upperCard.dy + topCardSize.height;
      final lowerTopY = lowerCard.dy;
      final midY = (upperBottomY + lowerTopY) / 2;

      canvas.drawLine(
        Offset(xFromCards, upperBottomY),
        Offset(xFromCards, midY),
        paint,
      );
      canvas.drawLine(
        Offset(xFromCards, lowerTopY),
        Offset(xFromCards, midY),
        paint,
      );

      final targetCenterX = targetCard.dx + (semiCardSize.width / 2);
      final targetBottomY = targetCard.dy + semiCardSize.height;
      final elbowY = targetBottomY + 18.h;
      final elbowX = toLeftHalf ? targetCenterX - 22.w : targetCenterX + 22.w;

      canvas.drawLine(
        Offset(xFromCards, midY),
        Offset(elbowX, midY),
        paint,
      );
      canvas.drawLine(
        Offset(elbowX, midY),
        Offset(elbowX, elbowY),
        paint,
      );
      canvas.drawLine(
        Offset(elbowX, elbowY),
        Offset(targetCenterX, elbowY),
        paint,
      );
      canvas.drawLine(
        Offset(targetCenterX, elbowY),
        Offset(targetCenterX, targetBottomY),
        paint,
      );
    }

    drawBottomPairConnector(
      upperCard: bottomRoundOnePositions[0],
      lowerCard: bottomRoundOnePositions[4],
      targetCard: bottomRoundTwoPositions[0],
      toLeftHalf: true,
    );

    drawBottomPairConnector(
      upperCard: bottomRoundOnePositions[1],
      lowerCard: bottomRoundOnePositions[5],
      targetCard: bottomRoundTwoPositions[0],
      toLeftHalf: false,
    );

    drawBottomPairConnector(
      upperCard: bottomRoundOnePositions[2],
      lowerCard: bottomRoundOnePositions[6],
      targetCard: bottomRoundTwoPositions[1],
      toLeftHalf: true,
    );

    drawBottomPairConnector(
      upperCard: bottomRoundOnePositions[3],
      lowerCard: bottomRoundOnePositions[7],
      targetCard: bottomRoundTwoPositions[1],
      toLeftHalf: false,
    );
  }

  @override
  bool shouldRepaint(covariant _BracketPainter oldDelegate) => false;
}

class _RoundOneCard extends StatelessWidget {
  final SharedKnockoutNodeUiModel node;
  final double width;
  final double height;

  const _RoundOneCard({
    required this.node,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.fromLTRB(8.w, 7.h, 8.w, 7.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: theme.colorScheme.onSurface.withAlpha(14),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha(18),
            blurRadius: 10.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: ClipRect(
        child: Align(
          alignment: Alignment.center,
          child: OverflowBox(
            alignment: Alignment.center,
            minWidth: 0,
            minHeight: 0,
            maxWidth: width - 16.w,
            maxHeight: double.infinity,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: width - 16.w,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const _NodeCircle(size: 18),
                      SizedBox(width: 22.w),
                      const _NodeCircle(size: 18),
                    ],
                  ),
                  SizedBox(height: 7.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ShortSeedText(node.homeSeed),
                      SizedBox(width: 12.w),
                      _ShortSeedText(node.awaySeed),
                    ],
                  ),
                  SizedBox(height: 7.h),
                  Text(
                    node.score,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: AppTextStyles.sizeLabel.sp,
                      height: 1,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoundTwoCard extends StatelessWidget {
  final SharedKnockoutNodeUiModel node;
  final double width;
  final double height;

  const _RoundTwoCard({
    required this.node,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: theme.colorScheme.onSurface.withAlpha(14),
          width: 1.w,
        ),
      ),
      child: ClipRect(
        child: Align(
          alignment: Alignment.center,
          child: OverflowBox(
            alignment: Alignment.center,
            minWidth: 0,
            minHeight: 0,
            maxWidth: width - 24.w,
            maxHeight: double.infinity,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: width - 24.w,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const _NodeCircle(size: 20),
                      SizedBox(width: 34.w),
                      const _NodeCircle(size: 20),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _MediumSeedText(node.homeSeed),
                      SizedBox(width: 18.w),
                      _MediumSeedText(node.awaySeed),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    node.score,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: AppTextStyles.sizeLabel.sp,
                      height: 1,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CenterMatchCard extends StatelessWidget {
  final SharedKnockoutCenterUiModel item;
  final double width;
  final double height;
  final bool isFinal;

  const _CenterMatchCard({
    required this.item,
    required this.width,
    required this.height,
    this.isFinal = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool highlight = isFinal || item.isFinalHighlight;
    final theme = Theme.of(context);

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: highlight
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withAlpha(14),
          width: highlight ? 1.2.w : 1.w,
        ),
      ),
      child: ClipRect(
        child: Align(
          alignment: Alignment.center,
          child: OverflowBox(
            alignment: Alignment.center,
            minWidth: 0,
            minHeight: 0,
            maxWidth: width - 32.w,
            maxHeight: double.infinity,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: width - 32.w,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const _CenterCircle(),
                      SizedBox(width: 20.w),
                      const _CenterCircle(),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const _CenterSeedText('TBD'),
                      SizedBox(width: 24.w),
                      const _CenterSeedText('TBD'),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    item.dateLabel,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withAlpha(135),
                      fontSize: AppTextStyles.sizeBodyLarge.sp,
                      height: 1,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (highlight) ...[
                    SizedBox(height: 10.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 11.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        item.statusLabel.isEmpty ? 'FINAL' : item.statusLabel,
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontSize: AppTextStyles.sizeCaption.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChampionBlock extends StatelessWidget {
  final double width;
  final double height;

  const _ChampionBlock({
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRect(
        child: Align(
          alignment: Alignment.center,
          child: OverflowBox(
            alignment: Alignment.center,
            minWidth: 0,
            minHeight: 0,
            maxWidth: width,
            maxHeight: double.infinity,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: width,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.emoji_events,
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 42.r,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'CHAMPION',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(
                        170,
                      ),
                      fontSize: AppTextStyles.sizeTiny.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NodeCircle extends StatelessWidget {
  final double size;

  const _NodeCircle({
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.colorScheme.onSurface.withAlpha(70),
          width: 1.1.w,
        ),
      ),
    );
  }
}

class _CenterCircle extends StatelessWidget {
  const _CenterCircle();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 32.r,
      height: 32.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.onSurface.withAlpha(12),
      ),
    );
  }
}

class _ShortSeedText extends StatelessWidget {
  final String text;

  const _ShortSeedText(this.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 24.w,
      child: Text(
        text,
        maxLines: 1,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: theme.colorScheme.onSurface.withAlpha(150),
          fontSize: AppTextStyles.sizeTiny.sp,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}

class _MediumSeedText extends StatelessWidget {
  final String text;

  const _MediumSeedText(this.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 30.w,
      child: Text(
        text,
        maxLines: 1,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: theme.colorScheme.onSurface.withAlpha(150),
          fontSize: AppTextStyles.sizeCaption.sp,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}

class _CenterSeedText extends StatelessWidget {
  final String text;

  const _CenterSeedText(this.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: theme.colorScheme.onSurface.withAlpha(160),
        fontSize: AppTextStyles.sizeBodySmall.sp,
        fontWeight: FontWeight.w700,
        height: 1,
      ),
    );
  }
}
