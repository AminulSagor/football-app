import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../themes/app_text_styles.dart';
import '../model/knockout_page_ui_model.dart';
import 'package:fotgram/core/widgets/app_cached_network_image.dart';

class SharedKnockoutPage extends StatelessWidget {
  final SharedKnockoutUiModel knockout;

  const SharedKnockoutPage({super.key, required this.knockout});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 80.h),
      child: Center(child: _KnockoutBracketCanvas(knockout: knockout)),
    );
  }
}

class _KnockoutBracketCanvas extends StatelessWidget {
  final SharedKnockoutUiModel knockout;

  const _KnockoutBracketCanvas({required this.knockout});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double canvasWidth = 358.w;

    final bool hasBottomSide =
        knockout.bottomRoundOne.isNotEmpty ||
        knockout.bottomRoundTwo.isNotEmpty ||
        !knockout.lowerCenter.isPlaceholder;

    final double topCardWidth = 83.w;
    final double topCardHeight = 74.h;
    final double semiCardWidth = 124.w;
    final double semiCardHeight = 78.h;
    final double centerCardWidth = 160.w;
    final double centerCardHeight = 98.h;
    final double finalCardWidth = 160.w;
    final double finalCardHeight = 118.h;
    final double championWidth = 72.w;
    final double championHeight = 154.h;

    final List<Offset> topRoundOnePositions = [
      Offset(0.w, 0.h),
      Offset(91.w, 0.h),
      Offset(182.w, 0.h),
      Offset(273.w, 0.h),
    ];

    final List<Offset> topRoundTwoPositions = [
      Offset(20.w, 112.h),
      Offset(214.w, 112.h),
    ];

    final Offset upperCenterPosition = Offset(99.w, 236.h);
    final Offset finalCenterPosition = Offset(99.w, 366.h);
    final Offset championPosition = Offset(286.w, 348.h);

    final Offset lowerCenterPosition = Offset(99.w, 516.h);

    final List<Offset> bottomRoundTwoPositions = [
      Offset(20.w, 692.h),
      Offset(214.w, 692.h),
    ];

    final List<Offset> bottomRoundOnePositions = [
      Offset(0.w, 826.h),
      Offset(91.w, 826.h),
      Offset(182.w, 826.h),
      Offset(273.w, 826.h),
    ];

    final double canvasHeight = hasBottomSide ? 866.h : 516.h;

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
              bottomRoundTwoPositions: hasBottomSide
                  ? bottomRoundTwoPositions
                  : const <Offset>[],
              bottomRoundOnePositions: hasBottomSide
                  ? bottomRoundOnePositions
                  : const <Offset>[],
              upperCenterPosition: upperCenterPosition,
              finalCenterPosition: finalCenterPosition,
              lowerCenterPosition: hasBottomSide
                  ? lowerCenterPosition
                  : Offset.zero,
              topCardSize: Size(topCardWidth, topCardHeight),
              semiCardSize: Size(semiCardWidth, semiCardHeight),
              centerCardSize: Size(centerCardWidth, centerCardHeight),
              finalCardSize: Size(finalCardWidth, finalCardHeight),
              hasBottomSide: hasBottomSide,
              strokeColor: theme.colorScheme.onSurface.withAlpha(38),
            ),
          ),

          for (int i = 0; i < knockout.topRoundOne.length && i < 4; i++)
            Positioned(
              left: topRoundOnePositions[i].dx,
              top: topRoundOnePositions[i].dy,
              child: _RoundOneCard(
                node: knockout.topRoundOne[i],
                width: topCardWidth,
                height: topCardHeight,
              ),
            ),

          for (int i = 0; i < knockout.topRoundTwo.length && i < 2; i++)
            Positioned(
              left: topRoundTwoPositions[i].dx,
              top: topRoundTwoPositions[i].dy,
              child: _RoundTwoCard(
                node: knockout.topRoundTwo[i],
                width: semiCardWidth,
                height: semiCardHeight,
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
              width: finalCardWidth,
              height: finalCardHeight,
              isFinal: true,
            ),
          ),

          Positioned(
            left: championPosition.dx,
            top: championPosition.dy,
            child: _ChampionBlock(
              width: championWidth,
              height: championHeight,
              championLogoUrl: knockout.championLogoUrl,
              championSeed: knockout.championSeed,
            ),
          ),

          if (hasBottomSide)
            Positioned(
              left: lowerCenterPosition.dx,
              top: lowerCenterPosition.dy,
              child: _CenterMatchCard(
                item: knockout.lowerCenter,
                width: centerCardWidth,
                height: centerCardHeight,
              ),
            ),

          if (hasBottomSide)
            for (int i = 0; i < knockout.bottomRoundTwo.length && i < 2; i++)
              Positioned(
                left: bottomRoundTwoPositions[i].dx,
                top: bottomRoundTwoPositions[i].dy,
                child: _RoundTwoCard(
                  node: knockout.bottomRoundTwo[i],
                  width: semiCardWidth,
                  height: semiCardHeight,
                ),
              ),

          if (hasBottomSide)
            for (int i = 0; i < knockout.bottomRoundOne.length && i < 4; i++)
              Positioned(
                left: bottomRoundOnePositions[i].dx,
                top: bottomRoundOnePositions[i].dy,
                child: _RoundOneCard(
                  node: knockout.bottomRoundOne[i],
                  width: topCardWidth,
                  height: topCardHeight,
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
  final Size finalCardSize;
  final bool hasBottomSide;
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
    required this.finalCardSize,
    required this.hasBottomSide,
    required this.strokeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = strokeColor
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    Offset topCenter(Offset card, Size cardSize) =>
        Offset(card.dx + cardSize.width / 2, card.dy);
    Offset bottomCenter(Offset card, Size cardSize) =>
        Offset(card.dx + cardSize.width / 2, card.dy + cardSize.height);

    void drawPairToTarget({
      required Offset leftSource,
      required Offset rightSource,
      required Size sourceSize,
      required Offset target,
      required Size targetSize,
    }) {
      final leftBottom = bottomCenter(leftSource, sourceSize);
      final rightBottom = bottomCenter(rightSource, sourceSize);
      final targetTop = topCenter(target, targetSize);
      final joinY = leftBottom.dy + ((targetTop.dy - leftBottom.dy) * 0.48);
      final minX = [
        leftBottom.dx,
        rightBottom.dx,
        targetTop.dx,
      ].reduce((a, b) => a < b ? a : b);
      final maxX = [
        leftBottom.dx,
        rightBottom.dx,
        targetTop.dx,
      ].reduce((a, b) => a > b ? a : b);

      canvas.drawLine(leftBottom, Offset(leftBottom.dx, joinY), paint);
      canvas.drawLine(rightBottom, Offset(rightBottom.dx, joinY), paint);
      canvas.drawLine(Offset(minX, joinY), Offset(maxX, joinY), paint);
      canvas.drawLine(Offset(targetTop.dx, joinY), targetTop, paint);
    }

    void drawTargetsToPair({
      required Offset source,
      required Size sourceSize,
      required Offset leftTarget,
      required Offset rightTarget,
      required Size targetSize,
    }) {
      final sourceBottom = bottomCenter(source, sourceSize);
      final leftTop = topCenter(leftTarget, targetSize);
      final rightTop = topCenter(rightTarget, targetSize);
      final joinY = sourceBottom.dy + ((leftTop.dy - sourceBottom.dy) * 0.52);

      canvas.drawLine(sourceBottom, Offset(sourceBottom.dx, joinY), paint);
      canvas.drawLine(
        Offset(leftTop.dx, joinY),
        Offset(rightTop.dx, joinY),
        paint,
      );
      canvas.drawLine(Offset(leftTop.dx, joinY), leftTop, paint);
      canvas.drawLine(Offset(rightTop.dx, joinY), rightTop, paint);
    }

    if (topRoundOnePositions.length >= 4 && topRoundTwoPositions.length >= 2) {
      drawPairToTarget(
        leftSource: topRoundOnePositions[0],
        rightSource: topRoundOnePositions[1],
        sourceSize: topCardSize,
        target: topRoundTwoPositions[0],
        targetSize: semiCardSize,
      );
      drawPairToTarget(
        leftSource: topRoundOnePositions[2],
        rightSource: topRoundOnePositions[3],
        sourceSize: topCardSize,
        target: topRoundTwoPositions[1],
        targetSize: semiCardSize,
      );
    }

    if (topRoundTwoPositions.length >= 2) {
      drawPairToTarget(
        leftSource: topRoundTwoPositions[0],
        rightSource: topRoundTwoPositions[1],
        sourceSize: semiCardSize,
        target: upperCenterPosition,
        targetSize: centerCardSize,
      );
    }

    canvas.drawLine(
      bottomCenter(upperCenterPosition, centerCardSize),
      topCenter(finalCenterPosition, finalCardSize),
      paint,
    );

    if (hasBottomSide) {
      canvas.drawLine(
        bottomCenter(finalCenterPosition, finalCardSize),
        topCenter(lowerCenterPosition, centerCardSize),
        paint,
      );

      if (bottomRoundTwoPositions.length >= 2) {
        drawTargetsToPair(
          source: lowerCenterPosition,
          sourceSize: centerCardSize,
          leftTarget: bottomRoundTwoPositions[0],
          rightTarget: bottomRoundTwoPositions[1],
          targetSize: semiCardSize,
        );
      }

      if (bottomRoundTwoPositions.length >= 2 &&
          bottomRoundOnePositions.length >= 4) {
        drawTargetsToPair(
          source: bottomRoundTwoPositions[0],
          sourceSize: semiCardSize,
          leftTarget: bottomRoundOnePositions[0],
          rightTarget: bottomRoundOnePositions[1],
          targetSize: topCardSize,
        );
        drawTargetsToPair(
          source: bottomRoundTwoPositions[1],
          sourceSize: semiCardSize,
          leftTarget: bottomRoundOnePositions[2],
          rightTarget: bottomRoundOnePositions[3],
          targetSize: topCardSize,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BracketPainter oldDelegate) =>
      oldDelegate.strokeColor != strokeColor ||
      oldDelegate.hasBottomSide != hasBottomSide;
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
            color: theme.shadowColor.withAlpha(16),
            blurRadius: 8.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _NodeCircle(size: 18, logoUrl: node.homeLogoUrl),
              SizedBox(width: 21.w),
              _NodeCircle(size: 18, logoUrl: node.awayLogoUrl),
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
      padding: EdgeInsets.fromLTRB(12.w, 6.h, 12.w, 6.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: theme.colorScheme.onSurface.withAlpha(14),
          width: 1.w,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _NodeCircle(size: 22, logoUrl: node.homeLogoUrl),
              SizedBox(width: 34.w),
              _NodeCircle(size: 22, logoUrl: node.awayLogoUrl),
            ],
          ),
          SizedBox(height: 5.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _MediumSeedText(node.homeSeed),
              SizedBox(width: 22.w),
              _MediumSeedText(node.awaySeed),
            ],
          ),
          SizedBox(height: 5.h),
          SizedBox(
            width: width - 24.w,
            height: 13.h,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                node.score,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: AppTextStyles.sizeLabel.sp,
                  height: 1,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
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
    const finalAccent = Color(0xFFFFC400);
    final borderColor = highlight
        ? finalAccent
        : theme.colorScheme.onSurface.withAlpha(14);

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.fromLTRB(16.w, 7.h, 16.w, 7.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor, width: highlight ? 1.4.w : 1.w),
        boxShadow: highlight
            ? [
                BoxShadow(
                  color: finalAccent.withAlpha(24),
                  blurRadius: 16.r,
                  offset: Offset(0, 5.h),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CenterCircle(logoUrl: item.homeLogoUrl),
              SizedBox(width: 24.w),
              _CenterCircle(logoUrl: item.awayLogoUrl),
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CenterSeedText(item.homeSeed),
              SizedBox(width: 28.w),
              _CenterSeedText(item.awaySeed),
            ],
          ),
          SizedBox(height: 5.h),
          SizedBox(
            width: width - 32.w,
            height: 14.h,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                item.dateLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: AppTextStyles.sizeLabel.sp,
                  height: 1,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          if (highlight) ...[
            SizedBox(height: 5.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: finalAccent,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  item.statusLabel.isEmpty ? 'FINAL' : item.statusLabel,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: AppTextStyles.sizeCaption.sp,
                    fontWeight: FontWeight.w900,
                    height: 1,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ChampionBlock extends StatelessWidget {
  final double width;
  final double height;
  final String championLogoUrl;
  final String championSeed;

  const _ChampionBlock({
    required this.width,
    required this.height,
    this.championLogoUrl = '',
    this.championSeed = '?',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: width,
      height: height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ChampionAvatar(
            logoUrl: championLogoUrl,
            fallbackText: championSeed.trim().isEmpty ? '?' : championSeed,
          ),
          SizedBox(height: 6.h),
          Icon(
            Icons.emoji_events,
            color: theme.colorScheme.onSurface,
            size: 48.r,
          ),
          SizedBox(height: 6.h),
          Text(
            'CHAMPION',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withAlpha(170),
              fontSize: AppTextStyles.sizeTiny.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChampionAvatar extends StatelessWidget {
  final String logoUrl;
  final String fallbackText;

  const _ChampionAvatar({required this.logoUrl, required this.fallbackText});

  @override
  Widget build(BuildContext context) {
    final hasLogo = logoUrl.trim().isNotEmpty;
    final theme = Theme.of(context);

    return Container(
      width: 34.r,
      height: 34.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: hasLogo
            ? Colors.transparent
            : theme.colorScheme.onSurface.withAlpha(18),
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: hasLogo
          ? AppCachedNetworkImage(
              imageUrl: logoUrl,
              width: 34.r,
              height: 34.r,
              fit: BoxFit.contain,
              errorBuilder: (context) => _QuestionMark(text: fallbackText),
            )
          : _QuestionMark(text: fallbackText),
    );
  }
}

class _QuestionMark extends StatelessWidget {
  final String text;

  const _QuestionMark({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text == '?' ? '?' : text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
        fontSize:
            (text == '?' ? AppTextStyles.sizeBodyLarge : AppTextStyles.sizeTiny)
                .sp,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _NodeCircle extends StatelessWidget {
  final double size;
  final String logoUrl;

  const _NodeCircle({required this.size, this.logoUrl = ''});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasLogo = logoUrl.trim().isNotEmpty;

    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: hasLogo ? Colors.transparent : null,
        border: hasLogo
            ? null
            : Border.all(
                color: theme.colorScheme.onSurface.withAlpha(70),
                width: 1.1.w,
              ),
      ),
      clipBehavior: Clip.antiAlias,
      child: hasLogo
          ? AppCachedNetworkImage(
              imageUrl: logoUrl,
              fit: BoxFit.contain,
              width: size.r,
              height: size.r,
              errorBuilder: (context) => const SizedBox.shrink(),
            )
          : null,
    );
  }
}

class _CenterCircle extends StatelessWidget {
  final String logoUrl;

  const _CenterCircle({this.logoUrl = ''});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasLogo = logoUrl.trim().isNotEmpty;

    return Container(
      width: 34.r,
      height: 34.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: hasLogo
            ? Colors.transparent
            : theme.colorScheme.onSurface.withAlpha(14),
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: hasLogo
          ? AppCachedNetworkImage(
              imageUrl: logoUrl,
              fit: BoxFit.contain,
              errorBuilder: (context) => const SizedBox.shrink(),
            )
          : Text(
              '?',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withAlpha(150),
                fontSize: AppTextStyles.sizeBody.sp,
                fontWeight: FontWeight.w800,
              ),
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
      width: 34.w,
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

    return SizedBox(
      width: 38.w,
      child: Text(
        text,
        maxLines: 1,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: theme.colorScheme.onSurface.withAlpha(160),
          fontSize: AppTextStyles.sizeBodySmall.sp,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}
