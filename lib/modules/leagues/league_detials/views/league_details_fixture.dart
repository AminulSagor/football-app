import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/widgets/app_cached_network_image.dart';
import '../models/league_detials_model.dart';
import '../league_details_controller.dart';

class LeagueDetailsFixturesPage extends GetView<LeagueDetailsController> {
  const LeagueDetailsFixturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state.value;
      final isLoading = state.isLoading || state.isFixturesLoading;
      final fixtures = isLoading ? _skeletonFixtures() : state.fixtures;

      return Skeletonizer(
        enabled: isLoading,
        effect: _solidSkeletonEffect(Theme.of(context)),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
          children: [
            _FixturesSurfaceCard(
              fixtures: fixtures,
              isLoadingMore: state.isFixturesLoadingMore,
              showDateNavigator: true,
              onModeTap: controller.showFixturesModePicker,
              onActionTap: fixtures.mode == LeagueDetailsFixturesMode.byDate
                  ? () => controller.showFixtureDateRangePicker(context)
                  : fixtures.mode == LeagueDetailsFixturesMode.byTeam
                  ? () => controller.showTeamPicker()
                  : () => controller.showRoundPicker(),
              onDatePreviousTap: () => controller.showPreviousFixtureDate(),
              onDateNextTap: () => controller.showNextFixtureDate(),
              onLoadMoreTap: () => controller.loadMoreFixtures(),
              onFixtureTap: controller.openMatchDetails,
            ),
          ],
        ),
      );
    });
  }
}

class _FixturesSurfaceCard extends StatelessWidget {
  final LeagueDetailsFixturesViewModel fixtures;
  final bool isLoadingMore;
  final bool showDateNavigator;
  final VoidCallback onModeTap;
  final VoidCallback onActionTap;
  final VoidCallback onDatePreviousTap;
  final VoidCallback onDateNextTap;
  final VoidCallback onLoadMoreTap;
  final ValueChanged<LeagueDetailsFixtureUiModel> onFixtureTap;

  const _FixturesSurfaceCard({
    required this.fixtures,
    required this.isLoadingMore,
    required this.showDateNavigator,
    required this.onModeTap,
    required this.onActionTap,
    required this.onDatePreviousTap,
    required this.onDateNextTap,
    required this.onLoadMoreTap,
    required this.onFixtureTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sections = fixtures.sectionsForMode;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface.withAlpha(220),
            theme.colorScheme.surface.withAlpha(140),
          ],
        ),
        border: Border.all(
          color: theme.dividerColor.withAlpha(150),
          width: 1.w,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Padding(
          padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  _FixturesChip(
                    label: fixtures.modeLabel,
                    icon: Icons.keyboard_arrow_down_rounded,
                    onTap: onModeTap,
                  ),
                  const Spacer(),
                  _FixturesChip(
                    label: fixtures.actionLabel,
                    icon: fixtures.actionIcon,
                    onTap: onActionTap,
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              if (fixtures.mode == LeagueDetailsFixturesMode.byDate &&
                  showDateNavigator) ...[
                _DateNavigatorBar(
                  label: fixtures.selectedDateLabel,
                  isNextDisabled: fixtures.isDateNextDisabled,
                  onPreviousTap: onDatePreviousTap,
                  onNextTap: onDateNextTap,
                ),
                SizedBox(height: 16.h),
              ],
              if (fixtures.mode == LeagueDetailsFixturesMode.byTeam) ...[
                _TeamSelectorRow(
                  label: fixtures.selectedTeamLabel.isEmpty
                      ? 'Select team'
                      : fixtures.selectedTeamLabel,
                  logoUrl: fixtures.selectedTeamLogoUrl,
                  onTap: onActionTap,
                ),
                SizedBox(height: 14.h),
                _SectionDividerTitle(
                  label: fixtures.teamRangeLabel.isEmpty
                      ? 'ALL MATCHES'
                      : fixtures.teamRangeLabel,
                ),
                SizedBox(height: 18.h),
              ],
              if (fixtures.mode != LeagueDetailsFixturesMode.byDate &&
                  fixtures.mode != LeagueDetailsFixturesMode.byTeam)
                SizedBox(height: 2.h),
              if (sections.isNotEmpty)
                _FixtureSectionsList(
                  sections: sections,
                  sectionSpacing:
                      fixtures.mode == LeagueDetailsFixturesMode.byTeam
                      ? 18.h
                      : 20.h,
                  onFixtureTap: onFixtureTap,
                ),
              if (isLoadingMore) ...[
                SizedBox(height: sections.isEmpty ? 0 : 16.h),
                const _FixtureLoadMoreSkeleton(),
              ],
              if (sections.isEmpty && !isLoadingMore)
                const _InCardEmptyMessage(
                  message: 'No fixtures found for the selected filter.',
                ),
              if (fixtures.showLoadMoreButton && !isLoadingMore) ...[
                SizedBox(height: 18.h),
                Center(child: _LoadMoreButton(onTap: onLoadMoreTap)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FixturesChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const _FixturesChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          height: 36.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: theme.colorScheme.secondary,
            border: Border.all(color: theme.colorScheme.secondary, width: 1.w),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: const Color(0xFF05110D),
                  fontSize: AppTextStyles.sizeBodySmall.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(icon, size: 16.r, color: const Color(0xFF05110D)),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateNavigatorBar extends StatelessWidget {
  final String label;
  final bool isNextDisabled;
  final VoidCallback onPreviousTap;
  final VoidCallback onNextTap;

  const _DateNavigatorBar({
    required this.label,
    required this.isNextDisabled,
    required this.onPreviousTap,
    required this.onNextTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        _DateArrowButton(
          icon: Icons.chevron_left_rounded,
          onTap: onPreviousTap,
        ),
        Expanded(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: AppTextStyles.sizeOverline.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.8,
            ),
          ),
        ),
        _DateArrowButton(
          icon: Icons.chevron_right_rounded,
          onTap: isNextDisabled ? null : onNextTap,
        ),
      ],
    );
  }
}

class _DateArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _DateArrowButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isEnabled = onTap != null;
    final fillColor = isEnabled
        ? theme.colorScheme.secondary
        : theme.colorScheme.surface.withAlpha(140);
    final iconColor = isEnabled
        ? const Color(0xFF05110D)
        : theme.colorScheme.onSurface.withAlpha(90);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Container(
          width: 42.w,
          height: 32.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: fillColor,
            border: Border.all(color: fillColor, width: 1.w),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 18.r, color: iconColor),
        ),
      ),
    );
  }
}

class _TeamSelectorRow extends StatelessWidget {
  final String label;
  final String logoUrl;
  final VoidCallback onTap;

  const _TeamSelectorRow({
    required this.label,
    required this.logoUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.r),
        onTap: onTap,
        child: Container(
          height: 40.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: theme.colorScheme.surface.withAlpha(120),
            border: Border.all(
              color: theme.dividerColor.withAlpha(140),
              width: 1.w,
            ),
          ),
          child: Row(
            children: [
              _TeamSelectorLogo(label: label, logoUrl: logoUrl),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: AppTextStyles.sizeBodySmall.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 20.r,
                color: theme.colorScheme.onSurface.withAlpha(200),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TeamSelectorLogo extends StatelessWidget {
  final String label;
  final String logoUrl;

  const _TeamSelectorLogo({required this.label, required this.logoUrl});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final seed = label.trim().isEmpty ? 'T' : label.trim()[0].toUpperCase();

    return Container(
      width: 22.r,
      height: 22.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.surface.withAlpha(180),
        border: Border.all(
          color: theme.dividerColor.withAlpha(150),
          width: 1.w,
        ),
      ),
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      child: logoUrl.isEmpty
          ? _FixtureTeamSeed(seed: seed)
          : AppCachedNetworkImage(
              imageUrl: logoUrl,
              width: 18.r,
              height: 18.r,
              fit: BoxFit.contain,
              errorBuilder: (context) => _FixtureTeamSeed(seed: seed),
            ),
    );
  }
}

class _SectionDividerTitle extends StatelessWidget {
  final String label;

  const _SectionDividerTitle({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1.h,
            color: theme.dividerColor.withAlpha(90),
          ),
        ),
        SizedBox(width: 14.w),
        Text(
          label,
          style: TextStyle(
            color: theme.colorScheme.secondary,
            fontSize: AppTextStyles.sizeOverline.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.8,
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Container(
            height: 1.h,
            color: theme.dividerColor.withAlpha(90),
          ),
        ),
      ],
    );
  }
}

class _FixtureSectionsList extends StatelessWidget {
  final List<LeagueDetailsFixtureSectionUiModel> sections;
  final double sectionSpacing;
  final ValueChanged<LeagueDetailsFixtureUiModel> onFixtureTap;

  const _FixtureSectionsList({
    required this.sections,
    required this.sectionSpacing,
    required this.onFixtureTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (
          var sectionIndex = 0;
          sectionIndex < sections.length;
          sectionIndex++
        ) ...[
          Padding(
            padding: EdgeInsets.only(
              top: sectionIndex == 0 ? 0.h : sectionSpacing,
            ),
            child: _FixtureSection(
              section: sections[sectionIndex],
              onFixtureTap: onFixtureTap,
            ),
          ),
        ],
      ],
    );
  }
}

class _FixtureSection extends StatelessWidget {
  final LeagueDetailsFixtureSectionUiModel section;
  final ValueChanged<LeagueDetailsFixtureUiModel> onFixtureTap;

  const _FixtureSection({required this.section, required this.onFixtureTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SectionDividerTitle(label: section.title),
        SizedBox(height: 14.h),
        for (
          var fixtureIndex = 0;
          fixtureIndex < section.fixtures.length;
          fixtureIndex++
        )
          Padding(
            padding: EdgeInsets.only(
              bottom: fixtureIndex == section.fixtures.length - 1 ? 0.h : 10.h,
            ),
            child: _FixtureCard(
              fixture: section.fixtures[fixtureIndex],
              onTap: () => onFixtureTap(section.fixtures[fixtureIndex]),
            ),
          ),
      ],
    );
  }
}

class _FixtureCard extends StatelessWidget {
  final LeagueDetailsFixtureUiModel fixture;
  final VoidCallback onTap;

  const _FixtureCard({required this.fixture, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = fixture.isFinished
        ? theme.colorScheme.onSurface.withAlpha(120)
        : theme.colorScheme.secondary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.surface.withAlpha(222),
                theme.colorScheme.surface.withAlpha(148),
              ],
            ),
            border: Border.all(
              color: theme.dividerColor.withAlpha(130),
              width: 1.w,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _FixtureTeamRow(team: fixture.homeTeam),
                      SizedBox(height: 10.h),
                      _FixtureTeamRow(team: fixture.awayTeam),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                fixture.hasScore
                    ? _FixtureScoreColumn(
                        topScore: _scoreText(fixture.homeScore),
                        bottomScore: _scoreText(fixture.awayScore),
                      )
                    : SizedBox(width: 20.w),
                SizedBox(width: 12.w),
                Container(
                  width: 1.w,
                  height: 54.h,
                  color: theme.dividerColor.withAlpha(160),
                ),
                SizedBox(width: 12.w),
                SizedBox(
                  width: 54.w,
                  child: _FixtureStatusColumn(
                    statusLabel: fixture.statusLabel,
                    statusDetail: fixture.statusDetail,
                    color: statusColor,
                    isFinished: fixture.isFinished,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _scoreText(int? score) {
    return score == null ? '-' : '$score';
  }
}

class _FixtureTeamRow extends StatelessWidget {
  final LeagueDetailsFixtureTeamUiModel team;

  const _FixtureTeamRow({required this.team});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        _FixtureTeamLogo(team: team),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            team.teamName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: AppTextStyles.sizeBodySmall.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

class _FixtureTeamLogo extends StatelessWidget {
  final LeagueDetailsFixtureTeamUiModel team;

  const _FixtureTeamLogo({required this.team});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.r,
      height: 20.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: team.badgeColor.withAlpha(220),
        border: Border.all(color: Colors.white.withAlpha(24), width: 1.w),
      ),
      alignment: Alignment.center,
      child: ClipOval(
        child: team.logoUrl.isEmpty
            ? _FixtureTeamSeed(seed: team.shortName)
            : AppCachedNetworkImage(
                imageUrl: team.logoUrl,
                width: 18.r,
                height: 18.r,
                fit: BoxFit.contain,
                errorBuilder: (context) =>
                    _FixtureTeamSeed(seed: team.shortName),
              ),
      ),
    );
  }
}

class _FixtureTeamSeed extends StatelessWidget {
  final String seed;

  const _FixtureTeamSeed({required this.seed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        seed,
        style: TextStyle(
          color: Colors.white.withAlpha(225),
          fontSize: AppTextStyles.sizeTiny.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _FixtureScoreColumn extends StatelessWidget {
  final String topScore;
  final String bottomScore;

  const _FixtureScoreColumn({
    required this.topScore,
    required this.bottomScore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 20.w,
      child: Column(
        children: [
          Text(
            topScore,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: AppTextStyles.sizeBody.sp,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            bottomScore,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: AppTextStyles.sizeBody.sp,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _FixtureStatusColumn extends StatelessWidget {
  final String statusLabel;
  final String statusDetail;
  final Color color;
  final bool isFinished;

  const _FixtureStatusColumn({
    required this.statusLabel,
    required this.statusDetail,
    required this.color,
    required this.isFinished,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          statusLabel,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
            fontSize: AppTextStyles.sizeBodySmall.sp,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
        if (statusDetail.isNotEmpty) ...[
          SizedBox(height: 3.h),
          Text(
            statusDetail,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color.withAlpha(isFinished ? 170 : 220),
              fontSize: AppTextStyles.sizeTiny.sp,
              fontWeight: FontWeight.w600,
              height: 1,
            ),
          ),
        ],
      ],
    );
  }
}

class _InCardEmptyMessage extends StatelessWidget {
  final String message;

  const _InCardEmptyMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 28.h),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: theme.colorScheme.onSurface.withAlpha(150),
          fontSize: AppTextStyles.sizeBody.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _FixtureLoadMoreSkeleton extends StatelessWidget {
  const _FixtureLoadMoreSkeleton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final skeletonSections = _skeletonFixtures().byDateSections;

    return Skeletonizer(
      enabled: true,
      effect: _solidSkeletonEffect(theme),
      child: _FixtureSectionsList(
        sections: skeletonSections,
        sectionSpacing: 12.h,
        onFixtureTap: (_) {},
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
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: theme.colorScheme.secondary,
            border: Border.all(color: theme.colorScheme.secondary, width: 1.w),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.secondary.withAlpha(52),
                blurRadius: 14.r,
                offset: Offset(0, 7.h),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Load More',
                style: TextStyle(
                  color: const Color(0xFF05110D),
                  fontSize: AppTextStyles.sizeBodySmall.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18.r,
                color: const Color(0xFF05110D),
              ),
            ],
          ),
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

LeagueDetailsFixturesViewModel _skeletonFixtures() {
  final home = const LeagueDetailsFixtureTeamUiModel(
    teamName: 'Home Team',
    shortName: 'HOM',
    badgeColor: Color(0xFF2D3D39),
  );
  final away = const LeagueDetailsFixtureTeamUiModel(
    teamName: 'Away Team',
    shortName: 'AWY',
    badgeColor: Color(0xFF2D3D39),
  );
  final fixtures = List<LeagueDetailsFixtureUiModel>.generate(
    4,
    (index) => LeagueDetailsFixtureUiModel(
      fixtureId: 'skeleton_$index',
      homeTeam: home,
      awayTeam: away,
      homeScore: index,
      awayScore: index,
      statusLabel: 'FT',
      statusDetail: '',
    ),
  );
  return LeagueDetailsFixturesViewModel(
    selectedDateIndex: 0,
    selectedRoundLabel: 'Today',
    byDateSections: <LeagueDetailsFixtureSectionUiModel>[
      LeagueDetailsFixtureSectionUiModel(title: 'TODAY', fixtures: fixtures),
    ],
    byRoundSections: <LeagueDetailsFixtureSectionUiModel>[
      LeagueDetailsFixtureSectionUiModel(title: 'TODAY', fixtures: fixtures),
    ],
  );
}
