import 'package:flutter/material.dart';

import '../../model/leagues_models.dart';

class LeagueDetailsStandingsRowUiModel {
  final String rank;
  final String teamId;
  final String teamName;
  final String badgeSeed;
  final Color badgeColor;
  final String teamLogoUrl;
  final String played;
  final String plusMinus;
  final String goalDifference;
  final String points;
  final String description;

  const LeagueDetailsStandingsRowUiModel({
    required this.rank,
    this.teamId = '',
    required this.teamName,
    required this.badgeSeed,
    required this.badgeColor,
    required this.played,
    required this.plusMinus,
    required this.goalDifference,
    required this.points,
    this.teamLogoUrl = '',
    this.description = '',
  });

  bool get isWorldCupPlayoffPromotion {
    return description.trim() == 'Promotion - World Cup (Play Offs)';
  }
}

class LeagueDetailsWorldCupGroupUiModel {
  final String title;
  final List<LeagueDetailsStandingsRowUiModel> rows;

  const LeagueDetailsWorldCupGroupUiModel({
    required this.title,
    required this.rows,
  });
}

class LeagueDetailsSeasonTeamUiModel {
  final String id;
  final String name;
  final String logoUrl;

  const LeagueDetailsSeasonTeamUiModel({
    this.id = '',
    this.name = '',
    this.logoUrl = '',
  });
}

class LeagueDetailsSeasonHistoryUiModel {
  final String season;
  final LeagueDetailsSeasonTeamUiModel winner;
  final LeagueDetailsSeasonTeamUiModel runnerUp;
  final String status;

  const LeagueDetailsSeasonHistoryUiModel({
    required this.season,
    this.winner = const LeagueDetailsSeasonTeamUiModel(),
    this.runnerUp = const LeagueDetailsSeasonTeamUiModel(),
    this.status = '',
  });
}

class LeagueDetailsKnockoutMatchUiModel {
  final String homeSeed;
  final String awaySeed;
  final String homeLabel;
  final String awayLabel;
  final String homeLogoUrl;
  final String awayLogoUrl;
  final String dateLabel;
  final bool isHighlighted;
  final bool showChampionMark;
  final bool isFinished;
  final bool homeWinner;
  final bool awayWinner;

  const LeagueDetailsKnockoutMatchUiModel({
    required this.homeSeed,
    required this.awaySeed,
    required this.homeLabel,
    required this.awayLabel,
    this.homeLogoUrl = '',
    this.awayLogoUrl = '',
    required this.dateLabel,
    this.isHighlighted = false,
    this.showChampionMark = false,
    this.isFinished = false,
    this.homeWinner = false,
    this.awayWinner = false,
  });
}

class LeagueDetailsPlayerStatRowUiModel {
  final String rank;
  final String name;
  final String teamId;
  final String teamName;
  // final String? teamId;
  final String value;
  final String subtitleValue;
  final String playerImageUrl;
  final String teamLogoUrl;

  const LeagueDetailsPlayerStatRowUiModel({
    required this.rank,
    required this.name,
    this.teamId = '',
    required this.teamName,
    //this.teamId,
    required this.value,
    this.subtitleValue = '',
    this.playerImageUrl = '',
    this.teamLogoUrl = '',
  });
}


class LeagueDetailsPlayerStatSectionUiModel {
  final String category;
  final String key;
  final String title;
  final List<LeagueDetailsPlayerStatRowUiModel> rows;

  const LeagueDetailsPlayerStatSectionUiModel({
    required this.category,
    required this.key,
    required this.title,
    this.rows = const <LeagueDetailsPlayerStatRowUiModel>[],
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
  final String logoUrl;

  const LeagueDetailsFixtureTeamUiModel({
    required this.teamName,
    required this.shortName,
    required this.badgeColor,
    this.logoUrl = '',
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

  bool get isFinished => statusLabel.toUpperCase() == 'FT';

  bool get hasScore => homeScore != null || awayScore != null;
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
  final String fromDate;
  final String toDate;
  final int datePage;
  final int dateTotalPages;
  final int roundPage;
  final int roundTotalPages;
  final bool isDateNextDisabled;
  final List<String> roundLabels;
  final List<LeagueDetailsFixtureSectionUiModel> byDateSections;
  final List<LeagueDetailsFixtureSectionUiModel> byRoundSections;
  final List<LeagueDetailsFixtureSectionUiModel> byTeamSections;

  const LeagueDetailsFixturesViewModel({
    this.mode = LeagueDetailsFixturesMode.byDate,
    this.selectedDateIndex = 0,
    this.selectedRoundLabel = '',
    this.selectedTeamLabel = '',
    this.teamRangeLabel = '',
    this.fromDate = '',
    this.toDate = '',
    this.datePage = 1,
    this.dateTotalPages = 1,
    this.roundPage = 1,
    this.roundTotalPages = 1,
    this.isDateNextDisabled = false,
    this.roundLabels = const <String>[],
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
        return selectedRoundLabel.isEmpty ? 'Select round' : selectedRoundLabel;
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
    return mode == LeagueDetailsFixturesMode.byDate;
  }

  bool get showTeamSummary {
    return mode == LeagueDetailsFixturesMode.byTeam &&
        byTeamSections.isNotEmpty;
  }

  bool get showLoadMoreButton {
    switch (mode) {
      case LeagueDetailsFixturesMode.byDate:
        return datePage < dateTotalPages;
      case LeagueDetailsFixturesMode.byRound:
        return roundPage < roundTotalPages;
      case LeagueDetailsFixturesMode.byTeam:
        return false;
    }
  }

  String get selectedDateLabel {
    if (fromDate.isNotEmpty && toDate.isNotEmpty) {
      return '${_compactDateLabel(fromDate)} - ${_compactDateLabel(toDate)}';
    }
    if (byDateSections.isEmpty) {
      return '';
    }
    return byDateSections.first.title;
  }

  List<LeagueDetailsFixtureSectionUiModel> get sectionsForMode {
    switch (mode) {
      case LeagueDetailsFixturesMode.byDate:
        return byDateSections;
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
    Object? fromDate = _unset,
    Object? toDate = _unset,
    int? datePage,
    int? dateTotalPages,
    int? roundPage,
    int? roundTotalPages,
    bool? isDateNextDisabled,
    Object? roundLabels = _unset,
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
      fromDate: identical(fromDate, _unset)
          ? this.fromDate
          : fromDate as String,
      toDate: identical(toDate, _unset) ? this.toDate : toDate as String,
      datePage: datePage ?? this.datePage,
      dateTotalPages: dateTotalPages ?? this.dateTotalPages,
      roundPage: roundPage ?? this.roundPage,
      roundTotalPages: roundTotalPages ?? this.roundTotalPages,
      isDateNextDisabled:
          isDateNextDisabled ?? this.isDateNextDisabled,
      roundLabels: identical(roundLabels, _unset)
          ? this.roundLabels
          : roundLabels as List<String>,
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

String _compactDateLabel(String date) {
  final parsed = DateTime.tryParse(date);
  if (parsed == null) {
    return date;
  }
  const months = <String>[
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC',
  ];
  return '${parsed.day} ${months[parsed.month - 1]}';
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

  LeagueDetailsOverviewUiModel copyWith({
    List<LeagueDetailsStandingsRowUiModel>? topThreeRows,
    List<LeagueDetailsPlayerStatRowUiModel>? topScorers,
    List<LeagueDetailsPlayerStatRowUiModel>? topAssists,
    String? teamName,
    String? roundLabel,
    List<LeagueDetailsPitchPlayerPositionUiModel>? teamOfTheWeekPlayers,
  }) {
    return LeagueDetailsOverviewUiModel(
      topThreeRows: topThreeRows ?? this.topThreeRows,
      topScorers: topScorers ?? this.topScorers,
      topAssists: topAssists ?? this.topAssists,
      teamName: teamName ?? this.teamName,
      roundLabel: roundLabel ?? this.roundLabel,
      teamOfTheWeekPlayers: teamOfTheWeekPlayers ?? this.teamOfTheWeekPlayers,
    );
  }
}

class LeagueDetailsViewModel {
  static const Object _unset = Object();

  final LeaguesTopLeagueUiModel? league;
  final List<String> seasons;
  final String selectedSeason;
  final bool isFollowing;
  final bool isLoading;
  final bool isFixturesLoading;
  final bool isFixturesLoadingMore;
  final String? errorCode;
  final List<LeagueDetailsStandingsRowUiModel> standingsRows;
  final List<LeagueDetailsWorldCupGroupUiModel> worldCupGroups;
  final int standingsPage;
  final int standingsTotalPages;
  final bool isStandingsLoadingMore;
  final LeagueDetailsFixturesViewModel fixtures;
  final LeagueDetailsOverviewUiModel overview;
  final List<LeagueDetailsPlayerStatRowUiModel> topScorersRows;
  final List<LeagueDetailsPlayerStatRowUiModel> topAssistsRows;
  final List<LeagueDetailsPlayerStatSectionUiModel> playerStatsSections;
  final bool isPlayerStatsLoading;
  final bool hasLoadedPlayerStats;
  final List<LeagueDetailsPlayerStatSectionUiModel> teamStatsSections;
  final bool isTeamStatsLoading;
  final bool hasLoadedTeamStats;
  final List<LeagueDetailsKnockoutMatchUiModel> knockoutRoundOf16;
  final List<LeagueDetailsKnockoutMatchUiModel> knockoutQuarterFinals;
  final List<LeagueDetailsKnockoutMatchUiModel> knockoutSemiFinals;
  final List<LeagueDetailsKnockoutMatchUiModel> knockoutFinals;
  final bool isKnockoutLoading;
  final bool hasLoadedKnockout;
  final List<LeagueDetailsSeasonHistoryUiModel> seasonHistory;
  final bool isSeasonHistoryLoading;
  final bool hasLoadedSeasonHistory;

  const LeagueDetailsViewModel({
    this.league,
    this.seasons = const <String>[],
    this.selectedSeason = '',
    this.isFollowing = false,
    this.isLoading = false,
    this.isFixturesLoading = false,
    this.isFixturesLoadingMore = false,
    this.errorCode,
    this.standingsRows = const <LeagueDetailsStandingsRowUiModel>[],
    this.worldCupGroups = const <LeagueDetailsWorldCupGroupUiModel>[],
    this.standingsPage = 1,
    this.standingsTotalPages = 1,
    this.isStandingsLoadingMore = false,
    this.fixtures = const LeagueDetailsFixturesViewModel(),
    this.overview = const LeagueDetailsOverviewUiModel(),
    this.topScorersRows = const <LeagueDetailsPlayerStatRowUiModel>[],
    this.topAssistsRows = const <LeagueDetailsPlayerStatRowUiModel>[],
    this.playerStatsSections = const <LeagueDetailsPlayerStatSectionUiModel>[],
    this.isPlayerStatsLoading = false,
    this.hasLoadedPlayerStats = false,
    this.teamStatsSections = const <LeagueDetailsPlayerStatSectionUiModel>[],
    this.isTeamStatsLoading = false,
    this.hasLoadedTeamStats = false,
    this.knockoutRoundOf16 = const <LeagueDetailsKnockoutMatchUiModel>[],
    this.knockoutQuarterFinals = const <LeagueDetailsKnockoutMatchUiModel>[],
    this.knockoutSemiFinals = const <LeagueDetailsKnockoutMatchUiModel>[],
    this.knockoutFinals = const <LeagueDetailsKnockoutMatchUiModel>[],
    this.isKnockoutLoading = false,
    this.hasLoadedKnockout = false,
    this.seasonHistory = const <LeagueDetailsSeasonHistoryUiModel>[],
    this.isSeasonHistoryLoading = false,
    this.hasLoadedSeasonHistory = false,
  });

  String get leagueName => league?.leagueName ?? 'Premier League';

  LeagueDetailsViewModel copyWith({
    Object? league = _unset,
    Object? seasons = _unset,
    Object? selectedSeason = _unset,
    bool? isFollowing,
    bool? isLoading,
    bool? isFixturesLoading,
    bool? isFixturesLoadingMore,
    Object? errorCode = _unset,
    Object? standingsRows = _unset,
    Object? worldCupGroups = _unset,
    int? standingsPage,
    int? standingsTotalPages,
    bool? isStandingsLoadingMore,
    Object? fixtures = _unset,
    Object? overview = _unset,
    Object? topScorersRows = _unset,
    Object? topAssistsRows = _unset,
    Object? playerStatsSections = _unset,
    bool? isPlayerStatsLoading,
    bool? hasLoadedPlayerStats,
    Object? teamStatsSections = _unset,
    bool? isTeamStatsLoading,
    bool? hasLoadedTeamStats,
    Object? knockoutRoundOf16 = _unset,
    Object? knockoutQuarterFinals = _unset,
    Object? knockoutSemiFinals = _unset,
    Object? knockoutFinals = _unset,
    bool? isKnockoutLoading,
    bool? hasLoadedKnockout,
    Object? seasonHistory = _unset,
    bool? isSeasonHistoryLoading,
    bool? hasLoadedSeasonHistory,
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
      isLoading: isLoading ?? this.isLoading,
      isFixturesLoading: isFixturesLoading ?? this.isFixturesLoading,
      isFixturesLoadingMore: isFixturesLoadingMore ?? this.isFixturesLoadingMore,
      errorCode: identical(errorCode, _unset)
          ? this.errorCode
          : errorCode as String?,
      standingsRows: identical(standingsRows, _unset)
          ? this.standingsRows
          : standingsRows as List<LeagueDetailsStandingsRowUiModel>,
      worldCupGroups: identical(worldCupGroups, _unset)
          ? this.worldCupGroups
          : worldCupGroups as List<LeagueDetailsWorldCupGroupUiModel>,
      standingsPage: standingsPage ?? this.standingsPage,
      standingsTotalPages: standingsTotalPages ?? this.standingsTotalPages,
      isStandingsLoadingMore: isStandingsLoadingMore ?? this.isStandingsLoadingMore,
      fixtures: identical(fixtures, _unset)
          ? this.fixtures
          : fixtures as LeagueDetailsFixturesViewModel,
      overview: identical(overview, _unset)
          ? this.overview
          : overview as LeagueDetailsOverviewUiModel,
      topScorersRows: identical(topScorersRows, _unset)
          ? this.topScorersRows
          : topScorersRows as List<LeagueDetailsPlayerStatRowUiModel>,
      topAssistsRows: identical(topAssistsRows, _unset)
          ? this.topAssistsRows
          : topAssistsRows as List<LeagueDetailsPlayerStatRowUiModel>,
      playerStatsSections: identical(playerStatsSections, _unset)
          ? this.playerStatsSections
          : playerStatsSections as List<LeagueDetailsPlayerStatSectionUiModel>,
      isPlayerStatsLoading: isPlayerStatsLoading ?? this.isPlayerStatsLoading,
      hasLoadedPlayerStats: hasLoadedPlayerStats ?? this.hasLoadedPlayerStats,
      teamStatsSections: identical(teamStatsSections, _unset)
          ? this.teamStatsSections
          : teamStatsSections as List<LeagueDetailsPlayerStatSectionUiModel>,
      isTeamStatsLoading: isTeamStatsLoading ?? this.isTeamStatsLoading,
      hasLoadedTeamStats: hasLoadedTeamStats ?? this.hasLoadedTeamStats,
      knockoutRoundOf16: identical(knockoutRoundOf16, _unset)
          ? this.knockoutRoundOf16
          : knockoutRoundOf16 as List<LeagueDetailsKnockoutMatchUiModel>,
      knockoutQuarterFinals: identical(knockoutQuarterFinals, _unset)
          ? this.knockoutQuarterFinals
          : knockoutQuarterFinals as List<LeagueDetailsKnockoutMatchUiModel>,
      knockoutSemiFinals: identical(knockoutSemiFinals, _unset)
          ? this.knockoutSemiFinals
          : knockoutSemiFinals as List<LeagueDetailsKnockoutMatchUiModel>,
      knockoutFinals: identical(knockoutFinals, _unset)
          ? this.knockoutFinals
          : knockoutFinals as List<LeagueDetailsKnockoutMatchUiModel>,
      isKnockoutLoading: isKnockoutLoading ?? this.isKnockoutLoading,
      hasLoadedKnockout: hasLoadedKnockout ?? this.hasLoadedKnockout,
      seasonHistory: identical(seasonHistory, _unset)
          ? this.seasonHistory
          : seasonHistory as List<LeagueDetailsSeasonHistoryUiModel>,
      isSeasonHistoryLoading:
          isSeasonHistoryLoading ?? this.isSeasonHistoryLoading,
      hasLoadedSeasonHistory:
          hasLoadedSeasonHistory ?? this.hasLoadedSeasonHistory,
    );
  }
}
