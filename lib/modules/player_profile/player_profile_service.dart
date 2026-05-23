import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/api_client.dart';
import '../../core/services/following_service.dart';
import '../../core/models/following_models.dart';
import 'model/player_profile_model.dart';

class PlayerProfileService {
  final ApiClient _apiClient;

  PlayerProfileService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<PlayerProfileViewModel> fetchPlayerDetails({
    required String playerId,
    required String season,
    required PlayerProfileViewModel previous,
    String? teamId,
  }) async {
    final playerData = await _fetchFootballData(
      '/football/players',
      queryParameters: <String, dynamic>{'id': playerId, 'season': season},
    );

    final playerItems = _readListOfMaps(playerData['response']);

    if (playerItems.isEmpty) {
      throw Exception('player_not_found');
    }

    final playerItem = playerItems.first;
    // Hydrate follow status from backend if present in response
    try {
      final follow = _readMap(playerItem['follow']);
      final isFollowed = follow['isFollowed'];
      if (isFollowed is bool) {
        // sync follows via FollowingService if available in Get
        try {
          if (Get.isRegistered<FollowingService>()) {
            final followingService = Get.find<FollowingService>();
            followingService.syncFollowState(
              entityType: FollowEntityType.player,
              entityId: playerId,
              isFollowing: isFollowed,
            );
          }
        } catch (_) {
          // ignore if FollowingService not available at this layer
        }
      }
    } catch (_) {
      // ignore parse errors
    }
    final player = _readMap(playerItem['player']);
    final statistics = _readListOfMaps(playerItem['statistics']);

    final primaryStat = _pickPrimaryStatistic(statistics);
    final logoStat = _pickBestLeagueLogoStatistic(
      statistics,
      fallback: primaryStat,
    );
    final statsTotals = _aggregateStatistics(statistics);

    final team = _readMap(primaryStat['team']);
    final league = _readMap(logoStat['league']);

    final playerName = _string(player['name']);
    final teamName = _string(team['name']);
    final teamIdFromStats = _string(team['id']);
    final teamLogoUrl = _string(team['logo']);
    final playerPhoto = _string(player['photo']);

    final leagueName = _string(league['name']);
    final leagueLogoUrl = _string(league['logo']);
    final leagueFlagUrl = _string(league['flag']);

    final trophies = await fetchPlayerTrophies(playerId: playerId);
    final career = await fetchPlayerCareer(
      playerId: playerId,
      currentTeamName: teamName,
      currentTeamLogoUrl: teamLogoUrl,
      statsTotals: statsTotals,
    );

    final matchGroups = await fetchPlayerRecentMatches(
      playerId: playerId,
      season: season,
      teamId: _string(teamId).isNotEmpty ? _string(teamId) : teamIdFromStats,
      fallbackTeamName: teamName,
    );

    return PlayerProfileViewModel(
      id: playerId,
      playerName: playerName.isEmpty ? previous.playerName : playerName,
      teamName: teamName.isEmpty ? previous.teamName : teamName,
      teamLogoUrl: teamLogoUrl,
      leagueName: leagueName,
      leagueLogoUrl: leagueLogoUrl,
      leagueFlagUrl: leagueFlagUrl,
      avatarSeed: _seed(playerName.isEmpty ? previous.playerName : playerName),
      avatarImageUrl: playerPhoto,
      isFollowing: previous.isFollowing,
      selectedSeason: season,
      seasons: _buildSeasonOptions(season),
      topStatValue: _metric(
        _nested(statsTotals, const <String>['games', 'minutes']),
      ),
      topStatLabel: 'Minutes Played',
      facts: _buildFacts(player: player, primaryStat: primaryStat),
      summaryMetrics: _buildSummaryMetrics(statsTotals),
      traits: _buildTraits(statsTotals),
      trophies: trophies,
      matchGroups: matchGroups,
      statSections: _buildStatSections(statsTotals),
      seniorCareer: career,
      nationalCareer: _buildNationalCareer(player),
      hasLoadedOnce: true,
    );
  }

  Future<List<PlayerProfileMatchGroupUiModel>> fetchPlayerRecentMatches({
    required String playerId,
    required String season,
    required String teamId,
    required String fallbackTeamName,
    int lastFixtures = 6,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final cleanTeamId = teamId.trim();

      final data = await _fetchFootballData(
        '/football/players/$playerId/recent-matches',
        queryParameters: <String, dynamic>{
          'season': season,
          if (cleanTeamId.isNotEmpty) 'team': cleanTeamId,
          'last': lastFixtures,
          'page': page,
          'limit': limit,
        },
      );

      final items = _readListOfMaps(data['items']);
      final responseTeamIds = _readStringList(data['teamIds']);

      return _buildRecentMatchGroups(
        items,
        queryTeamId: cleanTeamId,
        responseTeamIds: responseTeamIds,
        fallbackTeamName: fallbackTeamName,
      );
    } catch (_) {
      return const <PlayerProfileMatchGroupUiModel>[];
    }
  }

  Future<List<PlayerProfileTrophyUiModel>> fetchPlayerTrophies({
    required String playerId,
  }) async {
    try {
      final data = await _fetchFootballData(
        '/football/trophies',
        queryParameters: <String, dynamic>{'player': playerId},
      );

      return _readListOfMaps(data['response'])
          .take(10)
          .map((item) {
            final title = _string(item['league']);
            final country = _string(item['country']);
            final season = _string(item['season']);
            final place = _string(item['place']);

            return PlayerProfileTrophyUiModel(
              title: title.isEmpty ? 'Trophy' : title,
              country: country.isEmpty ? '-' : country,
              season: season.isEmpty ? '-' : season,
              result: place.isEmpty ? 'Winner' : place,
              seed: _seed(title),
            );
          })
          .toList(growable: false);
    } catch (_) {
      return const <PlayerProfileTrophyUiModel>[];
    }
  }

  Future<List<PlayerCareerClubUiModel>> fetchPlayerCareer({
    required String playerId,
    required String currentTeamName,
    required String currentTeamLogoUrl,
    required Map<String, dynamic> statsTotals,
  }) async {
    final career = <PlayerCareerClubUiModel>[];

    if (currentTeamName.trim().isNotEmpty) {
      career.add(
        PlayerCareerClubUiModel(
          title: currentTeamName,
          rangeLabel: 'CURRENT CLUB',
          matches: _metric(
            _nested(statsTotals, const <String>['games', 'appearences']),
          ),
          goals: _metric(
            _nested(statsTotals, const <String>['goals', 'total']),
          ),
          seed: _seed(currentTeamName),
          logoUrl: currentTeamLogoUrl,
        ),
      );
    }

    try {
      final transferData = await _fetchFootballData(
        '/football/transfers',
        queryParameters: <String, dynamic>{'player': playerId},
      );

      final seenTeams = <String>{currentTeamName.toLowerCase().trim()};

      for (final item in _readListOfMaps(transferData['response'])) {
        final transfers = item['transfers'];
        if (transfers is! List) continue;

        for (final rawTransfer in transfers) {
          final transfer = _readMap(rawTransfer);
          final teams = _readMap(transfer['teams']);
          final inTeam = _readMap(teams['in']);
          final outTeam = _readMap(teams['out']);

          final inTeamName = _string(inTeam['name']);
          final outTeamName = _string(outTeam['name']);
          final clubName = inTeamName.isNotEmpty ? inTeamName : outTeamName;

          if (clubName.isEmpty) continue;

          final key = clubName.toLowerCase().trim();
          if (seenTeams.contains(key)) continue;
          seenTeams.add(key);

          final logoUrl = _string(inTeam['logo']).isNotEmpty
              ? _string(inTeam['logo'])
              : _string(outTeam['logo']);

          career.add(
            PlayerCareerClubUiModel(
              title: clubName,
              rangeLabel: _formatTransferLabel(
                date: _string(transfer['date']),
                type: _string(transfer['type']),
              ),
              matches: '-',
              goals: '-',
              seed: _seed(clubName),
              logoUrl: logoUrl,
            ),
          );
        }
      }
    } catch (_) {
      // Transfer API is optional for UI. Keep current club row.
    }

    return career;
  }

  Future<Map<String, dynamic>> _fetchFootballData(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      path,
      queryParameters: queryParameters,
      options: dio.Options(
        headers: <String, dynamic>{'Content-Type': 'application/json'},
      ),
    );

    final responseData = response.data;
    _ensureSuccess(responseData);

    final data = responseData?['data'];

    if (data is! Map) {
      throw Exception('missing_data');
    }

    return Map<String, dynamic>.from(data);
  }

  void _ensureSuccess(Map<String, dynamic>? responseData) {
    if (responseData == null) {
      throw Exception('empty_response');
    }

    final success = responseData['success'];

    if (success is bool && !success) {
      final message = responseData['message'];

      if (message is String && message.trim().isNotEmpty) {
        throw Exception(message.trim());
      }

      throw Exception('request_failed');
    }
  }

  Map<String, dynamic> _pickPrimaryStatistic(
    List<Map<String, dynamic>> statistics,
  ) {
    if (statistics.isEmpty) {
      return <String, dynamic>{};
    }

    Map<String, dynamic>? best;
    num bestAppearances = -1;
    num bestMinutes = -1;

    for (final stat in statistics) {
      final teamName = _string(_nested(stat, const <String>['team', 'name']));
      if (teamName.isEmpty) continue;

      final appearances = _num(
        _nested(stat, const <String>['games', 'appearences']),
      );
      final minutes = _num(_nested(stat, const <String>['games', 'minutes']));

      if (best == null ||
          appearances > bestAppearances ||
          (appearances == bestAppearances && minutes > bestMinutes)) {
        best = stat;
        bestAppearances = appearances;
        bestMinutes = minutes;
      }
    }

    return best ?? statistics.first;
  }

  Map<String, dynamic> _pickBestLeagueLogoStatistic(
    List<Map<String, dynamic>> statistics, {
    required Map<String, dynamic> fallback,
  }) {
    Map<String, dynamic>? best;
    num bestAppearances = -1;
    num bestMinutes = -1;

    for (final stat in statistics) {
      final leagueLogo = _string(
        _nested(stat, const <String>['league', 'logo']),
      );
      final leagueFlag = _string(
        _nested(stat, const <String>['league', 'flag']),
      );

      if (leagueLogo.isEmpty && leagueFlag.isEmpty) continue;

      final appearances = _num(
        _nested(stat, const <String>['games', 'appearences']),
      );
      final minutes = _num(_nested(stat, const <String>['games', 'minutes']));

      if (best == null ||
          appearances > bestAppearances ||
          (appearances == bestAppearances && minutes > bestMinutes)) {
        best = stat;
        bestAppearances = appearances;
        bestMinutes = minutes;
      }
    }

    return best ?? fallback;
  }

  Map<String, dynamic> _aggregateStatistics(
    List<Map<String, dynamic>> statistics,
  ) {
    num appearances = 0;
    num lineups = 0;
    num minutes = 0;

    num substitutesIn = 0;
    num substitutesOut = 0;
    num substitutesBench = 0;

    num shotsTotal = 0;
    num shotsOn = 0;

    num goalsTotal = 0;
    num assists = 0;
    num saves = 0;

    num passesTotal = 0;
    num passesKey = 0;

    num tacklesTotal = 0;
    num tacklesBlocks = 0;
    num tacklesInterceptions = 0;

    num duelsTotal = 0;
    num duelsWon = 0;

    num dribblesAttempts = 0;
    num dribblesSuccess = 0;
    num dribblesPast = 0;

    num foulsDrawn = 0;
    num foulsCommitted = 0;

    num cardsYellow = 0;
    num cardsRed = 0;

    num penaltyWon = 0;
    num penaltyScored = 0;
    num penaltyMissed = 0;
    num penaltySaved = 0;

    double accuracyWeightedSum = 0;
    double accuracyWeight = 0;

    for (final stat in statistics) {
      appearances += _num(
        _nested(stat, const <String>['games', 'appearences']),
      );
      lineups += _num(_nested(stat, const <String>['games', 'lineups']));
      minutes += _num(_nested(stat, const <String>['games', 'minutes']));

      substitutesIn += _num(_nested(stat, const <String>['substitutes', 'in']));
      substitutesOut += _num(
        _nested(stat, const <String>['substitutes', 'out']),
      );
      substitutesBench += _num(
        _nested(stat, const <String>['substitutes', 'bench']),
      );

      shotsTotal += _num(_nested(stat, const <String>['shots', 'total']));
      shotsOn += _num(_nested(stat, const <String>['shots', 'on']));

      goalsTotal += _num(_nested(stat, const <String>['goals', 'total']));
      assists += _num(_nested(stat, const <String>['goals', 'assists']));
      saves += _num(_nested(stat, const <String>['goals', 'saves']));

      final passTotal = _num(_nested(stat, const <String>['passes', 'total']));
      passesTotal += passTotal;
      passesKey += _num(_nested(stat, const <String>['passes', 'key']));

      final rawAccuracy = _nested(stat, const <String>['passes', 'accuracy']);
      final accuracyText = _string(rawAccuracy);

      if (passTotal > 0 && accuracyText.isNotEmpty) {
        final accuracyValue = _num(rawAccuracy);
        accuracyWeightedSum += accuracyValue * passTotal;
        accuracyWeight += passTotal;
      }

      tacklesTotal += _num(_nested(stat, const <String>['tackles', 'total']));
      tacklesBlocks += _num(_nested(stat, const <String>['tackles', 'blocks']));
      tacklesInterceptions += _num(
        _nested(stat, const <String>['tackles', 'interceptions']),
      );

      duelsTotal += _num(_nested(stat, const <String>['duels', 'total']));
      duelsWon += _num(_nested(stat, const <String>['duels', 'won']));

      dribblesAttempts += _num(
        _nested(stat, const <String>['dribbles', 'attempts']),
      );
      dribblesSuccess += _num(
        _nested(stat, const <String>['dribbles', 'success']),
      );
      dribblesPast += _num(_nested(stat, const <String>['dribbles', 'past']));

      foulsDrawn += _num(_nested(stat, const <String>['fouls', 'drawn']));
      foulsCommitted += _num(
        _nested(stat, const <String>['fouls', 'committed']),
      );

      cardsYellow += _num(_nested(stat, const <String>['cards', 'yellow']));
      cardsRed += _num(_nested(stat, const <String>['cards', 'red']));

      penaltyWon += _num(_nested(stat, const <String>['penalty', 'won']));
      penaltyScored += _num(_nested(stat, const <String>['penalty', 'scored']));
      penaltyMissed += _num(_nested(stat, const <String>['penalty', 'missed']));
      penaltySaved += _num(_nested(stat, const <String>['penalty', 'saved']));
    }

    final accuracy = accuracyWeight > 0
        ? (accuracyWeightedSum / accuracyWeight).round()
        : 0;

    return <String, dynamic>{
      'games': <String, dynamic>{
        'appearences': appearances,
        'lineups': lineups,
        'minutes': minutes,
      },
      'substitutes': <String, dynamic>{
        'in': substitutesIn,
        'out': substitutesOut,
        'bench': substitutesBench,
      },
      'shots': <String, dynamic>{'total': shotsTotal, 'on': shotsOn},
      'goals': <String, dynamic>{
        'total': goalsTotal,
        'assists': assists,
        'saves': saves,
      },
      'passes': <String, dynamic>{
        'total': passesTotal,
        'key': passesKey,
        'accuracy': accuracy,
      },
      'tackles': <String, dynamic>{
        'total': tacklesTotal,
        'blocks': tacklesBlocks,
        'interceptions': tacklesInterceptions,
      },
      'duels': <String, dynamic>{'total': duelsTotal, 'won': duelsWon},
      'dribbles': <String, dynamic>{
        'attempts': dribblesAttempts,
        'success': dribblesSuccess,
        'past': dribblesPast,
      },
      'fouls': <String, dynamic>{
        'drawn': foulsDrawn,
        'committed': foulsCommitted,
      },
      'cards': <String, dynamic>{'yellow': cardsYellow, 'red': cardsRed},
      'penalty': <String, dynamic>{
        'won': penaltyWon,
        'scored': penaltyScored,
        'missed': penaltyMissed,
        'saved': penaltySaved,
      },
    };
  }

  List<PlayerProfileFactUiModel> _buildFacts({
    required Map<String, dynamic> player,
    required Map<String, dynamic> primaryStat,
  }) {
    final nationality = _string(player['nationality']);
    final number = _string(
      _nested(primaryStat, const <String>['games', 'number']),
    );
    final height = _string(player['height']);
    final age = _string(player['age']);
    final birthDate = _string(_nested(player, const <String>['birth', 'date']));
    final position = _string(
      _nested(primaryStat, const <String>['games', 'position']),
    );

    return <PlayerProfileFactUiModel>[
      PlayerProfileFactUiModel(
        value: nationality.isEmpty ? '-' : _countrySeed(nationality),
        label: nationality.isEmpty ? 'Country' : nationality,
        isHighlighted: true,
      ),
      PlayerProfileFactUiModel(
        value: number.isEmpty ? '-' : number,
        label: 'Shirt No.',
        isHighlighted: true,
      ),
      PlayerProfileFactUiModel(
        value: _withUnitIfNumber(height, 'cm'),
        label: 'Height',
      ),
      PlayerProfileFactUiModel(
        value: age.isEmpty ? '-' : '$age years',
        label: birthDate.isEmpty ? 'Birth Date' : _formatBirthDate(birthDate),
      ),
      PlayerProfileFactUiModel(
        value: position.isEmpty ? '-' : position,
        label: 'Field Position',
        isHighlighted: true,
      ),
    ];
  }

  List<PlayerProfileMetricUiModel> _buildSummaryMetrics(
    Map<String, dynamic> stat,
  ) {
    return <PlayerProfileMetricUiModel>[
      PlayerProfileMetricUiModel(
        label: 'Matches',
        value: _metric(_nested(stat, const <String>['games', 'appearences'])),
      ),
      PlayerProfileMetricUiModel(
        label: 'Assists',
        value: _metric(_nested(stat, const <String>['goals', 'assists'])),
      ),
      PlayerProfileMetricUiModel(
        label: 'Goals',
        value: _metric(_nested(stat, const <String>['goals', 'total'])),
      ),
    ];
  }

  List<PlayerProfileTraitUiModel> _buildTraits(Map<String, dynamic> stat) {
    final goals = _num(_nested(stat, const <String>['goals', 'total']));
    final shots = _num(_nested(stat, const <String>['shots', 'total']));
    final keyPasses = _num(_nested(stat, const <String>['passes', 'key']));
    final passes = _num(_nested(stat, const <String>['passes', 'total']));

    final defensive =
        _num(_nested(stat, const <String>['tackles', 'total'])) +
        _num(_nested(stat, const <String>['tackles', 'blocks'])) +
        _num(_nested(stat, const <String>['tackles', 'interceptions']));

    final duelsTotal = _num(_nested(stat, const <String>['duels', 'total']));
    final duelsWon = _num(_nested(stat, const <String>['duels', 'won']));

    return <PlayerProfileTraitUiModel>[
      PlayerProfileTraitUiModel(
        label: 'DEFENSIVE CONTRIB.',
        value: _percent(defensive, 70),
        alignment: Alignment.topLeft,
      ),
      PlayerProfileTraitUiModel(
        label: 'GOALS',
        value: _percent(goals, 45),
        alignment: Alignment.topRight,
      ),
      PlayerProfileTraitUiModel(
        label: 'AERIAL WON',
        value: duelsTotal <= 0
            ? '0%'
            : '${((duelsWon / duelsTotal) * 100).round()}%',
        alignment: Alignment.centerLeft,
      ),
      PlayerProfileTraitUiModel(
        label: 'SHOT\nATTEMPTS',
        value: _percent(shots, 180),
        alignment: Alignment.centerRight,
      ),
      PlayerProfileTraitUiModel(
        label: 'CHANCES CREATED',
        value: _percent(keyPasses, 70),
        alignment: Alignment.bottomLeft,
      ),
      PlayerProfileTraitUiModel(
        label: 'TOUCHES',
        value: _percent(passes, 1300),
        alignment: Alignment.bottomRight,
      ),
    ];
  }

  List<PlayerProfileStatSectionUiModel> _buildStatSections(
    Map<String, dynamic> stat,
  ) {
    return <PlayerProfileStatSectionUiModel>[
      PlayerProfileStatSectionUiModel(
        title: 'GAMES',
        metrics: <PlayerProfileMetricUiModel>[
          _statMetric(
            'APPEARANCES',
            _nested(stat, const <String>['games', 'appearences']),
          ),
          _statMetric(
            'LINEUPS',
            _nested(stat, const <String>['games', 'lineups']),
          ),
          _statMetric(
            'MINUTES',
            _nested(stat, const <String>['games', 'minutes']),
          ),
          _statMetric(
            'BENCH',
            _nested(stat, const <String>['substitutes', 'bench']),
          ),
        ],
      ),
      PlayerProfileStatSectionUiModel(
        title: 'SHOOTING',
        metrics: <PlayerProfileMetricUiModel>[
          _statMetric('GOALS', _nested(stat, const <String>['goals', 'total'])),
          _statMetric(
            'ASSISTS',
            _nested(stat, const <String>['goals', 'assists']),
          ),
          _statMetric('SHOTS', _nested(stat, const <String>['shots', 'total'])),
          _statMetric(
            'SHOTS ON TARGET',
            _nested(stat, const <String>['shots', 'on']),
          ),
        ],
      ),
      PlayerProfileStatSectionUiModel(
        title: 'PASSING',
        metrics: <PlayerProfileMetricUiModel>[
          _statMetric(
            'TOTAL PASSES',
            _nested(stat, const <String>['passes', 'total']),
          ),
          _statMetric(
            'KEY PASSES',
            _nested(stat, const <String>['passes', 'key']),
          ),
          _statMetric(
            'ACCURACY',
            '${_metric(_nested(stat, const <String>['passes', 'accuracy']))}%',
          ),
        ],
      ),
      PlayerProfileStatSectionUiModel(
        title: 'POSSESSION',
        metrics: <PlayerProfileMetricUiModel>[
          _statMetric(
            'DUELS TOTAL',
            _nested(stat, const <String>['duels', 'total']),
          ),
          _statMetric(
            'DUELS WON',
            _nested(stat, const <String>['duels', 'won']),
          ),
          _statMetric(
            'DRIBBLES ATTEMPTED',
            _nested(stat, const <String>['dribbles', 'attempts']),
          ),
          _statMetric(
            'DRIBBLES SUCCESS',
            _nested(stat, const <String>['dribbles', 'success']),
          ),
        ],
      ),
      PlayerProfileStatSectionUiModel(
        title: 'DEFENDING',
        metrics: <PlayerProfileMetricUiModel>[
          _statMetric(
            'TACKLES',
            _nested(stat, const <String>['tackles', 'total']),
          ),
          _statMetric(
            'BLOCKS',
            _nested(stat, const <String>['tackles', 'blocks']),
          ),
          _statMetric(
            'INTERCEPTIONS',
            _nested(stat, const <String>['tackles', 'interceptions']),
          ),
        ],
      ),
      PlayerProfileStatSectionUiModel(
        title: 'FOULS',
        metrics: <PlayerProfileMetricUiModel>[
          _statMetric(
            'FOULS DRAWN',
            _nested(stat, const <String>['fouls', 'drawn']),
          ),
          _statMetric(
            'FOULS COMMITTED',
            _nested(stat, const <String>['fouls', 'committed']),
          ),
        ],
      ),
      PlayerProfileStatSectionUiModel(
        title: 'DISCIPLINE',
        metrics: <PlayerProfileMetricUiModel>[
          _statMetric(
            'YELLOW CARDS',
            _nested(stat, const <String>['cards', 'yellow']),
            valueColor: const Color(0xFFFFA500),
          ),
          _statMetric(
            'RED CARDS',
            _nested(stat, const <String>['cards', 'red']),
          ),
        ],
      ),
      PlayerProfileStatSectionUiModel(
        title: 'PENALTIES',
        metrics: <PlayerProfileMetricUiModel>[
          _statMetric(
            'PENALTY WON',
            _nested(stat, const <String>['penalty', 'won']),
          ),
          _statMetric(
            'PENALTY SCORED',
            _nested(stat, const <String>['penalty', 'scored']),
          ),
          _statMetric(
            'PENALTY MISSED',
            _nested(stat, const <String>['penalty', 'missed']),
          ),
        ],
      ),
    ];
  }

  List<PlayerProfileMatchGroupUiModel> _buildRecentMatchGroups(
    List<Map<String, dynamic>> items, {
    required String queryTeamId,
    required List<String> responseTeamIds,
    required String fallbackTeamName,
  }) {
    final groupOrder = <String>[];
    final groupTitles = <String, String>{};
    final groupSubtitles = <String, String>{};
    final groupLogos = <String, String>{};
    final groupMatches = <String, List<PlayerProfileMatchItemUiModel>>{};

    for (final item in items) {
      final fixturePayload = _readMap(item['fixture']);
      final fixture = _readMap(fixturePayload['fixture']);
      final league = _readMap(fixturePayload['league']);
      final teams = _readMap(fixturePayload['teams']);
      final homeTeam = _readMap(teams['home']);
      final awayTeam = _readMap(teams['away']);
      final goals = _readMap(fixturePayload['goals']);
      final player = _readMap(item['player']);

      final leagueId = _string(league['id']);
      final leagueName = _string(league['name']);
      final leagueCountry = _string(league['country']);
      final leagueRound = _string(league['round']);

      final groupKey = leagueId.isNotEmpty
          ? leagueId
          : (leagueName.isNotEmpty ? leagueName : _string(item['fixtureId']));

      if (!groupMatches.containsKey(groupKey)) {
        groupOrder.add(groupKey);
        groupTitles[groupKey] = leagueName.isEmpty
            ? 'Recent matches'
            : leagueName;

        groupSubtitles[groupKey] = [
          if (leagueCountry.isNotEmpty) leagueCountry,
          if (leagueRound.isNotEmpty) leagueRound,
        ].join(' • ');

        groupLogos[groupKey] = _string(league['logo']).isNotEmpty
            ? _string(league['logo'])
            : _string(league['flag']);

        groupMatches[groupKey] = <PlayerProfileMatchItemUiModel>[];
      }

      final homeId = _string(homeTeam['id']);
      final awayId = _string(awayTeam['id']);
      final homeName = _string(homeTeam['name']);
      final awayName = _string(awayTeam['name']);

      final playerTeamId = _resolvePlayerTeamId(
        homeId: homeId,
        awayId: awayId,
        queryTeamId: queryTeamId,
        responseTeamIds: responseTeamIds,
        fallbackTeamName: fallbackTeamName,
        homeName: homeName,
        awayName: awayName,
      );

      final isPlayerHomeTeam = playerTeamId.isNotEmpty
          ? playerTeamId == homeId
          : _sameText(fallbackTeamName, homeName);

      final opponent = isPlayerHomeTeam ? awayTeam : homeTeam;

      final homeGoals = _scoreValue(goals['home']);
      final awayGoals = _scoreValue(goals['away']);

      final statusShort = _string(
        _nested(fixture, const <String>['status', 'short']),
      );
      final statusLong = _string(
        _nested(fixture, const <String>['status', 'long']),
      );
      final statusLabel = statusShort.isNotEmpty ? statusShort : statusLong;

      final scoreLabel = [
        '$homeName $homeGoals - $awayGoals $awayName',
        if (statusLabel.isNotEmpty) statusLabel,
      ].join(' • ');

      groupMatches[groupKey]!.add(
        PlayerProfileMatchItemUiModel(
          dateLabel: _formatMatchDate(_string(fixture['date'])),
          competitionLabel: leagueRound.isNotEmpty
              ? leagueRound
              : (leagueName.isEmpty ? 'Match' : leagueName),
          opponentName: _string(opponent['name']).isEmpty
              ? 'Opponent unavailable'
              : _string(opponent['name']),
          opponentLogoUrl: _string(opponent['logo']),
          scoreLabel: scoreLabel,
          statLabel: _buildRecentMatchStatLabel(player),
          minuteLabel: _buildRecentMatchMetaLabel(player),
          eventChips: _readStringList(player['eventChips']),
          isGoalPositive:
              _num(player['goals']) > 0 || _num(player['assists']) > 0,
        ),
      );
    }

    return groupOrder
        .map(
          (key) => PlayerProfileMatchGroupUiModel(
            title: groupTitles[key] ?? 'Recent matches',
            subtitle: (groupSubtitles[key] ?? '').isEmpty
                ? 'Latest player appearances'
                : groupSubtitles[key]!,
            logoUrl: groupLogos[key] ?? '',
            matches:
                groupMatches[key] ?? const <PlayerProfileMatchItemUiModel>[],
          ),
        )
        .where((group) => group.matches.isNotEmpty)
        .toList(growable: false);
  }

  String _resolvePlayerTeamId({
    required String homeId,
    required String awayId,
    required String queryTeamId,
    required List<String> responseTeamIds,
    required String fallbackTeamName,
    required String homeName,
    required String awayName,
  }) {
    if (queryTeamId == homeId || queryTeamId == awayId) {
      return queryTeamId;
    }

    for (final id in responseTeamIds) {
      if (id == homeId || id == awayId) {
        return id;
      }
    }

    if (_sameText(fallbackTeamName, homeName)) {
      return homeId;
    }

    if (_sameText(fallbackTeamName, awayName)) {
      return awayId;
    }

    return homeId;
  }

  String _buildRecentMatchStatLabel(Map<String, dynamic> player) {
    final goals = _num(player['goals']).toInt();
    final assists = _num(player['assists']).toInt();
    final yellowCards = _num(player['yellowCards']).toInt();
    final redCards = _num(player['redCards']).toInt();
    final rating = _string(player['rating']);

    final parts = <String>[
      if (goals > 0) '${goals}G',
      if (assists > 0) '${assists}A',
      if (yellowCards > 0) '${yellowCards}YC',
      if (redCards > 0) '${redCards}RC',
    ];

    if (parts.isNotEmpty) {
      return parts.join(' • ');
    }

    if (rating.isNotEmpty) {
      return 'Rating $rating';
    }

    return 'Played';
  }

  String _buildRecentMatchMetaLabel(Map<String, dynamic> player) {
    final minutes = _num(player['minutes']).toInt();
    final rating = _string(player['rating']);
    final position = _string(player['position']);

    final parts = <String>[
      if (minutes > 0) '$minutes mins',
      if (rating.isNotEmpty) 'R $rating',
      if (position.isNotEmpty) position,
    ];

    return parts.isEmpty ? '-' : parts.join(' • ');
  }

  String _formatMatchDate(String rawDate) {
    final date = DateTime.tryParse(rawDate)?.toLocal();
    if (date == null) return rawDate.isEmpty ? '-' : rawDate;

    return '${_month(date.month).toUpperCase()} ${date.day}, ${date.year}';
  }

  String _scoreValue(dynamic value) {
    final text = _string(value);
    return text.isEmpty ? '-' : text;
  }

  List<PlayerCareerClubUiModel> _buildNationalCareer(
    Map<String, dynamic> player,
  ) {
    final nationality = _string(player['nationality']);

    if (nationality.isEmpty) {
      return const <PlayerCareerClubUiModel>[];
    }

    return <PlayerCareerClubUiModel>[
      PlayerCareerClubUiModel(
        title: nationality,
        rangeLabel: 'NATIONAL TEAM',
        matches: '-',
        goals: '-',
        seed: _countrySeed(nationality),
      ),
    ];
  }

  PlayerProfileMetricUiModel _statMetric(
    String label,
    dynamic value, {
    Color valueColor = const Color(0xFF39E0B3),
  }) {
    return PlayerProfileMetricUiModel(
      label: label,
      value: _metric(value),
      valueColor: valueColor,
    );
  }

  List<Map<String, dynamic>> _readListOfMaps(dynamic value) {
    if (value is! List) {
      return const <Map<String, dynamic>>[];
    }

    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList(growable: false);
  }

  List<String> _readStringList(dynamic value) {
    if (value is! List) {
      return const <String>[];
    }

    return value
        .map((item) => _string(item))
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }

  bool _sameText(String left, String right) {
    return left.trim().toLowerCase() == right.trim().toLowerCase();
  }

  Map<String, dynamic> _readMap(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return <String, dynamic>{};
  }

  dynamic _nested(Map<String, dynamic> json, List<String> keys) {
    dynamic current = json;

    for (final key in keys) {
      if (current is! Map) return null;
      current = current[key];
    }

    return current;
  }

  String _string(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text == 'null' ? '' : text;
  }

  String _metric(dynamic value) {
    if (value is num) {
      if (value % 1 == 0) return value.toInt().toString();
      return value.toStringAsFixed(1);
    }

    final text = _string(value);
    return text.isEmpty ? '0' : text;
  }

  num _num(dynamic value) {
    if (value is num) return value;
    return num.tryParse(value?.toString() ?? '') ?? 0;
  }

  String _percent(num value, num max) {
    if (max <= 0) return '0%';
    final percent = ((value / max) * 100).clamp(0, 100).round();
    return '$percent%';
  }

  String _withUnitIfNumber(String value, String unit) {
    final clean = value.trim();
    if (clean.isEmpty) return '-';

    if (RegExp(r'^\d+(\.\d+)?$').hasMatch(clean)) {
      return '$clean $unit';
    }

    return clean;
  }

  List<String> _buildSeasonOptions(String season) {
    final selected = int.tryParse(season) ?? DateTime.now().year;
    return List<String>.generate(6, (index) => '${selected - index}');
  }

  String _seed(String value) {
    final tokens = value
        .trim()
        .split(RegExp(r'\s+'))
        .where((token) => token.isNotEmpty)
        .toList(growable: false);

    if (tokens.isEmpty) return 'PL';

    if (tokens.length == 1) {
      final token = tokens.first;
      return token
          .substring(0, token.length >= 2 ? 2 : token.length)
          .toUpperCase();
    }

    return '${tokens.first[0]}${tokens.last[0]}'.toUpperCase();
  }

  String _countrySeed(String value) {
    final clean = value.trim();
    if (clean.isEmpty) return '-';
    return clean
        .substring(0, clean.length >= 3 ? 3 : clean.length)
        .toUpperCase();
  }

  String _formatBirthDate(String rawDate) {
    final date = DateTime.tryParse(rawDate);
    if (date == null) return rawDate;

    return '${_month(date.month)} ${date.day}, ${date.year}';
  }

  String _formatShortDate(String rawDate) {
    final date = DateTime.tryParse(rawDate);
    if (date == null) return rawDate.isEmpty ? '-' : rawDate;

    return '${_month(date.month).toUpperCase()} ${date.day}, ${date.year.toString().substring(2)}';
  }

  String _formatTransferLabel({required String date, required String type}) {
    final dateText = _formatShortDate(date);
    if (type.isEmpty) return dateText;
    return '$dateText • ${type.toUpperCase()}';
  }

  String _month(int month) {
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
}
