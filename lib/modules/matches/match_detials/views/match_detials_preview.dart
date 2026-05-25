import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'widgets/widgets.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/ads/admob_banner_ad.dart';
import '../match_details_controller.dart';
import '../models/match_details_model.dart';
import 'package:fotgram/core/widgets/app_cached_network_image.dart';

class MatchDetialsPreviewPage extends GetView<MatchDetailsController> {
  const MatchDetialsPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state.value;

      return ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
        children: [
          AdMobBannerAd.largeBanner(
            key: const ValueKey('match_preview_top_banner_ad'),
            margin: EdgeInsets.only(bottom: 16.h),
          ),
          if (state.venue.hasSurfaceInfo) ...[
            _SectionCard(child: VenueCard(venue: state.venue)),
            SizedBox(height: 16.h),
          ],
          _SectionCard(child: _MetaCard(meta: state.meta)),
          if (state.topScorers != null) ...[
            SizedBox(height: 16.h),
            _SectionCard(
              title: state.topScorers!.title,
              child: _TopScorersCompareCard(model: state.topScorers!),
            ),
          ],
          if (state.header.scenario == MatchDetailsScenario.live) ...[
            SizedBox(height: 16.h),
            _SectionCard(
              title: 'Events',
              child: state.events.isEmpty
                  ? const _InlineEmptyMessage(
                      message: 'No match events are available yet.',
                    )
                  : MatchEventsCard(
                      events: state.events,
                      markers: state.timelineMarkers,
                    ),
            ),
          ],
          SizedBox(height: 16.h),
          _SectionCard(
            title: state.teamForm.title,
            child:
                state.teamForm.homeMatches.isEmpty &&
                    state.teamForm.awayMatches.isEmpty &&
                    state.teamForm.homeResults.isEmpty &&
                    state.teamForm.awayResults.isEmpty
                ? const _InlineEmptyMessage(
                    message: 'Recent team form is not available yet.',
                  )
                : _TeamFormCard(teamForm: state.teamForm),
          ),
          if (state.header.scenario == MatchDetailsScenario.live) ...[
            SizedBox(height: 16.h),
          ] else ...[
            SizedBox(height: 16.h),
            _SectionCard(
              title: 'About the match',
              child: _AboutMatchCard(
                text: state.aboutText,
                isExpanded: controller.isAboutExpanded.value,
                onToggle: controller.toggleAboutExpanded,
              ),
            ),
          ],
        ],
      );
    });
  }
}

class _InlineEmptyMessage extends StatelessWidget {
  final String message;

  const _InlineEmptyMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: theme.colorScheme.onSurface.withAlpha(145),
        fontSize: AppTextStyles.sizeBodySmall.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String? title;
  final Widget child;

  const _SectionCard({this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withAlpha(6),
                borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
              ),
              child: Text(
                title!,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: AppTextStyles.sizeBodySmall.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _MetaCard extends StatelessWidget {
  final MatchDetailsMetaInfoUiModel meta;

  const _MetaCard({required this.meta});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MetaInfoRow(icon: Icons.calendar_today_outlined, label: meta.dateTime),
        SizedBox(height: 18.h),
        _MetaInfoRow(
          icon: Icons.sports_soccer_outlined,
          label: meta.competition,
        ),
        if (meta.referee.trim().isNotEmpty) ...[
          SizedBox(height: 18.h),
          _MetaInfoRow(
            icon: Icons.flag_circle_outlined,
            label: meta.referee,
            leadingFlag: true,
          ),
        ],
      ],
    );
  }
}

class _MetaInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool leadingFlag;

  const _MetaInfoRow({
    required this.icon,
    required this.label,
    this.leadingFlag = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          color: theme.colorScheme.onSurface.withAlpha(170),
          size: 18.r,
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: AppTextStyles.sizeBody.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

class _TopScorersCompareCard extends StatelessWidget {
  final MatchDetailsTopScorerCompareUiModel model;

  const _TopScorersCompareCard({required this.model});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          model.competitionLabel,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: AppTextStyles.sizeBodyLarge.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 20.h),
        Row(
          children: [
            Expanded(
              child: _ComparePlayer(
                name: model.homePlayerName,
                photoUrl: model.homePlayerPhotoUrl,
              ),
            ),
            Expanded(
              child: _ComparePlayer(
                name: model.awayPlayerName,
                photoUrl: model.awayPlayerPhotoUrl,
                alignEnd: true,
              ),
            ),
          ],
        ),
        SizedBox(height: 18.h),
        for (var i = 0; i < model.metrics.length; i++) ...[
          _CompareMetricBar(metric: model.metrics[i]),
          if (i != model.metrics.length - 1) SizedBox(height: 14.h),
        ],
      ],
    );
  }
}

class _ComparePlayer extends StatelessWidget {
  final String name;
  final String? photoUrl;
  final bool alignEnd;

  const _ComparePlayer({
    required this.name,
    this.photoUrl,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Container(
          width: 58.r,
          height: 58.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.surface.withAlpha(80),
            border: Border.all(color: AppColors.brand, width: 1.w),
          ),
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.center,
          child: photoUrl == null || photoUrl!.trim().isEmpty
              ? Icon(
                  Icons.person_outline,
                  color: theme.colorScheme.onSurface.withAlpha(130),
                  size: 28.r,
                )
              : AppCachedNetworkImage(
                  imageUrl: photoUrl!,
                  width: 58.r,
                  height: 58.r,
                  fit: BoxFit.cover,
                  errorBuilder: (context) => Icon(
                    Icons.person_outline,
                    color: theme.colorScheme.onSurface.withAlpha(130),
                    size: 28.r,
                  ),
                ),
        ),
        SizedBox(height: 8.h),
        Text(
          name,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: AppTextStyles.sizeBody.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _CompareMetricBar extends StatelessWidget {
  final MatchDetailsCompareMetricUiModel metric;

  const _CompareMetricBar({required this.metric});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          metric.label,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: AppTextStyles.sizeBodySmall.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          height: 36.h,
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurface.withAlpha(8),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    metric.homeValue,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: AppTextStyles.sizeBodyLarge.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              Container(
                width: 1.w,
                color: theme.colorScheme.onSurface.withAlpha(12),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    metric.awayValue,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: AppTextStyles.sizeBodyLarge.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TeamFormCard extends StatelessWidget {
  final MatchDetailsTeamFormUiModel teamForm;

  const _TeamFormCard({required this.teamForm});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _FormColumn(
            matches: teamForm.homeMatches,
            legacyResults: teamForm.homeResults,
          ),
        ),
        SizedBox(width: 22.w),
        Expanded(
          child: _FormColumn(
            matches: teamForm.awayMatches,
            legacyResults: teamForm.awayResults,
          ),
        ),
      ],
    );
  }
}

class _FormColumn extends StatelessWidget {
  final List<MatchDetailsTeamFormMatchUiModel> matches;
  final List<String> legacyResults;

  const _FormColumn({required this.matches, required this.legacyResults});

  @override
  Widget build(BuildContext context) {
    final visibleMatches = matches.isNotEmpty
        ? matches
        : legacyResults
              .map(
                (result) => MatchDetailsTeamFormMatchUiModel(
                  scoreLabel: result,
                  result: result,
                ),
              )
              .toList(growable: false);

    return Column(
      children: visibleMatches
          .map(
            (match) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _TeamFormMatchRow(match: match),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _TeamFormMatchRow extends StatelessWidget {
  final MatchDetailsTeamFormMatchUiModel match;

  const _TeamFormMatchRow({required this.match});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _TeamFormLogo(url: match.homeLogoUrl),
        SizedBox(width: 8.w),
        _TeamFormScorePill(match: match),
        SizedBox(width: 8.w),
        _TeamFormLogo(url: match.awayLogoUrl),
      ],
    );
  }
}

class _TeamFormLogo extends StatelessWidget {
  final String? url;

  const _TeamFormLogo({this.url});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 28.r,
      height: 28.r,
      decoration: BoxDecoration(shape: BoxShape.circle),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: url == null || url!.trim().isEmpty
          ? Icon(
              Icons.shield_outlined,
              color: theme.colorScheme.onSurface.withAlpha(130),
              size: 15.r,
            )
          : AppCachedNetworkImage(
              imageUrl: url!,
              width: 28.r,
              height: 28.r,
              fit: BoxFit.cover,
              errorBuilder: (context) {
                return Icon(
                  Icons.shield_outlined,
                  color: theme.colorScheme.onSurface.withAlpha(130),
                  size: 15.r,
                );
              },
            ),
    );
  }
}

class _TeamFormScorePill extends StatelessWidget {
  final MatchDetailsTeamFormMatchUiModel match;

  const _TeamFormScorePill({required this.match});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppColors.palette(theme.brightness);
    final result = match.result.toUpperCase();
    final pillColor = result == 'W'
        ? palette.brand
        : result == 'L'
        ? palette.error
        : palette.surfaceMuted;
    final textColor = result == 'D'
        ? theme.colorScheme.onSurface
        : theme.colorScheme.onPrimary;

    return Container(
      constraints: BoxConstraints(minWidth: 60.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: pillColor,
        borderRadius: BorderRadius.circular(7.r),
      ),
      alignment: Alignment.center,
      child: Text(
        match.scoreLabel,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: textColor,
          fontSize: AppTextStyles.sizeCaption.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _AboutMatchCard extends StatelessWidget {
  final String text;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _AboutMatchCard({
    required this.text,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text.trim().isEmpty ? 'No match about information found.' : text,
          maxLines: isExpanded ? null : 2,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: AppTextStyles.sizeBody.sp,
            fontWeight: FontWeight.w500,
            height: 1.65,
          ),
        ),
        SizedBox(height: 16.h),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10.r),
            onTap: onToggle,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: const Color(0xFF119166),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                isExpanded ? 'Collapse' : 'Expand',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: AppTextStyles.sizeBodySmall.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

BoxDecoration _cardDecoration(BuildContext context) {
  final theme = Theme.of(context);

  return BoxDecoration(
    borderRadius: BorderRadius.circular(18.r),
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [AppColors.surfaceSoft, AppColors.surface],
    ),
    border: Border.all(color: theme.dividerColor, width: 1.w),
  );
}
