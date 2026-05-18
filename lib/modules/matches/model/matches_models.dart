enum MatchesTimelineFilter { ongoing, byTime }

class MatchesSportCodes {
  static const String football = 'football';
  static const String cricket = 'cricket';
  static const String basketball = 'basketball';
}

class MatchesDayLabelCodes {
  static const String today = 'today';
  static const String tomorrow = 'tomorrow';
  static const String old = 'old';
  static const String upcoming = 'upcoming';
}

class MatchesFixtureStatusCodes {
  static const String live = 'live';
  static const String finished = 'finished';
  static const String upcoming = 'upcoming';
}

class MatchesSchedulePayloadModel {
  final String sportCode;

  const MatchesSchedulePayloadModel({required this.sportCode});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'sport_code': sportCode};
  }
}

class FootballFixturesApiResponseModel {
  final bool success;
  final int? statusCode;
  final String message;
  final FootballFixturesDataModel data;

  const FootballFixturesApiResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory FootballFixturesApiResponseModel.fromJson(Map<String, dynamic> json) {
    return FootballFixturesApiResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: _toIntOrNull(json['statusCode']),
      message: json['message'] as String? ?? '',
      data: FootballFixturesDataModel.fromJson(_mapObject(json['data'])),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class FootballFixturesDataModel {
  final String get;
  final Map<String, dynamic> parameters;
  final Object? errors;
  final int results;
  final FootballPagingModel paging;
  final List<FootballFixtureModel> response;

  const FootballFixturesDataModel({
    required this.get,
    required this.parameters,
    required this.errors,
    required this.results,
    required this.paging,
    required this.response,
  });

  factory FootballFixturesDataModel.fromJson(Map<String, dynamic> json) {
    return FootballFixturesDataModel(
      get: json['get'] as String? ?? '',
      parameters: _mapObject(json['parameters']),
      errors: json['errors'],
      results: _toIntOrNull(json['results']) ?? 0,
      paging: FootballPagingModel.fromJson(_mapObject(json['paging'])),
      response: _mapList(json['response'])
          .map(FootballFixtureModel.fromJson)
          .toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'get': get,
      'parameters': parameters,
      'errors': errors,
      'results': results,
      'paging': paging.toJson(),
      'response': response.map((fixture) => fixture.toJson()).toList(),
    };
  }
}


class FootballLeagueFixturesApiResponseModel {
  final bool success;
  final int? statusCode;
  final String message;
  final FootballLeagueFixturesDataModel data;

  const FootballLeagueFixturesApiResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory FootballLeagueFixturesApiResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FootballLeagueFixturesApiResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: _toIntOrNull(json['statusCode']),
      message: json['message'] as String? ?? '',
      data: FootballLeagueFixturesDataModel.fromJson(_mapObject(json['data'])),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class FootballLeagueFixturesDataModel {
  final String date;
  final String timezone;
  final List<FootballLeagueFixturesItemModel> items;
  final FootballLeagueFixturesMetaModel meta;

  const FootballLeagueFixturesDataModel({
    required this.date,
    required this.timezone,
    required this.items,
    required this.meta,
  });

  factory FootballLeagueFixturesDataModel.fromJson(Map<String, dynamic> json) {
    return FootballLeagueFixturesDataModel(
      date: json['date'] as String? ?? '',
      timezone: json['timezone'] as String? ?? '',
      items: _mapList(json['items'])
          .map(FootballLeagueFixturesItemModel.fromJson)
          .toList(growable: false),
      meta: FootballLeagueFixturesMetaModel.fromJson(_mapObject(json['meta'])),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'date': date,
      'timezone': timezone,
      'items': items.map((item) => item.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }
}

class FootballLeagueFixturesMetaModel {
  final int page;
  final int limit;
  final int totalLeagues;
  final int totalPages;
  final int totalMatches;

  const FootballLeagueFixturesMetaModel({
    required this.page,
    required this.limit,
    required this.totalLeagues,
    required this.totalPages,
    required this.totalMatches,
  });

  factory FootballLeagueFixturesMetaModel.fromJson(Map<String, dynamic> json) {
    return FootballLeagueFixturesMetaModel(
      page: _toIntOrNull(json['page']) ?? 1,
      limit: _toIntOrNull(json['limit']) ?? 10,
      totalLeagues: _toIntOrNull(json['totalLeagues']) ?? 0,
      totalPages: _toIntOrNull(json['totalPages']) ?? 1,
      totalMatches: _toIntOrNull(json['totalMatches']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'page': page,
      'limit': limit,
      'totalLeagues': totalLeagues,
      'totalPages': totalPages,
      'totalMatches': totalMatches,
    };
  }
}

class FootballLeagueFixturesItemModel {
  final FootballLeagueModel league;
  final int matchCount;
  final List<FootballFixtureModel> fixtures;

  const FootballLeagueFixturesItemModel({
    required this.league,
    required this.matchCount,
    required this.fixtures,
  });

  factory FootballLeagueFixturesItemModel.fromJson(Map<String, dynamic> json) {
    final fixtures = _mapList(json['fixtures'])
        .map(FootballFixtureModel.fromJson)
        .toList(growable: false);

    return FootballLeagueFixturesItemModel(
      league: FootballLeagueModel.fromJson(_mapObject(json['league'])),
      matchCount: _toIntOrNull(json['matchCount']) ?? fixtures.length,
      fixtures: fixtures,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'league': league.toJson(),
      'matchCount': matchCount,
      'fixtures': fixtures.map((fixture) => fixture.toJson()).toList(),
    };
  }
}

class FootballPagingModel {
  final int current;
  final int total;

  const FootballPagingModel({required this.current, required this.total});

  factory FootballPagingModel.fromJson(Map<String, dynamic> json) {
    return FootballPagingModel(
      current: _toIntOrNull(json['current']) ?? 0,
      total: _toIntOrNull(json['total']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'current': current, 'total': total};
  }
}

class FootballFixtureModel {
  final FootballFixtureInfoModel fixture;
  final FootballLeagueModel league;
  final FootballTeamsModel teams;
  final FootballGoalsModel goals;
  final FootballScoreModel score;
  final List<FootballFixtureEventModel> events;
  final List<FootballLineupModel> lineups;
  final List<FootballTeamStatisticsModel> statistics;
  final List<FootballTeamPlayersModel> players;

  const FootballFixtureModel({
    required this.fixture,
    required this.league,
    required this.teams,
    required this.goals,
    required this.score,
    required this.events,
    this.lineups = const <FootballLineupModel>[],
    this.statistics = const <FootballTeamStatisticsModel>[],
    this.players = const <FootballTeamPlayersModel>[],
  });

  factory FootballFixtureModel.fromJson(Map<String, dynamic> json) {
    return FootballFixtureModel(
      fixture: FootballFixtureInfoModel.fromJson(_mapObject(json['fixture'])),
      league: FootballLeagueModel.fromJson(_mapObject(json['league'])),
      teams: FootballTeamsModel.fromJson(_mapObject(json['teams'])),
      goals: FootballGoalsModel.fromJson(_mapObject(json['goals'])),
      score: FootballScoreModel.fromJson(_mapObject(json['score'])),
      events: _mapList(json['events'])
          .map(FootballFixtureEventModel.fromJson)
          .toList(growable: false),
      lineups: _mapList(json['lineups'])
          .map(FootballLineupModel.fromJson)
          .toList(growable: false),
      statistics: _mapList(json['statistics'])
          .map(FootballTeamStatisticsModel.fromJson)
          .toList(growable: false),
      players: _mapList(json['players'])
          .map(FootballTeamPlayersModel.fromJson)
          .toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'fixture': fixture.toJson(),
      'league': league.toJson(),
      'teams': teams.toJson(),
      'goals': goals.toJson(),
      'score': score.toJson(),
      'events': events.map((event) => event.toJson()).toList(),
      'lineups': lineups.map((lineup) => lineup.toJson()).toList(),
      'statistics': statistics.map((statistic) => statistic.toJson()).toList(),
      'players': players.map((teamPlayers) => teamPlayers.toJson()).toList(),
    };
  }
}

class FootballFixtureInfoModel {
  final int? id;
  final String? referee;
  final String timezone;
  final String date;
  final int? timestamp;
  final FootballPeriodsModel periods;
  final FootballVenueModel venue;
  final FootballStatusModel status;

  const FootballFixtureInfoModel({
    required this.id,
    required this.referee,
    required this.timezone,
    required this.date,
    required this.timestamp,
    required this.periods,
    required this.venue,
    required this.status,
  });

  DateTime? get kickoffAt {
    return DateTime.tryParse(date)?.toLocal();
  }

  factory FootballFixtureInfoModel.fromJson(Map<String, dynamic> json) {
    return FootballFixtureInfoModel(
      id: _toIntOrNull(json['id']),
      referee: json['referee'] as String?,
      timezone: json['timezone'] as String? ?? '',
      date: json['date'] as String? ?? '',
      timestamp: _toIntOrNull(json['timestamp']),
      periods: FootballPeriodsModel.fromJson(_mapObject(json['periods'])),
      venue: FootballVenueModel.fromJson(_mapObject(json['venue'])),
      status: FootballStatusModel.fromJson(_mapObject(json['status'])),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'referee': referee,
      'timezone': timezone,
      'date': date,
      'timestamp': timestamp,
      'periods': periods.toJson(),
      'venue': venue.toJson(),
      'status': status.toJson(),
    };
  }
}

class FootballPeriodsModel {
  final int? first;
  final int? second;

  const FootballPeriodsModel({required this.first, required this.second});

  factory FootballPeriodsModel.fromJson(Map<String, dynamic> json) {
    return FootballPeriodsModel(
      first: _toIntOrNull(json['first']),
      second: _toIntOrNull(json['second']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'first': first, 'second': second};
  }
}

class FootballVenueModel {
  final int? id;
  final String? name;
  final String? city;

  const FootballVenueModel({
    required this.id,
    required this.name,
    required this.city,
  });

  factory FootballVenueModel.fromJson(Map<String, dynamic> json) {
    return FootballVenueModel(
      id: _toIntOrNull(json['id']),
      name: json['name'] as String?,
      city: json['city'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'name': name, 'city': city};
  }
}

class FootballStatusModel {
  final String long;
  final String short;
  final int? elapsed;
  final int? extra;

  const FootballStatusModel({
    required this.long,
    required this.short,
    required this.elapsed,
    required this.extra,
  });

  factory FootballStatusModel.fromJson(Map<String, dynamic> json) {
    return FootballStatusModel(
      long: json['long'] as String? ?? '',
      short: json['short'] as String? ?? '',
      elapsed: _toIntOrNull(json['elapsed']),
      extra: _toIntOrNull(json['extra']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'long': long,
      'short': short,
      'elapsed': elapsed,
      'extra': extra,
    };
  }
}

class FootballLeagueModel {
  final int? id;
  final String name;
  final String country;
  final String? logo;
  final String? flag;
  final int? season;
  final String round;
  final bool? standings;

  const FootballLeagueModel({
    required this.id,
    required this.name,
    required this.country,
    required this.logo,
    required this.flag,
    required this.season,
    required this.round,
    required this.standings,
  });

  factory FootballLeagueModel.fromJson(Map<String, dynamic> json) {
    return FootballLeagueModel(
      id: _toIntOrNull(json['id']),
      name: json['name'] as String? ?? '',
      country: json['country'] as String? ?? '',
      logo: json['logo'] as String?,
      flag: json['flag'] as String?,
      season: _toIntOrNull(json['season']),
      round: json['round'] as String? ?? '',
      standings: _toBoolOrNull(json['standings']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'country': country,
      'logo': logo,
      'flag': flag,
      'season': season,
      'round': round,
      'standings': standings,
    };
  }
}

class FootballTeamsModel {
  final FootballTeamModel home;
  final FootballTeamModel away;

  const FootballTeamsModel({required this.home, required this.away});

  factory FootballTeamsModel.fromJson(Map<String, dynamic> json) {
    return FootballTeamsModel(
      home: FootballTeamModel.fromJson(_mapObject(json['home'])),
      away: FootballTeamModel.fromJson(_mapObject(json['away'])),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'home': home.toJson(), 'away': away.toJson()};
  }
}

class FootballTeamModel {
  final int? id;
  final String name;
  final String? logo;
  final bool? winner;
  final FootballTeamColorsModel? colors;
  final String? update;

  const FootballTeamModel({
    required this.id,
    required this.name,
    required this.logo,
    required this.winner,
    this.colors,
    this.update,
  });

  factory FootballTeamModel.fromJson(Map<String, dynamic> json) {
    final colorsJson = _mapObject(json['colors']);

    return FootballTeamModel(
      id: _toIntOrNull(json['id']),
      name: json['name'] as String? ?? '',
      logo: json['logo'] as String?,
      winner: _toBoolOrNull(json['winner']),
      colors: colorsJson.isEmpty ? null : FootballTeamColorsModel.fromJson(colorsJson),
      update: json['update'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'logo': logo,
      'winner': winner,
      'colors': colors?.toJson(),
      'update': update,
    };
  }
}

class FootballTeamColorsModel {
  final FootballKitColorModel player;
  final FootballKitColorModel goalkeeper;

  const FootballTeamColorsModel({
    required this.player,
    required this.goalkeeper,
  });

  factory FootballTeamColorsModel.fromJson(Map<String, dynamic> json) {
    return FootballTeamColorsModel(
      player: FootballKitColorModel.fromJson(_mapObject(json['player'])),
      goalkeeper: FootballKitColorModel.fromJson(_mapObject(json['goalkeeper'])),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'player': player.toJson(),
      'goalkeeper': goalkeeper.toJson(),
    };
  }
}

class FootballKitColorModel {
  final String? primary;
  final String? number;
  final String? border;

  const FootballKitColorModel({
    required this.primary,
    required this.number,
    required this.border,
  });

  factory FootballKitColorModel.fromJson(Map<String, dynamic> json) {
    return FootballKitColorModel(
      primary: json['primary'] as String?,
      number: json['number'] as String?,
      border: json['border'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'primary': primary,
      'number': number,
      'border': border,
    };
  }
}

class FootballGoalsModel {
  final int? home;
  final int? away;

  const FootballGoalsModel({required this.home, required this.away});

  factory FootballGoalsModel.fromJson(Map<String, dynamic> json) {
    return FootballGoalsModel(
      home: _toIntOrNull(json['home']),
      away: _toIntOrNull(json['away']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'home': home, 'away': away};
  }
}

class FootballScoreModel {
  final FootballScoreTimeModel halftime;
  final FootballScoreTimeModel fulltime;
  final FootballScoreTimeModel extratime;
  final FootballScoreTimeModel penalty;

  const FootballScoreModel({
    required this.halftime,
    required this.fulltime,
    required this.extratime,
    required this.penalty,
  });

  factory FootballScoreModel.fromJson(Map<String, dynamic> json) {
    return FootballScoreModel(
      halftime: FootballScoreTimeModel.fromJson(_mapObject(json['halftime'])),
      fulltime: FootballScoreTimeModel.fromJson(_mapObject(json['fulltime'])),
      extratime: FootballScoreTimeModel.fromJson(_mapObject(json['extratime'])),
      penalty: FootballScoreTimeModel.fromJson(_mapObject(json['penalty'])),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'halftime': halftime.toJson(),
      'fulltime': fulltime.toJson(),
      'extratime': extratime.toJson(),
      'penalty': penalty.toJson(),
    };
  }
}

class FootballScoreTimeModel {
  final int? home;
  final int? away;

  const FootballScoreTimeModel({required this.home, required this.away});

  factory FootballScoreTimeModel.fromJson(Map<String, dynamic> json) {
    return FootballScoreTimeModel(
      home: _toIntOrNull(json['home']),
      away: _toIntOrNull(json['away']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'home': home, 'away': away};
  }
}

class FootballFixtureEventModel {
  final FootballEventTimeModel time;
  final FootballTeamModel team;
  final FootballPersonModel player;
  final FootballPersonModel assist;
  final String type;
  final String detail;
  final String? comments;

  const FootballFixtureEventModel({
    required this.time,
    required this.team,
    required this.player,
    required this.assist,
    required this.type,
    required this.detail,
    required this.comments,
  });

  factory FootballFixtureEventModel.fromJson(Map<String, dynamic> json) {
    return FootballFixtureEventModel(
      time: FootballEventTimeModel.fromJson(_mapObject(json['time'])),
      team: FootballTeamModel.fromJson(_mapObject(json['team'])),
      player: FootballPersonModel.fromJson(_mapObject(json['player'])),
      assist: FootballPersonModel.fromJson(_mapObject(json['assist'])),
      type: json['type'] as String? ?? '',
      detail: json['detail'] as String? ?? '',
      comments: json['comments'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'time': time.toJson(),
      'team': team.toJson(),
      'player': player.toJson(),
      'assist': assist.toJson(),
      'type': type,
      'detail': detail,
      'comments': comments,
    };
  }
}

class FootballEventTimeModel {
  final int? elapsed;
  final int? extra;

  const FootballEventTimeModel({required this.elapsed, required this.extra});

  factory FootballEventTimeModel.fromJson(Map<String, dynamic> json) {
    return FootballEventTimeModel(
      elapsed: _toIntOrNull(json['elapsed']),
      extra: _toIntOrNull(json['extra']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'elapsed': elapsed, 'extra': extra};
  }
}

class FootballPersonModel {
  final int? id;
  final String? name;

  const FootballPersonModel({required this.id, required this.name});

  factory FootballPersonModel.fromJson(Map<String, dynamic> json) {
    return FootballPersonModel(
      id: _toIntOrNull(json['id']),
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'name': name};
  }
}


class FootballLineupModel {
  final FootballTeamModel team;
  final String formation;
  final List<FootballLineupPlayerWrapperModel> startXI;
  final List<FootballLineupPlayerWrapperModel> substitutes;
  final FootballCoachModel coach;

  const FootballLineupModel({
    required this.team,
    required this.formation,
    required this.startXI,
    required this.substitutes,
    required this.coach,
  });

  factory FootballLineupModel.fromJson(Map<String, dynamic> json) {
    return FootballLineupModel(
      team: FootballTeamModel.fromJson(_mapObject(json['team'])),
      formation: json['formation'] as String? ?? '',
      startXI: _mapList(json['startXI'])
          .map(FootballLineupPlayerWrapperModel.fromJson)
          .toList(growable: false),
      substitutes: _mapList(json['substitutes'])
          .map(FootballLineupPlayerWrapperModel.fromJson)
          .toList(growable: false),
      coach: FootballCoachModel.fromJson(_mapObject(json['coach'])),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'team': team.toJson(),
      'formation': formation,
      'startXI': startXI.map((player) => player.toJson()).toList(),
      'substitutes': substitutes.map((player) => player.toJson()).toList(),
      'coach': coach.toJson(),
    };
  }
}

class FootballLineupPlayerWrapperModel {
  final FootballLineupPlayerModel player;

  const FootballLineupPlayerWrapperModel({required this.player});

  factory FootballLineupPlayerWrapperModel.fromJson(Map<String, dynamic> json) {
    return FootballLineupPlayerWrapperModel(
      player: FootballLineupPlayerModel.fromJson(_mapObject(json['player'])),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'player': player.toJson()};
  }
}

class FootballLineupPlayerModel {
  final int? id;
  final String name;
  final int? number;
  final String pos;
  final String? grid;

  const FootballLineupPlayerModel({
    required this.id,
    required this.name,
    required this.number,
    required this.pos,
    required this.grid,
  });

  factory FootballLineupPlayerModel.fromJson(Map<String, dynamic> json) {
    return FootballLineupPlayerModel(
      id: _toIntOrNull(json['id']),
      name: json['name'] as String? ?? '',
      number: _toIntOrNull(json['number']),
      pos: json['pos'] as String? ?? '',
      grid: json['grid'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'number': number,
      'pos': pos,
      'grid': grid,
    };
  }
}

class FootballCoachModel {
  final int? id;
  final String name;
  final String? photo;

  const FootballCoachModel({
    required this.id,
    required this.name,
    required this.photo,
  });

  factory FootballCoachModel.fromJson(Map<String, dynamic> json) {
    return FootballCoachModel(
      id: _toIntOrNull(json['id']),
      name: json['name'] as String? ?? '',
      photo: json['photo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'name': name, 'photo': photo};
  }
}

class FootballTeamStatisticsModel {
  final FootballTeamModel team;
  final List<FootballStatisticItemModel> statistics;

  const FootballTeamStatisticsModel({
    required this.team,
    required this.statistics,
  });

  factory FootballTeamStatisticsModel.fromJson(Map<String, dynamic> json) {
    return FootballTeamStatisticsModel(
      team: FootballTeamModel.fromJson(_mapObject(json['team'])),
      statistics: _mapList(json['statistics'])
          .map(FootballStatisticItemModel.fromJson)
          .toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'team': team.toJson(),
      'statistics': statistics.map((item) => item.toJson()).toList(),
    };
  }
}

class FootballStatisticItemModel {
  final String type;
  final Object? value;

  const FootballStatisticItemModel({required this.type, required this.value});

  factory FootballStatisticItemModel.fromJson(Map<String, dynamic> json) {
    return FootballStatisticItemModel(
      type: json['type'] as String? ?? '',
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'type': type, 'value': value};
  }
}

class FootballTeamPlayersModel {
  final FootballTeamModel team;
  final List<FootballPlayerMatchModel> players;

  const FootballTeamPlayersModel({required this.team, required this.players});

  factory FootballTeamPlayersModel.fromJson(Map<String, dynamic> json) {
    return FootballTeamPlayersModel(
      team: FootballTeamModel.fromJson(_mapObject(json['team'])),
      players: _mapList(json['players'])
          .map(FootballPlayerMatchModel.fromJson)
          .toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'team': team.toJson(),
      'players': players.map((player) => player.toJson()).toList(),
    };
  }
}

class FootballPlayerMatchModel {
  final FootballPlayerInfoModel player;
  final List<FootballPlayerStatisticModel> statistics;

  const FootballPlayerMatchModel({
    required this.player,
    required this.statistics,
  });

  factory FootballPlayerMatchModel.fromJson(Map<String, dynamic> json) {
    return FootballPlayerMatchModel(
      player: FootballPlayerInfoModel.fromJson(_mapObject(json['player'])),
      statistics: _mapList(json['statistics'])
          .map(FootballPlayerStatisticModel.fromJson)
          .toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'player': player.toJson(),
      'statistics': statistics.map((item) => item.toJson()).toList(),
    };
  }
}

class FootballPlayerInfoModel {
  final int? id;
  final String name;
  final String? photo;

  const FootballPlayerInfoModel({
    required this.id,
    required this.name,
    required this.photo,
  });

  factory FootballPlayerInfoModel.fromJson(Map<String, dynamic> json) {
    return FootballPlayerInfoModel(
      id: _toIntOrNull(json['id']),
      name: json['name'] as String? ?? '',
      photo: json['photo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'name': name, 'photo': photo};
  }
}

class FootballPlayerStatisticModel {
  final FootballPlayerGamesModel games;
  final int? offsides;
  final FootballPlayerShotsModel shots;
  final FootballPlayerGoalsModel goals;
  final FootballPlayerPassesModel passes;
  final FootballPlayerTacklesModel tackles;
  final FootballPlayerDuelsModel duels;
  final FootballPlayerDribblesModel dribbles;
  final FootballPlayerFoulsModel fouls;
  final FootballPlayerCardsModel cards;
  final FootballPlayerPenaltyModel penalty;

  const FootballPlayerStatisticModel({
    required this.games,
    required this.offsides,
    required this.shots,
    required this.goals,
    required this.passes,
    required this.tackles,
    required this.duels,
    required this.dribbles,
    required this.fouls,
    required this.cards,
    required this.penalty,
  });

  factory FootballPlayerStatisticModel.fromJson(Map<String, dynamic> json) {
    return FootballPlayerStatisticModel(
      games: FootballPlayerGamesModel.fromJson(_mapObject(json['games'])),
      offsides: _toIntOrNull(json['offsides']),
      shots: FootballPlayerShotsModel.fromJson(_mapObject(json['shots'])),
      goals: FootballPlayerGoalsModel.fromJson(_mapObject(json['goals'])),
      passes: FootballPlayerPassesModel.fromJson(_mapObject(json['passes'])),
      tackles: FootballPlayerTacklesModel.fromJson(_mapObject(json['tackles'])),
      duels: FootballPlayerDuelsModel.fromJson(_mapObject(json['duels'])),
      dribbles: FootballPlayerDribblesModel.fromJson(_mapObject(json['dribbles'])),
      fouls: FootballPlayerFoulsModel.fromJson(_mapObject(json['fouls'])),
      cards: FootballPlayerCardsModel.fromJson(_mapObject(json['cards'])),
      penalty: FootballPlayerPenaltyModel.fromJson(_mapObject(json['penalty'])),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'games': games.toJson(),
      'offsides': offsides,
      'shots': shots.toJson(),
      'goals': goals.toJson(),
      'passes': passes.toJson(),
      'tackles': tackles.toJson(),
      'duels': duels.toJson(),
      'dribbles': dribbles.toJson(),
      'fouls': fouls.toJson(),
      'cards': cards.toJson(),
      'penalty': penalty.toJson(),
    };
  }
}

class FootballPlayerGamesModel {
  final int? minutes;
  final int? number;
  final String? position;
  final String? rating;
  final bool? captain;
  final bool? substitute;

  const FootballPlayerGamesModel({
    required this.minutes,
    required this.number,
    required this.position,
    required this.rating,
    required this.captain,
    required this.substitute,
  });

  factory FootballPlayerGamesModel.fromJson(Map<String, dynamic> json) {
    return FootballPlayerGamesModel(
      minutes: _toIntOrNull(json['minutes']),
      number: _toIntOrNull(json['number']),
      position: json['position'] as String?,
      rating: json['rating']?.toString(),
      captain: _toBoolOrNull(json['captain']),
      substitute: _toBoolOrNull(json['substitute']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'minutes': minutes,
      'number': number,
      'position': position,
      'rating': rating,
      'captain': captain,
      'substitute': substitute,
    };
  }
}

class FootballPlayerShotsModel {
  final int? total;
  final int? on;

  const FootballPlayerShotsModel({required this.total, required this.on});

  factory FootballPlayerShotsModel.fromJson(Map<String, dynamic> json) {
    return FootballPlayerShotsModel(
      total: _toIntOrNull(json['total']),
      on: _toIntOrNull(json['on']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{'total': total, 'on': on};
}

class FootballPlayerGoalsModel {
  final int? total;
  final int? conceded;
  final int? assists;
  final int? saves;

  const FootballPlayerGoalsModel({
    required this.total,
    required this.conceded,
    required this.assists,
    required this.saves,
  });

  factory FootballPlayerGoalsModel.fromJson(Map<String, dynamic> json) {
    return FootballPlayerGoalsModel(
      total: _toIntOrNull(json['total']),
      conceded: _toIntOrNull(json['conceded']),
      assists: _toIntOrNull(json['assists']),
      saves: _toIntOrNull(json['saves']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'total': total,
      'conceded': conceded,
      'assists': assists,
      'saves': saves,
    };
  }
}

class FootballPlayerPassesModel {
  final int? total;
  final int? key;
  final String? accuracy;

  const FootballPlayerPassesModel({
    required this.total,
    required this.key,
    required this.accuracy,
  });

  factory FootballPlayerPassesModel.fromJson(Map<String, dynamic> json) {
    return FootballPlayerPassesModel(
      total: _toIntOrNull(json['total']),
      key: _toIntOrNull(json['key']),
      accuracy: json['accuracy']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'total': total, 'key': key, 'accuracy': accuracy};
  }
}

class FootballPlayerTacklesModel {
  final int? total;
  final int? blocks;
  final int? interceptions;

  const FootballPlayerTacklesModel({
    required this.total,
    required this.blocks,
    required this.interceptions,
  });

  factory FootballPlayerTacklesModel.fromJson(Map<String, dynamic> json) {
    return FootballPlayerTacklesModel(
      total: _toIntOrNull(json['total']),
      blocks: _toIntOrNull(json['blocks']),
      interceptions: _toIntOrNull(json['interceptions']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'total': total,
      'blocks': blocks,
      'interceptions': interceptions,
    };
  }
}

class FootballPlayerDuelsModel {
  final int? total;
  final int? won;

  const FootballPlayerDuelsModel({required this.total, required this.won});

  factory FootballPlayerDuelsModel.fromJson(Map<String, dynamic> json) {
    return FootballPlayerDuelsModel(
      total: _toIntOrNull(json['total']),
      won: _toIntOrNull(json['won']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{'total': total, 'won': won};
}

class FootballPlayerDribblesModel {
  final int? attempts;
  final int? success;
  final int? past;

  const FootballPlayerDribblesModel({
    required this.attempts,
    required this.success,
    required this.past,
  });

  factory FootballPlayerDribblesModel.fromJson(Map<String, dynamic> json) {
    return FootballPlayerDribblesModel(
      attempts: _toIntOrNull(json['attempts']),
      success: _toIntOrNull(json['success']),
      past: _toIntOrNull(json['past']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'attempts': attempts,
      'success': success,
      'past': past,
    };
  }
}

class FootballPlayerFoulsModel {
  final int? drawn;
  final int? committed;

  const FootballPlayerFoulsModel({
    required this.drawn,
    required this.committed,
  });

  factory FootballPlayerFoulsModel.fromJson(Map<String, dynamic> json) {
    return FootballPlayerFoulsModel(
      drawn: _toIntOrNull(json['drawn']),
      committed: _toIntOrNull(json['committed']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'drawn': drawn, 'committed': committed};
  }
}

class FootballPlayerCardsModel {
  final int? yellow;
  final int? red;

  const FootballPlayerCardsModel({required this.yellow, required this.red});

  factory FootballPlayerCardsModel.fromJson(Map<String, dynamic> json) {
    return FootballPlayerCardsModel(
      yellow: _toIntOrNull(json['yellow']),
      red: _toIntOrNull(json['red']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{'yellow': yellow, 'red': red};
}

class FootballPlayerPenaltyModel {
  final int? won;
  final int? commited;
  final int? scored;
  final int? missed;
  final int? saved;

  const FootballPlayerPenaltyModel({
    required this.won,
    required this.commited,
    required this.scored,
    required this.missed,
    required this.saved,
  });

  factory FootballPlayerPenaltyModel.fromJson(Map<String, dynamic> json) {
    return FootballPlayerPenaltyModel(
      won: _toIntOrNull(json['won']),
      commited: _toIntOrNull(json['commited']),
      scored: _toIntOrNull(json['scored']),
      missed: _toIntOrNull(json['missed']),
      saved: _toIntOrNull(json['saved']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'won': won,
      'commited': commited,
      'scored': scored,
      'missed': missed,
      'saved': saved,
    };
  }
}

class MatchesTeamUiModel {
  final String teamId;
  final String teamName;
  final String shortName;
  final String badgeHex;
  final String? logoUrl;

  const MatchesTeamUiModel({
    required this.teamId,
    required this.teamName,
    required this.shortName,
    required this.badgeHex,
    this.logoUrl,
  });

  factory MatchesTeamUiModel.fromJson(Map<String, dynamic> json) {
    return MatchesTeamUiModel(
      teamId: json['team_id'] as String? ?? '',
      teamName: json['team_name'] as String? ?? '',
      shortName: json['short_name'] as String? ?? '',
      badgeHex: json['badge_hex'] as String? ?? '#324844',
      logoUrl: json['logo_url'] as String?,
    );
  }

  factory MatchesTeamUiModel.fromFootballTeam(FootballTeamModel team) {
    return MatchesTeamUiModel(
      teamId: '${team.id ?? ''}',
      teamName: team.name,
      shortName: _teamShortName(team.name),
      badgeHex: _teamBadgeHex(team.id),
      logoUrl: team.logo,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'team_id': teamId,
      'team_name': teamName,
      'short_name': shortName,
      'badge_hex': badgeHex,
      'logo_url': logoUrl,
    };
  }
}

class MatchesFixtureUiModel {
  final String fixtureId;
  final MatchesTeamUiModel homeTeam;
  final MatchesTeamUiModel awayTeam;
  final int? homeScore;
  final int? awayScore;
  final String statusCode;
  final String statusLabel;
  final String statusDetail;
  final int kickoffOrder;
  final bool visibleInOngoing;
  final DateTime? kickoffAt;
  final String rawStatusLong;
  final String rawStatusShort;

  const MatchesFixtureUiModel({
    required this.fixtureId,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.statusCode,
    required this.statusLabel,
    required this.statusDetail,
    required this.kickoffOrder,
    required this.visibleInOngoing,
    this.kickoffAt,
    this.rawStatusLong = '',
    this.rawStatusShort = '',
  });

  bool get isLive => statusCode == MatchesFixtureStatusCodes.live;

  factory MatchesFixtureUiModel.fromJson(Map<String, dynamic> json) {
    return MatchesFixtureUiModel(
      fixtureId: json['fixture_id'] as String? ?? '',
      homeTeam: MatchesTeamUiModel.fromJson(_mapObject(json['home_team'])),
      awayTeam: MatchesTeamUiModel.fromJson(_mapObject(json['away_team'])),
      homeScore: _toIntOrNull(json['home_score']),
      awayScore: _toIntOrNull(json['away_score']),
      statusCode: json['status_code'] as String? ?? '',
      statusLabel: json['status_label'] as String? ?? '',
      statusDetail: json['status_detail'] as String? ?? '',
      kickoffOrder: _toIntOrNull(json['kickoff_order']) ?? 0,
      visibleInOngoing: json['visible_in_ongoing'] as bool? ?? false,
      kickoffAt: DateTime.tryParse(json['kickoff_at'] as String? ?? ''),
      rawStatusLong: json['raw_status_long'] as String? ?? '',
      rawStatusShort: json['raw_status_short'] as String? ?? '',
    );
  }

  factory MatchesFixtureUiModel.fromFootballFixture(
    FootballFixtureModel match,
  ) {
    final statusCode = _matchStatusCode(match.fixture.status);
    final kickoffAt = match.fixture.kickoffAt;
    final isLive = statusCode == MatchesFixtureStatusCodes.live;
    final isUpcoming = statusCode == MatchesFixtureStatusCodes.upcoming;

    return MatchesFixtureUiModel(
      fixtureId: '${match.fixture.id ?? ''}',
      homeTeam: MatchesTeamUiModel.fromFootballTeam(match.teams.home),
      awayTeam: MatchesTeamUiModel.fromFootballTeam(match.teams.away),
      homeScore: match.goals.home,
      awayScore: match.goals.away,
      statusCode: statusCode,
      statusLabel: isLive
          ? 'LIVE'
          : isUpcoming
          ? _timeLabel24(kickoffAt)
          : _safeStatusLabel(match.fixture.status),
      statusDetail: isLive ? _elapsedLabel(match.fixture.status) : '',
      kickoffOrder: _kickoffOrder(kickoffAt),
      visibleInOngoing: isLive,
      kickoffAt: kickoffAt,
      rawStatusLong: match.fixture.status.long,
      rawStatusShort: match.fixture.status.short,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'fixture_id': fixtureId,
      'home_team': homeTeam.toJson(),
      'away_team': awayTeam.toJson(),
      'home_score': homeScore,
      'away_score': awayScore,
      'status_code': statusCode,
      'status_label': statusLabel,
      'status_detail': statusDetail,
      'kickoff_order': kickoffOrder,
      'visible_in_ongoing': visibleInOngoing,
      'kickoff_at': kickoffAt?.toIso8601String(),
      'raw_status_long': rawStatusLong,
      'raw_status_short': rawStatusShort,
    };
  }
}

class MatchesLeagueUiModel {
  final String leagueId;
  final String leagueName;
  final String stageName;
  final String badgeSeed;
  final int fixtureCount;
  final List<MatchesFixtureUiModel> fixtures;
  final String? logoUrl;
  final String? flagUrl;
  final String country;

  const MatchesLeagueUiModel({
    required this.leagueId,
    required this.leagueName,
    required this.stageName,
    required this.badgeSeed,
    required this.fixtureCount,
    required this.fixtures,
    this.logoUrl,
    this.flagUrl,
    this.country = '',
  });

  factory MatchesLeagueUiModel.fromJson(Map<String, dynamic> json) {
    final fixtures = _mapList(json['fixtures'])
        .map(MatchesFixtureUiModel.fromJson)
        .toList(growable: false);

    return MatchesLeagueUiModel(
      leagueId: json['league_id'] as String? ?? '',
      leagueName: json['league_name'] as String? ?? '',
      stageName: json['stage_name'] as String? ?? '',
      badgeSeed: json['badge_seed'] as String? ?? '',
      fixtureCount: _toIntOrNull(json['fixture_count']) ?? fixtures.length,
      fixtures: fixtures,
      logoUrl: json['logo_url'] as String?,
      flagUrl: json['flag_url'] as String?,
      country: json['country'] as String? ?? '',
    );
  }

  factory MatchesLeagueUiModel.fromFootballLeague({
    required FootballLeagueModel league,
    required List<MatchesFixtureUiModel> fixtures,
    int? fixtureCount,
  }) {
    return MatchesLeagueUiModel(
      leagueId: '${league.id ?? ''}-${league.season ?? ''}-${league.round}',
      leagueName: league.name,
      stageName: league.round.isNotEmpty ? league.round : league.country,
      badgeSeed: _leagueSeed(league.name),
      fixtureCount: fixtureCount ?? fixtures.length,
      fixtures: fixtures,
      logoUrl: league.logo,
      flagUrl: league.flag,
      country: league.country,
    );
  }

  MatchesLeagueUiModel copyWith({
    String? leagueId,
    String? leagueName,
    String? stageName,
    String? badgeSeed,
    int? fixtureCount,
    List<MatchesFixtureUiModel>? fixtures,
    String? logoUrl,
    String? flagUrl,
    String? country,
  }) {
    return MatchesLeagueUiModel(
      leagueId: leagueId ?? this.leagueId,
      leagueName: leagueName ?? this.leagueName,
      stageName: stageName ?? this.stageName,
      badgeSeed: badgeSeed ?? this.badgeSeed,
      fixtureCount: fixtureCount ?? this.fixtureCount,
      fixtures: fixtures ?? this.fixtures,
      logoUrl: logoUrl ?? this.logoUrl,
      flagUrl: flagUrl ?? this.flagUrl,
      country: country ?? this.country,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'league_id': leagueId,
      'league_name': leagueName,
      'stage_name': stageName,
      'badge_seed': badgeSeed,
      'fixture_count': fixtureCount,
      'fixtures': fixtures.map((fixture) => fixture.toJson()).toList(),
      'logo_url': logoUrl,
      'flag_url': flagUrl,
      'country': country,
    };
  }
}

class MatchesDayUiModel {
  final String dayId;
  final String dayLabelCode;
  final String displayDate;
  final List<MatchesLeagueUiModel> leagues;

  const MatchesDayUiModel({
    required this.dayId,
    required this.dayLabelCode,
    required this.displayDate,
    required this.leagues,
  });

  factory MatchesDayUiModel.fromJson(Map<String, dynamic> json) {
    return MatchesDayUiModel(
      dayId: json['day_id'] as String? ?? '',
      dayLabelCode: json['day_label_code'] as String? ?? '',
      displayDate: json['display_date'] as String? ?? '',
      leagues: _mapList(json['leagues'])
          .map(MatchesLeagueUiModel.fromJson)
          .toList(growable: false),
    );
  }

  MatchesDayUiModel copyWith({
    String? dayId,
    String? dayLabelCode,
    String? displayDate,
    List<MatchesLeagueUiModel>? leagues,
  }) {
    return MatchesDayUiModel(
      dayId: dayId ?? this.dayId,
      dayLabelCode: dayLabelCode ?? this.dayLabelCode,
      displayDate: displayDate ?? this.displayDate,
      leagues: leagues ?? this.leagues,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'day_id': dayId,
      'day_label_code': dayLabelCode,
      'display_date': displayDate,
      'leagues': leagues.map((league) => league.toJson()).toList(),
    };
  }
}

class MatchesSportScheduleUiModel {
  final String sportCode;
  final List<MatchesDayUiModel> days;
  final int leaguePage;
  final int leagueLimit;
  final int totalLeaguePages;
  final int totalLeagues;
  final int totalMatches;

  const MatchesSportScheduleUiModel({
    required this.sportCode,
    required this.days,
    this.leaguePage = 1,
    this.leagueLimit = 10,
    this.totalLeaguePages = 1,
    this.totalLeagues = 0,
    this.totalMatches = 0,
  });

  bool get hasMoreLeaguePages {
    return leaguePage < totalLeaguePages;
  }

  factory MatchesSportScheduleUiModel.fromJson(Map<String, dynamic> json) {
    return MatchesSportScheduleUiModel(
      sportCode: json['sport_code'] as String? ?? MatchesSportCodes.football,
      days: _mapList(json['days'])
          .map(MatchesDayUiModel.fromJson)
          .toList(growable: false),
      leaguePage: _toIntOrNull(json['league_page']) ?? 1,
      leagueLimit: _toIntOrNull(json['league_limit']) ?? 10,
      totalLeaguePages: _toIntOrNull(json['total_league_pages']) ?? 1,
      totalLeagues: _toIntOrNull(json['total_leagues']) ?? 0,
      totalMatches: _toIntOrNull(json['total_matches']) ?? 0,
    );
  }

  MatchesSportScheduleUiModel copyWith({
    String? sportCode,
    List<MatchesDayUiModel>? days,
    int? leaguePage,
    int? leagueLimit,
    int? totalLeaguePages,
    int? totalLeagues,
    int? totalMatches,
  }) {
    return MatchesSportScheduleUiModel(
      sportCode: sportCode ?? this.sportCode,
      days: days ?? this.days,
      leaguePage: leaguePage ?? this.leaguePage,
      leagueLimit: leagueLimit ?? this.leagueLimit,
      totalLeaguePages: totalLeaguePages ?? this.totalLeaguePages,
      totalLeagues: totalLeagues ?? this.totalLeagues,
      totalMatches: totalMatches ?? this.totalMatches,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'sport_code': sportCode,
      'days': days.map((day) => day.toJson()).toList(),
      'league_page': leaguePage,
      'league_limit': leagueLimit,
      'total_league_pages': totalLeaguePages,
      'total_leagues': totalLeagues,
      'total_matches': totalMatches,
    };
  }
}

class MatchesLiveMatchUiModel {
  final String matchId;
  final MatchesTeamUiModel homeTeam;
  final MatchesTeamUiModel awayTeam;
  final int? homeScore;
  final int? awayScore;
  final String minuteLabel;
  final String statusLabel;
  final bool isUpcoming;
  final String dateLabel;
  final String startTimeLabel;
  final String leagueLabel;

  const MatchesLiveMatchUiModel({
    required this.matchId,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.minuteLabel,
    required this.statusLabel,
    this.isUpcoming = false,
    this.dateLabel = '',
    this.startTimeLabel = '',
    this.leagueLabel = '',
  });

  factory MatchesLiveMatchUiModel.fromFootballFixture(
    FootballFixtureModel match, {
    required bool isUpcoming,
  }) {
    final kickoffAt = match.fixture.kickoffAt;

    return MatchesLiveMatchUiModel(
      matchId: '${match.fixture.id ?? ''}',
      homeTeam: MatchesTeamUiModel.fromFootballTeam(match.teams.home),
      awayTeam: MatchesTeamUiModel.fromFootballTeam(match.teams.away),
      homeScore: match.goals.home,
      awayScore: match.goals.away,
      minuteLabel: isUpcoming
          ? _compactDateLabel(kickoffAt)
          : _elapsedLabel(match.fixture.status),
      statusLabel: isUpcoming ? 'UPCOMING' : 'LIVE',
      isUpcoming: isUpcoming,
      dateLabel: _compactDateLabel(kickoffAt),
      startTimeLabel: _timeLabel12(kickoffAt),
      leagueLabel: match.league.name,
    );
  }
}

class MatchesViewModel {
  static const Object _unset = Object();

  final List<MatchesLiveMatchUiModel>? liveMatches;
  final bool isLiveMatchesExpanded;
  final bool isFilterExpanded;
  final bool isLoading;
  final String selectedSportCode;
  final MatchesTimelineFilter timelineFilter;
  final int selectedDayIndex;
  final MatchesSportScheduleUiModel? schedule;
  final Set<String> expandedLeagueIds;
  final String? errorCode;
  final bool isShowingUpcomingFallback;
  final bool isLeagueListLoading;
  final bool isLoadingMoreLeagues;

  const MatchesViewModel({
    this.isLoading = false,
    this.isLiveMatchesExpanded = false,
    this.isFilterExpanded = false,
    this.selectedSportCode = MatchesSportCodes.football,
    this.timelineFilter = MatchesTimelineFilter.ongoing,
    this.selectedDayIndex = 0,
    this.schedule,
    this.expandedLeagueIds = const <String>{},
    this.errorCode,
    this.liveMatches,
    this.isShowingUpcomingFallback = false,
    this.isLeagueListLoading = false,
    this.isLoadingMoreLeagues = false,
  });

  bool get isFootballSelected {
    return selectedSportCode == MatchesSportCodes.football;
  }

  String get liveSectionTitle {
    return isShowingUpcomingFallback ? 'Upcoming' : 'Live Now';
  }

  bool get canLoadMoreLeagues {
    final currentSchedule = schedule;
    return currentSchedule != null &&
        currentSchedule.hasMoreLeaguePages &&
        !isLeagueListLoading &&
        !isLoadingMoreLeagues &&
        !isLoading;
  }

  MatchesDayUiModel? get selectedDay {
    final currentSchedule = schedule;

    if (currentSchedule == null || currentSchedule.days.isEmpty) {
      return null;
    }

    if (selectedDayIndex < 0 || selectedDayIndex >= currentSchedule.days.length) {
      return null;
    }

    return currentSchedule.days[selectedDayIndex];
  }

  bool get shouldShowOngoingTimelineFilter {
    final day = selectedDay;
    if (day == null) return false;

    if (day.dayLabelCode == MatchesDayLabelCodes.today) {
      return true;
    }

    final dayDate = _dayDate(day.dayId);
    if (dayDate == null) return false;

    return dayDate == _todayDate;
  }

  int? get previousDayIndex {
    final currentSchedule = schedule;
    if (currentSchedule == null || currentSchedule.days.isEmpty) {
      return null;
    }

    final previousIndex = selectedDayIndex - 1;
    if (previousIndex < 0) return null;

    return previousIndex;
  }

  int? get nextDayIndex {
    final currentSchedule = schedule;
    if (currentSchedule == null || currentSchedule.days.isEmpty) {
      return null;
    }

    final nextIndex = selectedDayIndex + 1;
    if (nextIndex >= currentSchedule.days.length) return null;

    return nextIndex;
  }

  bool get canGoPreviousDay {
    return schedule != null && selectedDay != null;
  }

  bool get canGoNextDay {
    return schedule != null && selectedDay != null;
  }

  MatchesDayUiModel? get nextDay {
    final currentSchedule = schedule;
    final selected = selectedDay;

    if (currentSchedule == null || selected == null) {
      return null;
    }

    final selectedDate = _dayDate(selected.dayId);
    if (selectedDate == null) return null;

    final targetDate = selectedDate.add(const Duration(days: 1));

    for (final day in currentSchedule.days) {
      final dayDate = _dayDate(day.dayId);
      if (dayDate != null && dayDate == targetDate) {
        return day;
      }
    }

    return null;
  }

  DateTime get _todayDate {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime? _dayDate(String value) {
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return null;

    return DateTime(parsed.year, parsed.month, parsed.day);
  }

  MatchesViewModel copyWith({
    bool? isLoading,
    String? selectedSportCode,
    MatchesTimelineFilter? timelineFilter,
    int? selectedDayIndex,
    Object? schedule = _unset,
    Object? expandedLeagueIds = _unset,
    Object? errorCode = _unset,
    List<MatchesLiveMatchUiModel>? liveMatches,
    bool? isLiveMatchesExpanded,
    bool? isFilterExpanded,
    bool? isShowingUpcomingFallback,
    bool? isLeagueListLoading,
    bool? isLoadingMoreLeagues,
  }) {
    return MatchesViewModel(
      isLoading: isLoading ?? this.isLoading,
      selectedSportCode: selectedSportCode ?? this.selectedSportCode,
      timelineFilter: timelineFilter ?? this.timelineFilter,
      selectedDayIndex: selectedDayIndex ?? this.selectedDayIndex,
      schedule: identical(schedule, _unset)
          ? this.schedule
          : schedule as MatchesSportScheduleUiModel?,
      expandedLeagueIds: identical(expandedLeagueIds, _unset)
          ? this.expandedLeagueIds
          : expandedLeagueIds as Set<String>,
      errorCode: identical(errorCode, _unset) ? this.errorCode : errorCode as String?,
      liveMatches: liveMatches ?? this.liveMatches,
      isLiveMatchesExpanded: isLiveMatchesExpanded ?? this.isLiveMatchesExpanded,
      isFilterExpanded: isFilterExpanded ?? this.isFilterExpanded,
      isShowingUpcomingFallback:
          isShowingUpcomingFallback ?? this.isShowingUpcomingFallback,
      isLeagueListLoading: isLeagueListLoading ?? this.isLeagueListLoading,
      isLoadingMoreLeagues:
          isLoadingMoreLeagues ?? this.isLoadingMoreLeagues,
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
      .toList();
}

int? _toIntOrNull(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);

  return null;
}

bool? _toBoolOrNull(Object? value) {
  if (value is bool) return value;
  if (value is String) return value.toLowerCase() == 'true';
  return null;
}

String _matchStatusCode(FootballStatusModel status) {
  final short = status.short.toUpperCase();

  if (short == 'NS' || short == 'TBD') {
    return MatchesFixtureStatusCodes.upcoming;
  }

  const finishedStatuses = <String>{
    'FT',
    'AET',
    'PEN',
    'CANC',
    'PST',
    'AWD',
    'WO',
  };

  if (finishedStatuses.contains(short)) {
    return MatchesFixtureStatusCodes.finished;
  }

  if (status.elapsed != null) {
    return MatchesFixtureStatusCodes.live;
  }

  const liveStatuses = <String>{'1H', 'HT', '2H', 'ET', 'BT', 'P', 'SUSP', 'INT'};
  if (liveStatuses.contains(short)) {
    return MatchesFixtureStatusCodes.live;
  }

  return MatchesFixtureStatusCodes.finished;
}

String _safeStatusLabel(FootballStatusModel status) {
  if (status.short.isNotEmpty) return status.short;
  if (status.long.isNotEmpty) return status.long;
  return '-';
}

String _elapsedLabel(FootballStatusModel status) {
  final elapsed = status.elapsed;
  final extra = status.extra;
  if (elapsed == null) return status.short.isNotEmpty ? status.short : 'Live';
  if (extra != null && extra > 0) return "$elapsed+$extra'";
  return "$elapsed'";
}

int _kickoffOrder(DateTime? value) {
  if (value == null) return 0;
  return (value.hour * 100) + value.minute;
}

String _timeLabel24(DateTime? value) {
  if (value == null) return '-';
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

String _timeLabel12(DateTime? value) {
  if (value == null) return '-';
  final period = value.hour >= 12 ? 'PM' : 'AM';
  final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
  final minute = value.minute.toString().padLeft(2, '0');
  return '$hour:$minute $period';
}

String _compactDateLabel(DateTime? value) {
  if (value == null) return '';
  final normalized = DateTime(value.year, value.month, value.day);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final difference = normalized.difference(today).inDays;

  if (difference == 0) return 'Today';
  if (difference == 1) return 'Tomorrow';

  return '${value.day} ${_monthName(value.month)}';
}

String _monthName(int month) {
  const months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  if (month < 1 || month > 12) return '';
  return months[month - 1];
}

String _teamShortName(String name) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) return '';

  final words = trimmed
      .split(RegExp(r'\s+'))
      .where((word) => word.trim().isNotEmpty)
      .toList();

  if (words.length >= 2) {
    final letters = words.take(3).map((word) => word[0].toUpperCase()).join();
    return letters.length > 3 ? letters.substring(0, 3) : letters;
  }

  return trimmed.length <= 3
      ? trimmed.toUpperCase()
      : trimmed.substring(0, 3).toUpperCase();
}

String _leagueSeed(String name) {
  final seed = _teamShortName(name);
  return seed.isEmpty ? 'LG' : seed;
}

String _teamBadgeHex(int? id) {
  const palette = <String>[
    '#2A4FB4',
    '#0D8662',
    '#A23C4A',
    '#B89A4C',
    '#2E5A96',
    '#8C3D2D',
    '#294D93',
  ];

  final safeId = id ?? 0;
  return palette[safeId.abs() % palette.length];
}
