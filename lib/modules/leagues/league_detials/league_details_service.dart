import 'package:flutter/material.dart';

import '../../../core/services/api_client.dart';
import '../model/leagues_models.dart';
import 'models/league_detials_model.dart';

class LeagueDetailsService {
  final ApiClient _apiClient;

  LeagueDetailsService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<LeagueDetailsRemoteDataModel> fetchLeagueDetails({
    required LeaguesTopLeagueUiModel league,
    required String season,
  }) async {
    final leagueId = int.tryParse(league.leagueId) ?? 39;
    final seasonYear = _seasonYearFromLabel(season) ??
        league.season ??
        DateTime.now().year;

    final results = await Future.wait<dynamic>([
      fetchSeasons(),
      fetchStandings(leagueId: leagueId, season: seasonYear),
      fetchTopScorers(leagueId: leagueId, season: seasonYear),
      fetchTopAssists(leagueId: leagueId, season: seasonYear),
      fetchLeagueFixturesByDate(leagueId: leagueId, date: _todayDate()),
    ]);

    final seasons = results[0] as List<String>;
    final standings = results[1] as List<LeagueDetailsStandingsRowUiModel>;
    final topScorers = results[2] as List<LeagueDetailsPlayerStatRowUiModel>;
    final topAssists = results[3] as List<LeagueDetailsPlayerStatRowUiModel>;
    final fixtures = results[4] as LeagueDetailsFixturesViewModel;

    return LeagueDetailsRemoteDataModel(
      seasons: seasons,
      standingsRows: standings,
      fixtures: fixtures,
      topScorers: topScorers,
      topAssists: topAssists,
    );
  }

  Future<List<String>> fetchSeasons() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/leagues/seasons',
    );
    final responseData = response.data;
    if (responseData == null) {
      throw Exception('empty_response');
    }
    _ensureSuccess(responseData, 'Unable to load seasons.');

    final responseList = _listAt(responseData, const <String>['data', 'response']);
    return responseList
        .map((item) => item.toString())
        .where((item) => item.isNotEmpty)
        .toList(growable: false)
      ..sort((left, right) => right.compareTo(left));
  }

  Future<List<LeagueDetailsStandingsRowUiModel>> fetchStandings({
    required int leagueId,
    required int season,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/standings',
      queryParameters: <String, dynamic>{'league': leagueId, 'season': season},
    );
    final responseData = response.data;
    if (responseData == null) {
      throw Exception('empty_response');
    }
    _ensureSuccess(responseData, 'Unable to load standings.');

    final rows = <LeagueDetailsStandingsRowUiModel>[];
    final leagueResponse = _listAt(responseData, const <String>['data', 'response']);
    for (final leagueItem in leagueResponse.whereType<Map<String, dynamic>>()) {
      final league = leagueItem['league'];
      if (league is! Map<String, dynamic>) {
        continue;
      }
      final standingsGroups = league['standings'];
      if (standingsGroups is! List) {
        continue;
      }
      for (final group in standingsGroups) {
        if (group is! List) {
          continue;
        }
        for (final standing in group.whereType<Map<String, dynamic>>()) {
          final team = standing['team'] is Map<String, dynamic>
              ? standing['team'] as Map<String, dynamic>
              : const <String, dynamic>{};
          final all = standing['all'] is Map<String, dynamic>
              ? standing['all'] as Map<String, dynamic>
              : const <String, dynamic>{};
          final goals = all['goals'] is Map<String, dynamic>
              ? all['goals'] as Map<String, dynamic>
              : const <String, dynamic>{};
          final goalsFor = _asInt(goals['for']);
          final goalsAgainst = _asInt(goals['against']);
          final diff = _asInt(standing['goalsDiff']);
          rows.add(
            LeagueDetailsStandingsRowUiModel(
              rank: '${_asInt(standing['rank']) ?? rows.length + 1}',
              teamName: '${team['name'] ?? ''}',
              badgeSeed: _seedFromName('${team['name'] ?? ''}'),
              badgeColor: _colorFromValue(_asInt(team['id']) ?? rows.length),
              teamLogoUrl: '${team['logo'] ?? ''}',
              played: '${_asInt(all['played']) ?? '-'}',
              plusMinus: goalsFor == null || goalsAgainst == null
                  ? '-'
                  : '$goalsFor-$goalsAgainst',
              goalDifference: diff == null ? '-' : (diff > 0 ? '+$diff' : '$diff'),
              points: '${_asInt(standing['points']) ?? '-'}',
            ),
          );
        }
      }
    }

    return rows;
  }

  Future<List<LeagueDetailsPlayerStatRowUiModel>> fetchTopScorers({
    required int leagueId,
    required int season,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/players/top-scorers',
      queryParameters: <String, dynamic>{'league': leagueId, 'season': season},
    );
    final responseData = response.data;
    if (responseData == null) {
      throw Exception('empty_response');
    }
    _ensureSuccess(responseData, 'Unable to load top scorers.');
    return _parsePlayerStats(responseData, valueType: _PlayerStatValueType.goals);
  }

  Future<List<LeagueDetailsPlayerStatRowUiModel>> fetchTopAssists({
    required int leagueId,
    required int season,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/players/top-assists',
      queryParameters: <String, dynamic>{'league': leagueId, 'season': season},
    );
    final responseData = response.data;
    if (responseData == null) {
      throw Exception('empty_response');
    }
    _ensureSuccess(responseData, 'Unable to load top assists.');
    return _parsePlayerStats(responseData, valueType: _PlayerStatValueType.assists);
  }

  Future<LeagueDetailsFixturesViewModel> fetchLeagueFixturesByDate({
    required int leagueId,
    required String date,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/league',
      queryParameters: <String, dynamic>{
        'date': date,
        'page': 1,
        'timezone': 'Asia/Dhaka',
        'limit': 10,
      },
    );
    final responseData = response.data;
    if (responseData == null) {
      throw Exception('empty_response');
    }
    _ensureSuccess(responseData, 'Unable to load fixtures.');

    final items = _listAt(responseData, const <String>['data', 'items']);
    final sections = <LeagueDetailsFixtureSectionUiModel>[];

    for (final item in items.whereType<Map<String, dynamic>>()) {
      final league = item['league'] is Map<String, dynamic>
          ? item['league'] as Map<String, dynamic>
          : const <String, dynamic>{};
      if (_asInt(league['id']) != leagueId) {
        continue;
      }
      final fixturesJson = item['fixtures'];
      if (fixturesJson is! List) {
        continue;
      }
      final fixtures = fixturesJson
          .whereType<Map<String, dynamic>>()
          .map(_parseFixture)
          .toList(growable: false);
      if (fixtures.isNotEmpty) {
        sections.add(
          LeagueDetailsFixtureSectionUiModel(
            title: _fixtureSectionTitle(date),
            fixtures: fixtures,
          ),
        );
      }
    }

    return LeagueDetailsFixturesViewModel(
      mode: LeagueDetailsFixturesMode.byDate,
      selectedDateIndex: 0,
      selectedRoundLabel: sections.isEmpty ? '' : sections.first.title,
      selectedTeamLabel: '',
      teamRangeLabel: '',
      byDateSections: sections,
      byRoundSections: sections,
      byTeamSections: const <LeagueDetailsFixtureSectionUiModel>[],
    );
  }

  List<LeagueDetailsPlayerStatRowUiModel> _parsePlayerStats(
    Map<String, dynamic> json, {
    required _PlayerStatValueType valueType,
  }) {
    final response = _listAt(json, const <String>['data', 'response']);
    final rows = <LeagueDetailsPlayerStatRowUiModel>[];

    for (final item in response.whereType<Map<String, dynamic>>()) {
      final player = item['player'] is Map<String, dynamic>
          ? item['player'] as Map<String, dynamic>
          : const <String, dynamic>{};
      final statsList = item['statistics'];
      final stats = statsList is List && statsList.isNotEmpty && statsList.first is Map<String, dynamic>
          ? statsList.first as Map<String, dynamic>
          : const <String, dynamic>{};
      final team = stats['team'] is Map<String, dynamic>
          ? stats['team'] as Map<String, dynamic>
          : const <String, dynamic>{};
      final goals = stats['goals'] is Map<String, dynamic>
          ? stats['goals'] as Map<String, dynamic>
          : const <String, dynamic>{};
      final games = stats['games'] is Map<String, dynamic>
          ? stats['games'] as Map<String, dynamic>
          : const <String, dynamic>{};

      final primaryValue = valueType == _PlayerStatValueType.goals
          ? _asInt(goals['total'])
          : _asInt(goals['assists']);
      final secondaryValue = valueType == _PlayerStatValueType.goals
          ? _asInt(goals['assists'])
          : _asInt(goals['total']);

      rows.add(
        LeagueDetailsPlayerStatRowUiModel(
          rank: '${rows.length + 1}.',
          name: '${player['name'] ?? ''}',
          teamName: '${team['name'] ?? ''}',
          value: '${primaryValue ?? 0}',
          subtitleValue: '${secondaryValue ?? 0}',
          playerImageUrl: '${player['photo'] ?? ''}',
          teamLogoUrl: '${team['logo'] ?? ''}',
        ),
      );
    }

    return rows;
  }

  LeagueDetailsFixtureUiModel _parseFixture(Map<String, dynamic> item) {
    final fixture = item['fixture'] is Map<String, dynamic>
        ? item['fixture'] as Map<String, dynamic>
        : const <String, dynamic>{};
    final teams = item['teams'] is Map<String, dynamic>
        ? item['teams'] as Map<String, dynamic>
        : const <String, dynamic>{};
    final home = teams['home'] is Map<String, dynamic>
        ? teams['home'] as Map<String, dynamic>
        : const <String, dynamic>{};
    final away = teams['away'] is Map<String, dynamic>
        ? teams['away'] as Map<String, dynamic>
        : const <String, dynamic>{};
    final goals = item['goals'] is Map<String, dynamic>
        ? item['goals'] as Map<String, dynamic>
        : const <String, dynamic>{};
    final status = fixture['status'] is Map<String, dynamic>
        ? fixture['status'] as Map<String, dynamic>
        : const <String, dynamic>{};

    return LeagueDetailsFixtureUiModel(
      fixtureId: '${fixture['id'] ?? ''}',
      homeTeam: _parseFixtureTeam(home),
      awayTeam: _parseFixtureTeam(away),
      homeScore: _asInt(goals['home']),
      awayScore: _asInt(goals['away']),
      statusLabel: _fixtureStatusLabel(status, '${fixture['date'] ?? ''}'),
      statusDetail: '${status['short'] ?? ''}',
    );
  }

  LeagueDetailsFixtureTeamUiModel _parseFixtureTeam(Map<String, dynamic> team) {
    final name = '${team['name'] ?? ''}';
    return LeagueDetailsFixtureTeamUiModel(
      teamName: name,
      shortName: _seedFromName(name),
      badgeColor: _colorFromValue(_asInt(team['id']) ?? name.hashCode),
      logoUrl: '${team['logo'] ?? ''}',
    );
  }

  void _ensureSuccess(Map<String, dynamic> json, String fallbackMessage) {
    if (json['success'] == false) {
      throw Exception(json['message'] as String? ?? fallbackMessage);
    }
  }
}

class LeagueDetailsRemoteDataModel {
  final List<String> seasons;
  final List<LeagueDetailsStandingsRowUiModel> standingsRows;
  final LeagueDetailsFixturesViewModel fixtures;
  final List<LeagueDetailsPlayerStatRowUiModel> topScorers;
  final List<LeagueDetailsPlayerStatRowUiModel> topAssists;

  const LeagueDetailsRemoteDataModel({
    required this.seasons,
    required this.standingsRows,
    required this.fixtures,
    required this.topScorers,
    required this.topAssists,
  });
}

enum _PlayerStatValueType { goals, assists }

List<dynamic> _listAt(Map<String, dynamic> json, List<String> path) {
  dynamic current = json;
  for (final key in path) {
    if (current is Map<String, dynamic>) {
      current = current[key];
    } else {
      return const <dynamic>[];
    }
  }
  return current is List<dynamic> ? current : const <dynamic>[];
}

int? _asInt(dynamic value) {
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

int? _seasonYearFromLabel(String label) {
  final match = RegExp(r'\d{4}').firstMatch(label);
  if (match == null) {
    return null;
  }
  return int.tryParse(match.group(0)!);
}

String _todayDate() {
  final now = DateTime.now();
  return '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
}

String _fixtureSectionTitle(String date) {
  final parsed = DateTime.tryParse(date);
  if (parsed == null) {
    return date.toUpperCase();
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

String _fixtureStatusLabel(Map<String, dynamic> status, String date) {
  final short = '${status['short'] ?? ''}';
  if (short.toUpperCase() == 'NS') {
    final parsed = DateTime.tryParse(date);
    if (parsed != null) {
      final hour = parsed.hour.toString().padLeft(2, '0');
      final minute = parsed.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }
  }
  return short.isEmpty ? '${status['long'] ?? ''}' : short;
}

String _seedFromName(String name) {
  final words = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((item) => item.isNotEmpty)
      .toList(growable: false);
  if (words.isEmpty) {
    return 'T';
  }
  if (words.length == 1) {
    return words.first.substring(0, words.first.length < 2 ? 1 : 2).toUpperCase();
  }
  return words.take(3).map((word) => word[0]).join().toUpperCase();
}

Color _colorFromValue(int value) {
  const palette = <Color>[
    Color(0xFFBD1D28),
    Color(0xFF5CB9FF),
    Color(0xFFC13329),
    Color(0xFF89C1F5),
    Color(0xFF244A95),
    Color(0xFF1F7FDB),
    Color(0xFF101010),
    Color(0xFFF59E0B),
  ];
  return palette[value.abs() % palette.length];
}
