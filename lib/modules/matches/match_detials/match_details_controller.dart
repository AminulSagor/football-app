import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/api_client.dart';
import '../../../core/services/api_error_handler.dart';
import '../../../routes/routes.dart';
import '../model/matches_models.dart';
import 'models/match_details_model.dart';
import 'services/match_detials_service.dart';

class MatchDetailsController extends GetxController {
  final MatchDetialsService _service;

  MatchDetailsController({required MatchDetialsService service})
    : _service = service;

  final Rx<MatchDetailsScreenUiModel> state = _buildScreen(
    MatchDetailsScenario.finished,
  ).obs;

  final RxBool isHeadToHeadLoading = false.obs;
  final RxBool isHeadToHeadLoadingMore = false.obs;
  final RxBool canLoadMoreHeadToHead = false.obs;

  static const int _headToHeadPageSize = 5;

  String teamId = '12345';
  String _fixtureId = '';
  String _homeTeamId = '33';
  String _awayTeamId = '34';
  int _headToHeadLast = _headToHeadPageSize;

  MatchDetailsScenario get scenario => state.value.header.scenario;

  @override
  void onInit() {
    super.onInit();

    final argument = Get.arguments;
    MatchDetailsScenario selectedScenario = MatchDetailsScenario.finished;

    if (argument is String) {
      selectedScenario = _scenarioFrom(argument);
    } else if (argument is Map) {
      final raw = argument['scenario']?.toString() ?? 'finished';
      selectedScenario = _scenarioFrom(raw);
      _fixtureId = _argumentString(
        argument,
        const <String>['fixtureId', 'fixture_id', 'id'],
        _fixtureId,
      );
      _homeTeamId = _argumentString(
        argument,
        const <String>['homeTeamId', 'home_team_id', 'homeId'],
        _homeTeamId,
      );
      _awayTeamId = _argumentString(
        argument,
        const <String>['awayTeamId', 'away_team_id', 'awayId'],
        _awayTeamId,
      );
      teamId = _homeTeamId;
    }

    loadScenario(selectedScenario);
    _loadInitialDetails();
  }

  void onTeamNameTap([String? selectedTeamId]) {
    final nextTeamId = selectedTeamId?.trim();
    Get.toNamed(
      AppRoutes.teamProfile,
      arguments: nextTeamId == null || nextTeamId.isEmpty ? teamId : nextTeamId,
    );
  }

  void loadScenario(MatchDetailsScenario scenario) {
    state.value = _buildScreen(scenario);
  }

  Future<void> onHeadToHeadLoadMoreTap() async {
    if (isHeadToHeadLoading.value || isHeadToHeadLoadingMore.value) return;
    if (!canLoadMoreHeadToHead.value) return;

    await _loadHeadToHead(
      last: _headToHeadLast + _headToHeadPageSize,
      isLoadMore: true,
    );
  }

  Future<void> _loadHeadToHead({
    required int last,
    required bool isLoadMore,
  }) async {
    if (isLoadMore) {
      isHeadToHeadLoadingMore.value = true;
    } else {
      isHeadToHeadLoading.value = true;
      canLoadMoreHeadToHead.value = false;
      _headToHeadLast = _headToHeadPageSize;
      state.value = state.value.copyWith(
        headToHeadSummary: _emptyHeadToHeadSummary,
        headToHeadMatches: const <MatchDetailsHeadToHeadMatchUiModel>[],
      );
    }

    final previousCount = state.value.headToHeadMatches.length;
    final response = await ApiErrorHandler.handle<FootballFixturesDataModel>(
      () => _service.fetchHeadToHead(
        homeTeamId: _homeTeamId,
        awayTeamId: _awayTeamId,
        last: last,
      ),
      fallbackErrorCode: 'head_to_head_fetch_failed',
      userMessage: 'Unable to load head-to-head matches right now.',
    );

    if (isClosed) return;

    if (isLoadMore) {
      isHeadToHeadLoadingMore.value = false;
    } else {
      isHeadToHeadLoading.value = false;
    }

    if (!response.success || response.data == null) {
      if (!isLoadMore) {
        state.value = state.value.copyWith(
          headToHeadSummary: _emptyHeadToHeadSummary,
          headToHeadMatches: const <MatchDetailsHeadToHeadMatchUiModel>[],
        );
      }
      canLoadMoreHeadToHead.value = false;
      return;
    }

    final fixtures = response.data!.response;
    final matches = fixtures
        .map(_toHeadToHeadMatch)
        .toList(growable: false);

    _headToHeadLast = last;
    canLoadMoreHeadToHead.value =
        matches.length >= last && matches.length > previousCount;

    state.value = state.value.copyWith(
      headToHeadSummary: _buildHeadToHeadSummary(fixtures),
      headToHeadMatches: matches,
    );
  }


  Future<void> _loadInitialDetails() async {
    if (_fixtureId.isNotEmpty) {
      await _loadFixtureDetails();
    }

    if (_homeTeamId.trim().isNotEmpty && _awayTeamId.trim().isNotEmpty) {
      await _loadHeadToHead(last: _headToHeadPageSize, isLoadMore: false);
    }
  }

  Future<void> _loadFixtureDetails() async {
    final response = await ApiErrorHandler.handle<FootballFixtureModel>(
      () => _service.fetchFixtureById(fixtureId: _fixtureId),
      fallbackErrorCode: 'fixture_details_fetch_failed',
      userMessage: 'Unable to load match details right now.',
    );

    if (isClosed || !response.success || response.data == null) return;

    final fixture = response.data!;
    final homeId = fixture.teams.home.id?.toString() ?? '';
    final awayId = fixture.teams.away.id?.toString() ?? '';

    if (homeId.isNotEmpty) {
      _homeTeamId = homeId;
      teamId = homeId;
    }
    if (awayId.isNotEmpty) {
      _awayTeamId = awayId;
    }

    final nextScenario = _scenarioFromFixture(fixture);
    final base = _buildScreen(nextScenario);

    state.value = base.copyWith(
      header: _buildHeader(fixture, nextScenario),
      venue: _buildVenue(fixture),
      meta: _buildMeta(fixture),
      aboutText: _buildAboutText(fixture),
      lineup: _buildLineup(fixture, base.lineup),
      statsSections: _buildStatsSections(fixture, base.statsSections),
      factsTopStats: _buildStatsSections(fixture, base.factsTopStats),
    );
  }

  MatchDetailsScenario _scenarioFromFixture(FootballFixtureModel fixture) {
    final short = fixture.fixture.status.short.toUpperCase();
    if (short == 'NS' || short == 'TBD') return MatchDetailsScenario.upcoming;

    const finishedStatuses = <String>{
      'FT',
      'AET',
      'PEN',
      'CANC',
      'PST',
      'AWD',
      'WO',
    };
    if (finishedStatuses.contains(short)) return MatchDetailsScenario.finished;

    if (fixture.fixture.status.elapsed != null) return MatchDetailsScenario.live;

    const liveStatuses = <String>{'1H', 'HT', '2H', 'ET', 'BT', 'P', 'SUSP', 'INT'};
    if (liveStatuses.contains(short)) return MatchDetailsScenario.live;

    return MatchDetailsScenario.finished;
  }

  MatchDetailsHeaderUiModel _buildHeader(
    FootballFixtureModel fixture,
    MatchDetailsScenario scenario,
  ) {
    final kickoffAt = fixture.fixture.kickoffAt;

    return MatchDetailsHeaderUiModel(
      scenario: scenario,
      homeTeam: _toDetailsTeam(fixture.teams.home),
      awayTeam: _toDetailsTeam(fixture.teams.away),
      scoreOrTimeLabel: scenario == MatchDetailsScenario.upcoming
          ? _timeLabel12(kickoffAt)
          : '${fixture.goals.home ?? '-'} - ${fixture.goals.away ?? '-'}',
      statusChipLabel: scenario == MatchDetailsScenario.live
          ? 'Live'
          : scenario == MatchDetailsScenario.upcoming
          ? 'Upcoming'
          : _safeStatusLabel(fixture.fixture.status),
      statusText: scenario == MatchDetailsScenario.live
          ? _elapsedLabel(fixture.fixture.status)
          : fixture.fixture.status.long,
      metaDateTime: _dateTimeLabel(kickoffAt),
      metaCompetition: fixture.league.name.isNotEmpty
          ? fixture.league.name
          : fixture.league.country,
    );
  }

  MatchDetailsTeamUiModel _toDetailsTeam(FootballTeamModel team) {
    return MatchDetailsTeamUiModel(
      teamId: team.id?.toString() ?? '',
      name: team.name,
      shortName: _teamShortName(team.name),
      badgeColor: _teamBadgeColor(team.id),
      logoUrl: team.logo,
    );
  }

  MatchDetailsVenueUiModel _buildVenue(FootballFixtureModel fixture) {
    return MatchDetailsVenueUiModel(
      stadiumName: fixture.fixture.venue.name ?? '-',
      city: fixture.fixture.venue.city ?? '-',
      surface: 'Grass',
      mapLabel: 'Map',
    );
  }

  MatchDetailsMetaInfoUiModel _buildMeta(FootballFixtureModel fixture) {
    return MatchDetailsMetaInfoUiModel(
      dateTime: _dateTimeLabel(fixture.fixture.kickoffAt),
      competition: fixture.league.name.isNotEmpty
          ? fixture.league.name
          : fixture.league.country,
      referee: fixture.fixture.referee ?? '-',
      stage: fixture.league.round.isNotEmpty ? fixture.league.round : fixture.league.country,
    );
  }

  String _buildAboutText(FootballFixtureModel fixture) {
    final home = fixture.teams.home.name;
    final away = fixture.teams.away.name;
    final venue = fixture.fixture.venue.name;
    final city = fixture.fixture.venue.city;
    final competition = fixture.league.name.isNotEmpty
        ? fixture.league.name
        : fixture.league.country;
    final location = <String?>[venue, city]
        .where((item) => item != null && item.trim().isNotEmpty)
        .join(', ');

    return '$home faces $away${location.isEmpty ? '' : ' at $location'} on ${_dateTimeLabel(fixture.fixture.kickoffAt)}. This match is part of $competition.';
  }

  MatchDetailsLineupUiModel _buildLineup(
    FootballFixtureModel fixture,
    MatchDetailsLineupUiModel fallback,
  ) {
    if (fixture.lineups.length < 2) return fallback;

    final photos = _playerPhotoLookup(fixture);
    final homeLineup = _findLineup(fixture.lineups, fixture.teams.home.id) ?? fixture.lineups.first;
    final awayLineup = _findLineup(fixture.lineups, fixture.teams.away.id) ?? fixture.lineups.last;

    return MatchDetailsLineupUiModel(
      isPredicted: false,
      home: _toLineupTeamBlock(homeLineup, photos, isHome: true),
      away: _toLineupTeamBlock(awayLineup, photos, isHome: false),
      coaches: <MatchDetailsLineupPlayerUiModel>[
        _toCoachLineupPlayer(homeLineup.coach, 0.25),
        _toCoachLineupPlayer(awayLineup.coach, 0.75),
      ],
      substitutes: <MatchDetailsLineupPlayerUiModel>[
        ..._toPeopleList(homeLineup.substitutes, photos).take(5),
        ..._toPeopleList(awayLineup.substitutes, photos).take(5),
      ],
      bench: <MatchDetailsLineupPlayerUiModel>[
        ..._toPeopleList(homeLineup.substitutes.skip(5).toList(), photos).take(4),
        ..._toPeopleList(awayLineup.substitutes.skip(5).toList(), photos).take(4),
      ],
    );
  }

  FootballLineupModel? _findLineup(
    List<FootballLineupModel> lineups,
    int? teamId,
  ) {
    if (teamId == null) return null;
    for (final lineup in lineups) {
      if (lineup.team.id == teamId) return lineup;
    }
    return null;
  }

  Map<int, String> _playerPhotoLookup(FootballFixtureModel fixture) {
    final photos = <int, String>{};
    for (final teamPlayers in fixture.players) {
      for (final player in teamPlayers.players) {
        final id = player.player.id;
        final photo = player.player.photo;
        if (id != null && photo != null && photo.trim().isNotEmpty) {
          photos[id] = photo;
        }
      }
    }
    return photos;
  }

  MatchDetailsLineupTeamBlockUiModel _toLineupTeamBlock(
    FootballLineupModel lineup,
    Map<int, String> photos, {
    required bool isHome,
  }) {
    final rows = _gridRows(lineup.startXI);
    final players = lineup.startXI
        .map(
          (item) => _toLineupPlayer(
            item.player,
            photos,
            rows,
            lineup.team.colors,
            isHome: isHome,
          ),
        )
        .toList(growable: false);

    return MatchDetailsLineupTeamBlockUiModel(
      teamName: lineup.team.name,
      formation: lineup.formation,
      players: players,
      logoUrl: lineup.team.logo,
    );
  }

  Map<int, int> _gridRows(List<FootballLineupPlayerWrapperModel> players) {
    final rows = <int, int>{};
    for (final item in players) {
      final parsed = _parseGrid(item.player.grid);
      if (parsed == null) continue;
      final row = parsed.row;
      final column = parsed.column;
      final currentMax = rows[row] ?? 0;
      if (column > currentMax) rows[row] = column;
    }
    return rows;
  }

  MatchDetailsLineupPlayerUiModel _toLineupPlayer(
    FootballLineupPlayerModel player,
    Map<int, String> photos,
    Map<int, int> rowColumns,
    FootballTeamColorsModel? colors, {
    required bool isHome,
  }) {
    final parsedGrid = _parseGrid(player.grid);
    final row = parsedGrid?.row ?? 1;
    final column = parsedGrid?.column ?? 1;
    final maxColumn = rowColumns[row] ?? 1;
    final maxRow = rowColumns.keys.isEmpty
        ? 5
        : rowColumns.keys.reduce((value, element) => value > element ? value : element);

    final rawY = row / (maxRow + 1);
    final y = isHome ? rawY : 1 - rawY;
    final circleHex = player.pos.toUpperCase() == 'G'
        ? colors?.goalkeeper.primary
        : colors?.player.primary;

    final playerId = player.id;

    return MatchDetailsLineupPlayerUiModel(
      x: column / (maxColumn + 1),
      y: y.clamp(0.06, 0.94).toDouble(),
      name: _compactPlayerName(player.name),
      subtitle: player.number == null ? player.pos : '#${player.number} • ${player.pos}',
      photoUrl: playerId == null ? null : photos[playerId],
      circleColor: _colorFromApiHex(circleHex, const Color(0xFF2FBC8D)),
    );
  }

  List<MatchDetailsLineupPlayerUiModel> _toPeopleList(
    List<FootballLineupPlayerWrapperModel> players,
    Map<int, String> photos,
  ) {
    return players
        .map(
          (item) {
            final playerId = item.player.id;
            return MatchDetailsLineupPlayerUiModel(
              x: 0,
              y: 0,
              name: item.player.name,
              subtitle: item.player.number == null
                  ? item.player.pos
                  : '#${item.player.number} • ${item.player.pos}',
              photoUrl: playerId == null ? null : photos[playerId],
            );
          },
        )
        .toList(growable: false);
  }

  MatchDetailsLineupPlayerUiModel _toCoachLineupPlayer(
    FootballCoachModel coach,
    double x,
  ) {
    return MatchDetailsLineupPlayerUiModel(
      x: x,
      y: 0,
      name: coach.name.isEmpty ? 'Coach' : coach.name,
      subtitle: 'Coach',
      photoUrl: coach.photo,
    );
  }

  _GridPosition? _parseGrid(String? grid) {
    if (grid == null || !grid.contains(':')) return null;
    final parts = grid.split(':');
    if (parts.length != 2) return null;
    final row = int.tryParse(parts[0]);
    final column = int.tryParse(parts[1]);
    if (row == null || column == null) return null;
    return _GridPosition(row: row, column: column);
  }

  List<MatchDetailsStatSectionUiModel> _buildStatsSections(
    FootballFixtureModel fixture,
    List<MatchDetailsStatSectionUiModel> fallback,
  ) {
    if (fixture.statistics.length < 2) return fallback;

    final homeStats = fixture.statistics.first.statistics;
    final awayStats = fixture.statistics.last.statistics;
    final labels = <String>[
      'Ball Possession',
      'Total Shots',
      'Shots on Goal',
      'Shots off Goal',
      'Corner Kicks',
      'Fouls',
      'Yellow Cards',
      'Red Cards',
      'Passes accurate',
    ];

    return <MatchDetailsStatSectionUiModel>[
      MatchDetailsStatSectionUiModel(
        title: 'Top stats',
        showPossessionBar: true,
        rows: labels
            .map(
              (label) => MatchDetailsStatRowUiModel(
                label: _statLabel(label),
                homeValue: _statValue(homeStats, label),
                awayValue: _statValue(awayStats, label),
              ),
            )
            .toList(growable: false),
      ),
    ];
  }

  String _statValue(List<FootballStatisticItemModel> items, String type) {
    for (final item in items) {
      if (item.type == type) return item.value?.toString() ?? '-';
    }
    return '-';
  }

  String _statLabel(String value) {
    if (value.isEmpty) return value;
    return '${value[0].toUpperCase()}${value.substring(1).replaceAll('_', ' ')}';
  }

  MatchDetailsScenario _scenarioFrom(String value) {
    switch (value.toLowerCase()) {
      case 'live':
        return MatchDetailsScenario.live;
      case 'upcoming':
        return MatchDetailsScenario.upcoming;
      default:
        return MatchDetailsScenario.finished;
    }
  }

  String _argumentString(
    Map<dynamic, dynamic> argument,
    List<String> keys,
    String fallback,
  ) {
    for (final key in keys) {
      final value = argument[key]?.toString().trim();
      if (value != null && value.isNotEmpty) {
        return value;
      }
    }

    return fallback;
  }

  MatchDetailsHeadToHeadSummaryUiModel _buildHeadToHeadSummary(
    List<FootballFixtureModel> fixtures,
  ) {
    var homeWins = 0;
    var draws = 0;
    var awayWins = 0;

    for (final fixture in fixtures) {
      final homeGoals = fixture.goals.home;
      final awayGoals = fixture.goals.away;

      if (homeGoals == null || awayGoals == null) continue;

      if (homeGoals == awayGoals) {
        draws++;
        continue;
      }

      final winnerId = homeGoals > awayGoals
          ? fixture.teams.home.id
          : fixture.teams.away.id;
      final winnerTeamId = winnerId?.toString() ?? '';

      if (winnerTeamId == _homeTeamId) {
        homeWins++;
      } else if (winnerTeamId == _awayTeamId) {
        awayWins++;
      }
    }

    return MatchDetailsHeadToHeadSummaryUiModel(
      homeWins: homeWins,
      draws: draws,
      awayWins: awayWins,
    );
  }

  MatchDetailsHeadToHeadMatchUiModel _toHeadToHeadMatch(
    FootballFixtureModel fixture,
  ) {
    final kickoffAt = fixture.fixture.kickoffAt;
    final isUpcoming = _isUpcomingFixture(fixture);
    final homeGoals = fixture.goals.home;
    final awayGoals = fixture.goals.away;

    return MatchDetailsHeadToHeadMatchUiModel(
      dateLabel: _dateLabel(kickoffAt),
      competitionLabel: fixture.league.name.isNotEmpty
          ? fixture.league.name
          : fixture.league.country,
      homeTeamName: fixture.teams.home.name,
      awayTeamName: fixture.teams.away.name,
      centerLabel: isUpcoming
          ? _timeLabel12(kickoffAt)
          : '${homeGoals ?? '-'} - ${awayGoals ?? '-'}',
      isUpcoming: isUpcoming,
      homeLogoUrl: fixture.teams.home.logo,
      awayLogoUrl: fixture.teams.away.logo,
    );
  }

  bool _isUpcomingFixture(FootballFixtureModel fixture) {
    final short = fixture.fixture.status.short.toUpperCase();
    return short == 'NS' || short == 'TBD';
  }

  String _dateLabel(DateTime? value) {
    if (value == null) return '-';

    final month = _monthName(value.month);
    final currentYear = DateTime.now().year;
    if (value.year == currentYear) {
      return '${value.day} $month';
    }

    return '${value.day} $month ${value.year}';
  }

  String _timeLabel12(DateTime? value) {
    if (value == null) return '-';

    final period = value.hour >= 12 ? 'PM' : 'AM';
    final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
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


  String _dateTimeLabel(DateTime? value) {
    if (value == null) return '-';
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '${value.day} ${_monthName(value.month)} ${value.year}, $hour:$minute';
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

  String _compactPlayerName(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length <= 1) return name;
    return parts.last;
  }

  Color _teamBadgeColor(int? id) {
    const palette = <Color>[
      Color(0xFF2A4FB4),
      Color(0xFF0D8662),
      Color(0xFFA23C4A),
      Color(0xFFB89A4C),
      Color(0xFF2E5A96),
      Color(0xFF8C3D2D),
      Color(0xFF294D93),
    ];
    final safeId = id ?? 0;
    return palette[safeId.abs() % palette.length];
  }

  Color _colorFromApiHex(String? value, Color fallback) {
    final hex = value?.replaceAll('#', '').trim();
    if (hex == null || (hex.length != 6 && hex.length != 8)) return fallback;
    final normalized = hex.length == 6 ? 'FF$hex' : hex;
    final parsed = int.tryParse(normalized, radix: 16);
    return parsed == null ? fallback : Color(parsed);
  }

  static const MatchDetailsTeamUiModel _barcelona = MatchDetailsTeamUiModel(
    name: 'Barcelona',
    shortName: 'BAR',
    badgeColor: Color(0xFF7D1F1F),
  );

  static const MatchDetailsTeamUiModel _atletico = MatchDetailsTeamUiModel(
    name: 'Atletico Madrid',
    shortName: 'ATM',
    badgeColor: Color(0xFF274C93),
  );

  static const MatchDetailsVenueUiModel _venue = MatchDetailsVenueUiModel(
    stadiumName: 'Spotify Camp Nou',
    city: 'Barcelona, Spain',
    surface: 'Grass',
    mapLabel: 'Map',
  );

  static const MatchDetailsMetaInfoUiModel _meta = MatchDetailsMetaInfoUiModel(
    dateTime: 'Thu 15 April, 01:00',
    competition: 'Champions League Quarter-final',
    referee: 'István Kovács',
    stage: 'Champions League',
  );

  static const MatchDetailsTopScorerCompareUiModel _topScorers =
      MatchDetailsTopScorerCompareUiModel(
        title: 'Top scorers',
        competitionLabel: 'Champions League',
        homePlayerName: 'Player',
        awayPlayerName: 'Player',
        metrics: <MatchDetailsCompareMetricUiModel>[
          MatchDetailsCompareMetricUiModel(
            label: 'GOALS',
            homeValue: '5',
            awayValue: '8',
          ),
          MatchDetailsCompareMetricUiModel(
            label: 'ASSISTS',
            homeValue: '4',
            awayValue: '4',
          ),
          MatchDetailsCompareMetricUiModel(
            label: 'MATCHES PLAYED',
            homeValue: '11',
            awayValue: '12',
          ),
        ],
      );

  static const MatchDetailsTeamFormUiModel _teamForm = MatchDetailsTeamFormUiModel(
    title: 'Team form',
    homeResults: <String>['1 - 0', '1 - 0', '7 - 2'],
    awayResults: <String>['1 - 2', '3 - 2', '3 - 2'],
  );

  static const String _aboutText =
      'Barcelona faces Atletico Madrid at Spotify Camp Nou on Wed, Apr 8, 2026, 19:00 UTC. '
      'This match is part of the Champions League. You can check the recent head-to-head encounters, '
      'as well as full H2H record on this page to see how Barcelona and Atletico Madrid have fared '
      'against each other in the past. On FotMob, you can follow the Barcelona vs Atletico Madrid '
      'live score with a full set of details.';

  static const MatchDetailsPlayerOfMatchUiModel _playerOfTheMatch =
      MatchDetailsPlayerOfMatchUiModel(
        name: 'Juan Musso',
        teamName: 'ATLETICO MADRID',
      );

  static const List<MatchDetailsStatSectionUiModel> _factsTopStats =
      <MatchDetailsStatSectionUiModel>[
        MatchDetailsStatSectionUiModel(
          title: 'Top stats',
          showPossessionBar: true,
          rows: <MatchDetailsStatRowUiModel>[
            MatchDetailsStatRowUiModel(
              label: 'Ball possession',
              homeValue: '58%',
              awayValue: '42%',
            ),
            MatchDetailsStatRowUiModel(
              label: 'Total shots',
              homeValue: '18',
              awayValue: '5',
            ),
            MatchDetailsStatRowUiModel(
              label: 'Big chances',
              homeValue: '2',
              awayValue: '1',
            ),
          ],
        ),
      ];

  static const List<MatchDetailsEventUiModel> _events =
      <MatchDetailsEventUiModel>[
        MatchDetailsEventUiModel(
          minute: '31’',
          isHomeSide: false,
          type: MatchDetailsEventType.substitution,
          primaryText: 'Marc Pubill',
          secondaryText: 'Dávid Hancko',
          emphasizePrimary: true,
        ),
        MatchDetailsEventUiModel(
          minute: '31’',
          isHomeSide: false,
          type: MatchDetailsEventType.yellowCard,
          primaryText: 'Koke',
        ),
        MatchDetailsEventUiModel(
          minute: '42’',
          isHomeSide: true,
          type: MatchDetailsEventType.info,
          primaryText: 'Yellow card cancelled',
          secondaryText: 'Pau Cubarsí',
        ),
        MatchDetailsEventUiModel(
          minute: '44’',
          isHomeSide: true,
          type: MatchDetailsEventType.redCard,
          primaryText: 'Pau Cubarsí',
        ),
        MatchDetailsEventUiModel(
          minute: '45’',
          isHomeSide: false,
          type: MatchDetailsEventType.goal,
          primaryText: 'Julián Álvarez (0 - 1)',
          secondaryText: 'Direct free kick',
        ),
        MatchDetailsEventUiModel(
          minute: '46’',
          isHomeSide: true,
          type: MatchDetailsEventType.substitution,
          primaryText: 'Fermín López',
          secondaryText: 'Robert Lewandowski',
          emphasizePrimary: true,
        ),
        MatchDetailsEventUiModel(
          minute: '70’',
          isHomeSide: false,
          type: MatchDetailsEventType.goal,
          primaryText: 'Alexander Sørloth (0 - 2)',
          assistText: 'assist by Matteo Ruggeri',
        ),
      ];

  static const List<MatchDetailsTimelineMarkerUiModel> _timelineMarkers =
      <MatchDetailsTimelineMarkerUiModel>[
        MatchDetailsTimelineMarkerUiModel(label: 'HT 0 - 1'),
        MatchDetailsTimelineMarkerUiModel(label: 'FT 0 - 2'),
      ];

  static const List<MatchDetailsNextMatchUiModel> _nextMatches =
      <MatchDetailsNextMatchUiModel>[
        MatchDetailsNextMatchUiModel(
          title: 'Champions League Final Stage',
          timeLabel: '01:00',
          statusText: 'Tomorrow',
          homeTeam: _barcelona,
          awayTeam: _atletico,
        ),
        MatchDetailsNextMatchUiModel(
          title: 'Champions League Final Stage',
          timeLabel: '01:00',
          statusText: 'Tomorrow',
          homeTeam: _barcelona,
          awayTeam: _atletico,
        ),
      ];

  static const List<MatchDetailsStatSectionUiModel> _statsSections =
      <MatchDetailsStatSectionUiModel>[
        MatchDetailsStatSectionUiModel(
          title: 'Top stats',
          showPossessionBar: true,
          rows: <MatchDetailsStatRowUiModel>[
            MatchDetailsStatRowUiModel(
              label: 'Ball possession',
              homeValue: '58%',
              awayValue: '42%',
            ),
            MatchDetailsStatRowUiModel(
              label: 'Total shots',
              homeValue: '18',
              awayValue: '5',
            ),
            MatchDetailsStatRowUiModel(
              label: 'Shots on target',
              homeValue: '2',
              awayValue: '1',
            ),
            MatchDetailsStatRowUiModel(
              label: 'Big chances',
              homeValue: '2',
              awayValue: '1',
            ),
            MatchDetailsStatRowUiModel(
              label: 'Fouls committed',
              homeValue: '2',
              awayValue: '1',
            ),
            MatchDetailsStatRowUiModel(
              label: 'Corners',
              homeValue: '2',
              awayValue: '1',
            ),
          ],
        ),
        MatchDetailsStatSectionUiModel(
          title: 'Shots',
          rows: <MatchDetailsStatRowUiModel>[
            MatchDetailsStatRowUiModel(
              label: 'Total shots',
              homeValue: '18',
              awayValue: '5',
            ),
            MatchDetailsStatRowUiModel(
              label: 'Shots off target',
              homeValue: '2',
              awayValue: '1',
            ),
            MatchDetailsStatRowUiModel(
              label: 'Shots on target',
              homeValue: '2',
              awayValue: '1',
            ),
            MatchDetailsStatRowUiModel(
              label: 'Blocked shots',
              homeValue: '2',
              awayValue: '1',
            ),
            MatchDetailsStatRowUiModel(
              label: 'Hit woodwork',
              homeValue: '2',
              awayValue: '1',
            ),
            MatchDetailsStatRowUiModel(
              label: 'Shots inside box',
              homeValue: '2',
              awayValue: '1',
            ),
            MatchDetailsStatRowUiModel(
              label: 'Shots outside box',
              homeValue: '2',
              awayValue: '1',
            ),
          ],
        ),
        MatchDetailsStatSectionUiModel(
          title: 'Discipline',
          rows: <MatchDetailsStatRowUiModel>[
            MatchDetailsStatRowUiModel(
              label: 'Yellow Cards',
              homeValue: '1',
              awayValue: '3',
            ),
            MatchDetailsStatRowUiModel(
              label: 'Red Cards',
              homeValue: '1',
              awayValue: '0',
            ),
          ],
        ),
        MatchDetailsStatSectionUiModel(
          title: '',
          rows: <MatchDetailsStatRowUiModel>[
            MatchDetailsStatRowUiModel(
              label: 'Passes',
              homeValue: '2',
              awayValue: '1',
            ),
          ],
        ),
        MatchDetailsStatSectionUiModel(
          title: '',
          rows: <MatchDetailsStatRowUiModel>[
            MatchDetailsStatRowUiModel(
              label: 'Throws',
              homeValue: '2',
              awayValue: '1',
            ),
          ],
        ),
        MatchDetailsStatSectionUiModel(
          title: '',
          rows: <MatchDetailsStatRowUiModel>[
            MatchDetailsStatRowUiModel(
              label: 'Offside',
              homeValue: '2',
              awayValue: '1',
            ),
          ],
        ),
        MatchDetailsStatSectionUiModel(
          title: 'Defence',
          rows: <MatchDetailsStatRowUiModel>[
            MatchDetailsStatRowUiModel(
              label: 'Tackles',
              homeValue: '1',
              awayValue: '3',
            ),
            MatchDetailsStatRowUiModel(
              label: 'Interceptions',
              homeValue: '1',
              awayValue: '0',
            ),
            MatchDetailsStatRowUiModel(
              label: 'Blocks',
              homeValue: '1',
              awayValue: '0',
            ),
          ],
        ),
      ];

  static const MatchDetailsHeadToHeadSummaryUiModel _emptyHeadToHeadSummary =
      MatchDetailsHeadToHeadSummaryUiModel(
        homeWins: 0,
        draws: 0,
        awayWins: 0,
      );

  static const MatchDetailsHeadToHeadSummaryUiModel _headToHeadSummary =
      _emptyHeadToHeadSummary;

  static const List<MatchDetailsHeadToHeadMatchUiModel> _headToHeadMatches =
      <MatchDetailsHeadToHeadMatchUiModel>[];

  static const MatchDetailsLineupUiModel _lineup = MatchDetailsLineupUiModel(
    isPredicted: true,
    home: MatchDetailsLineupTeamBlockUiModel(
      teamName: 'Barcelona',
      formation: '4-2-3-1',
      players: <MatchDetailsLineupPlayerUiModel>[
        MatchDetailsLineupPlayerUiModel(
          x: 0.50,
          y: 0.12,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.15,
          y: 0.24,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.38,
          y: 0.24,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.62,
          y: 0.24,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.85,
          y: 0.24,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.28,
          y: 0.38,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.72,
          y: 0.38,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.15,
          y: 0.53,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.50,
          y: 0.53,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.85,
          y: 0.53,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.50,
          y: 0.67,
          name: 'Player',
          subtitle: '',
        ),
      ],
    ),
    away: MatchDetailsLineupTeamBlockUiModel(
      teamName: 'Atletico Madrid',
      formation: '4-4-2',
      players: <MatchDetailsLineupPlayerUiModel>[
        MatchDetailsLineupPlayerUiModel(
          x: 0.30,
          y: 0.16,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.70,
          y: 0.16,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.15,
          y: 0.30,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.38,
          y: 0.30,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.62,
          y: 0.30,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.85,
          y: 0.30,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.15,
          y: 0.47,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.38,
          y: 0.47,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.62,
          y: 0.47,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.85,
          y: 0.47,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.50,
          y: 0.65,
          name: 'Player',
          subtitle: '',
        ),
      ],
    ),
    coaches: <MatchDetailsLineupPlayerUiModel>[
      MatchDetailsLineupPlayerUiModel(
        x: 0.20,
        y: 0.50,
        name: 'Player',
        subtitle: '',
      ),
      MatchDetailsLineupPlayerUiModel(
        x: 0.80,
        y: 0.50,
        name: 'Player',
        subtitle: '',
      ),
    ],
    substitutes: <MatchDetailsLineupPlayerUiModel>[
      MatchDetailsLineupPlayerUiModel(
        x: 0.25,
        y: 0.18,
        name: 'Player',
        subtitle: 'Defender',
      ),
      MatchDetailsLineupPlayerUiModel(
        x: 0.75,
        y: 0.18,
        name: 'Player',
        subtitle: 'Defender',
      ),
      MatchDetailsLineupPlayerUiModel(
        x: 0.25,
        y: 0.50,
        name: 'Player',
        subtitle: 'Defender',
      ),
      MatchDetailsLineupPlayerUiModel(
        x: 0.75,
        y: 0.50,
        name: 'Player',
        subtitle: 'Defender',
      ),
      MatchDetailsLineupPlayerUiModel(
        x: 0.25,
        y: 0.82,
        name: 'Player',
        subtitle: 'Defender',
      ),
      MatchDetailsLineupPlayerUiModel(
        x: 0.75,
        y: 0.82,
        name: 'Player',
        subtitle: 'Defender',
      ),
    ],
    bench: <MatchDetailsLineupPlayerUiModel>[
      MatchDetailsLineupPlayerUiModel(
        x: 0.25,
        y: 0.25,
        name: 'Player',
        subtitle: 'Defender',
      ),
      MatchDetailsLineupPlayerUiModel(
        x: 0.75,
        y: 0.25,
        name: 'Player',
        subtitle: 'Defender',
      ),
      MatchDetailsLineupPlayerUiModel(
        x: 0.25,
        y: 0.70,
        name: 'Player',
        subtitle: 'Defender',
      ),
      MatchDetailsLineupPlayerUiModel(
        x: 0.75,
        y: 0.70,
        name: 'Player',
        subtitle: 'Defender',
      ),
    ],
  );

  static const MatchDetailsKnockoutUiModel _knockout = MatchDetailsKnockoutUiModel(
    topRoundOne: <MatchDetailsKnockoutNodeUiModel>[
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'ASM',
        awaySeed: 'PSG',
        score: '4 - 5',
      ),
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'GAL',
        awaySeed: 'JUV',
        score: '7 - 5',
      ),
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'BEN',
        awaySeed: 'RMA',
        score: '1 - 3',
      ),
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'BVB',
        awaySeed: 'ATA',
        score: '3 - 4',
      ),
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'PSG',
        awaySeed: 'CHE',
        score: '8 - 2',
      ),
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'GAL',
        awaySeed: 'LIV',
        score: '1 - 4',
      ),
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'RMA',
        awaySeed: 'MCI',
        score: '5 - 1',
      ),
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'ATA',
        awaySeed: 'FCB',
        score: '2 - 10',
      ),
    ],
    topRoundTwo: <MatchDetailsKnockoutNodeUiModel>[
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'PSG',
        awaySeed: 'LIV',
        score: '2 - 0',
      ),
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'RMA',
        awaySeed: 'FCB',
        score: '1 - 2',
      ),
    ],
    upperCenter: MatchDetailsKnockoutCenterUiModel(
      dateLabel: '28 Apr',
      statusLabel: 'TBD',
    ),
    finalCenter: MatchDetailsKnockoutCenterUiModel(
      dateLabel: '30 May',
      statusLabel: 'FINAL',
      isFinalHighlight: true,
    ),
    lowerCenter: MatchDetailsKnockoutCenterUiModel(
      dateLabel: '29 Apr',
      statusLabel: 'TBD',
    ),
    bottomRoundTwo: <MatchDetailsKnockoutNodeUiModel>[
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'BAR',
        awaySeed: 'ATM',
        score: '0 - 2',
        isHighlighted: true,
      ),
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'SCP',
        awaySeed: 'ARS',
        score: '0 - 1',
      ),
    ],
    bottomRoundOne: <MatchDetailsKnockoutNodeUiModel>[
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'NEW',
        awaySeed: 'BAR',
        score: '3 - 8',
      ),
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'ATM',
        awaySeed: 'TOT',
        score: '7 - 5',
      ),
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'BOD',
        awaySeed: 'SCP',
        score: '3 - 5',
      ),
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'BO4',
        awaySeed: 'ARS',
        score: '1 - 3',
      ),
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'QRB',
        awaySeed: 'NEW',
        score: '3 - 9',
      ),
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'CLB',
        awaySeed: 'ATM',
        score: '4 - 7',
      ),
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'BOD',
        awaySeed: 'INT',
        score: '5 - 2',
      ),
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'OLY',
        awaySeed: 'BO4',
        score: '0 - 2',
      ),
    ],
  );

  static MatchDetailsScreenUiModel _buildScreen(
    MatchDetailsScenario scenario,
  ) {
    switch (scenario) {
      case MatchDetailsScenario.live:
        return MatchDetailsScreenUiModel(
          title: 'Match Details',
          header: MatchDetailsHeaderUiModel(
            scenario: scenario,
            homeTeam: _barcelona,
            awayTeam: _atletico,
            scoreOrTimeLabel: '0-0',
            statusChipLabel: 'Live',
            statusText: '',
            metaDateTime: 'Thu 15 April, 01:00',
            metaCompetition: 'Champions League',
          ),
          visibleTabs: const <MatchDetailsTabType>[
            MatchDetailsTabType.preview,
            MatchDetailsTabType.lineup,
            MatchDetailsTabType.knockout,
            MatchDetailsTabType.headToHead,
          ],
          venue: _venue,
          meta: _meta,
          topScorers: null,
          teamForm: _teamForm,
          aboutText: _aboutText,
          playerOfTheMatch: null,
          factsTopStats: const <MatchDetailsStatSectionUiModel>[],
          events: const <MatchDetailsEventUiModel>[],
          timelineMarkers: const <MatchDetailsTimelineMarkerUiModel>[],
          nextMatches: const <MatchDetailsNextMatchUiModel>[],
          statsSections: const <MatchDetailsStatSectionUiModel>[],
          headToHeadSummary: _headToHeadSummary,
          headToHeadMatches: _headToHeadMatches,
          lineup: _lineup,
          knockout: _knockout,
        );
      case MatchDetailsScenario.upcoming:
        return MatchDetailsScreenUiModel(
          title: 'Match Details',
          header: MatchDetailsHeaderUiModel(
            scenario: scenario,
            homeTeam: _barcelona,
            awayTeam: _atletico,
            scoreOrTimeLabel: '01:00',
            statusChipLabel: 'Agg 0 - 2',
            statusText: 'Tomorrow',
            metaDateTime: 'Thu 15 April, 01:00',
            metaCompetition: 'Champions League',
          ),
          visibleTabs: const <MatchDetailsTabType>[
            MatchDetailsTabType.preview,
            MatchDetailsTabType.lineup,
            MatchDetailsTabType.knockout,
            MatchDetailsTabType.headToHead,
          ],
          venue: _venue,
          meta: _meta,
          topScorers: _topScorers,
          teamForm: _teamForm,
          aboutText: _aboutText,
          playerOfTheMatch: null,
          factsTopStats: const <MatchDetailsStatSectionUiModel>[],
          events: const <MatchDetailsEventUiModel>[],
          timelineMarkers: const <MatchDetailsTimelineMarkerUiModel>[],
          nextMatches: const <MatchDetailsNextMatchUiModel>[],
          statsSections: const <MatchDetailsStatSectionUiModel>[],
          headToHeadSummary: _headToHeadSummary,
          headToHeadMatches: _headToHeadMatches,
          lineup: _lineup,
          knockout: _knockout,
        );
      case MatchDetailsScenario.finished:
        return MatchDetailsScreenUiModel(
          title: 'Match Details',
          header: MatchDetailsHeaderUiModel(
            scenario: scenario,
            homeTeam: _barcelona,
            awayTeam: _atletico,
            scoreOrTimeLabel: '0 - 2',
            statusChipLabel: '1st leg',
            statusText: 'Full time',
            metaDateTime: 'Thu 9 April, 01:00',
            metaCompetition: 'Champions League',
          ),
          visibleTabs: const <MatchDetailsTabType>[
            MatchDetailsTabType.facts,
            MatchDetailsTabType.lineup,
            MatchDetailsTabType.knockout,
            MatchDetailsTabType.stats,
            MatchDetailsTabType.headToHead,
          ],
          venue: _venue,
          meta: _meta,
          topScorers: null,
          teamForm: _teamForm,
          aboutText: _aboutText,
          playerOfTheMatch: _playerOfTheMatch,
          factsTopStats: _factsTopStats,
          events: _events,
          timelineMarkers: _timelineMarkers,
          nextMatches: _nextMatches,
          statsSections: _statsSections,
          headToHeadSummary: _headToHeadSummary,
          headToHeadMatches: _headToHeadMatches,
          lineup: MatchDetailsLineupUiModel(
            isPredicted: false,
            home: _lineup.home,
            away: _lineup.away,
            coaches: _lineup.coaches,
            substitutes: _lineup.substitutes,
            bench: _lineup.bench,
          ),
          knockout: _knockout,
        );
    }
  }

}

class _GridPosition {
  final int row;
  final int column;

  const _GridPosition({required this.row, required this.column});
}

class MatchDetailsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<MatchDetialsService>()) {
      Get.lazyPut<MatchDetialsService>(
        () => MatchDetialsService(apiClient: Get.find<ApiClient>()),
        fenix: true,
      );
    }

    Get.lazyPut<MatchDetailsController>(
      () => MatchDetailsController(service: Get.find<MatchDetialsService>()),
    );
  }
}