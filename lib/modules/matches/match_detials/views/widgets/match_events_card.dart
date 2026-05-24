import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:fotgram/core/themes/themes.dart';
import '../../models/match_details_model.dart';

class MatchEventsCard extends StatelessWidget {
  final List<MatchDetailsEventUiModel> events;
  final List<MatchDetailsTimelineMarkerUiModel> markers;

  const MatchEventsCard({
    super.key,
    required this.events,
    required this.markers,
  });

  @override
  Widget build(BuildContext context) {
    final sortedMarkers = <MatchDetailsTimelineMarkerUiModel>[...markers]
      ..sort((a, b) => (a.minute ?? 999).compareTo(b.minute ?? 999));
    final children = <Widget>[];
    var markerIndex = 0;

    void addSpacing() {
      if (children.isNotEmpty) children.add(SizedBox(height: 18.h));
    }

    void addMarker(MatchDetailsTimelineMarkerUiModel marker) {
      addSpacing();
      children.add(_TimelineMarker(label: marker.label));
    }

    for (final event in events) {
      final elapsed = event.elapsedMinute;

      while (markerIndex < sortedMarkers.length &&
          sortedMarkers[markerIndex].minute != null &&
          elapsed != null &&
          sortedMarkers[markerIndex].minute! < elapsed) {
        addMarker(sortedMarkers[markerIndex]);
        markerIndex++;
      }

      addSpacing();
      children.add(_EventRow(item: event));
    }

    while (markerIndex < sortedMarkers.length) {
      addMarker(sortedMarkers[markerIndex]);
      markerIndex++;
    }

    return Column(children: children);
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
        color: const Color(0xFFF0C419),
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
