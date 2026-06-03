class LeaguesSportCodes {
  static const String football = 'football';
}

class LeaguesFeedPayloadModel {
  final String sportCode;

  const LeaguesFeedPayloadModel({required this.sportCode});

  Map<String, dynamic> toJson() => <String, dynamic>{'sport_code': sportCode};
}

class FootballCountriesApiResponseModel {
  final bool success;
  final int? statusCode;
  final String message;
  final FootballCountriesDataModel data;

  const FootballCountriesApiResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory FootballCountriesApiResponseModel.fromJson(Map<String, dynamic> json) {
    return FootballCountriesApiResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: _parseOptionalInt(json['statusCode']),
      message: json['message'] as String? ?? '',
      data: FootballCountriesDataModel.fromJson(_mapObject(json['data'])),
    );
  }
}

class FootballCountriesDataModel {
  final String get;
  final Map<String, dynamic> parameters;
  final Object? errors;
  final int results;
  final FootballLeaguesPagingModel paging;
  final List<FootballCountryApiItemModel> response;

  const FootballCountriesDataModel({
    this.get = '',
    this.parameters = const <String, dynamic>{},
    this.errors,
    this.results = 0,
    this.paging = const FootballLeaguesPagingModel(),
    this.response = const <FootballCountryApiItemModel>[],
  });

  factory FootballCountriesDataModel.fromJson(Map<String, dynamic> json) {
    return FootballCountriesDataModel(
      get: json['get'] as String? ?? '',
      parameters: _mapObject(json['parameters']),
      errors: json['errors'],
      results: _parseOptionalInt(json['results']) ?? 0,
      paging: FootballLeaguesPagingModel.fromJson(_mapObject(json['paging'])),
      response: _mapList(json['response'])
          .map(FootballCountryApiItemModel.fromJson)
          .toList(growable: false),
    );
  }
}

class FootballCountryApiItemModel {
  final String name;
  final String? code;
  final String? flag;

  const FootballCountryApiItemModel({
    this.name = '',
    this.code,
    this.flag,
  });

  factory FootballCountryApiItemModel.fromJson(Map<String, dynamic> json) {
    return FootballCountryApiItemModel(
      name: json['name'] as String? ?? '',
      code: json['code'] as String?,
      flag: json['flag'] as String?,
    );
  }

  FootballCountryInfoModel toInfo() {
    return FootballCountryInfoModel(name: name, code: code, flag: flag);
  }
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
    return FootballLeaguesApiResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: _parseOptionalInt(json['statusCode']),
      message: json['message'] as String? ?? '',
      data: FootballLeaguesDataModel.fromJson(_mapObject(json['data'])),
    );
  }
}

class FootballLeaguesByCountryApiResponseModel {
  final bool success;
  final int? statusCode;
  final String message;
  final FootballLeaguesByCountryDataModel data;

  const FootballLeaguesByCountryApiResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory FootballLeaguesByCountryApiResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FootballLeaguesByCountryApiResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: _parseOptionalInt(json['statusCode']),
      message: json['message'] as String? ?? '',
      data: FootballLeaguesByCountryDataModel.fromJson(_mapObject(json['data'])),
    );
  }
}

class FootballLeaguesByCountryDataModel {
  final List<FootballLeagueApiItemModel> items;
  final FootballLeaguesByCountryMetaModel meta;

  const FootballLeaguesByCountryDataModel({
    this.items = const <FootballLeagueApiItemModel>[],
    this.meta = const FootballLeaguesByCountryMetaModel(),
  });

  factory FootballLeaguesByCountryDataModel.fromJson(Map<String, dynamic> json) {
    return FootballLeaguesByCountryDataModel(
      items: _mapList(json['items'])
          .map(FootballLeagueApiItemModel.fromJson)
          .toList(growable: false),
      meta: FootballLeaguesByCountryMetaModel.fromJson(_mapObject(json['meta'])),
    );
  }
}

class FootballLeaguesByCountryMetaModel {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const FootballLeaguesByCountryMetaModel({
    this.page = 1,
    this.limit = 20,
    this.total = 0,
    this.totalPages = 1,
  });

  factory FootballLeaguesByCountryMetaModel.fromJson(Map<String, dynamic> json) {
    return FootballLeaguesByCountryMetaModel(
      page: _parseOptionalInt(json['page']) ?? 1,
      limit: _parseOptionalInt(json['limit']) ?? 20,
      total: _parseOptionalInt(json['total']) ?? 0,
      totalPages: _parseOptionalInt(json['totalPages']) ?? 1,
    );
  }
}

class FootballLeaguesDataModel {
  final String get;
  final Map<String, dynamic> parameters;
  final Object? errors;
  final int results;
  final FootballLeaguesPagingModel paging;
  final List<FootballLeagueApiItemModel> response;

  const FootballLeaguesDataModel({
    this.get = '',
    this.parameters = const <String, dynamic>{},
    this.errors,
    this.results = 0,
    this.paging = const FootballLeaguesPagingModel(),
    this.response = const <FootballLeagueApiItemModel>[],
  });

  factory FootballLeaguesDataModel.fromJson(Map<String, dynamic> json) {
    return FootballLeaguesDataModel(
      get: json['get'] as String? ?? '',
      parameters: _mapObject(json['parameters']),
      errors: json['errors'],
      results: _parseOptionalInt(json['results']) ?? 0,
      paging: FootballLeaguesPagingModel.fromJson(_mapObject(json['paging'])),
      response: _mapList(json['response'])
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
      current: _parseOptionalInt(json['current']) ?? 1,
      total: _parseOptionalInt(json['total']) ?? 1,
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
      if (season.current && season.year != null) return season.year;
    }
    if (seasons.isEmpty) return null;
    return seasons.last.year;
  }

  factory FootballLeagueApiItemModel.fromJson(Map<String, dynamic> json) {
    return FootballLeagueApiItemModel(
      league: FootballLeagueInfoModel.fromJson(_mapObject(json['league'])),
      country: FootballCountryInfoModel.fromJson(_mapObject(json['country'])),
      seasons: _mapList(json['seasons'])
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
      id: _parseOptionalInt(json['id']),
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
      year: _parseOptionalInt(json['year']),
      start: json['start'] as String? ?? '',
      end: json['end'] as String? ?? '',
      current: json['current'] as bool? ?? false,
      coverage: _mapObject(json['coverage']),
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

  String get displayCountryName => _displayCountryName(countryName);

  String get apiCountryName => _apiCountryName(countryName);

  factory LeaguesTopLeagueUiModel.fromJson(Map<String, dynamic> json) {
    return LeaguesTopLeagueUiModel(
      leagueId: json['league_id'] as String? ?? '',
      image: json['image'] as String? ?? '',
      leagueName: json['league_name'] as String? ?? '',
      badgeSeed: json['badge_seed'] as String? ?? '',
      badgeHex: json['badge_hex'] as String? ?? '#2A3B36',
      countryName: _apiCountryName(json['country_name'] as String? ?? ''),
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
      countryName: _apiCountryName(item.country.name),
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

  String get displayCountryName => _displayCountryName(countryName);

  String get apiCountryName => _apiCountryName(countryName);

  factory LeaguesCompetitionUiModel.fromJson(Map<String, dynamic> json) {
    return LeaguesCompetitionUiModel(
      competitionId: json['competition_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      badgeSeed: json['badge_seed'] as String? ?? '',
      badgeHex: json['badge_hex'] as String? ?? '#2D373A',
      image: json['image'] as String? ?? '',
      type: json['type'] as String? ?? '',
      countryName: _apiCountryName(json['country_name'] as String? ?? ''),
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
      countryName: _apiCountryName(item.country.name),
      countryFlag: item.country.flag ?? '',
      season: item.currentSeasonYear,
    );
  }

  LeaguesTopLeagueUiModel toTopLeague({
    String fallbackCountryName = '',
    String fallbackCountryFlag = '',
  }) {
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
  final bool hasLoadedCompetitions;
  final bool isLoadingCompetitions;
  final bool isLoadingMoreCompetitions;
  final int leaguePage;
  final int totalLeaguePages;
  final int totalCompetitions;

  const LeaguesCountryUiModel({
    required this.countryId,
    required this.countryName,
    required this.flagSeed,
    required this.flagHex,
    required this.isExpandedByDefault,
    required this.competitions,
    this.flagUrl = '',
    this.hasLoadedCompetitions = false,
    this.isLoadingCompetitions = false,
    this.isLoadingMoreCompetitions = false,
    this.leaguePage = 1,
    this.totalLeaguePages = 1,
    this.totalCompetitions = 0,
  });

  String get displayCountryName => _displayCountryName(countryName);

  String get apiCountryName => _apiCountryName(countryName);

  bool get isExpandable => true;

  bool get canLoadMoreCompetitions {
    return hasLoadedCompetitions &&
        !isLoadingCompetitions &&
        !isLoadingMoreCompetitions &&
        leaguePage < totalLeaguePages;
  }

  factory LeaguesCountryUiModel.fromJson(Map<String, dynamic> json) {
    return LeaguesCountryUiModel(
      countryId: json['country_id'] as String? ?? '',
      countryName: _apiCountryName(json['country_name'] as String? ?? ''),
      flagSeed: json['flag_seed'] as String? ?? '',
      flagHex: json['flag_hex'] as String? ?? '#2D3D39',
      flagUrl: json['flag_url'] as String? ?? '',
      isExpandedByDefault: json['is_expanded_by_default'] as bool? ?? false,
      competitions: _mapList(json['competitions'])
          .map(LeaguesCompetitionUiModel.fromJson)
          .toList(growable: false),
      hasLoadedCompetitions: json['has_loaded_competitions'] as bool? ?? false,
      isLoadingCompetitions: json['is_loading_competitions'] as bool? ?? false,
      isLoadingMoreCompetitions:
          json['is_loading_more_competitions'] as bool? ?? false,
      leaguePage: _parseOptionalInt(json['league_page']) ?? 1,
      totalLeaguePages: _parseOptionalInt(json['total_league_pages']) ?? 1,
      totalCompetitions: _parseOptionalInt(json['total_competitions']) ?? 0,
    );
  }

  LeaguesCountryUiModel copyWith({
    String? countryId,
    String? countryName,
    String? flagSeed,
    String? flagHex,
    String? flagUrl,
    bool? isExpandedByDefault,
    List<LeaguesCompetitionUiModel>? competitions,
    bool? hasLoadedCompetitions,
    bool? isLoadingCompetitions,
    bool? isLoadingMoreCompetitions,
    int? leaguePage,
    int? totalLeaguePages,
    int? totalCompetitions,
  }) {
    return LeaguesCountryUiModel(
      countryId: countryId ?? this.countryId,
      countryName: countryName ?? this.countryName,
      flagSeed: flagSeed ?? this.flagSeed,
      flagHex: flagHex ?? this.flagHex,
      flagUrl: flagUrl ?? this.flagUrl,
      isExpandedByDefault: isExpandedByDefault ?? this.isExpandedByDefault,
      competitions: competitions ?? this.competitions,
      hasLoadedCompetitions:
          hasLoadedCompetitions ?? this.hasLoadedCompetitions,
      isLoadingCompetitions:
          isLoadingCompetitions ?? this.isLoadingCompetitions,
      isLoadingMoreCompetitions:
          isLoadingMoreCompetitions ?? this.isLoadingMoreCompetitions,
      leaguePage: leaguePage ?? this.leaguePage,
      totalLeaguePages: totalLeaguePages ?? this.totalLeaguePages,
      totalCompetitions: totalCompetitions ?? this.totalCompetitions,
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
      'has_loaded_competitions': hasLoadedCompetitions,
      'is_loading_competitions': isLoadingCompetitions,
      'is_loading_more_competitions': isLoadingMoreCompetitions,
      'league_page': leaguePage,
      'total_league_pages': totalLeaguePages,
      'total_competitions': totalCompetitions,
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
    return LeaguesFeedUiModel(
      sportCode: json['sport_code'] as String? ?? '',
      topLeagues: _mapList(json['top_leagues'])
          .map(LeaguesTopLeagueUiModel.fromJson)
          .toList(growable: false),
      countries: _mapList(json['countries'])
          .map(LeaguesCountryUiModel.fromJson)
          .toList(growable: false),
    );
  }

  factory LeaguesFeedUiModel.fromFootballCountriesData(
    FootballCountriesDataModel data,
  ) {
    final countries = data.response
        .map((item) {
          final info = item.toInfo();
          final countryName = _apiCountryName(info.name);
          return LeaguesCountryUiModel(
            countryId: _slugify(countryName),
            countryName: countryName,
            flagSeed: _countrySeed(info),
            flagHex: _colorHexFromValue(countryName.hashCode),
            flagUrl: info.flag ?? '',
            isExpandedByDefault: false,
            competitions: const <LeaguesCompetitionUiModel>[],
          );
        })
        .toList(growable: false)
      ..sort(_compareCountriesByDisplayPriority);

    return LeaguesFeedUiModel(
      sportCode: LeaguesSportCodes.football,
      topLeagues: const <LeaguesTopLeagueUiModel>[],
      countries: countries,
    );
  }

  factory LeaguesFeedUiModel.fromFootballLeaguesData(
    FootballLeaguesDataModel data,
  ) {
    final countryMap = <String, _CountryBuilder>{};

    for (final item in data.response) {
      final countryName = _apiCountryName(item.country.name);
      final countryId = _slugify(countryName);
      final builder = countryMap.putIfAbsent(
        countryId,
        () => _CountryBuilder(
          countryId: countryId,
          countryName: countryName,
          flagSeed: _countrySeed(item.country),
          flagHex: _colorHexFromValue(countryId.hashCode),
          flagUrl: item.country.flag ?? '',
          isExpandedByDefault: false,
        ),
      );

      builder.competitions.add(
        LeaguesCompetitionUiModel.fromFootballLeague(item),
      );
    }

    final countries = countryMap.values
        .map((builder) => builder.toUiModel())
        .toList(growable: false)
      ..sort(_compareCountriesByDisplayPriority);

    return LeaguesFeedUiModel(
      sportCode: LeaguesSportCodes.football,
      topLeagues: const <LeaguesTopLeagueUiModel>[],
      countries: countries,
    );
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
  final bool hasLoaded;

  const LeaguesViewModel({
    this.isLoading = false,
    this.topLeagues = const <LeaguesTopLeagueUiModel>[],
    this.countries = const <LeaguesCountryUiModel>[],
    this.expandedCountryIds = const <String>{},
    this.showAllTopLeagues = false,
    this.errorCode,
    this.hasLoaded = false,
  });

  bool get hasExpandableTopLeagues => topLeagues.length > 5;

  List<LeaguesTopLeagueUiModel> get visibleTopLeagues {
    if (!hasExpandableTopLeagues || showAllTopLeagues) return topLeagues;
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
    bool? hasLoaded,
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
      hasLoaded: hasLoaded ?? this.hasLoaded,
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
      hasLoadedCompetitions: true,
      totalCompetitions: sortedCompetitions.length,
    );
  }
}

Map<String, dynamic> _mapObject(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
}

List<Map<String, dynamic>> _mapList(Object? value) {
  if (value is! List) return const <Map<String, dynamic>>[];
  return value
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList(growable: false);
}

String _displayCountryName(String countryName) {
  final trimmed = countryName.trim();
  if (trimmed.toLowerCase() == 'world') return 'International';
  return trimmed;
}

String _apiCountryName(String countryName) {
  final trimmed = countryName.trim();
  if (trimmed.isEmpty || trimmed.toLowerCase() == 'international') {
    return 'World';
  }
  return trimmed;
}

bool _isWorldCountry(String countryName) {
  return _apiCountryName(countryName).toLowerCase() == 'world';
}

int _compareCountriesByDisplayPriority(
  LeaguesCountryUiModel left,
  LeaguesCountryUiModel right,
) {
  final leftIsWorld = _isWorldCountry(left.countryName);
  final rightIsWorld = _isWorldCountry(right.countryName);

  if (leftIsWorld && !rightIsWorld) return -1;
  if (!leftIsWorld && rightIsWorld) return 1;

  return left.displayCountryName.compareTo(right.displayCountryName);
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
      .split(RegExp(r'[\s-]+'))
      .where((item) => item.isNotEmpty)
      .toList(growable: false);

  if (words.isEmpty) return 'L';
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
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}
