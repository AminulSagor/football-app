import 'package:flutter/material.dart';

import '../leagues/model/leagues_models.dart';

class TeamProfileTeamUiModel {
  final String teamId;
  final String name;
  final String country;
  final String badgeSeed;
  final Color badgeColor;
  final String logoUrl;

  const TeamProfileTeamUiModel({
    this.teamId = '',
    required this.name,
    required this.country,
    required this.badgeSeed,
    required this.badgeColor,
    this.logoUrl = '',
  });
}

class TeamProfileNextMatchUiModel {
  final String fixtureId;
  final String competitionLabel;
  final String timeLabel;
  final String statusLabel;
  final TeamProfileTeamUiModel homeTeam;
  final TeamProfileTeamUiModel awayTeam;

  const TeamProfileNextMatchUiModel({
    this.fixtureId = '',
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
  final bool isDraw;
  final String fixtureId;
  final String homeTeamId;
  final String awayTeamId;
  final String homeTeamName;
  final String awayTeamName;
  final String logoUrl;
  final String homeLogoUrl;
  final String awayLogoUrl;
  final String teamName;

  const TeamProfileFormResultUiModel({
    required this.scoreLabel,
    required this.isPositive,
    this.isDraw = false,
    this.fixtureId = '',
    this.homeTeamId = '',
    this.awayTeamId = '',
    this.homeTeamName = '',
    this.awayTeamName = '',
    this.logoUrl = '',
    this.homeLogoUrl = '',
    this.awayLogoUrl = '',
    this.teamName = '',
  });
}

class TeamProfileTopPlayerUiModel {
  final String name;
  final String subtitle;
  final String value;
  final String badgeSeed;
  final Color badgeColor;
  final String imageUrl;

  const TeamProfileTopPlayerUiModel({
    required this.name,
    required this.subtitle,
    required this.value,
    required this.badgeSeed,
    required this.badgeColor,
    this.imageUrl = '',
  });
}

class TeamProfileLeagueItemUiModel {
  final String title;
  final String seasonLabel;
  final String badgeSeed;
  final Color badgeColor;
  final String logoUrl;

  const TeamProfileLeagueItemUiModel({
    required this.title,
    required this.seasonLabel,
    required this.badgeSeed,
    required this.badgeColor,
    this.logoUrl = '',
  });
}

class TeamProfileRankingItemUiModel {
  final String title;
  final String value;
  final String badgeSeed;
  final Color badgeColor;
  final String logoUrl;

  const TeamProfileRankingItemUiModel({
    required this.title,
    required this.value,
    required this.badgeSeed,
    required this.badgeColor,
    this.logoUrl = '',
  });
}

class TeamProfileVenueUiModel {
  final String stadiumName;
  final String city;
  final String capacity;
  final String surface;
  final String opened;
  final String imageUrl;
  final String address;

  const TeamProfileVenueUiModel({
    required this.stadiumName,
    required this.city,
    required this.capacity,
    required this.surface,
    required this.opened,
    this.imageUrl = '',
    this.address = '',
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
  final String logoUrl;

  const TeamProfileStandingsRowUiModel({
    required this.rank,
    required this.teamName,
    required this.badgeSeed,
    required this.badgeColor,
    required this.played,
    required this.plusMinus,
    required this.goalDifference,
    required this.points,
    this.logoUrl = '',
  });
}

class TeamProfileMatchRowUiModel {
  final String fixtureId;
  final String dateLabel;
  final String competitionLabel;
  final String leagueLogoUrl;
  final TeamProfileTeamUiModel homeTeam;
  final TeamProfileTeamUiModel awayTeam;
  final String centerLabel;
  final bool isUpcoming;

  const TeamProfileMatchRowUiModel({
    this.fixtureId = '',
    required this.dateLabel,
    required this.competitionLabel,
    this.leagueLogoUrl = '',
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
  final String logoUrl;
  final List<TeamProfileTrophyEntryUiModel> entries;

  const TeamProfileTrophySectionUiModel({
    required this.title,
    required this.badgeSeed,
    required this.badgeColor,
    this.logoUrl = '',
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

  TeamProfileOverviewUiModel copyWith({
    List<TeamProfileNextMatchUiModel>? nextMatches,
    List<TeamProfileFormResultUiModel>? leftResults,
    List<TeamProfileFormResultUiModel>? rightResults,
    List<TeamProfileTopPlayerUiModel>? topPlayers,
    List<TeamProfileLeagueItemUiModel>? leagues,
    List<TeamProfileRankingItemUiModel>? rankings,
    TeamProfileVenueUiModel? venue,
    String? aboutText,
  }) {
    return TeamProfileOverviewUiModel(
      nextMatches: nextMatches ?? this.nextMatches,
      leftResults: leftResults ?? this.leftResults,
      rightResults: rightResults ?? this.rightResults,
      topPlayers: topPlayers ?? this.topPlayers,
      leagues: leagues ?? this.leagues,
      rankings: rankings ?? this.rankings,
      venue: venue ?? this.venue,
      aboutText: aboutText ?? this.aboutText,
    );
  }
}

class TeamProfileViewModel {
  static const Object _unset = Object();

  final TeamProfileTeamUiModel team;
  final bool isFollowing;
  final bool isAboutExpanded;
  final bool isTeamInfoLoading;
  final bool isOverviewFixturesLoading;
  final bool isPreviousMatchesLoading;
  final bool isUpcomingMatchesLoading;
  final bool isPreviousMatchesLoadingMore;
  final bool isUpcomingMatchesLoadingMore;
  final bool isPlayersLoading;
  final bool isTeamLeaguesLoading;
  final bool isStandingsLoading;
  final bool isCoachesLoading;
  final bool isTrophiesLoading;
  final bool isTeamLeaguesExpanded;
  final bool canLoadMorePreviousMatchesFromApi;
  final bool canLoadMoreUpcomingMatchesFromApi;
  final List<String> seasons;
  final String selectedSeason;
  final TeamProfileOverviewUiModel overview;
  final List<FootballTeamPlayerItemModel> players;
  final List<FootballLeagueApiItemModel> teamLeagues;
  final FootballLeagueApiItemModel? domesticLeague;
  final List<FootballStandingRowModel> standingRows;
  final FootballTeamCoachModel? latestCoach;
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
    this.isTeamInfoLoading = false,
    this.isOverviewFixturesLoading = false,
    this.isPreviousMatchesLoading = false,
    this.isUpcomingMatchesLoading = false,
    this.isPreviousMatchesLoadingMore = false,
    this.isUpcomingMatchesLoadingMore = false,
    this.isPlayersLoading = false,
    this.isTeamLeaguesLoading = false,
    this.isStandingsLoading = false,
    this.isCoachesLoading = false,
    this.isTrophiesLoading = false,
    this.isTeamLeaguesExpanded = false,
    this.canLoadMorePreviousMatchesFromApi = false,
    this.canLoadMoreUpcomingMatchesFromApi = false,
    this.seasons = const <String>[],
    this.selectedSeason = '',
    this.overview = const TeamProfileOverviewUiModel(),
    this.players = const <FootballTeamPlayerItemModel>[],
    this.teamLeagues = const <FootballLeagueApiItemModel>[],
    this.domesticLeague,
    this.standingRows = const <FootballStandingRowModel>[],
    this.latestCoach,
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
    final count = _boundedCount(visiblePreviousMatches, previousMatches.length);
    return previousMatches.take(count).toList(growable: false);
  }

  List<TeamProfileMatchRowUiModel> get visibleUpcomingMatchItems {
    final count = _boundedCount(visibleUpcomingMatches, upcomingMatches.length);
    return upcomingMatches.take(count).toList(growable: false);
  }

  List<TeamProfileTrophySectionUiModel> get visibleTrophyItems {
    final count = _boundedCount(visibleTrophies, trophies.length);
    return trophies.take(count).toList(growable: false);
  }

  List<FootballLeagueApiItemModel> get visibleTeamLeagueItems {
    final count = isTeamLeaguesExpanded
        ? teamLeagues.length
        : _boundedCount(5, teamLeagues.length);
    return teamLeagues.take(count).toList(growable: false);
  }

  bool get canToggleTeamLeagues => teamLeagues.length > 5;

  bool get canLoadMorePreviousMatches {
    return canLoadMorePreviousMatchesFromApi ||
        visiblePreviousMatches < previousMatches.length;
  }

  bool get canLoadMoreUpcomingMatches {
    return canLoadMoreUpcomingMatchesFromApi ||
        visibleUpcomingMatches < upcomingMatches.length;
  }

  bool get canLoadMoreTrophies => visibleTrophies < trophies.length;

  TeamProfileViewModel copyWith({
    TeamProfileTeamUiModel? team,
    bool? isFollowing,
    bool? isAboutExpanded,
    bool? isTeamInfoLoading,
    bool? isOverviewFixturesLoading,
    bool? isPreviousMatchesLoading,
    bool? isUpcomingMatchesLoading,
    bool? isPreviousMatchesLoadingMore,
    bool? isUpcomingMatchesLoadingMore,
    bool? isPlayersLoading,
    bool? isTeamLeaguesLoading,
    bool? isStandingsLoading,
    bool? isCoachesLoading,
    bool? isTrophiesLoading,
    bool? isTeamLeaguesExpanded,
    bool? canLoadMorePreviousMatchesFromApi,
    bool? canLoadMoreUpcomingMatchesFromApi,
    Object? seasons = _unset,
    Object? selectedSeason = _unset,
    TeamProfileOverviewUiModel? overview,
    Object? players = _unset,
    Object? teamLeagues = _unset,
    Object? domesticLeague = _unset,
    Object? standingRows = _unset,
    Object? latestCoach = _unset,
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
      isTeamInfoLoading: isTeamInfoLoading ?? this.isTeamInfoLoading,
      isOverviewFixturesLoading:
          isOverviewFixturesLoading ?? this.isOverviewFixturesLoading,
      isPreviousMatchesLoading:
          isPreviousMatchesLoading ?? this.isPreviousMatchesLoading,
      isUpcomingMatchesLoading:
          isUpcomingMatchesLoading ?? this.isUpcomingMatchesLoading,
      isPreviousMatchesLoadingMore:
          isPreviousMatchesLoadingMore ?? this.isPreviousMatchesLoadingMore,
      isUpcomingMatchesLoadingMore:
          isUpcomingMatchesLoadingMore ?? this.isUpcomingMatchesLoadingMore,
      isPlayersLoading: isPlayersLoading ?? this.isPlayersLoading,
      isTeamLeaguesLoading: isTeamLeaguesLoading ?? this.isTeamLeaguesLoading,
      isStandingsLoading: isStandingsLoading ?? this.isStandingsLoading,
      isCoachesLoading: isCoachesLoading ?? this.isCoachesLoading,
      isTrophiesLoading: isTrophiesLoading ?? this.isTrophiesLoading,
      isTeamLeaguesExpanded:
          isTeamLeaguesExpanded ?? this.isTeamLeaguesExpanded,
      canLoadMorePreviousMatchesFromApi:
          canLoadMorePreviousMatchesFromApi ??
          this.canLoadMorePreviousMatchesFromApi,
      canLoadMoreUpcomingMatchesFromApi:
          canLoadMoreUpcomingMatchesFromApi ??
          this.canLoadMoreUpcomingMatchesFromApi,
      seasons: identical(seasons, _unset)
          ? this.seasons
          : seasons as List<String>,
      selectedSeason: identical(selectedSeason, _unset)
          ? this.selectedSeason
          : selectedSeason as String,
      overview: overview ?? this.overview,
      players: identical(players, _unset)
          ? this.players
          : players as List<FootballTeamPlayerItemModel>,
      teamLeagues: identical(teamLeagues, _unset)
          ? this.teamLeagues
          : teamLeagues as List<FootballLeagueApiItemModel>,
      domesticLeague: identical(domesticLeague, _unset)
          ? this.domesticLeague
          : domesticLeague as FootballLeagueApiItemModel?,
      standingRows: identical(standingRows, _unset)
          ? this.standingRows
          : standingRows as List<FootballStandingRowModel>,
      latestCoach: identical(latestCoach, _unset)
          ? this.latestCoach
          : latestCoach as FootballTeamCoachModel?,
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

int _boundedCount(int requested, int max) {
  if (requested < 0) return 0;
  if (requested > max) return max;
  return requested;
}

class FootballFollowStateModel {
  final bool isFollowed;
  final String entityType;
  final String entityId;

  const FootballFollowStateModel({
    this.isFollowed = false,
    this.entityType = '',
    this.entityId = '',
  });

  factory FootballFollowStateModel.fromJson(Map<String, dynamic> json) {
    return FootballFollowStateModel(
      isFollowed: json['isFollowed'] as bool? ?? false,
      entityType: json['entityType'] as String? ?? '',
      entityId: json['entityId']?.toString() ?? '',
    );
  }
}

class FootballTeamAboutApiResponseModel {
  final bool success;
  final int? statusCode;
  final String message;
  final FootballTeamAboutDataModel data;

  const FootballTeamAboutApiResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory FootballTeamAboutApiResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FootballTeamAboutApiResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: _toIntOrNull(json['statusCode']),
      message: json['message'] as String? ?? '',
      data: FootballTeamAboutDataModel.fromJson(_mapObject(json['data'])),
    );
  }
}

class FootballTeamAboutDataModel {
  final String teamId;
  final String about;
  final FootballFollowStateModel followContext;

  const FootballTeamAboutDataModel({
    this.teamId = '',
    this.about = '',
    this.followContext = const FootballFollowStateModel(),
  });

  factory FootballTeamAboutDataModel.fromJson(Map<String, dynamic> json) {
    return FootballTeamAboutDataModel(
      teamId: json['teamId']?.toString() ?? '',
      about: json['about'] as String? ?? '',
      followContext: FootballFollowStateModel.fromJson(
        _mapObject(json['followContext']),
      ),
    );
  }
}

class FootballTeamInfoApiResponseModel {
  final bool success;
  final int? statusCode;
  final String message;
  final FootballTeamInfoDataModel data;

  const FootballTeamInfoApiResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory FootballTeamInfoApiResponseModel.fromJson(Map<String, dynamic> json) {
    return FootballTeamInfoApiResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: _toIntOrNull(json['statusCode']),
      message: json['message'] as String? ?? '',
      data: FootballTeamInfoDataModel.fromJson(_mapObject(json['data'])),
    );
  }
}

class FootballTeamInfoDataModel {
  final String get;
  final Map<String, dynamic> parameters;
  final int results;
  final List<FootballTeamInfoItemModel> response;
  final FootballFollowStateModel follow;

  const FootballTeamInfoDataModel({
    required this.get,
    required this.parameters,
    required this.results,
    required this.response,
    this.follow = const FootballFollowStateModel(),
  });

  factory FootballTeamInfoDataModel.fromJson(Map<String, dynamic> json) {
    return FootballTeamInfoDataModel(
      get: json['get'] as String? ?? '',
      parameters: _mapObject(json['parameters']),
      results: _toIntOrNull(json['results']) ?? 0,
      response: _mapList(
        json['response'],
      ).map(FootballTeamInfoItemModel.fromJson).toList(growable: false),
      follow: FootballFollowStateModel.fromJson(_mapObject(json['follow'])),
    );
  }
}

class FootballTeamInfoItemModel {
  final FootballTeamInfoModel team;
  final FootballTeamVenueInfoModel venue;

  const FootballTeamInfoItemModel({required this.team, required this.venue});

  factory FootballTeamInfoItemModel.fromJson(Map<String, dynamic> json) {
    return FootballTeamInfoItemModel(
      team: FootballTeamInfoModel.fromJson(_mapObject(json['team'])),
      venue: FootballTeamVenueInfoModel.fromJson(_mapObject(json['venue'])),
    );
  }
}

class FootballTeamInfoModel {
  final int? id;
  final String name;
  final String code;
  final String country;
  final int? founded;
  final bool national;
  final String logo;

  const FootballTeamInfoModel({
    required this.id,
    required this.name,
    required this.code,
    required this.country,
    required this.founded,
    required this.national,
    required this.logo,
  });

  factory FootballTeamInfoModel.fromJson(Map<String, dynamic> json) {
    return FootballTeamInfoModel(
      id: _toIntOrNull(json['id']),
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      country: json['country'] as String? ?? '',
      founded: _toIntOrNull(json['founded']),
      national: json['national'] as bool? ?? false,
      logo: json['logo'] as String? ?? '',
    );
  }
}

class FootballTeamVenueInfoModel {
  final int? id;
  final String name;
  final String address;
  final String city;
  final int? capacity;
  final String surface;
  final String image;

  const FootballTeamVenueInfoModel({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.capacity,
    required this.surface,
    required this.image,
  });

  factory FootballTeamVenueInfoModel.fromJson(Map<String, dynamic> json) {
    return FootballTeamVenueInfoModel(
      id: _toIntOrNull(json['id']),
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      city: json['city'] as String? ?? '',
      capacity: _toIntOrNull(json['capacity']),
      surface: json['surface'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }
}

class FootballTeamPlayersApiResponseModel {
  final bool success;
  final int? statusCode;
  final String message;
  final FootballTeamPlayersDataModel data;

  const FootballTeamPlayersApiResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory FootballTeamPlayersApiResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FootballTeamPlayersApiResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: _toIntOrNull(json['statusCode']),
      message: json['message'] as String? ?? '',
      data: FootballTeamPlayersDataModel.fromJson(_mapObject(json['data'])),
    );
  }
}

class FootballTeamPlayersDataModel {
  final String get;
  final Map<String, dynamic> parameters;
  final int results;
  final List<FootballTeamPlayerItemModel> response;

  const FootballTeamPlayersDataModel({
    this.get = '',
    this.parameters = const <String, dynamic>{},
    this.results = 0,
    this.response = const <FootballTeamPlayerItemModel>[],
  });

  factory FootballTeamPlayersDataModel.fromJson(Map<String, dynamic> json) {
    return FootballTeamPlayersDataModel(
      get: json['get'] as String? ?? '',
      parameters: _mapObject(json['parameters']),
      results: _toIntOrNull(json['results']) ?? 0,
      response: _mapList(
        json['response'],
      ).map(FootballTeamPlayerItemModel.fromJson).toList(growable: false),
    );
  }
}

class FootballTeamPlayerItemModel {
  final FootballPlayerProfileModel player;
  final List<FootballPlayerStatisticModel> statistics;

  const FootballTeamPlayerItemModel({
    required this.player,
    this.statistics = const <FootballPlayerStatisticModel>[],
  });

  factory FootballTeamPlayerItemModel.fromJson(Map<String, dynamic> json) {
    return FootballTeamPlayerItemModel(
      player: FootballPlayerProfileModel.fromJson(_mapObject(json['player'])),
      statistics: _mapList(
        json['statistics'],
      ).map(FootballPlayerStatisticModel.fromJson).toList(growable: false),
    );
  }

  FootballPlayerStatisticModel? statisticForLeague(int? leagueId) {
    if (statistics.isEmpty) return null;
    if (leagueId != null) {
      for (final stat in statistics) {
        if (stat.league.id == leagueId) return stat;
      }
    }
    for (final stat in statistics) {
      if (stat.games.ratingValue != null || stat.games.appearences != null) {
        return stat;
      }
    }
    return statistics.first;
  }
}

class FootballPlayerProfileModel {
  final int? id;
  final String name;
  final String firstname;
  final String lastname;
  final int? age;
  final FootballBirthModel birth;
  final String nationality;
  final String height;
  final String weight;
  final bool injured;
  final String photo;

  const FootballPlayerProfileModel({
    this.id,
    this.name = '',
    this.firstname = '',
    this.lastname = '',
    this.age,
    this.birth = const FootballBirthModel(),
    this.nationality = '',
    this.height = '',
    this.weight = '',
    this.injured = false,
    this.photo = '',
  });

  factory FootballPlayerProfileModel.fromJson(Map<String, dynamic> json) {
    return FootballPlayerProfileModel(
      id: _toIntOrNull(json['id']),
      name: json['name'] as String? ?? '',
      firstname: json['firstname'] as String? ?? '',
      lastname: json['lastname'] as String? ?? '',
      age: _toIntOrNull(json['age']),
      birth: FootballBirthModel.fromJson(_mapObject(json['birth'])),
      nationality: json['nationality'] as String? ?? '',
      height: json['height']?.toString() ?? '',
      weight: json['weight']?.toString() ?? '',
      injured: json['injured'] as bool? ?? false,
      photo: json['photo'] as String? ?? '',
    );
  }
}

class FootballBirthModel {
  final String date;
  final String place;
  final String country;

  const FootballBirthModel({
    this.date = '',
    this.place = '',
    this.country = '',
  });

  factory FootballBirthModel.fromJson(Map<String, dynamic> json) {
    return FootballBirthModel(
      date: json['date'] as String? ?? '',
      place: json['place'] as String? ?? '',
      country: json['country'] as String? ?? '',
    );
  }
}

class FootballPlayerStatisticModel {
  final FootballStatTeamModel team;
  final FootballStatLeagueModel league;
  final FootballGamesStatModel games;
  final FootballSubstitutesStatModel substitutes;
  final FootballShotsStatModel shots;
  final FootballGoalsStatModel goals;
  final FootballPassesStatModel passes;
  final FootballTacklesStatModel tackles;
  final FootballDuelsStatModel duels;
  final FootballDribblesStatModel dribbles;
  final FootballFoulsStatModel fouls;
  final FootballCardsStatModel cards;
  final FootballPenaltyStatModel penalty;

  const FootballPlayerStatisticModel({
    this.team = const FootballStatTeamModel(),
    this.league = const FootballStatLeagueModel(),
    this.games = const FootballGamesStatModel(),
    this.substitutes = const FootballSubstitutesStatModel(),
    this.shots = const FootballShotsStatModel(),
    this.goals = const FootballGoalsStatModel(),
    this.passes = const FootballPassesStatModel(),
    this.tackles = const FootballTacklesStatModel(),
    this.duels = const FootballDuelsStatModel(),
    this.dribbles = const FootballDribblesStatModel(),
    this.fouls = const FootballFoulsStatModel(),
    this.cards = const FootballCardsStatModel(),
    this.penalty = const FootballPenaltyStatModel(),
  });

  factory FootballPlayerStatisticModel.fromJson(Map<String, dynamic> json) {
    return FootballPlayerStatisticModel(
      team: FootballStatTeamModel.fromJson(_mapObject(json['team'])),
      league: FootballStatLeagueModel.fromJson(_mapObject(json['league'])),
      games: FootballGamesStatModel.fromJson(_mapObject(json['games'])),
      substitutes: FootballSubstitutesStatModel.fromJson(
        _mapObject(json['substitutes']),
      ),
      shots: FootballShotsStatModel.fromJson(_mapObject(json['shots'])),
      goals: FootballGoalsStatModel.fromJson(_mapObject(json['goals'])),
      passes: FootballPassesStatModel.fromJson(_mapObject(json['passes'])),
      tackles: FootballTacklesStatModel.fromJson(_mapObject(json['tackles'])),
      duels: FootballDuelsStatModel.fromJson(_mapObject(json['duels'])),
      dribbles: FootballDribblesStatModel.fromJson(
        _mapObject(json['dribbles']),
      ),
      fouls: FootballFoulsStatModel.fromJson(_mapObject(json['fouls'])),
      cards: FootballCardsStatModel.fromJson(_mapObject(json['cards'])),
      penalty: FootballPenaltyStatModel.fromJson(_mapObject(json['penalty'])),
    );
  }
}

class FootballStatTeamModel {
  final int? id;
  final String name;
  final String logo;
  const FootballStatTeamModel({this.id, this.name = '', this.logo = ''});
  factory FootballStatTeamModel.fromJson(Map<String, dynamic> json) =>
      FootballStatTeamModel(
        id: _toIntOrNull(json['id']),
        name: json['name'] as String? ?? '',
        logo: json['logo'] as String? ?? '',
      );
}

class FootballStatLeagueModel {
  final int? id;
  final String name;
  final String country;
  final String logo;
  final String? flag;
  final int? season;
  const FootballStatLeagueModel({
    this.id,
    this.name = '',
    this.country = '',
    this.logo = '',
    this.flag,
    this.season,
  });
  factory FootballStatLeagueModel.fromJson(Map<String, dynamic> json) =>
      FootballStatLeagueModel(
        id: _toIntOrNull(json['id']),
        name: json['name'] as String? ?? '',
        country: json['country'] as String? ?? '',
        logo: json['logo'] as String? ?? '',
        flag: json['flag'] as String?,
        season: _toIntOrNull(json['season']),
      );
}

class FootballGamesStatModel {
  final int? appearences;
  final int? lineups;
  final int? minutes;
  final int? number;
  final String position;
  final String rating;
  final bool captain;
  double? get ratingValue => _toDoubleOrNull(rating);
  const FootballGamesStatModel({
    this.appearences,
    this.lineups,
    this.minutes,
    this.number,
    this.position = '',
    this.rating = '',
    this.captain = false,
  });
  factory FootballGamesStatModel.fromJson(Map<String, dynamic> json) =>
      FootballGamesStatModel(
        appearences: _toIntOrNull(json['appearences']),
        lineups: _toIntOrNull(json['lineups']),
        minutes: _toIntOrNull(json['minutes']),
        number: _toIntOrNull(json['number']),
        position: json['position'] as String? ?? '',
        rating: json['rating']?.toString() ?? '',
        captain: json['captain'] as bool? ?? false,
      );
}

class FootballSubstitutesStatModel {
  final int? into;
  final int? out;
  final int? bench;
  const FootballSubstitutesStatModel({this.into, this.out, this.bench});
  factory FootballSubstitutesStatModel.fromJson(Map<String, dynamic> json) =>
      FootballSubstitutesStatModel(
        into: _toIntOrNull(json['in']),
        out: _toIntOrNull(json['out']),
        bench: _toIntOrNull(json['bench']),
      );
}

class FootballShotsStatModel {
  final int? total;
  final int? on;
  const FootballShotsStatModel({this.total, this.on});
  factory FootballShotsStatModel.fromJson(Map<String, dynamic> json) =>
      FootballShotsStatModel(
        total: _toIntOrNull(json['total']),
        on: _toIntOrNull(json['on']),
      );
}

class FootballGoalsStatModel {
  final int? total;
  final int? conceded;
  final int? assists;
  final int? saves;
  const FootballGoalsStatModel({
    this.total,
    this.conceded,
    this.assists,
    this.saves,
  });
  factory FootballGoalsStatModel.fromJson(Map<String, dynamic> json) =>
      FootballGoalsStatModel(
        total: _toIntOrNull(json['total']),
        conceded: _toIntOrNull(json['conceded']),
        assists: _toIntOrNull(json['assists']),
        saves: _toIntOrNull(json['saves']),
      );
}

class FootballPassesStatModel {
  final int? total;
  final int? key;
  final int? accuracy;
  const FootballPassesStatModel({this.total, this.key, this.accuracy});
  factory FootballPassesStatModel.fromJson(Map<String, dynamic> json) =>
      FootballPassesStatModel(
        total: _toIntOrNull(json['total']),
        key: _toIntOrNull(json['key']),
        accuracy: _toIntOrNull(json['accuracy']),
      );
}

class FootballTacklesStatModel {
  final int? total;
  final int? blocks;
  final int? interceptions;
  const FootballTacklesStatModel({this.total, this.blocks, this.interceptions});
  factory FootballTacklesStatModel.fromJson(Map<String, dynamic> json) =>
      FootballTacklesStatModel(
        total: _toIntOrNull(json['total']),
        blocks: _toIntOrNull(json['blocks']),
        interceptions: _toIntOrNull(json['interceptions']),
      );
}

class FootballDuelsStatModel {
  final int? total;
  final int? won;
  const FootballDuelsStatModel({this.total, this.won});
  factory FootballDuelsStatModel.fromJson(Map<String, dynamic> json) =>
      FootballDuelsStatModel(
        total: _toIntOrNull(json['total']),
        won: _toIntOrNull(json['won']),
      );
}

class FootballDribblesStatModel {
  final int? attempts;
  final int? success;
  final int? past;
  const FootballDribblesStatModel({this.attempts, this.success, this.past});
  factory FootballDribblesStatModel.fromJson(Map<String, dynamic> json) =>
      FootballDribblesStatModel(
        attempts: _toIntOrNull(json['attempts']),
        success: _toIntOrNull(json['success']),
        past: _toIntOrNull(json['past']),
      );
}

class FootballFoulsStatModel {
  final int? drawn;
  final int? committed;
  const FootballFoulsStatModel({this.drawn, this.committed});
  factory FootballFoulsStatModel.fromJson(Map<String, dynamic> json) =>
      FootballFoulsStatModel(
        drawn: _toIntOrNull(json['drawn']),
        committed: _toIntOrNull(json['committed']),
      );
}

class FootballCardsStatModel {
  final int? yellow;
  final int? yellowred;
  final int? red;
  const FootballCardsStatModel({this.yellow, this.yellowred, this.red});
  factory FootballCardsStatModel.fromJson(Map<String, dynamic> json) =>
      FootballCardsStatModel(
        yellow: _toIntOrNull(json['yellow']),
        yellowred: _toIntOrNull(json['yellowred']),
        red: _toIntOrNull(json['red']),
      );
}

class FootballPenaltyStatModel {
  final int? won;
  final int? commited;
  final int? scored;
  final int? missed;
  final int? saved;
  const FootballPenaltyStatModel({
    this.won,
    this.commited,
    this.scored,
    this.missed,
    this.saved,
  });
  factory FootballPenaltyStatModel.fromJson(Map<String, dynamic> json) =>
      FootballPenaltyStatModel(
        won: _toIntOrNull(json['won']),
        commited: _toIntOrNull(json['commited']),
        scored: _toIntOrNull(json['scored']),
        missed: _toIntOrNull(json['missed']),
        saved: _toIntOrNull(json['saved']),
      );
}

class FootballStandingsApiResponseModel {
  final bool success;
  final int? statusCode;
  final String message;
  final FootballStandingsDataModel data;
  const FootballStandingsApiResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });
  factory FootballStandingsApiResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => FootballStandingsApiResponseModel(
    success: json['success'] as bool? ?? false,
    statusCode: _toIntOrNull(json['statusCode']),
    message: json['message'] as String? ?? '',
    data: FootballStandingsDataModel.fromJson(_mapObject(json['data'])),
  );
}

class FootballStandingsDataModel {
  final String get;
  final Map<String, dynamic> parameters;
  final int results;
  final List<FootballStandingsLeagueModel> response;
  const FootballStandingsDataModel({
    this.get = '',
    this.parameters = const <String, dynamic>{},
    this.results = 0,
    this.response = const <FootballStandingsLeagueModel>[],
  });
  factory FootballStandingsDataModel.fromJson(Map<String, dynamic> json) =>
      FootballStandingsDataModel(
        get: json['get'] as String? ?? '',
        parameters: _mapObject(json['parameters']),
        results: _toIntOrNull(json['results']) ?? 0,
        response: _mapList(
          json['response'],
        ).map(FootballStandingsLeagueModel.fromJson).toList(growable: false),
      );
}

class FootballStandingsLeagueModel {
  final int? id;
  final String name;
  final String country;
  final String logo;
  final String? flag;
  final int? season;
  final List<List<FootballStandingRowModel>> standings;
  const FootballStandingsLeagueModel({
    this.id,
    this.name = '',
    this.country = '',
    this.logo = '',
    this.flag,
    this.season,
    this.standings = const <List<FootballStandingRowModel>>[],
  });
  factory FootballStandingsLeagueModel.fromJson(Map<String, dynamic> json) {
    final leagueJson = json['league'] is Map
        ? _mapObject(json['league'])
        : json;
    final rawGroups = leagueJson['standings'];
    final groups = <List<FootballStandingRowModel>>[];
    if (rawGroups is List) {
      for (final group in rawGroups) {
        if (group is List) {
          groups.add(
            group
                .whereType<Map>()
                .map(
                  (item) => FootballStandingRowModel.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList(growable: false),
          );
        }
      }
    }
    return FootballStandingsLeagueModel(
      id: _toIntOrNull(leagueJson['id']),
      name: leagueJson['name'] as String? ?? '',
      country: leagueJson['country'] as String? ?? '',
      logo: leagueJson['logo'] as String? ?? '',
      flag: leagueJson['flag'] as String?,
      season: _toIntOrNull(leagueJson['season']),
      standings: groups,
    );
  }
}

class FootballStandingRowModel {
  final int? rank;
  final FootballStandingTeamModel team;
  final int? points;
  final int? goalsDiff;
  final String group;
  final String form;
  final String status;
  final String? description;
  final FootballStandingRecordModel all;
  final FootballStandingRecordModel home;
  final FootballStandingRecordModel away;
  final String update;
  const FootballStandingRowModel({
    this.rank,
    this.team = const FootballStandingTeamModel(),
    this.points,
    this.goalsDiff,
    this.group = '',
    this.form = '',
    this.status = '',
    this.description,
    this.all = const FootballStandingRecordModel(),
    this.home = const FootballStandingRecordModel(),
    this.away = const FootballStandingRecordModel(),
    this.update = '',
  });
  factory FootballStandingRowModel.fromJson(Map<String, dynamic> json) =>
      FootballStandingRowModel(
        rank: _toIntOrNull(json['rank']),
        team: FootballStandingTeamModel.fromJson(_mapObject(json['team'])),
        points: _toIntOrNull(json['points']),
        goalsDiff: _toIntOrNull(json['goalsDiff']),
        group: json['group'] as String? ?? '',
        form: json['form'] as String? ?? '',
        status: json['status'] as String? ?? '',
        description: json['description'] as String?,
        all: FootballStandingRecordModel.fromJson(_mapObject(json['all'])),
        home: FootballStandingRecordModel.fromJson(_mapObject(json['home'])),
        away: FootballStandingRecordModel.fromJson(_mapObject(json['away'])),
        update: json['update'] as String? ?? '',
      );
}

class FootballStandingTeamModel {
  final int? id;
  final String name;
  final String logo;
  const FootballStandingTeamModel({this.id, this.name = '', this.logo = ''});
  factory FootballStandingTeamModel.fromJson(Map<String, dynamic> json) =>
      FootballStandingTeamModel(
        id: _toIntOrNull(json['id']),
        name: json['name'] as String? ?? '',
        logo: json['logo'] as String? ?? '',
      );
}

class FootballStandingRecordModel {
  final int? played;
  final int? win;
  final int? draw;
  final int? lose;
  final FootballStandingGoalsModel goals;
  const FootballStandingRecordModel({
    this.played,
    this.win,
    this.draw,
    this.lose,
    this.goals = const FootballStandingGoalsModel(),
  });
  factory FootballStandingRecordModel.fromJson(Map<String, dynamic> json) =>
      FootballStandingRecordModel(
        played: _toIntOrNull(json['played']),
        win: _toIntOrNull(json['win']),
        draw: _toIntOrNull(json['draw']),
        lose: _toIntOrNull(json['lose']),
        goals: FootballStandingGoalsModel.fromJson(_mapObject(json['goals'])),
      );
}

class FootballStandingGoalsModel {
  final int? goalsFor;
  final int? against;
  const FootballStandingGoalsModel({this.goalsFor, this.against});
  factory FootballStandingGoalsModel.fromJson(Map<String, dynamic> json) =>
      FootballStandingGoalsModel(
        goalsFor: _toIntOrNull(json['for']),
        against: _toIntOrNull(json['against']),
      );
}

class FootballTeamCoachesApiResponseModel {
  final bool success;
  final int? statusCode;
  final String message;
  final FootballTeamCoachesDataModel data;
  const FootballTeamCoachesApiResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });
  factory FootballTeamCoachesApiResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => FootballTeamCoachesApiResponseModel(
    success: json['success'] as bool? ?? false,
    statusCode: _toIntOrNull(json['statusCode']),
    message: json['message'] as String? ?? '',
    data: FootballTeamCoachesDataModel.fromJson(_mapObject(json['data'])),
  );
}

class FootballTeamCoachesDataModel {
  final String get;
  final Map<String, dynamic> parameters;
  final int results;
  final List<FootballTeamCoachModel> response;
  const FootballTeamCoachesDataModel({
    this.get = '',
    this.parameters = const <String, dynamic>{},
    this.results = 0,
    this.response = const <FootballTeamCoachModel>[],
  });
  factory FootballTeamCoachesDataModel.fromJson(Map<String, dynamic> json) =>
      FootballTeamCoachesDataModel(
        get: json['get'] as String? ?? '',
        parameters: _mapObject(json['parameters']),
        results: _toIntOrNull(json['results']) ?? 0,
        response: _mapList(
          json['response'],
        ).map(FootballTeamCoachModel.fromJson).toList(growable: false),
      );
}

class FootballTeamCoachModel {
  final int? id;
  final String name;
  final String? firstname;
  final String? lastname;
  final int? age;
  final FootballBirthModel birth;
  final String? nationality;
  final String? height;
  final String? weight;
  final String photo;
  final FootballStatTeamModel team;
  final List<FootballCoachCareerModel> career;
  const FootballTeamCoachModel({
    this.id,
    this.name = '',
    this.firstname,
    this.lastname,
    this.age,
    this.birth = const FootballBirthModel(),
    this.nationality,
    this.height,
    this.weight,
    this.photo = '',
    this.team = const FootballStatTeamModel(),
    this.career = const <FootballCoachCareerModel>[],
  });
  factory FootballTeamCoachModel.fromJson(Map<String, dynamic> json) =>
      FootballTeamCoachModel(
        id: _toIntOrNull(json['id']),
        name: json['name'] as String? ?? '',
        firstname: json['firstname'] as String?,
        lastname: json['lastname'] as String?,
        age: _toIntOrNull(json['age']),
        birth: FootballBirthModel.fromJson(_mapObject(json['birth'])),
        nationality: json['nationality'] as String?,
        height: json['height'] as String?,
        weight: json['weight'] as String?,
        photo: json['photo'] as String? ?? '',
        team: FootballStatTeamModel.fromJson(_mapObject(json['team'])),
        career: _mapList(
          json['career'],
        ).map(FootballCoachCareerModel.fromJson).toList(growable: false),
      );
}

class FootballCoachCareerModel {
  final FootballStatTeamModel team;
  final String start;
  final String? end;
  const FootballCoachCareerModel({
    this.team = const FootballStatTeamModel(),
    this.start = '',
    this.end,
  });
  DateTime? get startDate => DateTime.tryParse(start);
  factory FootballCoachCareerModel.fromJson(Map<String, dynamic> json) =>
      FootballCoachCareerModel(
        team: FootballStatTeamModel.fromJson(_mapObject(json['team'])),
        start: json['start'] as String? ?? '',
        end: json['end'] as String?,
      );
}

class FootballTeamTrophiesPreviewApiResponseModel {
  final bool success;
  final int? statusCode;
  final String message;
  final FootballTeamTrophiesPreviewDataModel data;

  const FootballTeamTrophiesPreviewApiResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory FootballTeamTrophiesPreviewApiResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FootballTeamTrophiesPreviewApiResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: _toIntOrNull(json['statusCode']),
      message: json['message'] as String? ?? '',
      data: FootballTeamTrophiesPreviewDataModel.fromJson(
        _mapObject(json['data']),
      ),
    );
  }
}

class FootballTeamTrophiesPreviewDataModel {
  final String teamId;
  final FootballTeamTrophiesSyncStatusModel syncStatus;
  final List<FootballTeamTrophyPreviewItemModel> items;
  final FootballTeamTrophiesMetaModel meta;

  const FootballTeamTrophiesPreviewDataModel({
    this.teamId = '',
    this.syncStatus = const FootballTeamTrophiesSyncStatusModel(),
    this.items = const <FootballTeamTrophyPreviewItemModel>[],
    this.meta = const FootballTeamTrophiesMetaModel(),
  });

  factory FootballTeamTrophiesPreviewDataModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FootballTeamTrophiesPreviewDataModel(
      teamId: json['teamId']?.toString() ?? '',
      syncStatus: FootballTeamTrophiesSyncStatusModel.fromJson(
        _mapObject(json['syncStatus']),
      ),
      items: _mapList(json['items'])
          .map(FootballTeamTrophyPreviewItemModel.fromJson)
          .toList(growable: false),
      meta: FootballTeamTrophiesMetaModel.fromJson(_mapObject(json['meta'])),
    );
  }
}

class FootballTeamTrophiesSyncStatusModel {
  final bool initialSyncCompleted;
  final bool syncInProgress;
  final int? lastSyncedFromSeason;
  final int? lastSyncedToSeason;
  final String lastSyncedAt;
  final String? lastError;

  const FootballTeamTrophiesSyncStatusModel({
    this.initialSyncCompleted = false,
    this.syncInProgress = false,
    this.lastSyncedFromSeason,
    this.lastSyncedToSeason,
    this.lastSyncedAt = '',
    this.lastError,
  });

  factory FootballTeamTrophiesSyncStatusModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FootballTeamTrophiesSyncStatusModel(
      initialSyncCompleted: json['initialSyncCompleted'] as bool? ?? false,
      syncInProgress: json['syncInProgress'] as bool? ?? false,
      lastSyncedFromSeason: _toIntOrNull(json['lastSyncedFromSeason']),
      lastSyncedToSeason: _toIntOrNull(json['lastSyncedToSeason']),
      lastSyncedAt: json['lastSyncedAt'] as String? ?? '',
      lastError: json['lastError'] as String?,
    );
  }
}

class FootballTeamTrophyPreviewItemModel {
  final FootballTeamTrophyLeagueModel league;
  final FootballTeamTrophyResultModel winner;
  final FootballTeamTrophyResultModel runnerUp;
  final String lastSyncedAt;

  const FootballTeamTrophyPreviewItemModel({
    this.league = const FootballTeamTrophyLeagueModel(),
    this.winner = const FootballTeamTrophyResultModel(),
    this.runnerUp = const FootballTeamTrophyResultModel(),
    this.lastSyncedAt = '',
  });

  factory FootballTeamTrophyPreviewItemModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FootballTeamTrophyPreviewItemModel(
      league: FootballTeamTrophyLeagueModel.fromJson(
        _mapObject(json['league']),
      ),
      winner: FootballTeamTrophyResultModel.fromJson(
        _mapObject(json['winner']),
      ),
      runnerUp: FootballTeamTrophyResultModel.fromJson(
        _mapObject(json['runnerUp']),
      ),
      lastSyncedAt: json['lastSyncedAt'] as String? ?? '',
    );
  }
}

class FootballTeamTrophyLeagueModel {
  final int? id;
  final String name;
  final String type;
  final String logo;
  final String country;
  final String? flag;

  const FootballTeamTrophyLeagueModel({
    this.id,
    this.name = '',
    this.type = '',
    this.logo = '',
    this.country = '',
    this.flag,
  });

  factory FootballTeamTrophyLeagueModel.fromJson(Map<String, dynamic> json) {
    return FootballTeamTrophyLeagueModel(
      id: _toIntOrNull(json['id']),
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      logo: json['logo'] as String? ?? '',
      country: json['country'] as String? ?? '',
      flag: json['flag'] as String?,
    );
  }
}

class FootballTeamTrophyResultModel {
  final int count;
  final List<String> seasons;

  const FootballTeamTrophyResultModel({
    this.count = 0,
    this.seasons = const <String>[],
  });

  factory FootballTeamTrophyResultModel.fromJson(Map<String, dynamic> json) {
    return FootballTeamTrophyResultModel(
      count: _toIntOrNull(json['count']) ?? 0,
      seasons: (json['seasons'] is List)
          ? (json['seasons'] as List)
                .map((item) => item.toString())
                .toList(growable: false)
          : const <String>[],
    );
  }
}

class FootballTeamTrophiesMetaModel {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const FootballTeamTrophiesMetaModel({
    this.page = 1,
    this.limit = 20,
    this.total = 0,
    this.totalPages = 1,
  });

  factory FootballTeamTrophiesMetaModel.fromJson(Map<String, dynamic> json) {
    return FootballTeamTrophiesMetaModel(
      page: _toIntOrNull(json['page']) ?? 1,
      limit: _toIntOrNull(json['limit']) ?? 20,
      total: _toIntOrNull(json['total']) ?? 0,
      totalPages: _toIntOrNull(json['totalPages']) ?? 1,
    );
  }
}

Map<String, dynamic> _mapObject(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
}

List<Map<String, dynamic>> _mapList(Object? value) {
  if (value is List) {
    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList(growable: false);
  }
  return <Map<String, dynamic>>[];
}

double? _toDoubleOrNull(Object? value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

int? _toIntOrNull(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}
