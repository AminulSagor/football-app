class LeaguesSportCodes {
  static const String football = 'football';
}

class LeaguesFeedPayloadModel {
  final String sportCode;

  const LeaguesFeedPayloadModel({required this.sportCode});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'sport_code': sportCode};
  }
}

class LeaguesTopLeagueUiModel {
  final String leagueId;
  final String leagueName;
  final String badgeSeed;
  final String badgeHex;

  const LeaguesTopLeagueUiModel({
    required this.leagueId,
    required this.leagueName,
    required this.badgeSeed,
    required this.badgeHex,
  });

  factory LeaguesTopLeagueUiModel.fromJson(Map<String, dynamic> json) {
    return LeaguesTopLeagueUiModel(
      leagueId: json['league_id'] as String? ?? '',
      leagueName: json['league_name'] as String? ?? '',
      badgeSeed: json['badge_seed'] as String? ?? '',
      badgeHex: json['badge_hex'] as String? ?? '#2A3B36',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'league_id': leagueId,
      'league_name': leagueName,
      'badge_seed': badgeSeed,
      'badge_hex': badgeHex,
    };
  }
}

class LeaguesCompetitionUiModel {
  final String competitionId;
  final String title;
  final String badgeSeed;
  final String badgeHex;

  const LeaguesCompetitionUiModel({
    required this.competitionId,
    required this.title,
    required this.badgeSeed,
    required this.badgeHex,
  });

  factory LeaguesCompetitionUiModel.fromJson(Map<String, dynamic> json) {
    return LeaguesCompetitionUiModel(
      competitionId: json['competition_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      badgeSeed: json['badge_seed'] as String? ?? '',
      badgeHex: json['badge_hex'] as String? ?? '#2D373A',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'competition_id': competitionId,
      'title': title,
      'badge_seed': badgeSeed,
      'badge_hex': badgeHex,
    };
  }
}

class LeaguesCountryUiModel {
  final String countryId;
  final String countryName;
  final String flagSeed;
  final String flagHex;
  final bool isExpandedByDefault;
  final List<LeaguesCompetitionUiModel> competitions;

  const LeaguesCountryUiModel({
    required this.countryId,
    required this.countryName,
    required this.flagSeed,
    required this.flagHex,
    required this.isExpandedByDefault,
    required this.competitions,
  });

  bool get isExpandable => competitions.isNotEmpty;

  factory LeaguesCountryUiModel.fromJson(Map<String, dynamic> json) {
    final competitionsJson =
        (json['competitions'] as List<dynamic>? ?? const <dynamic>[])
            .whereType<Map<String, dynamic>>()
            .toList(growable: false);

    return LeaguesCountryUiModel(
      countryId: json['country_id'] as String? ?? '',
      countryName: json['country_name'] as String? ?? '',
      flagSeed: json['flag_seed'] as String? ?? '',
      flagHex: json['flag_hex'] as String? ?? '#2D3D39',
      isExpandedByDefault: json['is_expanded_by_default'] as bool? ?? false,
      competitions: competitionsJson
          .map(LeaguesCompetitionUiModel.fromJson)
          .toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'country_id': countryId,
      'country_name': countryName,
      'flag_seed': flagSeed,
      'flag_hex': flagHex,
      'is_expanded_by_default': isExpandedByDefault,
      'competitions': competitions.map((item) => item.toJson()).toList(),
    };
  }
}

class LeaguesFeedUiModel {
  final String sportCode;
  final List<LeaguesTopLeagueUiModel> topLeagues;
  final List<LeaguesCountryUiModel> countries;

  const LeaguesFeedUiModel({
    required this.sportCode,
    required this.topLeagues,
    required this.countries,
  });

  factory LeaguesFeedUiModel.fromJson(Map<String, dynamic> json) {
    final topLeaguesJson =
        (json['top_leagues'] as List<dynamic>? ?? const <dynamic>[])
            .whereType<Map<String, dynamic>>()
            .toList(growable: false);
    final countriesJson =
        (json['countries'] as List<dynamic>? ?? const <dynamic>[])
            .whereType<Map<String, dynamic>>()
            .toList(growable: false);

    return LeaguesFeedUiModel(
      sportCode: json['sport_code'] as String? ?? '',
      topLeagues: topLeaguesJson
          .map(LeaguesTopLeagueUiModel.fromJson)
          .toList(growable: false),
      countries: countriesJson
          .map(LeaguesCountryUiModel.fromJson)
          .toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'sport_code': sportCode,
      'top_leagues': topLeagues.map((item) => item.toJson()).toList(),
      'countries': countries.map((item) => item.toJson()).toList(),
    };
  }
}

class LeaguesViewModel {
  static const Object _unset = Object();

  final bool isLoading;
  final List<LeaguesTopLeagueUiModel> topLeagues;
  final List<LeaguesCountryUiModel> countries;
  final Set<String> expandedCountryIds;
  final bool showAllTopLeagues;
  final String? errorCode;

  const LeaguesViewModel({
    this.isLoading = false,
    this.topLeagues = const <LeaguesTopLeagueUiModel>[],
    this.countries = const <LeaguesCountryUiModel>[],
    this.expandedCountryIds = const <String>{},
    this.showAllTopLeagues = false,
    this.errorCode,
  });

  bool get hasExpandableTopLeagues => topLeagues.length > 5;

  List<LeaguesTopLeagueUiModel> get visibleTopLeagues {
    if (!hasExpandableTopLeagues || showAllTopLeagues) {
      return topLeagues;
    }

    return topLeagues.take(5).toList(growable: false);
  }

  bool isCountryExpanded(String countryId) {
    return expandedCountryIds.contains(countryId);
  }

  LeaguesViewModel copyWith({
    bool? isLoading,
    Object? topLeagues = _unset,
    Object? countries = _unset,
    Object? expandedCountryIds = _unset,
    bool? showAllTopLeagues,
    Object? errorCode = _unset,
  }) {
    return LeaguesViewModel(
      isLoading: isLoading ?? this.isLoading,
      topLeagues: identical(topLeagues, _unset)
          ? this.topLeagues
          : topLeagues as List<LeaguesTopLeagueUiModel>,
      countries: identical(countries, _unset)
          ? this.countries
          : countries as List<LeaguesCountryUiModel>,
      expandedCountryIds: identical(expandedCountryIds, _unset)
          ? this.expandedCountryIds
          : expandedCountryIds as Set<String>,
      showAllTopLeagues: showAllTopLeagues ?? this.showAllTopLeagues,
      errorCode: identical(errorCode, _unset)
          ? this.errorCode
          : errorCode as String?,
    );
  }
}
