import 'package:flutter/material.dart';

import '../../model/leagues_models.dart';

class LeagueDetailsStandingsRowUiModel {
  final String rank;
  final String teamName;
  final String badgeSeed;
  final Color badgeColor;
  final String played;
  final String plusMinus;
  final String goalDifference;
  final String points;

  const LeagueDetailsStandingsRowUiModel({
    required this.rank,
    required this.teamName,
    required this.badgeSeed,
    required this.badgeColor,
    required this.played,
    required this.plusMinus,
    required this.goalDifference,
    required this.points,
  });
}


class LeagueDetailsWorldCupGroupUiModel {
  final String title;
  final List<LeagueDetailsStandingsRowUiModel> rows;

  const LeagueDetailsWorldCupGroupUiModel({
    required this.title,
    required this.rows,
  });
}

class LeagueDetailsKnockoutMatchUiModel {
  final String homeSeed;
  final String awaySeed;
  final String homeLabel;
  final String awayLabel;
  final String dateLabel;
  final bool isHighlighted;
  final bool showChampionMark;

  const LeagueDetailsKnockoutMatchUiModel({
    required this.homeSeed,
    required this.awaySeed,
    required this.homeLabel,
    required this.awayLabel,
    required this.dateLabel,
    this.isHighlighted = false,
    this.showChampionMark = false,
  });
}

class LeagueDetailsPlayerStatRowUiModel {
  final String rank;
  final String name;
  final String teamName;
  final String value;

  const LeagueDetailsPlayerStatRowUiModel({
    required this.rank,
    required this.name,
    required this.teamName,
    required this.value,
  });
}

class LeagueDetailsPitchPlayerPositionUiModel {
  final double x;
  final double y;
  final String label;

  const LeagueDetailsPitchPlayerPositionUiModel({
    required this.x,
    required this.y,
    required this.label,
  });
}

enum LeagueDetailsFixturesMode { byDate, byRound, byTeam }

class LeagueDetailsFixtureTeamUiModel {
  final String teamName;
  final String shortName;
  final Color badgeColor;

  const LeagueDetailsFixtureTeamUiModel({
    required this.teamName,
    required this.shortName,
    required this.badgeColor,
  });
}

class LeagueDetailsFixtureUiModel {
  final String fixtureId;
  final LeagueDetailsFixtureTeamUiModel homeTeam;
  final LeagueDetailsFixtureTeamUiModel awayTeam;
  final int? homeScore;
  final int? awayScore;
  final String statusLabel;
  final String statusDetail;

  const LeagueDetailsFixtureUiModel({
    required this.fixtureId,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.statusLabel,
    required this.statusDetail,
  });

  bool get isFinished => statusLabel == 'FT';
}

class LeagueDetailsFixtureSectionUiModel {
  final String title;
  final List<LeagueDetailsFixtureUiModel> fixtures;

  const LeagueDetailsFixtureSectionUiModel({
    required this.title,
    required this.fixtures,
  });
}

class LeagueDetailsFixturesViewModel {
  static const Object _unset = Object();

  final LeagueDetailsFixturesMode mode;
  final int selectedDateIndex;
  final String selectedRoundLabel;
  final String selectedTeamLabel;
  final String teamRangeLabel;
  final List<LeagueDetailsFixtureSectionUiModel> byDateSections;
  final List<LeagueDetailsFixtureSectionUiModel> byRoundSections;
  final List<LeagueDetailsFixtureSectionUiModel> byTeamSections;

  const LeagueDetailsFixturesViewModel({
    this.mode = LeagueDetailsFixturesMode.byDate,
    this.selectedDateIndex = 0,
    this.selectedRoundLabel = '',
    this.selectedTeamLabel = '',
    this.teamRangeLabel = '',
    this.byDateSections = const <LeagueDetailsFixtureSectionUiModel>[],
    this.byRoundSections = const <LeagueDetailsFixtureSectionUiModel>[],
    this.byTeamSections = const <LeagueDetailsFixtureSectionUiModel>[],
  });

  String get modeLabel {
    switch (mode) {
      case LeagueDetailsFixturesMode.byDate:
        return 'By date';
      case LeagueDetailsFixturesMode.byRound:
        return 'By round';
      case LeagueDetailsFixturesMode.byTeam:
        return 'By team';
    }
  }

  String get actionLabel {
    switch (mode) {
      case LeagueDetailsFixturesMode.byDate:
        return 'Jump to date';
      case LeagueDetailsFixturesMode.byRound:
        return selectedRoundLabel;
      case LeagueDetailsFixturesMode.byTeam:
        return selectedTeamLabel;
    }
  }

  IconData get actionIcon {
    switch (mode) {
      case LeagueDetailsFixturesMode.byDate:
        return Icons.calendar_today_rounded;
      case LeagueDetailsFixturesMode.byRound:
      case LeagueDetailsFixturesMode.byTeam:
        return Icons.keyboard_arrow_down_rounded;
    }
  }

  bool get showDateNavigator {
    return mode == LeagueDetailsFixturesMode.byDate &&
        byDateSections.isNotEmpty;
  }

  bool get showTeamSummary {
    return mode == LeagueDetailsFixturesMode.byTeam &&
        byTeamSections.isNotEmpty;
  }

  bool get showLoadMoreButton {
    return mode == LeagueDetailsFixturesMode.byTeam;
  }

  String get selectedDateLabel {
    if (byDateSections.isEmpty) {
      return '';
    }

    final normalizedIndex = selectedDateIndex % byDateSections.length;
    return byDateSections[normalizedIndex].title;
  }

  List<LeagueDetailsFixtureSectionUiModel> get sectionsForMode {
    switch (mode) {
      case LeagueDetailsFixturesMode.byDate:
        if (byDateSections.isEmpty) {
          return byDateSections;
        }

        final normalizedIndex = selectedDateIndex % byDateSections.length;
        if (normalizedIndex == 0) {
          return byDateSections;
        }

        return <LeagueDetailsFixtureSectionUiModel>[
          ...byDateSections.sublist(normalizedIndex),
          ...byDateSections.sublist(0, normalizedIndex),
        ];
      case LeagueDetailsFixturesMode.byRound:
        return byRoundSections;
      case LeagueDetailsFixturesMode.byTeam:
        return byTeamSections;
    }
  }

  LeagueDetailsFixturesViewModel copyWith({
    LeagueDetailsFixturesMode? mode,
    int? selectedDateIndex,
    Object? selectedRoundLabel = _unset,
    Object? selectedTeamLabel = _unset,
    Object? teamRangeLabel = _unset,
    Object? byDateSections = _unset,
    Object? byRoundSections = _unset,
    Object? byTeamSections = _unset,
  }) {
    return LeagueDetailsFixturesViewModel(
      mode: mode ?? this.mode,
      selectedDateIndex: selectedDateIndex ?? this.selectedDateIndex,
      selectedRoundLabel: identical(selectedRoundLabel, _unset)
          ? this.selectedRoundLabel
          : selectedRoundLabel as String,
      selectedTeamLabel: identical(selectedTeamLabel, _unset)
          ? this.selectedTeamLabel
          : selectedTeamLabel as String,
      teamRangeLabel: identical(teamRangeLabel, _unset)
          ? this.teamRangeLabel
          : teamRangeLabel as String,
      byDateSections: identical(byDateSections, _unset)
          ? this.byDateSections
          : byDateSections as List<LeagueDetailsFixtureSectionUiModel>,
      byRoundSections: identical(byRoundSections, _unset)
          ? this.byRoundSections
          : byRoundSections as List<LeagueDetailsFixtureSectionUiModel>,
      byTeamSections: identical(byTeamSections, _unset)
          ? this.byTeamSections
          : byTeamSections as List<LeagueDetailsFixtureSectionUiModel>,
    );
  }
}

class LeagueDetailsOverviewUiModel {
  final List<LeagueDetailsStandingsRowUiModel> topThreeRows;
  final List<LeagueDetailsPlayerStatRowUiModel> topScorers;
  final List<LeagueDetailsPlayerStatRowUiModel> topAssists;
  final String teamName;
  final String roundLabel;
  final List<LeagueDetailsPitchPlayerPositionUiModel> teamOfTheWeekPlayers;

  const LeagueDetailsOverviewUiModel({
    this.topThreeRows = const <LeagueDetailsStandingsRowUiModel>[],
    this.topScorers = const <LeagueDetailsPlayerStatRowUiModel>[],
    this.topAssists = const <LeagueDetailsPlayerStatRowUiModel>[],
    this.teamName = '',
    this.roundLabel = '',
    this.teamOfTheWeekPlayers =
        const <LeagueDetailsPitchPlayerPositionUiModel>[],
  });
}

class LeagueDetailsViewModel {
  static const Object _unset = Object();

  final LeaguesTopLeagueUiModel? league;
  final List<String> seasons;
  final String selectedSeason;
  final bool isFollowing;
  final List<LeagueDetailsStandingsRowUiModel> standingsRows;
  final LeagueDetailsFixturesViewModel fixtures;
  final LeagueDetailsOverviewUiModel overview;

  const LeagueDetailsViewModel({
    this.league,
    this.seasons = const <String>[],
    this.selectedSeason = '',
    this.isFollowing = false,
    this.standingsRows = const <LeagueDetailsStandingsRowUiModel>[],
    this.fixtures = const LeagueDetailsFixturesViewModel(),
    this.overview = const LeagueDetailsOverviewUiModel(),
  });

  String get leagueName => league?.leagueName ?? 'Premier League';

  LeagueDetailsViewModel copyWith({
    Object? league = _unset,
    Object? seasons = _unset,
    Object? selectedSeason = _unset,
    bool? isFollowing,
    Object? standingsRows = _unset,
    Object? fixtures = _unset,
    Object? overview = _unset,
  }) {
    final nextSeasons = identical(seasons, _unset)
        ? this.seasons
        : seasons as List<String>;

    final nextSelectedSeason = identical(selectedSeason, _unset)
        ? (nextSeasons.contains(this.selectedSeason)
              ? this.selectedSeason
              : (nextSeasons.isNotEmpty
                    ? nextSeasons.first
                    : this.selectedSeason))
        : selectedSeason as String;

    return LeagueDetailsViewModel(
      league: identical(league, _unset)
          ? this.league
          : league as LeaguesTopLeagueUiModel?,
      seasons: nextSeasons,
      selectedSeason: nextSelectedSeason,
      isFollowing: isFollowing ?? this.isFollowing,
      standingsRows: identical(standingsRows, _unset)
          ? this.standingsRows
          : standingsRows as List<LeagueDetailsStandingsRowUiModel>,
      fixtures: identical(fixtures, _unset)
          ? this.fixtures
          : fixtures as LeagueDetailsFixturesViewModel,
      overview: identical(overview, _unset)
          ? this.overview
          : overview as LeagueDetailsOverviewUiModel,
    );
  }
}
