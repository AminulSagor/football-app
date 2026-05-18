import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/themes/app_text_styles.dart';
import '../../routes/app_routes.dart';
import 'leagues_controller.dart';
import 'model/leagues_models.dart';

const List<String> _flagAssetPaths = <String>[
  'assets/images/flags/Background+Border.png',
  'assets/images/flags/Background+Border (1).png',
  'assets/images/flags/Background+Border (2).png',
  'assets/images/flags/Background+Border (3).png',
  'assets/images/flags/Background+Border (4).png',
  'assets/images/flags/Background+Border (5).png',
];

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
      return Skeletonizer(
        enabled: true,
        effect: _solidSkeletonEffect(theme),
        child: _Body(
          state: _skeletonLeaguesState(),
          controller: controller,
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
            onTap: () => Get.toNamed(
              AppRoutes.leagueDetails,
              arguments: state.visibleTopLeagues[i],
            ),
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
  const _TopLeagueCard({
    required this.league,
    required this.onTap,
    required this.inte,
  });

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
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
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
                _TopLeagueLogo(league: league),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    league.leagueName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: AppTextStyles.sizeBodySmall.sp,
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


class _TopLeagueLogo extends StatelessWidget {
  final LeaguesTopLeagueUiModel league;

  const _TopLeagueLogo({required this.league});

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
      child: ClipOval(
        child: league.image.isEmpty
            ? _TopLeagueBadge(league: league)
            : Image.network(
                league.image,
                width: 32.r,
                height: 32.r,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return _TopLeagueBadge(league: league);
                },
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
              final imagePath = league.image;
              return Image.asset(
                imagePath,
                width: 22.r,
                height: 22.r,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  final seed = league.badgeSeed;
                  final hex = league.badgeHex;
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
                        onTap: () => Get.toNamed(
                          AppRoutes.leagueDetails,
                          arguments: country.competitions[index].toTopLeague(
                            fallbackCountryName: country.countryName,
                            fallbackCountryFlag: country.flagUrl,
                          ),
                        ),
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
                    fontSize: AppTextStyles.sizeBodySmall.sp,
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
      child: ClipOval(
        child: _CountryFlagContent(country: country),
      ),
    );
  }
}



class _CountryFlagContent extends StatelessWidget {
  final LeaguesCountryUiModel country;

  const _CountryFlagContent({required this.country});

  @override
  Widget build(BuildContext context) {
    final flagImageUrl = _countryFlagImageUrl(country);

    if (flagImageUrl.isNotEmpty) {
      return Image.network(
        flagImageUrl,
        width: 34.r,
        height: 34.r,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _CountryFlagFallback(country: country);
        },
      );
    }

    return _CountryFlagFallback(country: country);
  }
}

class _CountryFlagFallback extends StatelessWidget {
  final LeaguesCountryUiModel country;

  const _CountryFlagFallback({required this.country});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (country.flagSeed == 'GLB' || country.flagSeed == 'WO') {
      return Icon(
        Icons.public,
        size: 17.r,
        color: theme.colorScheme.surface,
      );
    }

    return Center(
      child: Text(
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

class _CompetitionLogo extends StatelessWidget {
  final LeaguesCompetitionUiModel competition;

  const _CompetitionLogo({required this.competition});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
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
      child: ClipOval(
        child: competition.image.isEmpty
            ? _CompetitionSeed(competition: competition)
            : Image.network(
                competition.image,
                width: 22.r,
                height: 22.r,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return _CompetitionSeed(competition: competition);
                },
              ),
      ),
    );
  }
}

class _CompetitionSeed extends StatelessWidget {
  final LeaguesCompetitionUiModel competition;

  const _CompetitionSeed({required this.competition});

  @override
  Widget build(BuildContext context) {
    return Text(
      competition.badgeSeed,
      style: TextStyle(
        color: Colors.white,
        fontSize: AppTextStyles.sizeCaption.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _CompetitionRow extends StatelessWidget {
  final LeaguesCompetitionUiModel competition;
  final VoidCallback onTap;

  const _CompetitionRow({required this.competition, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Row(
            children: [
              _CompetitionLogo(competition: competition),
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
              Icon(
                Icons.chevron_right_rounded,
                size: 18.r,
                color: theme.colorScheme.onSurface.withAlpha(110),
              ),
            ],
          ),
        ),
      ),
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


ShimmerEffect _solidSkeletonEffect(ThemeData theme) {
  final color = theme.colorScheme.onSurface.withAlpha(
    theme.brightness == Brightness.dark ? 28 : 18,
  );
  return ShimmerEffect(baseColor: color, highlightColor: color);
}

LeaguesViewModel _skeletonLeaguesState() {
  final leagues = List<LeaguesTopLeagueUiModel>.generate(
    5,
    (index) => LeaguesTopLeagueUiModel(
      leagueId: 'skeleton_$index',
      image: '',
      leagueName: 'League Name',
      badgeSeed: 'LG',
      badgeHex: '#2A3B36',
      countryName: 'Country',
      leagueType: 'League',
    ),
  );

  final competitions = leagues
      .map(
        (league) => LeaguesCompetitionUiModel(
          competitionId: league.leagueId,
          title: league.leagueName,
          badgeSeed: league.badgeSeed,
          badgeHex: league.badgeHex,
          image: league.image,
          type: league.leagueType,
        ),
      )
      .toList(growable: false);

  return LeaguesViewModel(
    isLoading: false,
    topLeagues: leagues,
    countries: <LeaguesCountryUiModel>[
      LeaguesCountryUiModel(
        countryId: 'skeleton_country',
        countryName: 'Country Name',
        flagSeed: 'CT',
        flagHex: '#2D3D39',
        isExpandedByDefault: true,
        competitions: competitions,
      ),
    ],
    expandedCountryIds: const <String>{'skeleton_country'},
  );
}

String _countryFlagImageUrl(LeaguesCountryUiModel country) {
  final flagUrl = country.flagUrl;
  if (flagUrl.isEmpty) {
    return '';
  }

  final lowerUrl = flagUrl.toLowerCase();
  if (!lowerUrl.endsWith('.svg')) {
    return flagUrl;
  }

  final fileName = lowerUrl.split('/').last.replaceAll('.svg', '');
  if (RegExp(r'^[a-z]{2}$').hasMatch(fileName)) {
    return 'https://flagcdn.com/w80/$fileName.png';
  }

  return flagUrl;
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

String _flagAssetByKey(String key) {
  if (key.isEmpty) {
    return _flagAssetPaths.first;
  }

  final hash = key.codeUnits.fold<int>(0, (sum, unit) => sum + unit);
  return _flagAssetPaths[hash % _flagAssetPaths.length];
}
