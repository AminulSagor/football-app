import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/app_cached_network_image.dart';
import '../match_details_controller.dart';
import '../models/match_details_model.dart';

ShimmerEffect _solidHeadToHeadSkeletonEffect(ThemeData theme) {
  final color = theme.colorScheme.onSurface.withAlpha(
    theme.brightness == Brightness.dark ? 28 : 18,
  );
  return ShimmerEffect(baseColor: color, highlightColor: color);
}

class MatchDetailsHeadToHeadPage extends GetView<MatchDetailsController> {
  const MatchDetailsHeadToHeadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state.value;
      final summary = state.headToHeadSummary;
      final matches = state.headToHeadMatches;

      return ListView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
        physics: const BouncingScrollPhysics(),
        children: [
          _H2HOverviewCard(
            summary: summary,
            homeTeam: state.header.homeTeam,
            awayTeam: state.header.awayTeam,
          ),
          SizedBox(height: 16.h),
          _H2HMatchesCard(
            matches: matches,
            isLoading: controller.isHeadToHeadLoading.value,
            isLoadingMore: controller.isHeadToHeadLoadingMore.value,
            canLoadMore: controller.canLoadMoreHeadToHead.value,
            onLoadMore: controller.onHeadToHeadLoadMoreTap,
          ),
        ],
      );
    });
  }
}

BoxDecoration _sharedCardDecoration(BuildContext context) {
  final theme = Theme.of(context);
  final palette = AppColors.palette(theme.brightness);

  return BoxDecoration(
    borderRadius: BorderRadius.circular(18.r),
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [palette.surfaceSoft, palette.surface],
    ),
    border: Border.all(color: theme.dividerColor, width: 1.w),
  );
}

class _H2HOverviewCard extends StatelessWidget {
  final MatchDetailsHeadToHeadSummaryUiModel summary;
  final MatchDetailsTeamUiModel homeTeam;
  final MatchDetailsTeamUiModel awayTeam;

  const _H2HOverviewCard({
    required this.summary,
    required this.homeTeam,
    required this.awayTeam,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _sharedCardDecoration(context),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'H2H Overview',
            style: AppTextStyles.label.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _SummaryBox(
                showTeamLogo: true,
                logoUrl: homeTeam.logoUrl,
                fallbackText: homeTeam.shortName,
                value: summary.homeWins.toString(),
                label: 'Wins',
                backgroundColor: Theme.of(context).colorScheme.primary,
                textColor: Theme.of(context).colorScheme.onPrimary,
              ),
              _SummaryBox(
                showTeamLogo: false,
                value: summary.draws.toString(),
                label: 'Draws',
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.onSurface.withAlpha(26),
                textColor: Theme.of(context).colorScheme.onSurface,
              ),
              _SummaryBox(
                showTeamLogo: true,
                logoUrl: awayTeam.logoUrl,
                fallbackText: awayTeam.shortName,
                value: summary.awayWins.toString(),
                label: 'Wins',
                backgroundColor: Theme.of(context).colorScheme.primary,
                textColor: Theme.of(context).colorScheme.onPrimary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryBox extends StatelessWidget {
  final String value;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final bool showTeamLogo;
  final String? logoUrl;
  final String fallbackText;

  const _SummaryBox({
    required this.value,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.showTeamLogo,
    this.logoUrl,
    this.fallbackText = '',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        if (showTeamLogo)
          _LogoCircle(
            imageUrl: logoUrl,
            fallbackText: fallbackText,
            size: 52.w,
            borderColor: theme.colorScheme.primary,
          ),
        SizedBox(height: 12.h),
        Container(
          width: 64.w,
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          alignment: Alignment.center,
          child: Text(
            value,
            style: AppTextStyles.headline.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: AppTextStyles.label.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(178),
          ),
        ),
      ],
    );
  }
}

class _LogoCircle extends StatelessWidget {
  final String? imageUrl;
  final String fallbackText;
  final double size;
  final Color borderColor;

  const _LogoCircle({
    required this.imageUrl,
    required this.fallbackText,
    required this.size,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final url = imageUrl?.trim();
    final text = _fallback(fallbackText);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: url == null || url.isEmpty
          ? Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.label.copyWith(
                color: theme.colorScheme.onSurface,
                fontSize: size <= 24 ? 7.sp : AppTextStyles.sizeCaption.sp,
                fontWeight: FontWeight.w900,
              ),
            )
          : AppCachedNetworkImage(
              imageUrl: url,
              width: size,
              height: size,
              fit: BoxFit.contain,
              errorBuilder: (context) {
                return Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.label.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontSize: size <= 24 ? 7.sp : AppTextStyles.sizeCaption.sp,
                    fontWeight: FontWeight.w900,
                  ),
                );
              },
            ),
    );
  }

  String _fallback(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '';
    final words = trimmed
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    if (words.length >= 2) {
      return words.take(2).map((word) => word[0].toUpperCase()).join();
    }
    return trimmed.length <= 3
        ? trimmed.toUpperCase()
        : trimmed.substring(0, 3).toUpperCase();
  }
}

class _H2HMatchesCard extends StatelessWidget {
  final List<MatchDetailsHeadToHeadMatchUiModel> matches;
  final bool isLoading;
  final bool isLoadingMore;
  final bool canLoadMore;
  final VoidCallback onLoadMore;

  const _H2HMatchesCard({
    required this.matches,
    required this.isLoading,
    required this.isLoadingMore,
    required this.canLoadMore,
    required this.onLoadMore,
  });

  List<MatchDetailsHeadToHeadMatchUiModel> _skeletonMatches() {
    return List<MatchDetailsHeadToHeadMatchUiModel>.generate(
      4,
      (index) => const MatchDetailsHeadToHeadMatchUiModel(
        dateLabel: '12 May',
        competitionLabel: 'League Name',
        homeTeamName: 'Home Team',
        awayTeamName: 'Away Team',
        centerLabel: '1 - 1',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: _sharedCardDecoration(context),
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'H2H Matches Overview',
              style: AppTextStyles.label.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          if (isLoading)
            Skeletonizer(
              enabled: true,
              effect: _solidHeadToHeadSkeletonEffect(theme),
              child: Column(
                children: _skeletonMatches()
                    .map((match) => _MatchRow(match: match))
                    .toList(growable: false),
              ),
            )
          else if (matches.isEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
              child: Text(
                'No head-to-head matches found.',
                style: AppTextStyles.label.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(150),
                ),
              ),
            )
          else
            for (var index = 0; index < matches.length; index++) ...[
              _MatchRow(match: matches[index]),
            ],
          if (!isLoading && canLoadMore) ...[
            SizedBox(height: 8.h),
            Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8.r),
                  onTap: isLoadingMore ? null : onLoadMore,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isLoadingMore) ...[
                          SizedBox(
                            width: 14.r,
                            height: 14.r,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.w,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                          SizedBox(width: 8.w),
                        ],
                        Text(
                          isLoadingMore ? 'Loading' : 'Load More',
                          style: AppTextStyles.label.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (!isLoadingMore) ...[
                          SizedBox(width: 4.w),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: theme.colorScheme.onPrimary,
                            size: 16.sp,
                          ),
                        ],
                      ],
                    ),
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

class _MatchRow extends StatelessWidget {
  final MatchDetailsHeadToHeadMatchUiModel match;

  const _MatchRow({required this.match});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.onSurface.withAlpha(13),
            width: 1.w,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                match.dateLabel,
                style: AppTextStyles.label.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(140),
                  fontSize: AppTextStyles.sizeOverline.sp,
                ),
              ),
              Row(
                children: [
                  Text(
                    match.competitionLabel,
                    style: AppTextStyles.label.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(140),
                      fontSize: AppTextStyles.sizeOverline.sp,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  _LogoCircle(
                    imageUrl: match.leagueLogoUrl,
                    fallbackText: match.competitionLabel,
                    size: 16.w,
                    borderColor: theme.colorScheme.onSurface.withAlpha(51),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  match.homeTeamName,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.label.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: match.isUpcoming
                        ? FontWeight.normal
                        : FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              _LogoCircle(
                imageUrl: match.homeLogoUrl,
                fallbackText: match.homeTeamName,
                size: 20.w,
                borderColor: theme.colorScheme.onSurface.withAlpha(51),
              ),
              SizedBox(width: 12.w),
              Container(
                padding: match.isUpcoming
                    ? EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h)
                    : EdgeInsets.zero,
                decoration: match.isUpcoming
                    ? BoxDecoration(
                        color: theme.colorScheme.onSurface.withAlpha(26),
                        borderRadius: BorderRadius.circular(4.r),
                      )
                    : null,
                child: Text(
                  match.centerLabel,
                  style: match.isUpcoming
                      ? AppTextStyles.label.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(140),
                          fontWeight: FontWeight.w500,
                        )
                      : AppTextStyles.headline.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                ),
              ),
              SizedBox(width: 12.w),
              _LogoCircle(
                imageUrl: match.awayLogoUrl,
                fallbackText: match.awayTeamName,
                size: 20.w,
                borderColor: theme.colorScheme.onSurface.withAlpha(51),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  match.awayTeamName,
                  textAlign: TextAlign.left,
                  style: AppTextStyles.label.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: match.isUpcoming
                        ? FontWeight.normal
                        : FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
