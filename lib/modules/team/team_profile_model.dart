import 'package:flutter/material.dart';

class TeamProfileTeamUiModel {
  final String name;
  final String country;
  final String badgeSeed;
  final Color badgeColor;

  const TeamProfileTeamUiModel({
    required this.name,
    required this.country,
    required this.badgeSeed,
    required this.badgeColor,
  });
}

class TeamProfileNextMatchUiModel {
  final String competitionLabel;
  final String timeLabel;
  final String statusLabel;
  final TeamProfileTeamUiModel homeTeam;
  final TeamProfileTeamUiModel awayTeam;

  const TeamProfileNextMatchUiModel({
    required this.competitionLabel,
    required this.timeLabel,
    required this.statusLabel,
    required this.homeTeam,
    required this.awayTeam,
  });
}

class TeamProfileFormResultUiModel {
  final String scoreLabel;
  final bool isPositive;

  const TeamProfileFormResultUiModel({
    required this.scoreLabel,
    required this.isPositive,
  });
}

class TeamProfileTopPlayerUiModel {
  final String name;
  final String subtitle;
  final String value;
  final String badgeSeed;
  final Color badgeColor;

  const TeamProfileTopPlayerUiModel({
    required this.name,
    required this.subtitle,
    required this.value,
    required this.badgeSeed,
    required this.badgeColor,
  });
}

class TeamProfileLeagueItemUiModel {
  final String title;
  final String seasonLabel;
  final String badgeSeed;
  final Color badgeColor;

  const TeamProfileLeagueItemUiModel({
    required this.title,
    required this.seasonLabel,
    required this.badgeSeed,
    required this.badgeColor,
  });
}

class TeamProfileRankingItemUiModel {
  final String title;
  final String value;
  final String badgeSeed;
  final Color badgeColor;

  const TeamProfileRankingItemUiModel({
    required this.title,
    required this.value,
    required this.badgeSeed,
    required this.badgeColor,
  });
}

class TeamProfileVenueUiModel {
  final String stadiumName;
  final String city;
  final String capacity;
  final String surface;
  final String opened;

  const TeamProfileVenueUiModel({
    required this.stadiumName,
    required this.city,
    required this.capacity,
    required this.surface,
    required this.opened,
  });
}

class TeamProfileStandingsRowUiModel {
  final String rank;
  final String teamName;
  final String badgeSeed;
  final Color badgeColor;
  final String played;
  final String plusMinus;
  final String goalDifference;
  final String points;

  const TeamProfileStandingsRowUiModel({
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

class TeamProfileMatchRowUiModel {
  final String dateLabel;
  final String competitionLabel;
  final TeamProfileTeamUiModel homeTeam;
  final TeamProfileTeamUiModel awayTeam;
  final String centerLabel;
  final bool isUpcoming;

  const TeamProfileMatchRowUiModel({
    required this.dateLabel,
    required this.competitionLabel,
    required this.homeTeam,
    required this.awayTeam,
    required this.centerLabel,
    this.isUpcoming = false,
  });
}

class TeamProfileSquadPersonUiModel {
  final String name;
  final String countryFlag;
  final String countryName;
  final String shirtNumber;
  final String age;
  final String badgeSeed;
  final Color badgeColor;

  const TeamProfileSquadPersonUiModel({
    required this.name,
    required this.countryFlag,
    required this.countryName,
    required this.shirtNumber,
    required this.age,
    required this.badgeSeed,
    required this.badgeColor,
  });
}

class TeamProfileSquadSectionUiModel {
  final String title;
  final List<TeamProfileSquadPersonUiModel> players;

  const TeamProfileSquadSectionUiModel({
    required this.title,
    required this.players,
  });
}

class TeamProfileTrophyEntryUiModel {
  final String count;
  final String label;
  final String years;

  const TeamProfileTrophyEntryUiModel({
    required this.count,
    required this.label,
    required this.years,
  });
}

class TeamProfileTrophySectionUiModel {
  final String title;
  final String badgeSeed;
  final Color badgeColor;
  final List<TeamProfileTrophyEntryUiModel> entries;

  const TeamProfileTrophySectionUiModel({
    required this.title,
    required this.badgeSeed,
    required this.badgeColor,
    required this.entries,
  });
}

class TeamProfileOverviewUiModel {
  final List<TeamProfileNextMatchUiModel> nextMatches;
  final List<TeamProfileFormResultUiModel> leftResults;
  final List<TeamProfileFormResultUiModel> rightResults;
  final List<TeamProfileTopPlayerUiModel> topPlayers;
  final List<TeamProfileLeagueItemUiModel> leagues;
  final List<TeamProfileRankingItemUiModel> rankings;
  final TeamProfileVenueUiModel venue;
  final String aboutText;

  const TeamProfileOverviewUiModel({
    this.nextMatches = const <TeamProfileNextMatchUiModel>[],
    this.leftResults = const <TeamProfileFormResultUiModel>[],
    this.rightResults = const <TeamProfileFormResultUiModel>[],
    this.topPlayers = const <TeamProfileTopPlayerUiModel>[],
    this.leagues = const <TeamProfileLeagueItemUiModel>[],
    this.rankings = const <TeamProfileRankingItemUiModel>[],
    this.venue = const TeamProfileVenueUiModel(
      stadiumName: '',
      city: '',
      capacity: '',
      surface: '',
      opened: '',
    ),
    this.aboutText = '',
  });
}

class TeamProfileViewModel {
  static const Object _unset = Object();

  final TeamProfileTeamUiModel team;
  final bool isFollowing;
  final bool isAboutExpanded;
  final List<String> seasons;
  final String selectedSeason;
  final TeamProfileOverviewUiModel overview;
  final List<TeamProfileStandingsRowUiModel> standings;
  final List<TeamProfileMatchRowUiModel> previousMatches;
  final List<TeamProfileMatchRowUiModel> upcomingMatches;
  final int visiblePreviousMatches;
  final int visibleUpcomingMatches;
  final TeamProfileSquadPersonUiModel coach;
  final List<TeamProfileSquadSectionUiModel> squadSections;
  final List<TeamProfileTrophySectionUiModel> trophies;
  final int visibleTrophies;

  const TeamProfileViewModel({
    this.team = const TeamProfileTeamUiModel(
      name: '',
      country: '',
      badgeSeed: '',
      badgeColor: Colors.transparent,
    ),
    this.isFollowing = false,
    this.isAboutExpanded = false,
    this.seasons = const <String>[],
    this.selectedSeason = '',
    this.overview = const TeamProfileOverviewUiModel(),
    this.standings = const <TeamProfileStandingsRowUiModel>[],
    this.previousMatches = const <TeamProfileMatchRowUiModel>[],
    this.upcomingMatches = const <TeamProfileMatchRowUiModel>[],
    this.visiblePreviousMatches = 2,
    this.visibleUpcomingMatches = 1,
    this.coach = const TeamProfileSquadPersonUiModel(
      name: '',
      countryFlag: '',
      countryName: '',
      shirtNumber: '',
      age: '',
      badgeSeed: '',
      badgeColor: Colors.transparent,
    ),
    this.squadSections = const <TeamProfileSquadSectionUiModel>[],
    this.trophies = const <TeamProfileTrophySectionUiModel>[],
    this.visibleTrophies = 4,
  });

  List<TeamProfileMatchRowUiModel> get visiblePreviousMatchItems {
    final count = visiblePreviousMatches.clamp(0, previousMatches.length);
    return previousMatches.take(count).toList(growable: false);
  }

  List<TeamProfileMatchRowUiModel> get visibleUpcomingMatchItems {
    final count = visibleUpcomingMatches.clamp(0, upcomingMatches.length);
    return upcomingMatches.take(count).toList(growable: false);
  }

  List<TeamProfileTrophySectionUiModel> get visibleTrophyItems {
    final count = visibleTrophies.clamp(0, trophies.length);
    return trophies.take(count).toList(growable: false);
  }

  bool get canLoadMorePreviousMatches {
    return visiblePreviousMatches < previousMatches.length;
  }

  bool get canLoadMoreUpcomingMatches {
    return visibleUpcomingMatches < upcomingMatches.length;
  }

  bool get canLoadMoreTrophies {
    return visibleTrophies < trophies.length;
  }

  TeamProfileViewModel copyWith({
    TeamProfileTeamUiModel? team,
    bool? isFollowing,
    bool? isAboutExpanded,
    Object? seasons = _unset,
    Object? selectedSeason = _unset,
    TeamProfileOverviewUiModel? overview,
    Object? standings = _unset,
    Object? previousMatches = _unset,
    Object? upcomingMatches = _unset,
    int? visiblePreviousMatches,
    int? visibleUpcomingMatches,
    TeamProfileSquadPersonUiModel? coach,
    Object? squadSections = _unset,
    Object? trophies = _unset,
    int? visibleTrophies,
  }) {
    return TeamProfileViewModel(
      team: team ?? this.team,
      isFollowing: isFollowing ?? this.isFollowing,
      isAboutExpanded: isAboutExpanded ?? this.isAboutExpanded,
      seasons: identical(seasons, _unset)
          ? this.seasons
          : seasons as List<String>,
      selectedSeason: identical(selectedSeason, _unset)
          ? this.selectedSeason
          : selectedSeason as String,
      overview: overview ?? this.overview,
      standings: identical(standings, _unset)
          ? this.standings
          : standings as List<TeamProfileStandingsRowUiModel>,
      previousMatches: identical(previousMatches, _unset)
          ? this.previousMatches
          : previousMatches as List<TeamProfileMatchRowUiModel>,
      upcomingMatches: identical(upcomingMatches, _unset)
          ? this.upcomingMatches
          : upcomingMatches as List<TeamProfileMatchRowUiModel>,
      visiblePreviousMatches:
          visiblePreviousMatches ?? this.visiblePreviousMatches,
      visibleUpcomingMatches:
          visibleUpcomingMatches ?? this.visibleUpcomingMatches,
      coach: coach ?? this.coach,
      squadSections: identical(squadSections, _unset)
          ? this.squadSections
          : squadSections as List<TeamProfileSquadSectionUiModel>,
      trophies: identical(trophies, _unset)
          ? this.trophies
          : trophies as List<TeamProfileTrophySectionUiModel>,
      visibleTrophies: visibleTrophies ?? this.visibleTrophies,
    );
  }
}
