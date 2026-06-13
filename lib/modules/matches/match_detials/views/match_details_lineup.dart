import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/widgets/app_cached_network_image.dart';
import '../match_details_controller.dart';
import '../models/match_details_model.dart';

class MatchDetailsLineupPage extends GetView<MatchDetailsController> {
  const MatchDetailsLineupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final lineup = controller.state.value.lineup;

      if (!lineup.hasData) {
        return ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(14.w, 24.h, 14.w, 28.h),
          children: const [_LineupEmptyState()],
        );
      }

      return ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 28.h),
        children: [
          if (lineup.showPitch)
            _LineupPitchCard(lineup: lineup)
          else
            const _LineupEmptyState(),
          if (lineup.coaches.isNotEmpty) ...[
            SizedBox(height: 22.h),
            _LineupPeopleCard(title: 'Coach', people: lineup.coaches),
          ],
          if (lineup.substitutes.isNotEmpty) ...[
            SizedBox(height: 22.h),
            _LineupPeopleCard(title: 'Substitutes', people: lineup.substitutes),
          ],
          if (lineup.bench.isNotEmpty) ...[
            SizedBox(height: 22.h),
            _LineupPeopleCard(title: 'Bench', people: lineup.bench),
          ],
        ],
      );
    });
  }
}

class _LineupEmptyState extends StatelessWidget {
  const _LineupEmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppColors.palette(theme.brightness);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 26.h),
      decoration: _cardDecoration(context),
      child: Column(
        children: [
          Icon(Icons.groups_rounded, size: 36.r, color: palette.textSubtle),
          SizedBox(height: 12.h),
          Text(
            'Lineup not available yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: AppTextStyles.sizeBody.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Player positions will appear here when lineup data is published.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withAlpha(145),
              fontSize: AppTextStyles.sizeBodySmall.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
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
            logoUrl: lineup.home.logoUrl,
            isTop: true,
          ),
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: palette.border.withAlpha(130),
                  width: 0.6.w,
                ),
                bottom: BorderSide(
                  color: palette.border.withAlpha(130),
                  width: 0.6.w,
                ),
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
                          photoUrl: player.photoUrl,
                          labelColor: palette.textPrimary,
                          circleColor: player.circleColor,
                        ),
                      for (final player in lineup.away.players)
                        _PitchPlayer(
                          x: player.x,
                          y: _mapAwayY(player.y),
                          name: player.name,
                          photoUrl: player.photoUrl,
                          labelColor: palette.textPrimary,
                          circleColor: player.circleColor,
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
            logoUrl: lineup.away.logoUrl,
            isBottom: true,
          ),
        ],
      ),
    );
  }

  double _mapHomeY(double y) {
    return -0.05 + (y * 0.56);
  }

  double _mapAwayY(double y) {
    return 0.45 + (y * 0.56);
  }
}

class _TeamStrip extends StatelessWidget {
  final String teamName;
  final String formation;
  final String? logoUrl;
  final bool isTop;
  final bool isBottom;

  const _TeamStrip({
    required this.teamName,
    required this.formation,
    this.logoUrl,
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
          _PersonAvatar(
            imageUrl: logoUrl,
            fallbackText: teamName,
            size: 24.r,
            borderColor: palette.primarySoft,
            backgroundColor: palette.surfaceSoft,
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
  final String? photoUrl;
  final Color labelColor;
  final Color circleColor;

  const _PitchPlayer({
    required this.x,
    required this.y,
    required this.name,
    required this.photoUrl,
    required this.labelColor,
    required this.circleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final circleSize = 38.r;
          final itemWidth = 64.w;
          final itemHeight = circleSize + 42.h;
          final left = (constraints.maxWidth * x) - (itemWidth / 2);
          final top = (constraints.maxHeight * y) - (circleSize / 2);

          return Stack(
            children: [
              Positioned(
                left: left
                    .clamp(0, constraints.maxWidth - itemWidth)
                    .toDouble(),
                top: top
                    .clamp(0, constraints.maxHeight - itemHeight)
                    .toDouble(),
                child: SizedBox(
                  width: itemWidth,
                  child: Column(
                    children: [
                      _PersonAvatar(
                        imageUrl: photoUrl,
                        fallbackText: name,
                        size: circleSize,
                        borderColor: circleColor,
                        backgroundColor: circleColor.withAlpha(70),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: labelColor,
                          fontSize: AppTextStyles.sizeTiny.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.05,
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

  const _LineupPeopleCard({required this.title, required this.people});

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
                          _PersonAvatar(
                            imageUrl: person.photoUrl,
                            fallbackText: person.name,
                            size: 40.r,
                            borderColor: person.circleColor,
                            backgroundColor: person.circleColor.withAlpha(55),
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

class _PersonAvatar extends StatelessWidget {
  final String? imageUrl;
  final String fallbackText;
  final double size;
  final Color borderColor;
  final Color backgroundColor;

  const _PersonAvatar({
    required this.imageUrl,
    required this.fallbackText,
    required this.size,
    required this.borderColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final initials = _initials(fallbackText);
    final url = imageUrl?.trim();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        border: Border.all(color: borderColor, width: 1.3.w),
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: url == null || url.isEmpty
          ? Text(
              initials,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: AppTextStyles.sizeTiny.sp,
                fontWeight: FontWeight.w900,
              ),
            )
          : AppCachedNetworkImage(
              imageUrl: url,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (context) {
                return Text(
                  initials,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: AppTextStyles.sizeTiny.sp,
                    fontWeight: FontWeight.w900,
                  ),
                );
              },
            ),
    );
  }

  String _initials(String value) {
    final words = value
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    if (words.isEmpty) return '';
    if (words.length == 1) {
      return words.first.length <= 2
          ? words.first.toUpperCase()
          : words.first.substring(0, 2).toUpperCase();
    }
    return words.take(2).map((word) => word[0].toUpperCase()).join();
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
      Rect.fromLTWH(
        penaltyX,
        size.height - penaltyHeight,
        penaltyWidth,
        penaltyHeight,
      ),
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
