class LeaguesSportCodes {
  static const String football = 'football';
}

class LeaguesFeedPayloadModel {
  final String sportCode;

  const LeaguesFeedPayloadModel({required this.sportCode});

  Map<String, dynamic> toJson() => <String, dynamic>{'sport_code': sportCode};
}

class FootballLeaguesApiResponseModel {
  final bool success;
  final int? statusCode;
  final String message;
  final FootballLeaguesDataModel data;

  const FootballLeaguesApiResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory FootballLeaguesApiResponseModel.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'];
    return FootballLeaguesApiResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String? ?? '',
      data: dataJson is Map<String, dynamic>
          ? FootballLeaguesDataModel.fromJson(dataJson)
          : const FootballLeaguesDataModel(),
    );
  }
}

class FootballLeaguesDataModel {
  final String get;
  final Map<String, dynamic> parameters;
  final List<dynamic> errors;
  final int results;
  final FootballLeaguesPagingModel paging;
  final List<FootballLeagueApiItemModel> response;

  const FootballLeaguesDataModel({
    this.get = '',
    this.parameters = const <String, dynamic>{},
    this.errors = const <dynamic>[],
    this.results = 0,
    this.paging = const FootballLeaguesPagingModel(),
    this.response = const <FootballLeagueApiItemModel>[],
  });

  factory FootballLeaguesDataModel.fromJson(Map<String, dynamic> json) {
    final responseJson =
        (json['response'] as List<dynamic>? ?? const <dynamic>[])
            .whereType<Map<String, dynamic>>()
            .toList(growable: false);

    return FootballLeaguesDataModel(
      get: json['get'] as String? ?? '',
      parameters: json['parameters'] is Map<String, dynamic>
          ? json['parameters'] as Map<String, dynamic>
          : const <String, dynamic>{},
      errors: json['errors'] as List<dynamic>? ?? const <dynamic>[],
      results: json['results'] as int? ?? 0,
      paging: json['paging'] is Map<String, dynamic>
          ? FootballLeaguesPagingModel.fromJson(
              json['paging'] as Map<String, dynamic>,
            )
          : const FootballLeaguesPagingModel(),
      response: responseJson
          .map(FootballLeagueApiItemModel.fromJson)
          .toList(growable: false),
    );
  }
}

class FootballLeaguesPagingModel {
  final int current;
  final int total;

  const FootballLeaguesPagingModel({this.current = 1, this.total = 1});

  factory FootballLeaguesPagingModel.fromJson(Map<String, dynamic> json) {
    return FootballLeaguesPagingModel(
      current: json['current'] as int? ?? 1,
      total: json['total'] as int? ?? 1,
    );
  }
}

class FootballLeagueApiItemModel {
  final FootballLeagueInfoModel league;
  final FootballCountryInfoModel country;
  final List<FootballLeagueSeasonModel> seasons;

  const FootballLeagueApiItemModel({
    this.league = const FootballLeagueInfoModel(),
    this.country = const FootballCountryInfoModel(),
    this.seasons = const <FootballLeagueSeasonModel>[],
  });

  int? get currentSeasonYear {
    for (final season in seasons) {
      if (season.current && season.year != null) {
        return season.year;
      }
    }
    if (seasons.isEmpty) {
      return null;
    }
    return seasons.last.year;
  }

  factory FootballLeagueApiItemModel.fromJson(Map<String, dynamic> json) {
    final seasonsJson =
        (json['seasons'] as List<dynamic>? ?? const <dynamic>[])
            .whereType<Map<String, dynamic>>()
            .toList(growable: false);

    return FootballLeagueApiItemModel(
      league: json['league'] is Map<String, dynamic>
          ? FootballLeagueInfoModel.fromJson(
              json['league'] as Map<String, dynamic>,
            )
          : const FootballLeagueInfoModel(),
      country: json['country'] is Map<String, dynamic>
          ? FootballCountryInfoModel.fromJson(
              json['country'] as Map<String, dynamic>,
            )
          : const FootballCountryInfoModel(),
      seasons: seasonsJson
          .map(FootballLeagueSeasonModel.fromJson)
          .toList(growable: false),
    );
  }
}

class FootballLeagueInfoModel {
  final int? id;
  final String name;
  final String type;
  final String logo;

  const FootballLeagueInfoModel({
    this.id,
    this.name = '',
    this.type = '',
    this.logo = '',
  });

  factory FootballLeagueInfoModel.fromJson(Map<String, dynamic> json) {
    return FootballLeagueInfoModel(
      id: json['id'] as int?,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      logo: json['logo'] as String? ?? '',
    );
  }
}

class FootballCountryInfoModel {
  final String name;
  final String? code;
  final String? flag;

  const FootballCountryInfoModel({this.name = '', this.code, this.flag});

  factory FootballCountryInfoModel.fromJson(Map<String, dynamic> json) {
    return FootballCountryInfoModel(
      name: json['name'] as String? ?? '',
      code: json['code'] as String?,
      flag: json['flag'] as String?,
    );
  }
}

class FootballLeagueSeasonModel {
  final int? year;
  final String start;
  final String end;
  final bool current;
  final Map<String, dynamic> coverage;

  const FootballLeagueSeasonModel({
    this.year,
    this.start = '',
    this.end = '',
    this.current = false,
    this.coverage = const <String, dynamic>{},
  });

  factory FootballLeagueSeasonModel.fromJson(Map<String, dynamic> json) {
    return FootballLeagueSeasonModel(
      year: json['year'] as int?,
      start: json['start'] as String? ?? '',
      end: json['end'] as String? ?? '',
      current: json['current'] as bool? ?? false,
      coverage: json['coverage'] is Map<String, dynamic>
          ? json['coverage'] as Map<String, dynamic>
          : const <String, dynamic>{},
    );
  }
}

class LeaguesTopLeagueUiModel {
  final String leagueId;
  final String image;
  final String leagueName;
  final String badgeSeed;
  final String badgeHex;
  final String countryName;
  final String leagueType;
  final int? season;
  final String countryFlag;

  const LeaguesTopLeagueUiModel({
    required this.leagueId,
    required this.image,
    required this.leagueName,
    required this.badgeSeed,
    required this.badgeHex,
    this.countryName = '',
    this.leagueType = '',
    this.season,
    this.countryFlag = '',
  });

  factory LeaguesTopLeagueUiModel.fromJson(Map<String, dynamic> json) {
    return LeaguesTopLeagueUiModel(
      leagueId: json['league_id'] as String? ?? '',
      image: json['image'] as String? ?? '',
      leagueName: json['league_name'] as String? ?? '',
      badgeSeed: json['badge_seed'] as String? ?? '',
      badgeHex: json['badge_hex'] as String? ?? '#2A3B36',
      countryName: json['country_name'] as String? ?? '',
      leagueType: json['league_type'] as String? ?? '',
      season: _parseOptionalInt(json['season']),
      countryFlag: json['country_flag'] as String? ?? '',
    );
  }

  factory LeaguesTopLeagueUiModel.fromFootballLeague(
    FootballLeagueApiItemModel item,
  ) {
    return LeaguesTopLeagueUiModel(
      leagueId: (item.league.id ?? 0).toString(),
      image: item.league.logo,
      leagueName: item.league.name,
      badgeSeed: _seedFromName(item.league.name),
      badgeHex: _colorHexFromValue(item.league.id ?? item.league.name.hashCode),
      countryName: item.country.name,
      leagueType: item.league.type,
      season: item.currentSeasonYear,
      countryFlag: item.country.flag ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'league_id': leagueId,
      'league_name': leagueName,
      'image': image,
      'badge_seed': badgeSeed,
      'badge_hex': badgeHex,
      'country_name': countryName,
      'league_type': leagueType,
      'season': season,
      'country_flag': countryFlag,
    };
  }
}

class LeaguesCompetitionUiModel {
  final String competitionId;
  final String title;
  final String badgeSeed;
  final String badgeHex;
  final String image;
  final String type;
  final String countryName;
  final String countryFlag;
  final int? season;

  const LeaguesCompetitionUiModel({
    required this.competitionId,
    required this.title,
    required this.badgeSeed,
    required this.badgeHex,
    this.image = '',
    this.type = '',
    this.countryName = '',
    this.countryFlag = '',
    this.season,
  });

  factory LeaguesCompetitionUiModel.fromJson(Map<String, dynamic> json) {
    return LeaguesCompetitionUiModel(
      competitionId: json['competition_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      badgeSeed: json['badge_seed'] as String? ?? '',
      badgeHex: json['badge_hex'] as String? ?? '#2D373A',
      image: json['image'] as String? ?? '',
      type: json['type'] as String? ?? '',
      countryName: json['country_name'] as String? ?? '',
      countryFlag: json['country_flag'] as String? ?? '',
      season: _parseOptionalInt(json['season']),
    );
  }

  factory LeaguesCompetitionUiModel.fromFootballLeague(
    FootballLeagueApiItemModel item,
  ) {
    return LeaguesCompetitionUiModel(
      competitionId: (item.league.id ?? 0).toString(),
      title: item.league.name,
      badgeSeed: _seedFromName(item.league.name),
      badgeHex: _colorHexFromValue(item.league.id ?? item.league.name.hashCode),
      image: item.league.logo,
      type: item.league.type,
      countryName: item.country.name,
      countryFlag: item.country.flag ?? '',
      season: item.currentSeasonYear,
    );
  }

  LeaguesTopLeagueUiModel toTopLeague({String fallbackCountryName = '', String fallbackCountryFlag = ''}) {
    return LeaguesTopLeagueUiModel(
      leagueId: competitionId,
      image: image,
      leagueName: title,
      badgeSeed: badgeSeed,
      badgeHex: badgeHex,
      countryName: countryName.isEmpty ? fallbackCountryName : countryName,
      leagueType: type,
      season: season,
      countryFlag: countryFlag.isEmpty ? fallbackCountryFlag : countryFlag,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'competition_id': competitionId,
      'title': title,
      'badge_seed': badgeSeed,
      'badge_hex': badgeHex,
      'image': image,
      'type': type,
      'country_name': countryName,
      'country_flag': countryFlag,
      'season': season,
    };
  }
}

class LeaguesCountryUiModel {
  final String countryId;
  final String countryName;
  final String flagSeed;
  final String flagHex;
  final String flagUrl;
  final bool isExpandedByDefault;
  final List<LeaguesCompetitionUiModel> competitions;

  const LeaguesCountryUiModel({
    required this.countryId,
    required this.countryName,
    required this.flagSeed,
    required this.flagHex,
    required this.isExpandedByDefault,
    required this.competitions,
    this.flagUrl = '',
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
      flagUrl: json['flag_url'] as String? ?? '',
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
      'flag_url': flagUrl,
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

  factory LeaguesFeedUiModel.fromFootballLeaguesData(
    FootballLeaguesDataModel data,
  ) {
    final countryMap = <String, _CountryBuilder>{};

    for (final item in data.response) {
      final countryName = item.country.name.isEmpty ? 'International' : item.country.name;
      final countryId = _slugify(countryName);
      final builder = countryMap.putIfAbsent(
        countryId,
        () => _CountryBuilder(
          countryId: countryId,
          countryName: countryName,
          flagSeed: _countrySeed(item.country),
          flagHex: _colorHexFromValue(countryId.hashCode),
          flagUrl: item.country.flag ?? '',
          isExpandedByDefault: countryName.toLowerCase() == 'world' ||
              countryName.toLowerCase() == 'international',
        ),
      );

      builder.competitions.add(
        LeaguesCompetitionUiModel.fromFootballLeague(item),
      );
    }

    final countries = countryMap.values
        .map((builder) => builder.toUiModel())
        .toList(growable: false)
      ..sort((left, right) {
        if (left.isExpandedByDefault != right.isExpandedByDefault) {
          return left.isExpandedByDefault ? -1 : 1;
        }
        return left.countryName.compareTo(right.countryName);
      });

    return LeaguesFeedUiModel(
      sportCode: LeaguesSportCodes.football,
      topLeagues: _buildTopLeagues(data.response),
      countries: countries,
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

class _CountryBuilder {
  final String countryId;
  final String countryName;
  final String flagSeed;
  final String flagHex;
  final String flagUrl;
  final bool isExpandedByDefault;
  final List<LeaguesCompetitionUiModel> competitions =
      <LeaguesCompetitionUiModel>[];

  _CountryBuilder({
    required this.countryId,
    required this.countryName,
    required this.flagSeed,
    required this.flagHex,
    required this.flagUrl,
    required this.isExpandedByDefault,
  });

  LeaguesCountryUiModel toUiModel() {
    final sortedCompetitions = List<LeaguesCompetitionUiModel>.from(competitions)
      ..sort((left, right) => left.title.compareTo(right.title));

    return LeaguesCountryUiModel(
      countryId: countryId,
      countryName: countryName,
      flagSeed: flagSeed,
      flagHex: flagHex,
      flagUrl: flagUrl,
      isExpandedByDefault: isExpandedByDefault,
      competitions: sortedCompetitions,
    );
  }
}

List<LeaguesTopLeagueUiModel> _buildTopLeagues(
  List<FootballLeagueApiItemModel> items,
) {
  const preferredLeagueIds = <int>[39, 140, 135, 78, 61, 2, 3, 848, 94, 88];
  final byId = <int, FootballLeagueApiItemModel>{};

  for (final item in items) {
    final id = item.league.id;
    if (id != null && !byId.containsKey(id)) {
      byId[id] = item;
    }
  }

  final selected = <FootballLeagueApiItemModel>[];
  for (final id in preferredLeagueIds) {
    final item = byId[id];
    if (item != null) {
      selected.add(item);
    }
  }

  for (final item in items) {
    if (selected.length >= 10) {
      break;
    }
    if (!selected.any((selectedItem) => selectedItem.league.id == item.league.id)) {
      selected.add(item);
    }
  }

  return selected
      .map(LeaguesTopLeagueUiModel.fromFootballLeague)
      .toList(growable: false);
}

String _countrySeed(FootballCountryInfoModel country) {
  final code = country.code;
  if (code != null && code.isNotEmpty) {
    return code.length > 3 ? code.substring(0, 3).toUpperCase() : code.toUpperCase();
  }
  return _seedFromName(country.name.isEmpty ? 'World' : country.name);
}

String _seedFromName(String name) {
  final words = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((item) => item.isNotEmpty)
      .toList(growable: false);

  if (words.isEmpty) {
    return 'L';
  }
  if (words.length == 1) {
    return words.first.substring(0, words.first.length < 2 ? 1 : 2).toUpperCase();
  }
  return words.take(3).map((word) => word[0]).join().toUpperCase();
}

String _slugify(String value) {
  final slug = value
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
  return slug.isEmpty ? 'unknown' : slug;
}

String _colorHexFromValue(int value) {
  const palette = <String>[
    '#243F38',
    '#285048',
    '#2C5D51',
    '#34645B',
    '#385A67',
    '#514C71',
    '#614D58',
    '#665243',
  ];
  return palette[value.abs() % palette.length];
}


int? _parseOptionalInt(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value);
  }
  return null;
}
