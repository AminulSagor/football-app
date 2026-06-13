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
    final leagueDetails = await fetchLeagueById(leagueId: leagueId);
    final resolvedLeague = leagueDetails.league ?? league;
    final seasonYear = _resolveSeasonYear(
      requestedSeason: season,
      availableSeasons: leagueDetails.seasons,
      fallbackSeason: resolvedLeague.season ?? league.season,
    );
    final results = await Future.wait<dynamic>([
      fetchStandingsData(
        leagueId: leagueId,
        season: seasonYear,
        page: 1,
        limit: 20,
      ),
      fetchTopScorers(leagueId: leagueId, season: seasonYear),
      fetchTopAssists(leagueId: leagueId, season: seasonYear),
      fetchInitialFixturesByDateRange(leagueId: leagueId, season: seasonYear),
    ]);

    final standingsData = results[0] as LeagueDetailsStandingsDataModel;
    final topScorers = results[1] as List<LeagueDetailsPlayerStatRowUiModel>;
    final topAssists = results[2] as List<LeagueDetailsPlayerStatRowUiModel>;
    final fixtures = results[3] as LeagueDetailsFixturesViewModel;

    return LeagueDetailsRemoteDataModel(
      league: resolvedLeague,
      seasons: leagueDetails.seasons,
      selectedSeason: '$seasonYear',
      isFollowing: leagueDetails.isFollowing,
      standingsRows: standingsData.rows,
      worldCupGroups: standingsData.worldCupGroups,
      standingsPage: standingsData.page,
      standingsTotalPages: standingsData.totalPages,
      fixtures: fixtures.copyWith(
        teamOptions: standingsData.rows,
        selectedTeamId: standingsData.rows.isNotEmpty
            ? standingsData.rows.first.teamId
            : '',
        selectedTeamLabel: standingsData.rows.isNotEmpty
            ? standingsData.rows.first.teamName
            : '',
        selectedTeamLogoUrl: standingsData.rows.isNotEmpty
            ? standingsData.rows.first.teamLogoUrl
            : '',
      ),
      topScorers: topScorers,
      topAssists: topAssists,
    );
  }

  Future<LeagueDetailsLeagueInfoApiModel> fetchLeagueById({
    required int leagueId,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/leagues',
      queryParameters: <String, dynamic>{'id': leagueId},
    );
    final responseData = response.data;
    if (responseData == null) {
      throw Exception('empty_response');
    }
    _ensureSuccess(responseData, 'Unable to load league information.');

    final items = _listAt(responseData, const <String>['data', 'response']);
    final typedItems = items.whereType<Map<String, dynamic>>();
    final firstItem = typedItems.isEmpty ? null : typedItems.first;
    final apiItem = firstItem == null
        ? null
        : FootballLeagueApiItemModel.fromJson(firstItem);
    final seasons = apiItem == null
        ? <String>[]
        : (apiItem.seasons
              .map((item) => item.year?.toString() ?? '')
              .where((item) => item.isNotEmpty)
              .toSet()
              .toList(growable: false)
            ..sort((left, right) => right.compareTo(left)));

    final data = responseData['data'] is Map<String, dynamic>
        ? responseData['data'] as Map<String, dynamic>
        : const <String, dynamic>{};
    final follow = data['follow'] is Map<String, dynamic>
        ? data['follow'] as Map<String, dynamic>
        : const <String, dynamic>{};

    return LeagueDetailsLeagueInfoApiModel(
      league: apiItem == null
          ? null
          : LeaguesTopLeagueUiModel.fromFootballLeague(apiItem),
      seasons: seasons,
      isFollowing: follow['isFollowed'] as bool? ?? false,
    );
  }

  Future<List<LeagueDetailsSeasonHistoryUiModel>> fetchWorldCupSeasonHistory({
    required int leagueId,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/leagues/$leagueId/seasons/history',
    );
    final responseData = response.data;
    if (responseData == null) {
      throw Exception('empty_response');
    }
    _ensureSuccess(responseData, 'Unable to load season history.');

    final seasons = _listAt(responseData, const <String>['data', 'seasons']);
    return seasons
        .whereType<Map<String, dynamic>>()
        .where((item) => '${item['status'] ?? ''}'.toUpperCase() == 'COMPLETED')
        .map(
          (item) => LeagueDetailsSeasonHistoryUiModel(
            season: '${item['season'] ?? ''}',
            status: '${item['status'] ?? ''}',
            winner: _seasonHistoryTeam(item['winner']),
            runnerUp: _seasonHistoryTeam(item['runnerUp']),
          ),
        )
        .where((item) => item.season.isNotEmpty)
        .toList(growable: false);
  }

  LeagueDetailsSeasonTeamUiModel _seasonHistoryTeam(dynamic rawTeam) {
    final team = rawTeam is Map<String, dynamic>
        ? rawTeam
        : const <String, dynamic>{};
    return LeagueDetailsSeasonTeamUiModel(
      id: '${team['id'] ?? ''}',
      name: '${team['name'] ?? ''}',
      logoUrl: '${team['logo'] ?? ''}',
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

    final responseList = _listAt(responseData, const <String>[
      'data',
      'response',
    ]);
    return responseList
        .map((item) => item.toString())
        .where((item) => item.isNotEmpty)
        .toList(growable: false)
      ..sort((left, right) => right.compareTo(left));
  }

  Future<List<LeagueDetailsStandingsRowUiModel>> fetchStandings({
    required int leagueId,
    required int season,
    int page = 1,
    int limit = 20,
  }) async {
    final data = await fetchStandingsData(
      leagueId: leagueId,
      season: season,
      page: page,
      limit: limit,
    );
    return data.rows;
  }

  Future<LeagueDetailsStandingsDataModel> fetchStandingsData({
    required int leagueId,
    required int season,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/standings',
      queryParameters: <String, dynamic>{
        'league': leagueId,
        'season': season,
        'page': page,
        'limit': limit,
      },
    );
    final responseData = response.data;
    if (responseData == null) {
      throw Exception('empty_response');
    }
    _ensureSuccess(responseData, 'Unable to load standings.');

    final rows = <LeagueDetailsStandingsRowUiModel>[];
    final groups = <LeagueDetailsWorldCupGroupUiModel>[];
    final leagueResponse = _listAt(responseData, const <String>[
      'data',
      'response',
    ]);
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
        final groupRows = <LeagueDetailsStandingsRowUiModel>[];
        for (final standing in group.whereType<Map<String, dynamic>>()) {
          final parsedRow = _parseStandingRow(standing, rows.length + 1);
          rows.add(parsedRow);
          groupRows.add(parsedRow);
        }
        if (groupRows.isNotEmpty) {
          final groupTitle = _safeGroupTitle(groupRows.first, group);
          groups.add(
            LeagueDetailsWorldCupGroupUiModel(
              title: groupTitle,
              rows: groupRows,
            ),
          );
        }
      }
    }

    final paging = _backendPaging(responseData);
    return LeagueDetailsStandingsDataModel(
      rows: rows,
      worldCupGroups: groups,
      page: paging.page,
      totalPages: paging.totalPages,
    );
  }

  LeagueDetailsStandingsRowUiModel _parseStandingRow(
    Map<String, dynamic> standing,
    int fallbackRank,
  ) {
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
    return LeagueDetailsStandingsRowUiModel(
      rank: '${_asInt(standing['rank']) ?? fallbackRank}',
      teamId: '${team['id'] ?? ''}',
      teamName: '${team['name'] ?? ''}',
      badgeSeed: _seedFromName('${team['name'] ?? ''}'),
      badgeColor: _colorFromValue(_asInt(team['id']) ?? fallbackRank),
      teamLogoUrl: '${team['logo'] ?? ''}',
      played: '${_asInt(all['played']) ?? '-'}',
      plusMinus: goalsFor == null || goalsAgainst == null
          ? '-'
          : '$goalsFor-$goalsAgainst',
      goalDifference: diff == null ? '-' : (diff > 0 ? '+$diff' : '$diff'),
      points: '${_asInt(standing['points']) ?? '-'}',
      description: '${standing['description'] ?? ''}',
    );
  }

  String _safeGroupTitle(
    LeagueDetailsStandingsRowUiModel firstRow,
    List<dynamic> rawGroup,
  ) {
    final firstStanding = rawGroup.whereType<Map<String, dynamic>>().isEmpty
        ? null
        : rawGroup.whereType<Map<String, dynamic>>().first;
    final groupName = firstStanding == null
        ? ''
        : '${firstStanding['group'] ?? ''}'.trim();
    return groupName.isEmpty ? 'Group ${firstRow.badgeSeed}' : groupName;
  }

  Future<LeagueDetailsKnockoutBracketDataModel> fetchKnockoutBracket({
    required int fixtureId,
    required int leagueId,
    required int season,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/matches/$fixtureId/knockout-bracket',
      queryParameters: <String, dynamic>{'league': leagueId, 'season': season},
    );

    final responseData = response.data;
    if (responseData == null) {
      throw Exception('empty_response');
    }
    _ensureSuccess(responseData, 'Unable to load knockout bracket.');

    final data = responseData['data'] is Map<String, dynamic>
        ? responseData['data'] as Map<String, dynamic>
        : const <String, dynamic>{};
    final rounds = data['rounds'] is List
        ? data['rounds'] as List<dynamic>
        : const <dynamic>[];

    List<LeagueDetailsKnockoutMatchUiModel> roundMatches(String targetRound) {
      final round = rounds.whereType<Map<String, dynamic>>().firstWhere(
        (item) => '${item['round'] ?? ''}'.trim() == targetRound,
        orElse: () => const <String, dynamic>{},
      );
      final fixtures = round['fixtures'] is Map<String, dynamic>
          ? round['fixtures'] as Map<String, dynamic>
          : const <String, dynamic>{};
      final responseItems = fixtures['response'] is List
          ? fixtures['response'] as List<dynamic>
          : const <dynamic>[];
      return responseItems
          .whereType<Map<String, dynamic>>()
          .map(_parseKnockoutFixture)
          .toList(growable: false);
    }

    return LeagueDetailsKnockoutBracketDataModel(
      roundOf16: roundMatches('Round of 16'),
      quarterFinals: roundMatches('Quarter-finals'),
      semiFinals: roundMatches('Semi-finals'),
      finals: roundMatches('Final'),
    );
  }

  LeagueDetailsKnockoutMatchUiModel _parseKnockoutFixture(
    Map<String, dynamic> item,
  ) {
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
    final score = item['score'] is Map<String, dynamic>
        ? item['score'] as Map<String, dynamic>
        : const <String, dynamic>{};
    final penalty = score['penalty'] is Map<String, dynamic>
        ? score['penalty'] as Map<String, dynamic>
        : const <String, dynamic>{};

    final homeName = '${home['name'] ?? ''}'.trim();
    final awayName = '${away['name'] ?? ''}'.trim();
    final status = fixture['status'] is Map<String, dynamic>
        ? fixture['status'] as Map<String, dynamic>
        : const <String, dynamic>{};
    final statusShort = '${status['short'] ?? ''}'.toUpperCase();
    final homeGoals = _asInt(goals['home']);
    final awayGoals = _asInt(goals['away']);
    final homePenalty = _asInt(penalty['home']);
    final awayPenalty = _asInt(penalty['away']);
    final scoreLabel = homeGoals == null || awayGoals == null
        ? _knockoutDateLabel('${fixture['date'] ?? ''}')
        : (homePenalty == null || awayPenalty == null
              ? '$homeGoals - $awayGoals'
              : '$homeGoals($homePenalty) - $awayGoals($awayPenalty)');

    return LeagueDetailsKnockoutMatchUiModel(
      homeSeed: _shortSeed(homeName),
      awaySeed: _shortSeed(awayName),
      homeLabel: homeName.isEmpty ? 'TBD' : homeName,
      awayLabel: awayName.isEmpty ? 'TBD' : awayName,
      homeLogoUrl: '${home['logo'] ?? ''}',
      awayLogoUrl: '${away['logo'] ?? ''}',
      dateLabel: scoreLabel.isEmpty ? 'TBD' : scoreLabel,
      isFinished: const <String>{'FT', 'AET', 'PEN'}.contains(statusShort),
      homeWinner: home['winner'] == true,
      awayWinner: away['winner'] == true,
    );
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
    return _parsePlayerStats(
      responseData,
      valueType: _PlayerStatValueType.goals,
    );
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
    return _parsePlayerStats(
      responseData,
      valueType: _PlayerStatValueType.assists,
    );
  }

  Future<List<LeagueDetailsPlayerStatSectionUiModel>> fetchPlayerStatsCategory({
    required int leagueId,
    required int season,
    required String category,
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/leagues/$leagueId/player-stats',
      queryParameters: <String, dynamic>{
        'season': season,
        'category': category,
        'page': page,
        'limit': limit,
      },
    );

    final responseData = response.data;
    if (responseData == null) {
      throw Exception('empty_response');
    }
    _ensureSuccess(responseData, 'Unable to load player stats.');

    final data = responseData['data'] is Map<String, dynamic>
        ? responseData['data'] as Map<String, dynamic>
        : const <String, dynamic>{};
    final sections = data['sections'] is List
        ? data['sections'] as List<dynamic>
        : const <dynamic>[];

    return sections
        .whereType<Map<String, dynamic>>()
        .map((section) {
          final items = section['items'] is List
              ? section['items'] as List<dynamic>
              : const <dynamic>[];
          final rows = <LeagueDetailsPlayerStatRowUiModel>[];

          for (final item in items.whereType<Map<String, dynamic>>()) {
            final player = item['player'] is Map<String, dynamic>
                ? item['player'] as Map<String, dynamic>
                : const <String, dynamic>{};
            final team = item['team'] is Map<String, dynamic>
                ? item['team'] as Map<String, dynamic>
                : const <String, dynamic>{};
            final rank = _asInt(item['rank']) ?? rows.length + 1;
            rows.add(
              LeagueDetailsPlayerStatRowUiModel(
                rank: '$rank.',
                playerId: '${player['id'] ?? ''}',
                name: '${player['name'] ?? ''}',
                teamId: '${team['id'] ?? ''}',
                teamName: '${team['name'] ?? ''}',
                value: '${item['value'] ?? '-'}',
                subtitleValue: '${team['name'] ?? ''}',
                playerImageUrl: '${player['photo'] ?? ''}',
                teamLogoUrl: '${team['logo'] ?? ''}',
              ),
            );
          }

          return LeagueDetailsPlayerStatSectionUiModel(
            category: '${data['category'] ?? category}',
            key: '${section['key'] ?? ''}',
            title: '${section['title'] ?? section['key'] ?? ''}',
            rows: rows,
          );
        })
        .toList(growable: false);
  }

  Future<List<LeagueDetailsPlayerStatSectionUiModel>> fetchTeamStatsCategory({
    required int leagueId,
    required int season,
    required String category,
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/leagues/$leagueId/team-stats',
      queryParameters: <String, dynamic>{
        'season': season,
        'category': category,
        'page': page,
        'limit': limit,
      },
    );

    final responseData = response.data;
    if (responseData == null) {
      throw Exception('empty_response');
    }
    _ensureSuccess(responseData, 'Unable to load team stats.');

    final data = responseData['data'] is Map<String, dynamic>
        ? responseData['data'] as Map<String, dynamic>
        : const <String, dynamic>{};
    final sections = data['sections'] is List
        ? data['sections'] as List<dynamic>
        : const <dynamic>[];

    return sections
        .whereType<Map<String, dynamic>>()
        .map((section) {
          final items = section['items'] is List
              ? section['items'] as List<dynamic>
              : const <dynamic>[];
          final rows = <LeagueDetailsPlayerStatRowUiModel>[];

          for (final item in items.whereType<Map<String, dynamic>>()) {
            final team = item['team'] is Map<String, dynamic>
                ? item['team'] as Map<String, dynamic>
                : const <String, dynamic>{};
            final rank = _asInt(item['rank']) ?? rows.length + 1;
            rows.add(
              LeagueDetailsPlayerStatRowUiModel(
                rank: '$rank.',
                name: '${team['name'] ?? ''}',
                teamId: '${team['id'] ?? ''}',
                teamName: '${team['name'] ?? ''}',
                value: '${item['value'] ?? '-'}',
                subtitleValue: '${team['name'] ?? ''}',
                teamLogoUrl: '${team['logo'] ?? ''}',
              ),
            );
          }

          return LeagueDetailsPlayerStatSectionUiModel(
            category: '${data['category'] ?? category}',
            key: '${section['key'] ?? ''}',
            title: '${section['title'] ?? section['key'] ?? ''}',
            rows: rows,
          );
        })
        .toList(growable: false);
  }

  Future<LeagueDetailsFixturesViewModel> fetchLeagueFixturesByDateRange({
    required int leagueId,
    required int season,
    required String fromDate,
    required String toDate,
    int page = 1,
    int limit = 10,
    List<LeagueDetailsFixtureSectionUiModel> existingSections =
        const <LeagueDetailsFixtureSectionUiModel>[],
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/fixtures',
      queryParameters: <String, dynamic>{
        'league': leagueId,
        'season': season,
        'from': fromDate,
        'to': toDate,
        'limit': limit,
        'page': page,
      },
    );
    final responseData = response.data;
    if (responseData == null) {
      throw Exception('empty_response');
    }
    _ensureSuccess(responseData, 'Unable to load fixtures.');

    final parsedSections = _parseFixtureSectionsFromResponse(responseData);
    final mergedSections = page <= 1
        ? parsedSections
        : _mergeFixtureSections(existingSections, parsedSections);
    final paging = _backendPaging(responseData);

    return LeagueDetailsFixturesViewModel(
      mode: LeagueDetailsFixturesMode.byDate,
      selectedDateIndex: 0,
      selectedRoundLabel: '',
      selectedTeamLabel: '',
      teamRangeLabel: '',
      fromDate: fromDate,
      toDate: toDate,
      datePage: paging.page,
      dateTotalPages: paging.totalPages,
      byDateSections: mergedSections,
      byRoundSections: const <LeagueDetailsFixtureSectionUiModel>[],
      byTeamSections: const <LeagueDetailsFixtureSectionUiModel>[],
    );
  }

  Future<LeagueDetailsFixturesViewModel> fetchWorldCupInitialFixturesByDateRange({
    required int leagueId,
    required int season,
  }) {
    return fetchInitialFixturesByDateRange(leagueId: leagueId, season: season);
  }

  Future<LeagueDetailsFixturesViewModel> fetchInitialFixturesByDateRange({
    required int leagueId,
    required int season,
  }) async {
    final nextProbeResponse = await _apiClient.get<Map<String, dynamic>>(
      '/football/fixtures',
      queryParameters: <String, dynamic>{
        'league': leagueId,
        'season': season,
        'next': 10,
      },
    );
    final nextProbeData = nextProbeResponse.data;
    if (nextProbeData == null) {
      throw Exception('empty_response');
    }
    _ensureSuccess(nextProbeData, 'Unable to load fixtures.');

    final nextDate = _firstFixtureDate(nextProbeData);
    if (nextDate != null) {
      final nextMatchDate = _dateOnly(nextDate.toLocal());
      final fromDate = nextMatchDate.subtract(const Duration(days: 1));
      final fixtures = await fetchLeagueFixturesByDateRange(
        leagueId: leagueId,
        season: season,
        fromDate: _dateString(fromDate),
        toDate: _dateString(nextMatchDate.add(const Duration(days: 6))),
        page: 1,
        limit: 10,
      );
      return fixtures.copyWith(isDateNextDisabled: false);
    }

    final lastProbeResponse = await _apiClient.get<Map<String, dynamic>>(
      '/football/fixtures',
      queryParameters: <String, dynamic>{
        'league': leagueId,
        'season': season,
        'last': 10,
      },
    );
    final lastProbeData = lastProbeResponse.data;
    if (lastProbeData == null) {
      throw Exception('empty_response');
    }
    _ensureSuccess(lastProbeData, 'Unable to load previous fixtures.');

    final lastDate = _firstFixtureDate(lastProbeData);
    if (lastDate == null) {
      final fallback = defaultFixtureDateRange();
      final fixtures = await fetchLeagueFixturesByDateRange(
        leagueId: leagueId,
        season: season,
        fromDate: fallback.start,
        toDate: fallback.end,
        page: 1,
        limit: 10,
      );
      return fixtures.copyWith(isDateNextDisabled: true);
    }

    final toDate = _dateOnly(lastDate.toLocal());
    final fixtures = await fetchLeagueFixturesByDateRange(
      leagueId: leagueId,
      season: season,
      fromDate: _dateString(toDate.subtract(const Duration(days: 7))),
      toDate: _dateString(toDate),
      page: 1,
      limit: 10,
    );
    return fixtures.copyWith(isDateNextDisabled: true);
  }

  Future<List<String>> fetchFixtureRounds({
    required int leagueId,
    required int season,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/fixtures/rounds',
      queryParameters: <String, dynamic>{'league': leagueId, 'season': season},
    );
    final responseData = response.data;
    if (responseData == null) {
      throw Exception('empty_response');
    }
    _ensureSuccess(responseData, 'Unable to load fixture rounds.');

    return _listAt(responseData, const <String>['data', 'response'])
        .map((item) => item.toString())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }

  Future<LeagueDetailsFixturesViewModel> fetchLeagueFixturesByRound({
    required int leagueId,
    required int season,
    required String round,
    required List<String> roundLabels,
    int page = 1,
    int limit = 10,
    List<LeagueDetailsFixtureSectionUiModel> existingSections =
        const <LeagueDetailsFixtureSectionUiModel>[],
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/fixtures',
      queryParameters: <String, dynamic>{
        'league': leagueId,
        'season': season,
        'round': round,
        'limit': limit,
        'page': page,
      },
    );
    final responseData = response.data;
    if (responseData == null) {
      throw Exception('empty_response');
    }
    _ensureSuccess(responseData, 'Unable to load round fixtures.');

    final parsedSections = _parseFixtureSectionsFromResponse(responseData);
    final mergedSections = page <= 1
        ? parsedSections
        : _mergeFixtureSections(existingSections, parsedSections);
    final paging = _backendPaging(responseData);

    return LeagueDetailsFixturesViewModel(
      mode: LeagueDetailsFixturesMode.byRound,
      selectedRoundLabel: round,
      roundLabels: roundLabels,
      roundPage: paging.page,
      roundTotalPages: paging.totalPages,
      byDateSections: const <LeagueDetailsFixtureSectionUiModel>[],
      byRoundSections: mergedSections,
      byTeamSections: const <LeagueDetailsFixtureSectionUiModel>[],
    );
  }

  Future<LeagueDetailsFixturesViewModel> fetchLeagueFixturesByTeam({
    required int leagueId,
    required int season,
    required String teamId,
    required String teamName,
    required String teamLogoUrl,
    required List<LeagueDetailsStandingsRowUiModel> teamOptions,
    int page = 1,
    int limit = 20,
    List<LeagueDetailsFixtureSectionUiModel> existingSections =
        const <LeagueDetailsFixtureSectionUiModel>[],
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/fixtures',
      queryParameters: <String, dynamic>{
        'league': leagueId,
        'season': season,
        'team': teamId,
        'limit': limit,
        'page': page,
      },
    );
    final responseData = response.data;
    if (responseData == null) {
      throw Exception('empty_response');
    }
    _ensureSuccess(responseData, 'Unable to load team fixtures.');

    final parsedSections = _parseFixtureSectionsFromResponse(responseData);
    final mergedSections = page <= 1
        ? parsedSections
        : _mergeFixtureSections(existingSections, parsedSections);
    final paging = _backendPaging(responseData);

    return LeagueDetailsFixturesViewModel(
      mode: LeagueDetailsFixturesMode.byTeam,
      selectedTeamId: teamId,
      selectedTeamLabel: teamName,
      selectedTeamLogoUrl: teamLogoUrl,
      teamOptions: teamOptions,
      teamRangeLabel: 'ALL MATCHES',
      teamPage: paging.page,
      teamTotalPages: paging.totalPages,
      byDateSections: const <LeagueDetailsFixtureSectionUiModel>[],
      byRoundSections: const <LeagueDetailsFixtureSectionUiModel>[],
      byTeamSections: mergedSections,
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
      final stats =
          statsList is List &&
              statsList.isNotEmpty &&
              statsList.first is Map<String, dynamic>
          ? statsList.first as Map<String, dynamic>
          : const <String, dynamic>{};
      final team = stats['team'] is Map<String, dynamic>
          ? stats['team'] as Map<String, dynamic>
          : const <String, dynamic>{};
      final goals = stats['goals'] is Map<String, dynamic>
          ? stats['goals'] as Map<String, dynamic>
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
          playerId: '${player['id'] ?? ''}',
          name: '${player['name'] ?? ''}',
          teamId: '${team['id'] ?? ''}',
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

  List<LeagueDetailsFixtureSectionUiModel> _parseFixtureSectionsFromResponse(
    Map<String, dynamic> json,
  ) {
    final response = _listAt(json, const <String>['data', 'response']);
    final grouped = <String, List<LeagueDetailsFixtureUiModel>>{};

    for (final item in response.whereType<Map<String, dynamic>>()) {
      final key = _fixtureDateKey(item);
      if (key.isEmpty) {
        continue;
      }
      grouped
          .putIfAbsent(key, () => <LeagueDetailsFixtureUiModel>[])
          .add(_parseFixture(item));
    }

    final keys = grouped.keys.toList(growable: false)..sort();
    return keys
        .map(
          (key) => LeagueDetailsFixtureSectionUiModel(
            title: _fixtureSectionTitle(key),
            fixtures: grouped[key]!,
          ),
        )
        .where((section) => section.fixtures.isNotEmpty)
        .toList(growable: false);
  }

  List<LeagueDetailsFixtureSectionUiModel> _mergeFixtureSections(
    List<LeagueDetailsFixtureSectionUiModel> existing,
    List<LeagueDetailsFixtureSectionUiModel> incoming,
  ) {
    final grouped = <String, List<LeagueDetailsFixtureUiModel>>{};
    for (final section in <LeagueDetailsFixtureSectionUiModel>[
      ...existing,
      ...incoming,
    ]) {
      grouped
          .putIfAbsent(section.title, () => <LeagueDetailsFixtureUiModel>[])
          .addAll(section.fixtures);
    }
    return grouped.entries
        .map(
          (entry) => LeagueDetailsFixtureSectionUiModel(
            title: entry.key,
            fixtures: entry.value,
          ),
        )
        .toList(growable: false);
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
      statusDetail: _fixtureStatusDetail(status),
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

class LeagueDetailsStandingsDataModel {
  final List<LeagueDetailsStandingsRowUiModel> rows;
  final List<LeagueDetailsWorldCupGroupUiModel> worldCupGroups;
  final int page;
  final int totalPages;

  const LeagueDetailsStandingsDataModel({
    required this.rows,
    required this.worldCupGroups,
    required this.page,
    required this.totalPages,
  });
}

class LeagueDetailsRemoteDataModel {
  final LeaguesTopLeagueUiModel? league;
  final List<String> seasons;
  final String selectedSeason;
  final bool isFollowing;
  final List<LeagueDetailsStandingsRowUiModel> standingsRows;
  final List<LeagueDetailsWorldCupGroupUiModel> worldCupGroups;
  final int standingsPage;
  final int standingsTotalPages;
  final LeagueDetailsFixturesViewModel fixtures;
  final List<LeagueDetailsPlayerStatRowUiModel> topScorers;
  final List<LeagueDetailsPlayerStatRowUiModel> topAssists;

  const LeagueDetailsRemoteDataModel({
    required this.league,
    required this.seasons,
    required this.selectedSeason,
    required this.isFollowing,
    required this.standingsRows,
    this.worldCupGroups = const <LeagueDetailsWorldCupGroupUiModel>[],
    this.standingsPage = 1,
    this.standingsTotalPages = 1,
    required this.fixtures,
    required this.topScorers,
    required this.topAssists,
  });
}

class LeagueDetailsKnockoutBracketDataModel {
  final List<LeagueDetailsKnockoutMatchUiModel> roundOf16;
  final List<LeagueDetailsKnockoutMatchUiModel> quarterFinals;
  final List<LeagueDetailsKnockoutMatchUiModel> semiFinals;
  final List<LeagueDetailsKnockoutMatchUiModel> finals;

  const LeagueDetailsKnockoutBracketDataModel({
    this.roundOf16 = const <LeagueDetailsKnockoutMatchUiModel>[],
    this.quarterFinals = const <LeagueDetailsKnockoutMatchUiModel>[],
    this.semiFinals = const <LeagueDetailsKnockoutMatchUiModel>[],
    this.finals = const <LeagueDetailsKnockoutMatchUiModel>[],
  });
}

class LeagueDetailsLeagueInfoApiModel {
  final LeaguesTopLeagueUiModel? league;
  final List<String> seasons;
  final bool isFollowing;

  const LeagueDetailsLeagueInfoApiModel({
    required this.league,
    required this.seasons,
    required this.isFollowing,
  });
}

class FixtureDateRangeModel {
  final String start;
  final String end;

  const FixtureDateRangeModel({required this.start, required this.end});
}

class _FixturePagingModel {
  final int page;
  final int totalPages;

  const _FixturePagingModel({required this.page, required this.totalPages});
}

enum _PlayerStatValueType { goals, assists }

FixtureDateRangeModel defaultFixtureDateRange() {
  final now = DateTime.now();
  return FixtureDateRangeModel(
    start: _dateString(now.subtract(const Duration(days: 1))),
    end: _dateString(now.add(const Duration(days: 7))),
  );
}

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

int _resolveSeasonYear({
  required String requestedSeason,
  required List<String> availableSeasons,
  required int? fallbackSeason,
}) {
  final requestedYear = _seasonYearFromLabel(requestedSeason);
  if (requestedYear != null && availableSeasons.contains('$requestedYear')) {
    return requestedYear;
  }
  if (requestedSeason.trim().isEmpty && availableSeasons.isNotEmpty) {
    return int.tryParse(availableSeasons.first) ?? DateTime.now().year;
  }
  if (fallbackSeason != null && availableSeasons.contains('$fallbackSeason')) {
    return fallbackSeason;
  }
  if (availableSeasons.isNotEmpty) {
    return int.tryParse(availableSeasons.first) ?? DateTime.now().year;
  }
  return requestedYear ?? fallbackSeason ?? DateTime.now().year;
}

String _shortSeed(String name) {
  final normalized = name.trim();
  if (normalized.isEmpty) {
    return 'TBD';
  }
  final words = normalized
      .split(RegExp(r'\s+'))
      .where((word) => word.trim().isNotEmpty)
      .toList(growable: false);
  if (words.length >= 2) {
    return words.take(2).map((word) => word[0].toUpperCase()).join();
  }
  return normalized.length <= 3
      ? normalized.toUpperCase()
      : normalized.substring(0, 3).toUpperCase();
}

String _knockoutDateLabel(String rawDate) {
  final parsed = DateTime.tryParse(rawDate);
  if (parsed == null) {
    return '';
  }
  return _compactDateLabel(parsed.toLocal());
}

String _dateString(DateTime date) {
  return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

DateTime _dateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

DateTime? _firstFixtureDate(Map<String, dynamic> json) {
  final response = _listAt(json, const <String>['data', 'response']);
  for (final item in response.whereType<Map<String, dynamic>>()) {
    final fixture = item['fixture'] is Map<String, dynamic>
        ? item['fixture'] as Map<String, dynamic>
        : const <String, dynamic>{};
    final parsed = DateTime.tryParse('${fixture['date'] ?? ''}');
    if (parsed != null) {
      return parsed;
    }
  }
  return null;
}

String _fixtureDateKey(Map<String, dynamic> item) {
  final fixture = item['fixture'] is Map<String, dynamic>
      ? item['fixture'] as Map<String, dynamic>
      : const <String, dynamic>{};
  final parsed = DateTime.tryParse('${fixture['date'] ?? ''}');
  if (parsed == null) {
    return '';
  }
  final local = parsed.toLocal();
  return _dateString(local);
}

String _fixtureSectionTitle(String date) {
  final parsed = DateTime.tryParse(date);
  if (parsed == null) {
    return date.toUpperCase();
  }

  final today = DateTime.now();
  final todayOnly = DateTime(today.year, today.month, today.day);
  final targetOnly = DateTime(parsed.year, parsed.month, parsed.day);
  final diff = targetOnly.difference(todayOnly).inDays;
  final compact = _compactDateLabel(parsed);
  if (diff == -1) {
    return 'YESTERDAY - $compact';
  }
  if (diff == 0) {
    return 'TODAY';
  }
  if (diff == 1) {
    return 'TOMORROW';
  }

  const weekDays = <String>[
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
    'SUNDAY',
  ];
  return '${weekDays[parsed.weekday - 1]} $compact';
}

String _compactDateLabel(DateTime parsed) {
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
      final local = parsed.toLocal();
      final hour = local.hour.toString().padLeft(2, '0');
      final minute = local.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }
  }
  return short.isEmpty ? '${status['long'] ?? ''}' : short;
}

String _fixtureStatusDetail(Map<String, dynamic> status) {
  final elapsed = _asInt(status['elapsed']);
  final short = '${status['short'] ?? ''}'.toUpperCase();
  if (elapsed == null || short == 'FT' || short == 'NS') {
    return '';
  }
  final extra = _asInt(status['extra']);
  return extra == null ? "$elapsed'" : "$elapsed+$extra'";
}

_FixturePagingModel _backendPaging(Map<String, dynamic> json) {
  final data = json['data'] is Map<String, dynamic>
      ? json['data'] as Map<String, dynamic>
      : const <String, dynamic>{};
  final backendPaging = data['backendPaging'] is Map<String, dynamic>
      ? data['backendPaging'] as Map<String, dynamic>
      : const <String, dynamic>{};
  return _FixturePagingModel(
    page: _asInt(backendPaging['page']) ?? 1,
    totalPages: _asInt(backendPaging['totalPages']) ?? 1,
  );
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
    return words.first
        .substring(0, words.first.length < 2 ? 1 : 2)
        .toUpperCase();
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
