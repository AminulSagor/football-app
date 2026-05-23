import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/themes/app_text_styles.dart';
import '../team_profile_controller.dart';
import '../team_profile_model.dart';
import 'package:fotgram/core/widgets/app_cached_network_image.dart';

class TeamProfileSquadPage extends GetView<TeamProfileController> {
  const TeamProfileSquadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state.value;
      final groupedPlayers = controller.playersByPosition;

      return ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 28.h),
        children: [
          _SquadSectionCard(
            title: 'Coach',
            child: state.isCoachesLoading && state.latestCoach == null
                ? const _EmptyText(text: 'Loading coach...')
                : state.latestCoach == null
                ? const _EmptyText(
                    text: 'No current coach found for this team.',
                  )
                : _CoachRow(
                    item: state.latestCoach!,
                    onTap: () =>
                        controller.openCoachProfile(state.latestCoach!),
                  ),
          ),
          SizedBox(height: 24.h),
          if (state.isPlayersLoading && groupedPlayers.isEmpty)
            const _SquadSectionCard(
              title: 'Players',
              child: _EmptyText(text: 'Loading squad players...'),
            )
          else if (groupedPlayers.isEmpty)
            const _SquadSectionCard(
              title: 'Players',
              child: _EmptyText(
                text: 'No squad player data found for this season.',
              ),
            )
          else
            for (final entry in groupedPlayers.entries) ...[
              _SquadSectionCard(
                title: entry.key,
                child: Column(
                  children: [
                    for (
                      var playerIndex = 0;
                      playerIndex < entry.value.length;
                      playerIndex++
                    )
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: playerIndex == entry.value.length - 1
                              ? 0
                              : 12.h,
                        ),
                        child: _PlayerRow(
                          item: entry.value[playerIndex],
                          stat: controller.playerStatistic(
                            entry.value[playerIndex],
                          ),
                          onTap: () => controller.openPlayerProfile(
                            entry.value[playerIndex],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
            ],
        ],
      );
    });
  }
}

class _SquadSectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SquadSectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [theme.colorScheme.surface, theme.scaffoldBackgroundColor],
        ),
        border: Border.all(
          color: theme.colorScheme.onSurface.withAlpha(10),
          width: 1.w,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
              color: theme.colorScheme.onSurface.withAlpha(4),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: AppTextStyles.sizeBody.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _CoachRow extends StatelessWidget {
  final FootballTeamCoachModel item;
  final VoidCallback? onTap;

  const _CoachRow({required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final content = Container(
      height: 72.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: theme.colorScheme.onSurface.withAlpha(6),
      ),
      child: Row(
        children: [
          _ImageCircle(seed: _seedFromName(item.name), imageUrl: item.photo),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: AppTextStyles.sizeBody.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  item.nationality ?? '-',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withAlpha(94),
                    fontSize: AppTextStyles.sizeBodySmall.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          _MetaColumn(
            label: 'AGE',
            value: item.age == null ? '-' : '${item.age}',
          ),
        ],
      ),
    );

    if (onTap == null) {
      return content;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: content,
      ),
    );
  }
}

class _PlayerRow extends StatelessWidget {
  final FootballTeamPlayerItemModel item;
  final FootballPlayerStatisticModel? stat;
  final VoidCallback? onTap;

  const _PlayerRow({required this.item, required this.stat, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final number = stat?.games.number == null ? '-' : '${stat!.games.number}';
    final position = stat?.games.position ?? '-';

    final content = Container(
      height: 72.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: theme.colorScheme.onSurface.withAlpha(6),
      ),
      child: Row(
        children: [
          _ImageCircle(
            seed: _seedFromName(item.player.name),
            imageUrl: item.player.photo,
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.player.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: AppTextStyles.sizeBody.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  '${item.player.nationality.isEmpty ? '-' : item.player.nationality} • $position',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withAlpha(94),
                    fontSize: AppTextStyles.sizeBodySmall.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          _MetaColumn(label: 'NO', value: number, highlight: true),
          SizedBox(width: 20.w),
          _MetaColumn(
            label: 'AGE',
            value: item.player.age == null ? '-' : '${item.player.age}',
          ),
        ],
      ),
    );

    if (onTap == null) {
      return content;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: content,
      ),
    );
  }
}

class _ImageCircle extends StatelessWidget {
  final String seed;
  final String imageUrl;

  const _ImageCircle({required this.seed, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 42.r,
      height: 42.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.primary, width: 1.w),
      ),
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      child: imageUrl.isEmpty
          ? Text(
              seed,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: AppTextStyles.sizeTiny.sp,
                fontWeight: FontWeight.w800,
              ),
            )
          : AppCachedNetworkImage(
  imageUrl: imageUrl,
  width: 42.r,
  height: 42.r,
  fit: BoxFit.cover,
  errorBuilder: (context) => Text(
                seed,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: AppTextStyles.sizeTiny.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
),
    );
  }
}

class _MetaColumn extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _MetaColumn({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: theme.colorScheme.onSurface.withAlpha(90),
            fontSize: AppTextStyles.sizeBodySmall.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            color: highlight
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
            fontSize: AppTextStyles.sizeHeading.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _EmptyText extends StatelessWidget {
  final String text;

  const _EmptyText({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: theme.colorScheme.onSurface.withAlpha(120),
          fontSize: AppTextStyles.sizeBodySmall.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

String _seedFromName(String value) {
  final clean = value.trim();
  if (clean.isEmpty) return '?';
  final parts = clean.split(RegExp(r'\s+'));
  if (parts.length == 1) {
    return clean
        .substring(0, clean.length < 3 ? clean.length : 3)
        .toUpperCase();
  }
  return parts.take(3).map((part) => part[0]).join().toUpperCase();
}
