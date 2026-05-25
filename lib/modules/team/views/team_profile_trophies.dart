import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/themes/app_text_styles.dart';
import '../team_profile_controller.dart';
import '../team_profile_model.dart';
import 'package:fotgram/core/widgets/app_cached_network_image.dart';

class TeamProfileTrophiesPage extends GetView<TeamProfileController> {
  const TeamProfileTrophiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state.value;
      final isLoading = state.isTrophiesLoading && state.trophies.isEmpty;
      final items = isLoading ? _skeletonTrophies : state.visibleTrophyItems;

      return Skeletonizer(
        enabled: isLoading,
        effect: _solidSkeletonEffect(Theme.of(context)),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 28.h),
          children: [
            if (!isLoading && items.isEmpty)
              const _EmptySectionMessage(
                message: 'No trophies found for this team.',
              ),
            for (var index = 0; index < items.length; index++) ...[
              _TrophySectionCard(item: items[index]),
              if (index != items.length - 1) SizedBox(height: 24.h),
            ],
            if (!isLoading && state.canLoadMoreTrophies) ...[
              SizedBox(height: 26.h),
              Center(
                child: _LoadMoreButton(onTap: controller.loadMoreTrophies),
              ),
            ],
          ],
        ),
      );
    });
  }
}

class _TrophySectionCard extends StatelessWidget {
  final TeamProfileTrophySectionUiModel item;

  const _TrophySectionCard({required this.item});

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
            child: Row(
              children: [
                _BadgeCircle(seed: item.badgeSeed, imageUrl: item.logoUrl),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: AppTextStyles.sizeBody.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
            child: Column(
              children: [
                for (var index = 0; index < item.entries.length; index++)
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: index == item.entries.length - 1 ? 0 : 12.h,
                    ),
                    child: _TrophyEntryRow(item: item.entries[index]),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrophyEntryRow extends StatelessWidget {
  final TeamProfileTrophyEntryUiModel item;

  const _TrophyEntryRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: theme.colorScheme.onSurface.withAlpha(6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 46.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.count,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: AppTextStyles.sizeTitle.sp,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                SizedBox(height: 6.h),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    item.label,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withAlpha(100),
                      fontSize: AppTextStyles.sizeBodySmall.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              item.years,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withAlpha(108),
                fontSize: AppTextStyles.sizeBodySmall.sp,
                fontWeight: FontWeight.w500,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeCircle extends StatelessWidget {
  final String seed;
  final String imageUrl;

  const _BadgeCircle({required this.seed, this.imageUrl = ''});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 24.r,
      height: 24.r,
      padding: EdgeInsets.all(2.r),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.colorScheme.onSurface.withAlpha(200),
          width: 1.w,
        ),
      ),
      alignment: Alignment.center,
      child: imageUrl.isNotEmpty
          ? ClipOval(
              child: AppCachedNetworkImage(
                width: 24.r,
                height: 24.r,
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context) => _BadgeFallback(seed: seed),
              ),
            )
          : _BadgeFallback(seed: seed),
    );
  }
}

class _BadgeFallback extends StatelessWidget {
  final String seed;

  const _BadgeFallback({required this.seed});

  @override
  Widget build(BuildContext context) {
    return Text(
      seed,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: AppTextStyles.sizeTiny.sp,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

const List<TeamProfileTrophySectionUiModel> _skeletonTrophies = [
  TeamProfileTrophySectionUiModel(
    title: 'Competition name',
    badgeSeed: 'LG',
    badgeColor: Colors.transparent,
    entries: [
      TeamProfileTrophyEntryUiModel(
        count: '0',
        label: 'Winner',
        years: '2020, 2021, 2022',
      ),
      TeamProfileTrophyEntryUiModel(
        count: '0',
        label: 'Runner-up',
        years: '2023',
      ),
    ],
  ),
  TeamProfileTrophySectionUiModel(
    title: 'Competition name',
    badgeSeed: 'LG',
    badgeColor: Colors.transparent,
    entries: [
      TeamProfileTrophyEntryUiModel(
        count: '0',
        label: 'Winner',
        years: '2020, 2021, 2022',
      ),
    ],
  ),
  TeamProfileTrophySectionUiModel(
    title: 'Competition name',
    badgeSeed: 'LG',
    badgeColor: Colors.transparent,
    entries: [
      TeamProfileTrophyEntryUiModel(
        count: '0',
        label: 'Winner',
        years: '2020, 2021, 2022',
      ),
    ],
  ),
];

ShimmerEffect _solidSkeletonEffect(ThemeData theme) {
  final color = theme.colorScheme.onSurface.withAlpha(
    theme.brightness == Brightness.dark ? 28 : 18,
  );
  return ShimmerEffect(baseColor: color, highlightColor: color);
}

class _EmptySectionMessage extends StatelessWidget {
  final String message;

  const _EmptySectionMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h),
      child: Text(
        message,
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

class _LoadMoreButton extends StatelessWidget {
  final VoidCallback onTap;

  const _LoadMoreButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.r),
        onTap: onTap,
        child: Container(
          height: 38.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: theme.colorScheme.primary,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Load More',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontSize: AppTextStyles.sizeBody.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18.r,
                color: theme.colorScheme.onPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
