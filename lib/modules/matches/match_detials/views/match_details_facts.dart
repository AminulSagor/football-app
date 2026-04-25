import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'widgets/widgets.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/themes/app_colors.dart';
import '../match_details_controller.dart';
import '../models/match_details_model.dart';

class MatchDetailsFactsPage extends GetView<MatchDetailsController> {
  const MatchDetailsFactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state.value;
      final theme = Theme.of(context);

      return ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
        children: [
          if (state.playerOfTheMatch != null)
            _SectionCard(
              title: 'Player of the Match',
              child: _PlayerOfTheMatchCard(player: state.playerOfTheMatch!),
            ),
          if (state.playerOfTheMatch != null) SizedBox(height: 16.h),
          _SectionCard(child: VenueCard(venue: state.venue)),
          SizedBox(height: 16.h),
          for (var i = 0; i < state.factsTopStats.length; i++) ...[
            _StatsSectionCard(section: state.factsTopStats[i]),
            SizedBox(height: 16.h),
          ],
          _SectionCard(
            title: 'Events',
            child: _EventsCard(
              events: state.events,
              markers: state.timelineMarkers,
            ),
          ),
          SizedBox(height: 16.h),
          _SectionCard(
            title: state.teamForm.title,
            child: _TeamFormCard(teamForm: state.teamForm),
          ),
          SizedBox(height: 16.h),
          _SectionCard(child: _MetaCard(meta: state.meta)),
          SizedBox(height: 18.h),
          Text(
            'Next match',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: AppTextStyles.sizeBodyLarge.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 14.h),
          SizedBox(
            height: 145.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: state.nextMatches.length,
              separatorBuilder: (_, __) => SizedBox(width: 12.w),
              itemBuilder: (context, index) {
                return _NextMatchCard(item: state.nextMatches[index]);
              },
            ),
          ),
          SizedBox(height: 18.h),
          _SectionCard(
            title: 'About the match',
            child: _AboutMatchCard(text: state.aboutText),
          ),
        ],
      );
    });
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
                color: theme.hintColor.withAlpha(
                  20,
                ), //theme.colorScheme.surface.withAlpha(20),
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

class _PlayerOfTheMatchCard extends StatelessWidget {
  final MatchDetailsPlayerOfMatchUiModel player;

  const _PlayerOfTheMatchCard({required this.player});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppColors.palette(theme.brightness);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: palette.surfaceMuted.withAlpha(100),
        borderRadius: BorderRadius.circular(18.r),
        // border: Border.all(
        //   color: theme.dividerColor.withAlpha(120),
        //   width: 1.w,
        // ),
      ),
      child: Row(
        children: [
          Container(
            width: 52.r,
            height: 52.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: theme.colorScheme.primary, width: 1.w),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: AppTextStyles.sizeBodyLarge.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  player.teamName.toUpperCase(),
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withAlpha(120),
                    fontSize: AppTextStyles.sizeOverline.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
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

// class _VenueCard extends StatelessWidget {
//   final MatchDetailsVenueUiModel venue;

//   const _VenueCard({required this.venue});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final palette = AppColors.palette(theme.brightness);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: 22.r,
//               height: 22.r,
//               decoration: BoxDecoration(
//                 color: theme.colorScheme.surface.withAlpha(10),
//                 borderRadius: BorderRadius.circular(6.r),
//                 border: Border.all(
//                   color: theme.dividerColor.withAlpha(120),
//                   width: 1.w,
//                 ),
//               ),
//               alignment: Alignment.center,
//               child: Icon(
//                 Icons.stadium_outlined,
//                 color: theme.colorScheme.onSurface.withAlpha(180),
//                 size: 20.r,
//               ),
//             ),
//             SizedBox(width: 10.w),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     venue.stadiumName,
//                     style: TextStyle(
//                       color: theme.colorScheme.onSurface,
//                       fontSize: AppTextStyles.sizeBody.sp,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   SizedBox(height: 2.h),
//                   Text(
//                     venue.city,
//                     style: TextStyle(
//                       color: theme.colorScheme.onSurface.withAlpha(145),
//                       fontSize: AppTextStyles.sizeTiny.sp,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(width: 10.w),
//             Container(
//               width: 36.r,
//               height: 36.r,
//               decoration: BoxDecoration(
//                 color: palette.background,
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.location_on,
//                 color: theme.colorScheme.primary,
//                 size: 17.r,
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 16.h),
//         Row(
//           children: [
//             Image.asset('assets/images/Container.png', width: 22.r, height: 22.r),
//             SizedBox(width: 10.w),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Surface',
//                   style: TextStyle(
//                     color: theme.colorScheme.onSurface.withAlpha(125),
//                     fontSize: AppTextStyles.sizeBodySmall.sp,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 SizedBox(height: 4.h),
//                 Text(
//                   venue.surface,
//                   style: TextStyle(
//                     color: theme.colorScheme.onSurface,
//                     fontSize: AppTextStyles.sizeBody.sp,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

class _StatsSectionCard extends StatelessWidget {
  final MatchDetailsStatSectionUiModel section;

  const _StatsSectionCard({required this.section});

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
              section.title,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: AppTextStyles.sizeBodySmall.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 16.h),
            child: Column(
              children: [
                if (section.showPossessionBar && section.rows.isNotEmpty) ...[
                  Text(
                    section.rows.first.label,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: AppTextStyles.sizeBodySmall.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  PossessionBar(row: section.rows.first),
                  SizedBox(height: 14.h),
                ],
                for (var row in section.rows.skip(
                  section.showPossessionBar ? 1 : 0,
                ))
                  Padding(
                    padding: EdgeInsets.only(bottom: 14.h),
                    child: _StatRow(row: row),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class _StatRow extends StatelessWidget {
  final MatchDetailsStatRowUiModel row;

  const _StatRow({required this.row});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        _ValuePill(value: row.homeValue),
        Expanded(
          child: Text(
            row.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withAlpha(170),
              fontSize: AppTextStyles.sizeBody.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          row.awayValue,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: AppTextStyles.sizeBodySmall.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ValuePill extends StatelessWidget {
  final String value;

  const _ValuePill({required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.primaryAlt,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Text(
        value,
        style: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontSize: AppTextStyles.sizeCaption.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _EventsCard extends StatelessWidget {
  final List<MatchDetailsEventUiModel> events;
  final List<MatchDetailsTimelineMarkerUiModel> markers;

  const _EventsCard({required this.events, required this.markers});

  @override
  Widget build(BuildContext context) {
    var markerIndex = 0;

    return Column(
      children: [
        for (var i = 0; i < events.length; i++) ...[
          _EventRow(item: events[i]),
          if (i == 4 && markerIndex < markers.length) ...[
            SizedBox(height: 18.h),
            _TimelineMarker(label: markers[markerIndex++].label),
            SizedBox(height: 18.h),
          ],
          if (i == events.length - 1 && markerIndex < markers.length) ...[
            SizedBox(height: 18.h),
            _TimelineMarker(label: markers[markerIndex].label),
          ] else if (i != events.length - 1) ...[
            SizedBox(height: 18.h),
          ],
        ],
      ],
    );
  }
}

class _EventRow extends StatelessWidget {
  final MatchDetailsEventUiModel item;

  const _EventRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final icon = switch (item.type) {
      MatchDetailsEventType.goal => _RoundIcon(
        fill: theme.colorScheme.onSurface.withAlpha(140),
      ),
      MatchDetailsEventType.substitution => _BlackCircleIcon(
        icon: Icons.sync_alt_rounded,
        color: theme.colorScheme.primary,
      ),
      MatchDetailsEventType.yellowCard => _CardIcon(
        color: theme.colorScheme.secondary,
      ),
      MatchDetailsEventType.redCard => _CardIcon(
        color: theme.colorScheme.error,
      ),
      MatchDetailsEventType.info => _BlackCircleIcon(
        icon: Icons.gavel_rounded,
        color: theme.colorScheme.onSurface,
      ),
    };

    final minute = Container(
      width: 34.r,
      height: 34.r,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        item.minute,
        style: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontSize: AppTextStyles.sizeCaption.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );

    final content = Column(
      crossAxisAlignment: item.isHomeSide
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        Text(
          item.primaryText,
          textAlign: item.isHomeSide ? TextAlign.left : TextAlign.right,
          style: TextStyle(
            color: item.emphasizePrimary
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
            fontSize: AppTextStyles.sizeBodySmall.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (item.secondaryText != null)
          Text(
            item.secondaryText!,
            textAlign: item.isHomeSide ? TextAlign.left : TextAlign.right,
            style: TextStyle(
              color: item.emphasizePrimary
                  ? theme.colorScheme.error
                  : theme.colorScheme.onSurface.withAlpha(160),
              fontSize: AppTextStyles.sizeBodySmall.sp,
              fontWeight: item.emphasizePrimary
                  ? FontWeight.w700
                  : FontWeight.w500,
            ),
          ),
        if (item.assistText != null)
          Text(
            item.assistText!,
            textAlign: item.isHomeSide ? TextAlign.left : TextAlign.right,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withAlpha(150),
              fontSize: AppTextStyles.sizeCaption.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );

    if (item.isHomeSide) {
      return Row(
        children: [
          minute,
          SizedBox(width: 12.w),
          icon,
          SizedBox(width: 12.w),
          Expanded(child: content),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: content),
        SizedBox(width: 12.w),
        icon,
        SizedBox(width: 12.w),
        minute,
      ],
    );
  }
}

class _TimelineMarker extends StatelessWidget {
  final String label;

  const _TimelineMarker({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Container(height: 1.h, color: theme.dividerColor),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withAlpha(160),
              fontSize: AppTextStyles.sizeBodySmall.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Container(height: 1.h, color: theme.dividerColor),
        ),
      ],
    );
  }
}

class _BlackCircleIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _BlackCircleIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 28.r,
      height: 28.r,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 16.r),
    );
  }
}

class _CardIcon extends StatelessWidget {
  final Color color;

  const _CardIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12.w,
      height: 18.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3.r),
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  final Color fill;

  const _RoundIcon({required this.fill});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 18.r,
      height: 18.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fill,
        border: Border.all(
          color: theme.colorScheme.onSurface.withAlpha(30),
          width: 1.w,
        ),
      ),
    );
  }
}

class _TeamFormCard extends StatelessWidget {
  final MatchDetailsTeamFormUiModel teamForm;

  const _TeamFormCard({required this.teamForm});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _FormColumn(results: teamForm.homeResults, isHome: true),
        ),
        SizedBox(width: 26.w),
        Expanded(
          child: _FormColumn(results: teamForm.awayResults, isHome: false),
        ),
      ],
    );
  }
}

class _FormColumn extends StatelessWidget {
  final List<String> results;
  final bool isHome;

  const _FormColumn({required this.results, required this.isHome});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: results
          .map(
            (result) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                children: [
                  Container(
                    width: 22.r,
                    height: 22.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.onSurface.withAlpha(60),
                        width: 1.w,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: isHome ? AppColors.primaryAlt : AppColors.error,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      result,
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontSize: AppTextStyles.sizeCaption.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(growable: false),
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
        _MetaInfoRow(
          icon: Icons.calendar_today_outlined,
          label: 'Thu 9 April, 01:00',
        ),
        SizedBox(height: 18.h),
        _MetaInfoRow(
          icon: Icons.sports_soccer_outlined,
          label: meta.competition,
        ),
        SizedBox(height: 18.h),
        _MetaInfoRow(
          icon: Icons.flag_circle_outlined,
          label: meta.referee,
          leadingFlag: true,
        ),
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
        if (leadingFlag)
          Container(
            width: 14.w,
            height: 10.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.r),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF0033A0),
                  Color(0xFFFCD116),
                  Color(0xFFCE1126),
                ],
              ),
            ),
          ),
        if (leadingFlag) SizedBox(width: 8.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: AppTextStyles.sizeBody.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _NextMatchCard extends StatelessWidget {
  final MatchDetailsNextMatchUiModel item;

  const _NextMatchCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 280.w,
      padding: EdgeInsets.all(16.w),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            item.title,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withAlpha(160),
              fontSize: AppTextStyles.sizeCaption.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(child: _SmallTeam(team: item.homeTeam)),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      item.timeLabel,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: AppTextStyles.sizeHeading.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      item.statusText,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withAlpha(140),
                        fontSize: AppTextStyles.sizeBodySmall.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: _SmallTeam(team: item.awayTeam)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallTeam extends StatelessWidget {
  final MatchDetailsTeamUiModel team;

  const _SmallTeam({required this.team});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: 46.r,
          height: 46.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.surface,
            border: Border.all(color: theme.colorScheme.primary, width: 1.w),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          team.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: AppTextStyles.sizeBodySmall.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _AboutMatchCard extends StatelessWidget {
  final String text;

  const _AboutMatchCard({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: AppTextStyles.sizeBody.sp,
            fontWeight: FontWeight.w500,
            height: 1.65,
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            'Expand',
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
              fontSize: AppTextStyles.sizeBodySmall.sp,
              fontWeight: FontWeight.w700,
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
