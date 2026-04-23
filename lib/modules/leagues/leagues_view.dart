
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/themes/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../shared/app_bar_view.dart';
import 'leagues_controller.dart';
import 'model/leagues_models.dart';

class LeaguesView extends GetView<LeaguesController> {
  const LeaguesView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.scaffoldBackgroundColor,
            theme.brightness == Brightness.dark
                ? const Color(0xFF030907)
                : theme.colorScheme.surface.withAlpha(22),
          ],
        ),
      ),
      child: SafeArea(
        child: Obx(() {
          final state = controller.state.value;

          return Column(
            children: [
              SizedBox(height: 8.h),
              Expanded(
                child: _Body(state: state, controller: controller),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final LeaguesViewModel state;
  final LeaguesController controller;

  const _Body({required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (state.isLoading) {
      return Center(
        child: SizedBox(
          width: 26.r,
          height: 26.r,
          child: CircularProgressIndicator(
            strokeWidth: 2.4.w,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.secondary,
            ),
          ),
        ),
      );
    }

    if (state.errorCode != null) {
      return _ErrorState(onRetry: controller.reload);
    }

    if (state.topLeagues.isEmpty && state.countries.isEmpty) {
      return const _EmptyState();
    }

    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 26.h),
      children: [
        _SectionHeader(
          title: 'TOP LEAGUES',
          actionLabel: state.hasExpandableTopLeagues
              ? (state.showAllTopLeagues ? 'SEE LESS' : 'SEE ALL')
              : 'SEE ALL',
          onActionTap: state.hasExpandableTopLeagues
              ? controller.toggleTopLeaguesVisibility
              : null,
        ),
        SizedBox(height: 12.h),
        //for (final league in state.visibleTopLeagues)
        for (int i = 0; i < state.visibleTopLeagues.length; i++)
          _TopLeagueCard(
            inte: i,
            league: state.visibleTopLeagues[i],
            onTap: () =>
                Get.toNamed(AppRoutes.leagueDetails, arguments: state.visibleTopLeagues[i]),
          ),
        SizedBox(height: 24.h),
        const _SectionHeader(title: 'ALL LEAGUES'),
        SizedBox(height: 12.h),
        for (final country in state.countries)
          _CountryLeagueGroup(
            country: country,
            isExpanded: state.isCountryExpanded(country.countryId),
            onToggle: () => controller.toggleCountryExpanded(country.countryId),
          ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  const _SectionHeader({
    this.actionLabel,
    this.onActionTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: theme.colorScheme.onSurface.withAlpha(150),
            fontSize: AppTextStyles.sizeLabel.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        const Spacer(),
        if (actionLabel != null)
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12.r),
              onTap: onActionTap,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Text(
                  actionLabel!,
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontSize: AppTextStyles.sizeCaption.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _TopLeagueCard extends StatelessWidget {
  final LeaguesTopLeagueUiModel league;
  final VoidCallback onTap;
  final int inte;
  const _TopLeagueCard({required this.league, required this.onTap, required this.inte});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: onTap,
          child: Container(
            height: 74.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  theme.colorScheme.surface.withAlpha(228),
                  theme.colorScheme.surface.withAlpha(146),
                ],
              ),
              border: Border.all(
                color: theme.dividerColor.withAlpha(135),
                width: 1.w,
              ),
            ),
            child: Row(
              children: [
                //_TopLeagueBadge(league: league),
                Image.asset('assets/images/Overlay (1).png', width: 35.r, height: 35.r),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    league.leagueName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: AppTextStyles.sizeBody.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 22.r,
                  color: theme.colorScheme.onSurface.withAlpha(165),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopLeagueBadge extends StatelessWidget {
  final LeaguesTopLeagueUiModel league;

  const _TopLeagueBadge({required this.league});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 40.r,
      height: 40.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.surface.withAlpha(190),
        border: Border.all(
          color: theme.dividerColor.withAlpha(130),
          width: 1.w,
        ),
      ),
      alignment: Alignment.center,
      child: Container(
            width: 22.r,
            height: 22.r,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.r),
              child: Builder(
                builder: (context) {
                  // final imagePath = (league.image == null || league.image.isEmpty)
                  //     ? 'assets/leagues/${league.leagueId}.png'
                  //     : league.image;
                  final imagePath = league.image ?? '';
                  return Image.asset(
                    imagePath,
                    width: 22.r,
                    height: 22.r,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      final seed = league.badgeSeed ?? '';
                      final hex = league.badgeHex ?? '#324440';
                      return Container(
                        decoration: BoxDecoration(
                          color: _parseHexColor(hex).withAlpha(220),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          seed,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppTextStyles.sizeTiny.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
      ),
    );
  }
}

class _CountryLeagueGroup extends StatelessWidget {
  final LeaguesCountryUiModel country;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _CountryLeagueGroup({
    required this.country,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (isExpanded) {
      return _ExpandedCountryCard(country: country, onToggle: onToggle);
    }

    return _CountryRow(country: country, isExpanded: false, onTap: onToggle);
  }
}

class _ExpandedCountryCard extends StatelessWidget {
  final LeaguesCountryUiModel country;
  final VoidCallback onToggle;

  const _ExpandedCountryCard({required this.country, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface.withAlpha(220),
              theme.colorScheme.surface.withAlpha(140),
            ],
          ),
          border: Border.all(
            color: theme.dividerColor.withAlpha(135),
            width: 1.w,
          ),
        ),
        child: Column(
          children: [
            _CountryRow(
              country: country,
              isExpanded: true,
              useHorizontalPadding: true,
              onTap: onToggle,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(54.w, 2.h, 14.w, 14.h),
              child: Column(
                children: [
                  for (
                    var index = 0;
                    index < country.competitions.length;
                    index++
                  )
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: index == country.competitions.length - 1
                            ? 0
                            : 12.h,
                      ),
                      child: _CompetitionRow(
                        competition: country.competitions[index],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountryRow extends StatelessWidget {
  final LeaguesCountryUiModel country;
  final bool isExpanded;
  final bool useHorizontalPadding;
  final VoidCallback onTap;

  const _CountryRow({
    required this.country,
    required this.isExpanded,
    this.useHorizontalPadding = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: country.isExpandable ? onTap : null,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            useHorizontalPadding ? 12.w : 0,
            12.h,
            useHorizontalPadding ? 12.w : 0,
            12.h,
          ),
          child: Row(
            children: [
              _CountryFlag(country: country),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  country.countryName,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: AppTextStyles.sizeBody.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                isExpanded ? Icons.keyboard_arrow_down : Icons.chevron_right,
                size: 22.r,
                color: theme.colorScheme.onSurface.withAlpha(165),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountryFlag extends StatelessWidget {
  final LeaguesCountryUiModel country;

  const _CountryFlag({required this.country});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 34.r,
      height: 34.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _parseHexColor(country.flagHex),
        border: Border.all(
          color: theme.dividerColor.withAlpha(155),
          width: 1.w,
        ),
      ),
      alignment: Alignment.center,
      child: country.flagSeed == 'GLB'
          ? Icon(Icons.public, size: 17.r, color: theme.colorScheme.surface)
          : Text(
              country.flagSeed,
              style: TextStyle(
                color: Colors.white,
                fontSize: AppTextStyles.sizeTiny.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
    );
  }
}

class _CompetitionRow extends StatelessWidget {
  final LeaguesCompetitionUiModel competition;

  const _CompetitionRow({required this.competition});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 26.r,
          height: 26.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _parseHexColor(competition.badgeHex),
            border: Border.all(
              color: theme.dividerColor.withAlpha(140),
              width: 1.w,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            competition.badgeSeed,
            style: TextStyle(
              color: Colors.white,
              fontSize: AppTextStyles.sizeCaption.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            competition.title,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withAlpha(185),
              fontSize: AppTextStyles.sizeBodySmall.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 34.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Unable to load leagues',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withAlpha(170),
                fontSize: AppTextStyles.sizeBody.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 14.h),
            SizedBox(
              height: 42.h,
              child: ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                ),
                child: const Text('Retry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Text(
        'No leagues available',
        style: TextStyle(
          color: theme.colorScheme.onSurface.withAlpha(155),
          fontSize: AppTextStyles.sizeBody.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

Color _parseHexColor(String hexValue) {
  final normalized = hexValue.replaceFirst('#', '');
  if (normalized.length != 6) {
    return const Color(0xFF324440);
  }

  final colorInt = int.tryParse('FF$normalized', radix: 16);
  if (colorInt == null) {
    return const Color(0xFF324440);
  }

  return Color(colorInt);
}
