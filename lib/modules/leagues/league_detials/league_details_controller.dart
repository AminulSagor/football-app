import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/models/following_models.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/api_error_handler.dart';
import '../../../core/services/following_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../routes/app_routes.dart';
import '../model/leagues_models.dart';
import 'models/league_detials_model.dart';
import 'league_details_service.dart';

class LeagueDetailsController extends GetxController {
  bool get isWorldCup {
    return (state.value.league?.leagueId ?? '').trim() == '1';
  }

  List<LeagueDetailsWorldCupGroupUiModel> get worldCupGroups {
    return state.value.worldCupGroups;
  }

  List<LeagueDetailsWorldCupGroupUiModel> mergeWorldCupGroups(
    List<LeagueDetailsWorldCupGroupUiModel> existing,
    List<LeagueDetailsWorldCupGroupUiModel> incoming,
  ) {
    final merged = <LeagueDetailsWorldCupGroupUiModel>[...existing];
    for (final incomingGroup in incoming) {
      final index = merged.indexWhere(
        (group) => group.title == incomingGroup.title,
      );
      if (index == -1) {
        merged.add(incomingGroup);
        continue;
      }
      final current = merged[index];
      merged[index] = LeagueDetailsWorldCupGroupUiModel(
        title: current.title,
        rows: <LeagueDetailsStandingsRowUiModel>[
          ...current.rows,
          ...incomingGroup.rows,
        ],
      );
    }
    return merged;
  }

  List<LeagueDetailsKnockoutMatchUiModel> get worldCupTopOpeningMatches {
    return _openingMatchesForQuarterMatches(
      worldCupTopQuarterMatches,
      fallbackStart: 0,
    );
  }

  List<LeagueDetailsKnockoutMatchUiModel> get worldCupTopQuarterMatches {
    return _quarterMatchesForSemi(worldCupTopSemiMatch, fallbackStart: 0);
  }

  LeagueDetailsKnockoutMatchUiModel get worldCupTopSemiMatch {
    final matches = state.value.knockoutSemiFinals;
    return matches.isEmpty ? _knockoutPlaceholder() : matches.first;
  }

  LeagueDetailsKnockoutMatchUiModel get worldCupFinalMatch {
    final matches = state.value.knockoutFinals;
    final match = matches.isEmpty ? _knockoutPlaceholder() : matches.first;
    return LeagueDetailsKnockoutMatchUiModel(
      homeSeed: match.homeSeed,
      awaySeed: match.awaySeed,
      homeLabel: match.homeLabel,
      awayLabel: match.awayLabel,
      homeLogoUrl: match.homeLogoUrl,
      awayLogoUrl: match.awayLogoUrl,
      dateLabel: match.dateLabel,
      isHighlighted: true,
      showChampionMark: true,
      isFinished: match.isFinished,
      homeWinner: match.homeWinner,
      awayWinner: match.awayWinner,
    );
  }

  LeagueDetailsKnockoutMatchUiModel get worldCupBottomSemiMatch {
    final matches = state.value.knockoutSemiFinals;
    return matches.length < 2 ? _knockoutPlaceholder() : matches[1];
  }

  List<LeagueDetailsKnockoutMatchUiModel> get worldCupBottomQuarterMatches {
    return _quarterMatchesForSemi(worldCupBottomSemiMatch, fallbackStart: 2);
  }

  List<LeagueDetailsKnockoutMatchUiModel> get worldCupBottomOpeningMatches {
    return _openingMatchesForQuarterMatches(
      worldCupBottomQuarterMatches,
      fallbackStart: 4,
    );
  }

  List<LeagueDetailsKnockoutMatchUiModel> _quarterMatchesForSemi(
    LeagueDetailsKnockoutMatchUiModel semiMatch, {
    required int fallbackStart,
  }) {
    final quarterFinals = state.value.knockoutQuarterFinals;
    if (quarterFinals.isEmpty) {
      return _knockoutPlaceholders(2);
    }

    return _fixedKnockoutList(
      _sourceMatchesForTarget(
        target: semiMatch,
        candidates: quarterFinals,
        fallbackStart: fallbackStart,
        fallbackCount: 2,
      ),
      2,
    );
  }

  List<LeagueDetailsKnockoutMatchUiModel> _openingMatchesForQuarterMatches(
    List<LeagueDetailsKnockoutMatchUiModel> quarterMatches, {
    required int fallbackStart,
  }) {
    final openingMatches = state.value.knockoutRoundOf16;
    if (openingMatches.isEmpty) {
      return _knockoutPlaceholders(4);
    }

    final usedCandidateIndexes = <int>{};
    final resolvedMatches = <LeagueDetailsKnockoutMatchUiModel>[];

    for (final quarterMatch in quarterMatches.take(2)) {
      resolvedMatches.addAll(
        _sourceMatchesForTarget(
          target: quarterMatch,
          candidates: openingMatches,
          usedCandidateIndexes: usedCandidateIndexes,
          fallbackStart: fallbackStart + resolvedMatches.length,
          fallbackCount: 2,
        ),
      );
    }

    return _fixedKnockoutList(resolvedMatches, 4);
  }

  List<LeagueDetailsKnockoutMatchUiModel> _sourceMatchesForTarget({
    required LeagueDetailsKnockoutMatchUiModel target,
    required List<LeagueDetailsKnockoutMatchUiModel> candidates,
    Set<int>? usedCandidateIndexes,
    required int fallbackStart,
    required int fallbackCount,
  }) {
    final usedIndexes = usedCandidateIndexes ?? <int>{};
    final resolvedMatches = <LeagueDetailsKnockoutMatchUiModel>[];
    final targetSides = <Set<String>>[
      _teamKeys(target.homeLabel, target.homeSeed),
      _teamKeys(target.awayLabel, target.awaySeed),
    ];

    for (final targetSide in targetSides) {
      final index = _candidateIndexForTeamKeys(
        candidates,
        targetSide,
        usedIndexes,
      );
      if (index == -1) {
        continue;
      }

      usedIndexes.add(index);
      resolvedMatches.add(candidates[index]);
    }

    for (
      var index = fallbackStart;
      index < candidates.length && resolvedMatches.length < fallbackCount;
      index++
    ) {
      if (usedIndexes.contains(index)) {
        continue;
      }
      usedIndexes.add(index);
      resolvedMatches.add(candidates[index]);
    }

    for (
      var index = 0;
      index < candidates.length && resolvedMatches.length < fallbackCount;
      index++
    ) {
      if (usedIndexes.contains(index)) {
        continue;
      }
      usedIndexes.add(index);
      resolvedMatches.add(candidates[index]);
    }

    return resolvedMatches;
  }

  int _candidateIndexForTeamKeys(
    List<LeagueDetailsKnockoutMatchUiModel> candidates,
    Set<String> teamKeys,
    Set<int> usedCandidateIndexes,
  ) {
    if (teamKeys.isEmpty) {
      return -1;
    }

    for (var index = 0; index < candidates.length; index++) {
      if (usedCandidateIndexes.contains(index)) {
        continue;
      }
      if (_matchContainsTeamKeys(candidates[index], teamKeys)) {
        return index;
      }
    }

    return -1;
  }

  bool _matchContainsTeamKeys(
    LeagueDetailsKnockoutMatchUiModel match,
    Set<String> teamKeys,
  ) {
    return _intersects(_teamKeys(match.homeLabel, match.homeSeed), teamKeys) ||
        _intersects(_teamKeys(match.awayLabel, match.awaySeed), teamKeys);
  }

  bool _intersects(Set<String> first, Set<String> second) {
    for (final value in first) {
      if (second.contains(value)) {
        return true;
      }
    }
    return false;
  }

  Set<String> _teamKeys(String label, String seed) {
    final keys = <String>{
      _normalizeKnockoutTeamKey(label),
      _normalizeKnockoutTeamKey(seed),
    }..removeWhere(
        (value) => value.isEmpty || value == 'tbd' || value == 'question',
      );

    return keys;
  }

  String _normalizeKnockoutTeamKey(String value) {
    final normalized = value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '');
    if (normalized == '?' || normalized == '-') {
      return '';
    }
    return normalized;
  }

  List<LeagueDetailsKnockoutMatchUiModel> _fixedKnockoutList(
    List<LeagueDetailsKnockoutMatchUiModel> matches,
    int count,
  ) {
    final resolvedMatches = matches.take(count).toList(growable: true);
    while (resolvedMatches.length < count) {
      resolvedMatches.add(_knockoutPlaceholder());
    }
    return List<LeagueDetailsKnockoutMatchUiModel>.unmodifiable(
      resolvedMatches,
    );
  }

  LeagueDetailsKnockoutMatchUiModel _knockoutPlaceholder() {
    return const LeagueDetailsKnockoutMatchUiModel(
      homeSeed: 'TBD',
      awaySeed: 'TBD',
      homeLabel: 'TBD',
      awayLabel: 'TBD',
      dateLabel: 'TBD',
    );
  }

  List<LeagueDetailsKnockoutMatchUiModel> _knockoutPlaceholders(int count) {
    return List<LeagueDetailsKnockoutMatchUiModel>.filled(
      count,
      _knockoutPlaceholder(),
      growable: false,
    );
  }

  static const String _tableTitle = 'League Table';
  static const String _tableMessage = 'No table data loaded.';
  static const String _fixturesTitle = 'Fixtures';
  static const String _fixturesMessage = 'No fixtures loaded.';
  static const String _playerStatsTitle = 'Player Stats';
  static const String _playerStatsMessage = 'No player stats loaded.';
  static const String _teamStatsTitle = 'Team Stats';
  static const String _teamStatsMessage = 'No team stats loaded.';

  final LeaguesTopLeagueUiModel? initialLeague;
  final LeagueDetailsService _service;

  LeagueDetailsController({
    this.initialLeague,
    required LeagueDetailsService service,
  }) : _service = service,
       _followingService = Get.find<FollowingService>();

  final FollowingService _followingService;
  Worker? _worker;
  int _activeTabIndex = 0;
  final Map<String, int> _playerStatsCategoryPages = <String, int>{};
  final Set<String> _playerStatsCategoryHasMore = <String>{};
  bool _isLoadingMorePlayerStats = false;
  final Map<String, int> _teamStatsCategoryPages = <String, int>{};
  final Set<String> _teamStatsCategoryHasMore = <String>{};
  bool _isLoadingMoreTeamStats = false;
  bool _hasUserSelectedSeason = false;

  final Rx<LeagueDetailsViewModel> state = const LeagueDetailsViewModel(
    isLoading: true,
  ).obs;

  String get tableTitle => _tableTitle;
  String get tableMessage => _tableMessage;
  String get fixturesTitle => _fixturesTitle;
  String get fixturesMessage => _fixturesMessage;
  String get playerStatsTitle => _playerStatsTitle;
  String get playerStatsMessage => _playerStatsMessage;
  String get teamStatsTitle => _teamStatsTitle;
  String get teamStatsMessage => _teamStatsMessage;
  bool get isPlayerStatsTabActive => !isWorldCup && _activeTabIndex == 3;
  bool get isTeamStatsTabActive => !isWorldCup && _activeTabIndex == 4;

  @override
  void onInit() {
    super.onInit();

    if (initialLeague != null) {
      state.value = state.value.copyWith(league: initialLeague);
    }

    _syncFollowingState();
    _loadLeagueDetails();
    _worker = ever<int>(
      _followingService.revision,
      (_) => _syncFollowingState(),
    );
  }

  @override
  void onClose() {
    _worker?.dispose();
    super.onClose();
  }

  void selectSeason(String season) {
    final currentState = state.value;
    if (!currentState.seasons.contains(season) ||
        currentState.selectedSeason == season) {
      return;
    }

    _hasUserSelectedSeason = true;

    state.value = currentState.copyWith(
      selectedSeason: season,
      playerStatsSections: const <LeagueDetailsPlayerStatSectionUiModel>[],
      hasLoadedPlayerStats: false,
      teamStatsSections: const <LeagueDetailsPlayerStatSectionUiModel>[],
      hasLoadedTeamStats: false,
      worldCupGroups: const <LeagueDetailsWorldCupGroupUiModel>[],
      standingsPage: 1,
      standingsTotalPages: 1,
      isStandingsLoadingMore: false,
      isFixturesLoadingMore: false,
      knockoutRoundOf16: const <LeagueDetailsKnockoutMatchUiModel>[],
      knockoutQuarterFinals: const <LeagueDetailsKnockoutMatchUiModel>[],
      knockoutSemiFinals: const <LeagueDetailsKnockoutMatchUiModel>[],
      knockoutFinals: const <LeagueDetailsKnockoutMatchUiModel>[],
      hasLoadedKnockout: false,
      isKnockoutLoading: false,
      fixtures: const LeagueDetailsFixturesViewModel(),
    );
    _resetStatsPagination();

    final shouldReloadKnockoutImmediately = isWorldCup && _activeTabIndex == 1;
    if (shouldReloadKnockoutImmediately) {
      ensureKnockoutLoaded(force: true);
    }

    _loadLeagueDetails().then((_) {
      if (shouldReloadKnockoutImmediately) {
        return;
      }
      if (isWorldCup && _activeTabIndex == 3) {
        ensureSeasonHistoryLoaded(force: true);
      } else if (!isWorldCup && _activeTabIndex == 3) {
        ensurePlayerStatsLoaded(force: true);
      } else if (!isWorldCup && _activeTabIndex == 4) {
        ensureTeamStatsLoaded(force: true);
      }
    });
  }

  Future<void> reload({bool showLoading = true}) async {
    if (showLoading) {
      state.value = state.value.copyWith(
        playerStatsSections: const <LeagueDetailsPlayerStatSectionUiModel>[],
        hasLoadedPlayerStats: false,
        teamStatsSections: const <LeagueDetailsPlayerStatSectionUiModel>[],
        hasLoadedTeamStats: false,
        worldCupGroups: const <LeagueDetailsWorldCupGroupUiModel>[],
        standingsPage: 1,
        standingsTotalPages: 1,
        isStandingsLoadingMore: false,
        isFixturesLoadingMore: false,
        knockoutRoundOf16: const <LeagueDetailsKnockoutMatchUiModel>[],
        knockoutQuarterFinals: const <LeagueDetailsKnockoutMatchUiModel>[],
        knockoutSemiFinals: const <LeagueDetailsKnockoutMatchUiModel>[],
        knockoutFinals: const <LeagueDetailsKnockoutMatchUiModel>[],
        hasLoadedKnockout: false,
        isKnockoutLoading: false,
      );
      _resetStatsPagination();
    }

    await _loadLeagueDetails(showLoading: showLoading);

    if (isWorldCup && _activeTabIndex == 3) {
      await ensureSeasonHistoryLoaded(force: true, showLoading: showLoading);
    } else if (!isWorldCup && _activeTabIndex == 3) {
      await ensurePlayerStatsLoaded(force: true, showLoading: showLoading);
    } else if (!isWorldCup && _activeTabIndex == 4) {
      await ensureTeamStatsLoaded(force: true, showLoading: showLoading);
    }
  }

  Future<void> refreshCurrentTab() async {
    if (isWorldCup && _activeTabIndex == 1) {
      await ensureKnockoutLoaded(force: true, showLoading: false);
      return;
    }
    if (isWorldCup && _activeTabIndex == 3) {
      await ensureSeasonHistoryLoaded(force: true, showLoading: false);
      return;
    }
    if (!isWorldCup && _activeTabIndex == 3) {
      await ensurePlayerStatsLoaded(force: true, showLoading: false);
      return;
    }
    if (!isWorldCup && _activeTabIndex == 4) {
      await ensureTeamStatsLoaded(force: true, showLoading: false);
      return;
    }
    await reload(showLoading: false);
  }

  void openTeamProfile(String teamId) {
    final cleanTeamId = teamId.trim();
    if (cleanTeamId.isEmpty) {
      return;
    }

    Get.toNamed(
      AppRoutes.teamProfile,
      arguments: <String, dynamic>{'teamId': cleanTeamId},
    );
  }

  void openPlayerProfile(LeagueDetailsPlayerStatRowUiModel player) {
    openPlayerProfileById(
      playerId: player.playerId,
      playerName: player.name,
      teamId: player.teamId,
      teamName: player.teamName,
    );
  }

  void openPlayerProfileById({
    required String playerId,
    String playerName = '',
    String teamId = '',
    String teamName = '',
  }) {
    final cleanPlayerId = playerId.trim();
    if (cleanPlayerId.isEmpty) {
      return;
    }

    final arguments = <String, dynamic>{
      'playerId': cleanPlayerId,
      'playerName': playerName,
      'teamName': teamName,
    };

    final cleanTeamId = teamId.trim();
    if (cleanTeamId.isNotEmpty) {
      arguments['teamId'] = cleanTeamId;
    }

    Get.toNamed(AppRoutes.playerProfile, arguments: arguments);
  }

  void openMatchDetails(LeagueDetailsFixtureUiModel fixture) {
    final cleanFixtureId = fixture.fixtureId.trim();
    if (cleanFixtureId.isEmpty) {
      return;
    }

    Get.toNamed(
      AppRoutes.matchDetails,
      arguments: <String, dynamic>{
        'fixtureId': cleanFixtureId,
        'scenario': fixture.isFinished ? 'finished' : 'upcoming',
      },
    );
  }

  Future<bool> loadMoreWorldCupStandings() async {
    final current = state.value;
    if (!isWorldCup ||
        current.isLoading ||
        current.isStandingsLoadingMore ||
        current.standingsPage >= current.standingsTotalPages) {
      return false;
    }

    final league = current.league ?? initialLeague;
    final leagueId = int.tryParse(league?.leagueId ?? '');
    if (leagueId == null) {
      return false;
    }

    final seasonYear = _selectedSeasonYear(
      current.selectedSeason,
      league?.season,
    );
    final nextPage = current.standingsPage + 1;
    state.value = current.copyWith(isStandingsLoadingMore: true);

    final response =
        await ApiErrorHandler.handle<LeagueDetailsStandingsDataModel>(
          () => _service.fetchStandingsData(
            leagueId: leagueId,
            season: seasonYear,
            page: nextPage,
            limit: 20,
          ),
          fallbackErrorCode: 'world_cup_standings_more_fetch_failed',
          userMessage: 'Unable to load more standings right now.',
          showUserError: false,
        );

    if (isClosed) {
      return false;
    }

    if (!response.success || response.data == null) {
      state.value = state.value.copyWith(isStandingsLoadingMore: false);
      return false;
    }

    final data = response.data!;
    state.value = state.value.copyWith(
      isStandingsLoadingMore: false,
      standingsRows: <LeagueDetailsStandingsRowUiModel>[
        ...state.value.standingsRows,
        ...data.rows,
      ],
      worldCupGroups: mergeWorldCupGroups(
        state.value.worldCupGroups,
        data.worldCupGroups,
      ),
      standingsPage: data.page,
      standingsTotalPages: data.totalPages,
    );
    return data.rows.isNotEmpty || data.worldCupGroups.isNotEmpty;
  }

  void onLeagueDetailsTabChanged(int index) {
    _activeTabIndex = index;
    if (isWorldCup && index == 1) {
      ensureKnockoutLoaded();
    } else if (isWorldCup && index == 3) {
      ensureSeasonHistoryLoaded();
    } else if (!isWorldCup && index == 3) {
      ensurePlayerStatsLoaded();
    } else if (!isWorldCup && index == 4) {
      ensureTeamStatsLoaded();
    }
  }

  void _resetStatsPagination() {
    _playerStatsCategoryPages.clear();
    _playerStatsCategoryHasMore.clear();
    _teamStatsCategoryPages.clear();
    _teamStatsCategoryHasMore.clear();
  }

  Future<void> ensureSeasonHistoryLoaded({
    bool force = false,
    bool showLoading = true,
  }) async {
    final current = state.value;
    if (!isWorldCup ||
        (!force &&
            (current.hasLoadedSeasonHistory ||
                current.isSeasonHistoryLoading))) {
      return;
    }

    final league = current.league ?? initialLeague;
    final leagueId = int.tryParse(league?.leagueId ?? '');
    if (leagueId == null) {
      return;
    }

    if (showLoading) {
      state.value = current.copyWith(isSeasonHistoryLoading: true);
    }

    final response =
        await ApiErrorHandler.handle<List<LeagueDetailsSeasonHistoryUiModel>>(
          () => _service.fetchWorldCupSeasonHistory(leagueId: leagueId),
          fallbackErrorCode: 'world_cup_season_history_fetch_failed',
          userMessage: 'Unable to load season history right now.',
          showUserError: false,
        );

    if (isClosed) {
      return;
    }

    state.value = state.value.copyWith(
      isSeasonHistoryLoading: false,
      hasLoadedSeasonHistory: true,
      seasonHistory: response.success && response.data != null
          ? response.data!
          : const <LeagueDetailsSeasonHistoryUiModel>[],
    );
  }

  Future<void> ensureKnockoutLoaded({
    bool force = false,
    bool showLoading = true,
  }) async {
    final current = state.value;
    if (!isWorldCup ||
        (!force && (current.hasLoadedKnockout || current.isKnockoutLoading))) {
      return;
    }

    final league = current.league ?? initialLeague;
    final leagueId = int.tryParse(league?.leagueId ?? '');
    if (leagueId == null) {
      return;
    }

    final seasonYear = _selectedSeasonYear(
      current.selectedSeason,
      league?.season,
    );
    if (showLoading) {
      state.value = current.copyWith(isKnockoutLoading: true);
    }

    final response =
        await ApiErrorHandler.handle<LeagueDetailsKnockoutBracketDataModel>(
          () => _service.fetchKnockoutBracket(
            fixtureId: leagueId,
            leagueId: leagueId,
            season: seasonYear,
          ),
          fallbackErrorCode: 'league_knockout_fetch_failed',
          userMessage: 'Unable to load knockout bracket right now.',
          showUserError: false,
        );

    if (isClosed) {
      return;
    }

    final data = response.success && response.data != null
        ? response.data!
        : const LeagueDetailsKnockoutBracketDataModel();

    state.value = state.value.copyWith(
      isKnockoutLoading: false,
      hasLoadedKnockout: true,
      knockoutRoundOf16: data.roundOf16,
      knockoutQuarterFinals: data.quarterFinals,
      knockoutSemiFinals: data.semiFinals,
      knockoutFinals: data.finals,
    );
  }

  Future<void> ensurePlayerStatsLoaded({
    bool force = false,
    bool showLoading = true,
  }) async {
    final current = state.value;
    if (!force &&
        (current.hasLoadedPlayerStats || current.isPlayerStatsLoading)) {
      return;
    }

    final league = current.league ?? initialLeague;
    final leagueId = int.tryParse(league?.leagueId ?? '');
    if (leagueId == null) {
      return;
    }
    final seasonYear = _selectedSeasonYear(
      current.selectedSeason,
      league?.season,
    );

    if (showLoading) {
      state.value = current.copyWith(isPlayerStatsLoading: true);
    }

    final response =
        await ApiErrorHandler.handle<
          List<LeagueDetailsPlayerStatSectionUiModel>
        >(
          () async {
            final results =
                await Future.wait<List<LeagueDetailsPlayerStatSectionUiModel>>(
                  const <String>[
                    'minutes',
                    'attack',
                    'defense',
                    'goalkeeping',
                    'discipline',
                  ].map(
                    (category) => _service.fetchPlayerStatsCategory(
                      leagueId: leagueId,
                      season: seasonYear,
                      category: category,
                      page: 1,
                      limit: 10,
                    ),
                  ),
                );
            return results.expand((item) => item).toList(growable: false);
          },
          fallbackErrorCode: 'league_player_stats_fetch_failed',
          userMessage: 'Unable to load player stats right now.',
          showUserError: false,
        );

    if (isClosed) {
      return;
    }

    final sections = response.success && response.data != null
        ? response.data!
        : const <LeagueDetailsPlayerStatSectionUiModel>[];
    _playerStatsCategoryPages
      ..clear()
      ..addEntries(
        const <String>[
          'minutes',
          'attack',
          'defense',
          'goalkeeping',
          'discipline',
        ].map((category) => MapEntry<String, int>(category, 1)),
      );
    _playerStatsCategoryHasMore
      ..clear()
      ..addAll(const <String>[
        'minutes',
        'attack',
        'defense',
        'goalkeeping',
        'discipline',
      ]);

    state.value = state.value.copyWith(
      isPlayerStatsLoading: false,
      hasLoadedPlayerStats: true,
      playerStatsSections: sections,
    );
  }

  Future<void> ensureTeamStatsLoaded({
    bool force = false,
    bool showLoading = true,
  }) async {
    final current = state.value;
    if (!force && (current.hasLoadedTeamStats || current.isTeamStatsLoading)) {
      return;
    }

    final league = current.league ?? initialLeague;
    final leagueId = int.tryParse(league?.leagueId ?? '');
    if (leagueId == null) {
      return;
    }
    final seasonYear = _selectedSeasonYear(
      current.selectedSeason,
      league?.season,
    );

    if (showLoading) {
      state.value = current.copyWith(isTeamStatsLoading: true);
    }

    final response =
        await ApiErrorHandler.handle<
          List<LeagueDetailsPlayerStatSectionUiModel>
        >(
          () async {
            final results =
                await Future.wait<List<LeagueDetailsPlayerStatSectionUiModel>>(
                  const <String>[
                    'topStats',
                    'attack',
                    'defense',
                    'discipline',
                  ].map(
                    (category) => _service.fetchTeamStatsCategory(
                      leagueId: leagueId,
                      season: seasonYear,
                      category: category,
                      page: 1,
                      limit: 10,
                    ),
                  ),
                );
            return results.expand((item) => item).toList(growable: false);
          },
          fallbackErrorCode: 'league_team_stats_fetch_failed',
          userMessage: 'Unable to load team stats right now.',
          showUserError: false,
        );

    if (isClosed) {
      return;
    }

    final sections = response.success && response.data != null
        ? response.data!
        : const <LeagueDetailsPlayerStatSectionUiModel>[];
    _teamStatsCategoryPages
      ..clear()
      ..addEntries(
        const <String>[
          'topStats',
          'attack',
          'defense',
          'discipline',
        ].map((category) => MapEntry<String, int>(category, 1)),
      );
    _teamStatsCategoryHasMore
      ..clear()
      ..addAll(const <String>['topStats', 'attack', 'defense', 'discipline']);

    state.value = state.value.copyWith(
      isTeamStatsLoading: false,
      hasLoadedTeamStats: true,
      teamStatsSections: sections,
    );
  }

  Future<bool> loadMorePlayerStatsForFilter(String filterLabel) async {
    if (_isLoadingMorePlayerStats) {
      return false;
    }

    final category = _playerStatsCategoryForFilter(filterLabel);
    if (category.isEmpty || !_playerStatsCategoryHasMore.contains(category)) {
      return false;
    }

    final league = state.value.league ?? initialLeague;
    final leagueId = int.tryParse(league?.leagueId ?? '');
    if (leagueId == null) {
      return false;
    }
    final seasonYear = _selectedSeasonYear(
      state.value.selectedSeason,
      league?.season,
    );
    final nextPage = (_playerStatsCategoryPages[category] ?? 1) + 1;

    _isLoadingMorePlayerStats = true;
    final response =
        await ApiErrorHandler.handle<
          List<LeagueDetailsPlayerStatSectionUiModel>
        >(
          () => _service.fetchPlayerStatsCategory(
            leagueId: leagueId,
            season: seasonYear,
            category: category,
            page: nextPage,
            limit: 10,
          ),
          fallbackErrorCode: 'league_player_stats_more_fetch_failed',
          userMessage: 'Unable to load more player stats right now.',
          showUserError: false,
        );
    _isLoadingMorePlayerStats = false;

    if (isClosed || !response.success || response.data == null) {
      return false;
    }

    final incoming = response.data!;
    if (_sectionsHaveNoRows(incoming)) {
      _playerStatsCategoryHasMore.remove(category);
      return false;
    }

    _playerStatsCategoryPages[category] = nextPage;
    state.value = state.value.copyWith(
      playerStatsSections: _mergeStatSections(
        state.value.playerStatsSections,
        incoming,
      ),
    );
    return true;
  }

  Future<bool> loadMoreTeamStatsForFilter(String filterLabel) async {
    if (_isLoadingMoreTeamStats) {
      return false;
    }

    final category = _teamStatsCategoryForFilter(filterLabel);
    if (category.isEmpty || !_teamStatsCategoryHasMore.contains(category)) {
      return false;
    }

    final league = state.value.league ?? initialLeague;
    final leagueId = int.tryParse(league?.leagueId ?? '');
    if (leagueId == null) {
      return false;
    }
    final seasonYear = _selectedSeasonYear(
      state.value.selectedSeason,
      league?.season,
    );
    final nextPage = (_teamStatsCategoryPages[category] ?? 1) + 1;

    _isLoadingMoreTeamStats = true;
    final response =
        await ApiErrorHandler.handle<
          List<LeagueDetailsPlayerStatSectionUiModel>
        >(
          () => _service.fetchTeamStatsCategory(
            leagueId: leagueId,
            season: seasonYear,
            category: category,
            page: nextPage,
            limit: 10,
          ),
          fallbackErrorCode: 'league_team_stats_more_fetch_failed',
          userMessage: 'Unable to load more team stats right now.',
          showUserError: false,
        );
    _isLoadingMoreTeamStats = false;

    if (isClosed || !response.success || response.data == null) {
      return false;
    }

    final incoming = response.data!;
    if (_sectionsHaveNoRows(incoming)) {
      _teamStatsCategoryHasMore.remove(category);
      return false;
    }

    _teamStatsCategoryPages[category] = nextPage;
    state.value = state.value.copyWith(
      teamStatsSections: _mergeStatSections(
        state.value.teamStatsSections,
        incoming,
      ),
    );
    return true;
  }

  bool _sectionsHaveNoRows(
    List<LeagueDetailsPlayerStatSectionUiModel> sections,
  ) {
    return sections.every((section) => section.rows.isEmpty);
  }

  List<LeagueDetailsPlayerStatSectionUiModel> _mergeStatSections(
    List<LeagueDetailsPlayerStatSectionUiModel> existing,
    List<LeagueDetailsPlayerStatSectionUiModel> incoming,
  ) {
    final merged = <LeagueDetailsPlayerStatSectionUiModel>[...existing];
    for (final incomingSection in incoming) {
      final index = merged.indexWhere(
        (section) =>
            _normalizePlayerStatLabel(section.key) ==
                _normalizePlayerStatLabel(incomingSection.key) &&
            section.category == incomingSection.category,
      );
      if (index == -1) {
        merged.add(incomingSection);
        continue;
      }

      final currentSection = merged[index];
      merged[index] = LeagueDetailsPlayerStatSectionUiModel(
        category: currentSection.category,
        key: currentSection.key,
        title: currentSection.title,
        rows: <LeagueDetailsPlayerStatRowUiModel>[
          ...currentSection.rows,
          ...incomingSection.rows,
        ],
      );
    }
    return merged;
  }

  String _playerStatsCategoryForFilter(String filterLabel) {
    final normalized = _normalizePlayerStatLabel(filterLabel);
    for (final section in state.value.playerStatsSections) {
      if (_normalizePlayerStatLabel(section.title) == normalized ||
          _normalizePlayerStatLabel(section.key) == normalized) {
        return section.category;
      }
    }
    return '';
  }

  String _teamStatsCategoryForFilter(String filterLabel) {
    final normalized = _normalizePlayerStatLabel(filterLabel);
    for (final section in state.value.teamStatsSections) {
      if (_normalizePlayerStatLabel(section.title) == normalized ||
          _normalizePlayerStatLabel(section.key) == normalized) {
        return section.category;
      }
    }

    if (_topStatsLabels.map(_normalizePlayerStatLabel).contains(normalized)) {
      return 'topStats';
    }
    if (_attackTeamLabels.map(_normalizePlayerStatLabel).contains(normalized)) {
      return 'attack';
    }
    if (_defenseTeamLabels
        .map(_normalizePlayerStatLabel)
        .contains(normalized)) {
      return 'defense';
    }
    if (_disciplineTeamLabels
        .map(_normalizePlayerStatLabel)
        .contains(normalized)) {
      return 'discipline';
    }
    return '';
  }

  int _selectedSeasonYear(String selectedSeason, int? fallbackSeason) {
    final match = RegExp(r'\d{4}').firstMatch(selectedSeason);
    if (match != null) {
      return int.tryParse(match.group(0)!) ??
          fallbackSeason ??
          DateTime.now().year;
    }
    return fallbackSeason ?? DateTime.now().year;
  }

  Future<void> _loadLeagueDetails({bool showLoading = true}) async {
    final league = state.value.league ?? initialLeague;
    if (league == null) {
      state.value = state.value.copyWith(
        isLoading: false,
        errorCode: 'missing_league',
      );
      return;
    }

    if (showLoading) {
      state.value = state.value.copyWith(isLoading: true, errorCode: null);
    } else {
      state.value = state.value.copyWith(errorCode: null);
    }

    final response = await ApiErrorHandler.handle<LeagueDetailsRemoteDataModel>(
      () => _service.fetchLeagueDetails(
        league: league,
        season: !_hasUserSelectedSeason || state.value.selectedSeason.isEmpty
            ? ''
            : state.value.selectedSeason,
      ),
      fallbackErrorCode: 'league_details_fetch_failed',
      userMessage: 'Unable to load league details right now.',
    );

    if (isClosed) {
      return;
    }

    if (!response.success || response.data == null) {
      state.value = state.value.copyWith(
        isLoading: false,
        errorCode: response.errorCode,
      );
      return;
    }

    final data = response.data!;
    final resolvedLeague = data.league ?? league;
    final currentSeasonYearMatch = RegExp(
      r'\d{4}',
    ).firstMatch(state.value.selectedSeason);
    final currentSeasonYear = currentSeasonYearMatch?.group(0);
    final nextSelectedSeason = data.seasons.contains(data.selectedSeason)
        ? data.selectedSeason
        : (data.seasons.contains(state.value.selectedSeason)
              ? state.value.selectedSeason
              : (currentSeasonYear != null &&
                        data.seasons.contains(currentSeasonYear)
                    ? currentSeasonYear
                    : (resolvedLeague.season != null &&
                              data.seasons.contains('${resolvedLeague.season}')
                          ? '${resolvedLeague.season}'
                          : (data.seasons.isNotEmpty
                                ? data.seasons.first
                                : state.value.selectedSeason))));

    state.value = state.value.copyWith(
      league: resolvedLeague,
      isLoading: false,
      isFollowing: data.isFollowing,
      seasons: data.seasons.isEmpty ? state.value.seasons : data.seasons,
      selectedSeason: nextSelectedSeason,
      standingsRows: data.standingsRows,
      worldCupGroups: data.worldCupGroups,
      standingsPage: data.standingsPage,
      standingsTotalPages: data.standingsTotalPages,
      isStandingsLoadingMore: false,
      fixtures: data.fixtures,
      overview: LeagueDetailsOverviewUiModel(
        topThreeRows: data.standingsRows.take(3).toList(growable: false),
        topScorers: data.topScorers.take(3).toList(growable: false),
        topAssists: data.topAssists.take(3).toList(growable: false),
        teamName: resolvedLeague.leagueName,
        roundLabel: nextSelectedSeason,
      ),
      topScorersRows: data.topScorers,
      topAssistsRows: data.topAssists,
      errorCode: null,
    );

    if (isWorldCup && _activeTabIndex == 1) {
      ensureKnockoutLoaded();
    }
  }

  void cycleFixturesMode() {
    showFixturesModePicker();
  }

  void showFixturesModePicker() {
    Get.bottomSheet<void>(
      SafeArea(
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Get.theme.dividerColor.withAlpha(120)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _pickerTile(
                  title: 'By date',
                  isSelected:
                      state.value.fixtures.mode ==
                      LeagueDetailsFixturesMode.byDate,
                  onTap: () {
                    Get.back<void>();
                    _selectFixturesMode(LeagueDetailsFixturesMode.byDate);
                  },
                ),
                _pickerTile(
                  title: 'By round',
                  isSelected:
                      state.value.fixtures.mode ==
                      LeagueDetailsFixturesMode.byRound,
                  onTap: () {
                    Get.back<void>();
                    _selectFixturesMode(LeagueDetailsFixturesMode.byRound);
                  },
                ),
                _pickerTile(
                  title: 'By team',
                  isSelected:
                      state.value.fixtures.mode ==
                      LeagueDetailsFixturesMode.byTeam,
                  onTap: () {
                    Get.back<void>();
                    _selectFixturesMode(LeagueDetailsFixturesMode.byTeam);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _pickerTile({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      title: Text(title),
      trailing: isSelected ? const Icon(Icons.check_rounded) : null,
    );
  }

  Future<void> _selectFixturesMode(LeagueDetailsFixturesMode mode) async {
    final currentFixtures = state.value.fixtures;
    state.value = state.value.copyWith(
      fixtures: currentFixtures.copyWith(mode: mode),
    );

    if (mode == LeagueDetailsFixturesMode.byDate &&
        currentFixtures.byDateSections.isEmpty) {
      if (isWorldCup) {
        await _loadWorldCupInitialFixturesByDateRange();
      } else {
        final range = defaultFixtureDateRange();
        await _loadFixturesByDateRange(
          fromDate: range.start,
          toDate: range.end,
        );
      }
      return;
    }

    if (mode == LeagueDetailsFixturesMode.byRound) {
      await _ensureRoundFixturesLoaded();
      return;
    }

    if (mode == LeagueDetailsFixturesMode.byTeam) {
      await _ensureTeamFixturesLoaded();
    }
  }

  Future<void> showFixtureDateRangePicker(BuildContext context) async {
    final currentFixtures = state.value.fixtures;
    final range = _dateRangeFromFixtures(currentFixtures);
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2035, 12, 31),
      initialDateRange: DateTimeRange(start: range.start, end: range.end),
    );

    if (picked == null) {
      return;
    }

    await _loadFixturesByDateRange(
      fromDate: _dateString(picked.start),
      toDate: _dateString(picked.end),
    );
  }

  Future<void> showPreviousFixtureDate() async {
    await _shiftFixtureDateRange(-7);
  }

  Future<void> showNextFixtureDate() async {
    if (state.value.fixtures.isDateNextDisabled) {
      return;
    }
    await _shiftFixtureDateRange(7);
  }

  Future<void> _shiftFixtureDateRange(int dayDelta) async {
    final range = _dateRangeFromFixtures(state.value.fixtures);
    await _loadFixturesByDateRange(
      fromDate: _dateString(range.start.add(Duration(days: dayDelta))),
      toDate: _dateString(range.end.add(Duration(days: dayDelta))),
    );
  }

  Future<void> showRoundPicker() async {
    await _ensureFixtureRoundsLoaded();
    if (isClosed) {
      return;
    }

    final fixtures = state.value.fixtures;
    final rounds = fixtures.roundLabels;
    if (rounds.isEmpty) {
      return;
    }

    Get.bottomSheet<void>(
      SafeArea(
        child: Material(
          color: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(maxHeight: Get.height * 0.62),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Get.theme.dividerColor.withAlpha(120)),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: rounds.length,
              itemBuilder: (context, index) {
                final round = rounds[index];
                return _pickerTile(
                  title: round,
                  isSelected: round == fixtures.selectedRoundLabel,
                  onTap: () {
                    Get.back<void>();
                    _loadFixturesByRound(round: round);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showTeamPicker() async {
    final fixtures = state.value.fixtures;
    final teams = fixtures.teamOptions.isNotEmpty
        ? fixtures.teamOptions
        : state.value.standingsRows;
    if (teams.isEmpty) {
      return;
    }

    Get.bottomSheet<void>(
      SafeArea(
        child: Material(
          color: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(maxHeight: Get.height * 0.62),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Get.theme.dividerColor.withAlpha(120)),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: teams.length,
              itemBuilder: (context, index) {
                final team = teams[index];
                return _pickerTile(
                  title: team.teamName,
                  isSelected: team.teamId == fixtures.selectedTeamId,
                  onTap: () {
                    Get.back<void>();
                    _loadFixturesByTeam(team: team);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loadMoreFixtures() async {
    final fixtures = state.value.fixtures;
    if (state.value.isFixturesLoading || state.value.isFixturesLoadingMore) {
      return;
    }

    if (fixtures.mode == LeagueDetailsFixturesMode.byDate &&
        fixtures.datePage < fixtures.dateTotalPages) {
      await _loadFixturesByDateRange(
        fromDate: fixtures.fromDate,
        toDate: fixtures.toDate,
        page: fixtures.datePage + 1,
        append: true,
      );
      return;
    }

    if (fixtures.mode == LeagueDetailsFixturesMode.byRound &&
        fixtures.roundPage < fixtures.roundTotalPages &&
        fixtures.selectedRoundLabel.isNotEmpty) {
      await _loadFixturesByRound(
        round: fixtures.selectedRoundLabel,
        page: fixtures.roundPage + 1,
        append: true,
      );
      return;
    }

    if (fixtures.mode == LeagueDetailsFixturesMode.byTeam &&
        fixtures.teamPage < fixtures.teamTotalPages &&
        fixtures.selectedTeamId.isNotEmpty) {
      await _loadFixturesByTeam(page: fixtures.teamPage + 1, append: true);
    }
  }

  Future<void> _ensureRoundFixturesLoaded() async {
    await _ensureFixtureRoundsLoaded();
    if (isClosed) {
      return;
    }

    final fixtures = state.value.fixtures;
    if (fixtures.byRoundSections.isNotEmpty &&
        fixtures.selectedRoundLabel.isNotEmpty) {
      return;
    }

    final firstRound = fixtures.selectedRoundLabel.isNotEmpty
        ? fixtures.selectedRoundLabel
        : (fixtures.roundLabels.isNotEmpty ? fixtures.roundLabels.first : '');
    if (firstRound.isEmpty) {
      return;
    }

    await _loadFixturesByRound(round: firstRound);
  }

  Future<void> _ensureTeamFixturesLoaded() async {
    final fixtures = state.value.fixtures;
    if (fixtures.byTeamSections.isNotEmpty &&
        fixtures.selectedTeamId.isNotEmpty) {
      return;
    }

    final teams = fixtures.teamOptions.isNotEmpty
        ? fixtures.teamOptions
        : state.value.standingsRows;
    if (teams.isEmpty) {
      return;
    }

    final selected = fixtures.selectedTeamId.isNotEmpty
        ? teams.firstWhere(
            (team) => team.teamId == fixtures.selectedTeamId,
            orElse: () => teams.first,
          )
        : teams.first;
    await _loadFixturesByTeam(team: selected);
  }

  Future<void> _ensureFixtureRoundsLoaded() async {
    final fixtures = state.value.fixtures;
    if (fixtures.roundLabels.isNotEmpty) {
      return;
    }

    final leagueId = _currentLeagueId;
    final seasonYear = _currentSeasonYear;
    if (leagueId == null || seasonYear == null) {
      return;
    }

    state.value = state.value.copyWith(isFixturesLoading: true);
    final response = await ApiErrorHandler.handle<List<String>>(
      () => _service.fetchFixtureRounds(leagueId: leagueId, season: seasonYear),
      fallbackErrorCode: 'fixture_rounds_fetch_failed',
      userMessage: 'Unable to load fixture rounds right now.',
    );

    if (isClosed) {
      return;
    }

    final nextRounds = response.success && response.data != null
        ? response.data!
        : const <String>[];
    final selectedRound = state.value.fixtures.selectedRoundLabel.isNotEmpty
        ? state.value.fixtures.selectedRoundLabel
        : (nextRounds.isNotEmpty ? nextRounds.first : '');

    state.value = state.value.copyWith(
      isFixturesLoading: false,
      fixtures: state.value.fixtures.copyWith(
        roundLabels: nextRounds,
        selectedRoundLabel: selectedRound,
      ),
    );
  }

  Future<void> _loadWorldCupInitialFixturesByDateRange() async {
    final leagueId = _currentLeagueId;
    final seasonYear = _currentSeasonYear;
    if (leagueId == null || seasonYear == null) {
      return;
    }

    state.value = state.value.copyWith(isFixturesLoading: true);
    final response =
        await ApiErrorHandler.handle<LeagueDetailsFixturesViewModel>(
          () => _service.fetchWorldCupInitialFixturesByDateRange(
            leagueId: leagueId,
            season: seasonYear,
          ),
          fallbackErrorCode: 'world_cup_fixture_date_fetch_failed',
          userMessage: 'Unable to load fixtures right now.',
        );

    if (isClosed) {
      return;
    }

    if (!response.success || response.data == null) {
      state.value = state.value.copyWith(isFixturesLoading: false);
      return;
    }

    final currentFixtures = state.value.fixtures;
    final nextFixtures = response.data!.copyWith(
      mode: LeagueDetailsFixturesMode.byDate,
      roundLabels: currentFixtures.roundLabels,
      selectedRoundLabel: currentFixtures.selectedRoundLabel,
      byRoundSections: currentFixtures.byRoundSections,
      roundPage: currentFixtures.roundPage,
      roundTotalPages: currentFixtures.roundTotalPages,
      selectedTeamId: currentFixtures.selectedTeamId,
      selectedTeamLabel: currentFixtures.selectedTeamLabel,
      selectedTeamLogoUrl: currentFixtures.selectedTeamLogoUrl,
      teamOptions: currentFixtures.teamOptions,
      byTeamSections: currentFixtures.byTeamSections,
      teamPage: currentFixtures.teamPage,
      teamTotalPages: currentFixtures.teamTotalPages,
    );

    state.value = state.value.copyWith(
      isFixturesLoading: false,
      fixtures: nextFixtures,
    );
  }

  Future<void> _loadFixturesByDateRange({
    required String fromDate,
    required String toDate,
    int page = 1,
    bool append = false,
  }) async {
    final leagueId = _currentLeagueId;
    final seasonYear = _currentSeasonYear;
    if (leagueId == null || seasonYear == null) {
      return;
    }

    state.value = state.value.copyWith(
      isFixturesLoading: append ? state.value.isFixturesLoading : true,
      isFixturesLoadingMore: append,
    );
    final response =
        await ApiErrorHandler.handle<LeagueDetailsFixturesViewModel>(
          () => _service.fetchLeagueFixturesByDateRange(
            leagueId: leagueId,
            season: seasonYear,
            fromDate: fromDate,
            toDate: toDate,
            page: page,
            existingSections: append
                ? state.value.fixtures.byDateSections
                : const <LeagueDetailsFixtureSectionUiModel>[],
          ),
          fallbackErrorCode: 'league_fixture_date_fetch_failed',
          userMessage: 'Unable to load fixtures right now.',
        );

    if (isClosed) {
      return;
    }

    if (!response.success || response.data == null) {
      state.value = state.value.copyWith(
        isFixturesLoading: false,
        isFixturesLoadingMore: false,
      );
      return;
    }

    final currentFixtures = state.value.fixtures;
    final nextFixtures = response.data!.copyWith(
      mode: LeagueDetailsFixturesMode.byDate,
      roundLabels: currentFixtures.roundLabels,
      selectedRoundLabel: currentFixtures.selectedRoundLabel,
      byRoundSections: currentFixtures.byRoundSections,
      roundPage: currentFixtures.roundPage,
      roundTotalPages: currentFixtures.roundTotalPages,
      selectedTeamId: currentFixtures.selectedTeamId,
      selectedTeamLabel: currentFixtures.selectedTeamLabel,
      selectedTeamLogoUrl: currentFixtures.selectedTeamLogoUrl,
      teamOptions: currentFixtures.teamOptions,
      byTeamSections: currentFixtures.byTeamSections,
      teamPage: currentFixtures.teamPage,
      teamTotalPages: currentFixtures.teamTotalPages,
    );

    state.value = state.value.copyWith(
      isFixturesLoading: false,
      isFixturesLoadingMore: false,
      fixtures: nextFixtures,
    );
  }

  Future<void> _loadFixturesByRound({
    required String round,
    int page = 1,
    bool append = false,
  }) async {
    final leagueId = _currentLeagueId;
    final seasonYear = _currentSeasonYear;
    if (leagueId == null || seasonYear == null) {
      return;
    }

    state.value = state.value.copyWith(
      isFixturesLoading: append ? state.value.isFixturesLoading : true,
      isFixturesLoadingMore: append,
    );
    final currentFixtures = state.value.fixtures;
    final response =
        await ApiErrorHandler.handle<LeagueDetailsFixturesViewModel>(
          () => _service.fetchLeagueFixturesByRound(
            leagueId: leagueId,
            season: seasonYear,
            round: round,
            roundLabels: currentFixtures.roundLabels,
            page: page,
            existingSections: append
                ? currentFixtures.byRoundSections
                : const <LeagueDetailsFixtureSectionUiModel>[],
          ),
          fallbackErrorCode: 'league_fixture_round_fetch_failed',
          userMessage: 'Unable to load round fixtures right now.',
        );

    if (isClosed) {
      return;
    }

    if (!response.success || response.data == null) {
      state.value = state.value.copyWith(
        isFixturesLoading: false,
        isFixturesLoadingMore: false,
      );
      return;
    }

    final nextFixtures = response.data!.copyWith(
      mode: LeagueDetailsFixturesMode.byRound,
      fromDate: currentFixtures.fromDate,
      toDate: currentFixtures.toDate,
      byDateSections: currentFixtures.byDateSections,
      datePage: currentFixtures.datePage,
      dateTotalPages: currentFixtures.dateTotalPages,
      selectedTeamId: currentFixtures.selectedTeamId,
      selectedTeamLabel: currentFixtures.selectedTeamLabel,
      selectedTeamLogoUrl: currentFixtures.selectedTeamLogoUrl,
      teamOptions: currentFixtures.teamOptions,
      byTeamSections: currentFixtures.byTeamSections,
      teamPage: currentFixtures.teamPage,
      teamTotalPages: currentFixtures.teamTotalPages,
    );

    state.value = state.value.copyWith(
      isFixturesLoading: false,
      isFixturesLoadingMore: false,
      fixtures: nextFixtures,
    );
  }

  Future<void> _loadFixturesByTeam({
    LeagueDetailsStandingsRowUiModel? team,
    int page = 1,
    bool append = false,
  }) async {
    final leagueId = _currentLeagueId;
    final seasonYear = _currentSeasonYear;
    if (leagueId == null || seasonYear == null) {
      return;
    }

    final fixtures = state.value.fixtures;
    final teams = fixtures.teamOptions.isNotEmpty
        ? fixtures.teamOptions
        : state.value.standingsRows;
    if (teams.isEmpty) {
      return;
    }

    final selected =
        team ??
        teams.firstWhere(
          (item) => item.teamId == fixtures.selectedTeamId,
          orElse: () => teams.first,
        );
    if (selected.teamId.isEmpty) {
      return;
    }

    state.value = state.value.copyWith(
      isFixturesLoading: append ? state.value.isFixturesLoading : true,
      isFixturesLoadingMore: append,
    );
    final currentFixtures = state.value.fixtures;
    final response =
        await ApiErrorHandler.handle<LeagueDetailsFixturesViewModel>(
          () => _service.fetchLeagueFixturesByTeam(
            leagueId: leagueId,
            season: seasonYear,
            teamId: selected.teamId,
            teamName: selected.teamName,
            teamLogoUrl: selected.teamLogoUrl,
            teamOptions: teams,
            page: page,
            existingSections: append
                ? currentFixtures.byTeamSections
                : const <LeagueDetailsFixtureSectionUiModel>[],
          ),
          fallbackErrorCode: 'league_fixture_team_fetch_failed',
          userMessage: 'Unable to load team fixtures right now.',
        );

    if (isClosed) {
      return;
    }

    if (!response.success || response.data == null) {
      state.value = state.value.copyWith(
        isFixturesLoading: false,
        isFixturesLoadingMore: false,
      );
      return;
    }

    final nextFixtures = response.data!.copyWith(
      mode: LeagueDetailsFixturesMode.byTeam,
      fromDate: currentFixtures.fromDate,
      toDate: currentFixtures.toDate,
      byDateSections: currentFixtures.byDateSections,
      datePage: currentFixtures.datePage,
      dateTotalPages: currentFixtures.dateTotalPages,
      roundLabels: currentFixtures.roundLabels,
      selectedRoundLabel: currentFixtures.selectedRoundLabel,
      byRoundSections: currentFixtures.byRoundSections,
      roundPage: currentFixtures.roundPage,
      roundTotalPages: currentFixtures.roundTotalPages,
    );

    state.value = state.value.copyWith(
      isFixturesLoading: false,
      isFixturesLoadingMore: false,
      fixtures: nextFixtures,
    );
  }

  DateTimeRange _dateRangeFromFixtures(
    LeagueDetailsFixturesViewModel fixtures,
  ) {
    final fallback = defaultFixtureDateRange();
    final start =
        DateTime.tryParse(fixtures.fromDate) ?? DateTime.parse(fallback.start);
    final end =
        DateTime.tryParse(fixtures.toDate) ?? DateTime.parse(fallback.end);
    return DateTimeRange(start: start, end: end);
  }

  String _dateString(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  int? get _currentLeagueId {
    final league = state.value.league ?? initialLeague;
    return int.tryParse(league?.leagueId ?? '');
  }

  int? get _currentSeasonYear {
    final selectedSeason = state.value.selectedSeason;
    final match = RegExp(r'\d{4}').firstMatch(selectedSeason);
    if (match != null) {
      return int.tryParse(match.group(0)!);
    }
    return (state.value.league ?? initialLeague)?.season;
  }

  Future<void> follow() async {
    final league = state.value.league;
    final payload = FollowEntityPayloadModel(
      entityType: FollowEntityType.league,
      entityId: league?.leagueId ?? 'premier-league',
      entityName: league?.leagueName,
      entityLogo: league?.image,
      notificationEnabled: true,
    );

    await ApiErrorHandler.handle<FollowingActionUiModel>(
      () => _followingService.follow(payload),
      fallbackErrorCode: 'league_follow_failed',
      userMessage: 'Could not follow this league right now.',
    );
  }

  Future<void> unfollow() async {
    final payload = UnfollowPayloadModel(
      entityType: FollowEntityType.league,
      entityId: state.value.league?.leagueId ?? 'premier-league',
    );

    await ApiErrorHandler.handle<FollowingActionUiModel>(
      () => _followingService.unfollow(payload),
      fallbackErrorCode: 'league_unfollow_failed',
      userMessage: 'Could not unfollow this league right now.',
    );
  }

  void _syncFollowingState() {
    state.value = state.value.copyWith(
      isFollowing: _followingService.isFollowing(
        FollowEntityType.league,
        state.value.league?.leagueId ?? 'premier-league',
      ),
    );
  }

  static const List<LeagueDetailsPlayerStatsCategoryData>
  playerStatsCategories = <LeagueDetailsPlayerStatsCategoryData>[
    LeagueDetailsPlayerStatsCategoryData(
      title: 'Top Stats',
      availableFilters: <String>[
        'Top scorer',
        'Assists',
        'Goals + Assists',
        'Minutes Played',
      ],
      cards: <LeagueDetailsPlayerStatsCardData>[
        LeagueDetailsPlayerStatsCardData(
          title: 'Top Scorers',
          filterLabel: 'Top scorer',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Top Assists',
          filterLabel: 'Assists',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Goals + Assists',
          filterLabel: 'Goals + Assists',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Minutes Played',
          filterLabel: 'Minutes Played',
        ),
      ],
    ),
    LeagueDetailsPlayerStatsCategoryData(
      title: 'Attack',
      availableFilters: <String>[
        'Shot Attempts',
        'Shots on Target',
        'Penalty Scored',
        'Penalty Missed',
        'Big chances created',
        'Chances created',
        'Big chances missed',
        'Penalties awarded',
      ],
      cards: <LeagueDetailsPlayerStatsCardData>[
        LeagueDetailsPlayerStatsCardData(
          title: 'Shot Attempts',
          filterLabel: 'Shot Attempts',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Shots on Target',
          filterLabel: 'Shots on Target',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Penalty Scored',
          filterLabel: 'Penalty Scored',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Penalty Missed',
          filterLabel: 'Penalty Missed',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Big Chances Created',
          filterLabel: 'Big chances created',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Big Chances Missed',
          filterLabel: 'Big chances missed',
        ),
      ],
    ),
    LeagueDetailsPlayerStatsCategoryData(
      title: 'Defense',
      availableFilters: <String>[
        'Tackles',
        'Interceptions',
        'Blocks',
        'Defense contribution',
        'Clearances',
        'Recoveries',
        'Penalties conceded',
      ],
      cards: <LeagueDetailsPlayerStatsCardData>[
        LeagueDetailsPlayerStatsCardData(
          title: 'Tackles',
          filterLabel: 'Tackles',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Interceptions',
          filterLabel: 'Interceptions',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Blocks',
          filterLabel: 'Blocks',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Defense contribution',
          filterLabel: 'Defense contribution',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Clearance',
          filterLabel: 'Clearances',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Recoveries',
          filterLabel: 'Recoveries',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Penalties conceded',
          filterLabel: 'Penalties conceded',
        ),
      ],
    ),
    LeagueDetailsPlayerStatsCategoryData(
      title: 'Goalkeeping',
      availableFilters: <String>[
        'Saves',
        'Goals Conceded',
        'Penalty Saved',
        'Goals prevented',
        'Clean sheets',
        'Save percentage',
      ],
      cards: <LeagueDetailsPlayerStatsCardData>[
        LeagueDetailsPlayerStatsCardData(title: 'Saves', filterLabel: 'Saves'),
        LeagueDetailsPlayerStatsCardData(
          title: 'Goals Conceded',
          filterLabel: 'Goals Conceded',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Penalty Saved',
          filterLabel: 'Penalty Saved',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Goals prevented',
          filterLabel: 'Goals prevented',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Clean sheets',
          filterLabel: 'Clean sheets',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Save percentage',
          filterLabel: 'Save percentage',
        ),
      ],
    ),
    LeagueDetailsPlayerStatsCategoryData(
      title: 'Discipline',
      availableFilters: <String>[
        'Yellow Cards',
        'Red Cards',
        'Fouls Committed',
        'Fouls Drawn',
      ],
      cards: <LeagueDetailsPlayerStatsCardData>[
        LeagueDetailsPlayerStatsCardData(
          title: 'Yellow Cards',
          filterLabel: 'Yellow Cards',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Red Cards',
          filterLabel: 'Red Cards',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Fouls Committed',
          filterLabel: 'Fouls Committed',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Fouls Drawn',
          filterLabel: 'Fouls Drawn',
        ),
      ],
    ),
  ];

  static const List<String> _topStatsLabels = <String>[
    'Goals per Match',
    'Goals Conceded per Match',
    'Clean Sheets',
    'Wins',
    'Failed to Score',
    'Average possession',
    'Attendance',
  ];

  static const List<String> _attackTeamLabels = <String>[
    'Shot Attempts',
    'Shots on Target',
    'Key Passes',
    'Penalty Scored',
    'Penalty Missed',
    'Big chances',
    'Big chances missed',
    'Accurate passes per match',
    'Accurate long balls per match',
    'Accurate crosses per match',
    'Penalties awarded',
    'Touches in opposition box',
    'Corners',
    'Set piece goals',
  ];

  static const List<String> _defenseTeamLabels = <String>[
    'Tackles',
    'Interceptions',
    'Blocks',
    'Saves',
    'Goals Conceded',
    'Interceptions per match',
    'Tackles per match',
    'Clearances per match',
    'Possession won final 3rd per match',
    'Set piece goals conceded',
    'Penalties conceded',
    'Saves per match',
  ];

  static const List<String> _disciplineTeamLabels = <String>[
    'Yellow Cards',
    'Red Cards',
    'Fouls Committed',
    'Fouls Drawn',
    'Fouls per match',
  ];

  static List<LeagueDetailsPlayerStatRowUiModel> teamStatsRowsFor(
    String filterLabel,
  ) {
    if (!Get.isRegistered<LeagueDetailsController>()) {
      return const <LeagueDetailsPlayerStatRowUiModel>[];
    }

    final state = Get.find<LeagueDetailsController>().state.value;
    final normalized = _normalizePlayerStatLabel(filterLabel);

    for (final section in state.teamStatsSections) {
      if (_normalizePlayerStatLabel(section.title) == normalized ||
          _normalizePlayerStatLabel(section.key) == normalized) {
        return section.rows;
      }
    }

    return const <LeagueDetailsPlayerStatRowUiModel>[];
  }

  static List<LeagueDetailsPlayerStatsPreviewRowData> playerStatsPreviewRowsFor(
    String filterLabel,
  ) {
    final rows = _remotePlayerRowsFor(
      filterLabel,
    ).take(3).toList(growable: false);
    if (rows.isNotEmpty) {
      return rows
          .map(
            (row) => LeagueDetailsPlayerStatsPreviewRowData(
              rank: row.rank,
              playerId: row.playerId,
              name: row.name,
              teamId: row.teamId,
              teamName: row.teamName,
              value: row.value,
              playerImageUrl: row.playerImageUrl,
            ),
          )
          .toList(growable: false);
    }

    return const <LeagueDetailsPlayerStatsPreviewRowData>[];
  }

  static List<LeagueDetailsPlayerStatsDetailRowData> playerStatsDetailRowsFor(
    String filterLabel,
  ) {
    final remoteRows = _remotePlayerRowsFor(filterLabel);
    if (remoteRows.isNotEmpty) {
      return remoteRows
          .map(
            (row) => LeagueDetailsPlayerStatsDetailRowData(
              rank: row.rank.replaceAll('.', ''),
              playerId: row.playerId,
              name: row.name,
              teamId: row.teamId,
              teamName: row.teamName,
              value: row.value,
              subtitleValue: row.subtitleValue.isEmpty
                  ? '-'
                  : row.subtitleValue,
              playerImageUrl: row.playerImageUrl,
              teamLogoUrl: row.teamLogoUrl,
            ),
          )
          .toList(growable: false);
    }

    return const <LeagueDetailsPlayerStatsDetailRowData>[];
  }

  static List<LeagueDetailsPlayerStatRowUiModel> _remotePlayerRowsFor(
    String filterLabel,
  ) {
    if (!Get.isRegistered<LeagueDetailsController>()) {
      return const <LeagueDetailsPlayerStatRowUiModel>[];
    }

    final state = Get.find<LeagueDetailsController>().state.value;
    final normalized = _normalizePlayerStatLabel(filterLabel);

    for (final section in state.playerStatsSections) {
      if (_normalizePlayerStatLabel(section.title) == normalized ||
          _normalizePlayerStatLabel(section.key) == normalized) {
        return section.rows;
      }
    }

    if (normalized == _normalizePlayerStatLabel('Assists')) {
      return state.topAssistsRows;
    }

    if (normalized == _normalizePlayerStatLabel('Top scorer')) {
      return state.topScorersRows;
    }

    if (normalized == _normalizePlayerStatLabel('Goals + Assists')) {
      final combined = <LeagueDetailsPlayerStatRowUiModel>[];
      for (final row in state.topScorersRows) {
        final goals = int.tryParse(row.value) ?? 0;
        final assists = int.tryParse(row.subtitleValue) ?? 0;
        combined.add(
          LeagueDetailsPlayerStatRowUiModel(
            rank: row.rank,
            playerId: row.playerId,
            name: row.name,
            teamId: row.teamId,
            teamName: row.teamName,
            value: '${goals + assists}',
            subtitleValue: assists.toString(),
            playerImageUrl: row.playerImageUrl,
            teamLogoUrl: row.teamLogoUrl,
          ),
        );
      }
      combined.sort(
        (left, right) => (int.tryParse(right.value) ?? 0).compareTo(
          int.tryParse(left.value) ?? 0,
        ),
      );
      return List<LeagueDetailsPlayerStatRowUiModel>.generate(combined.length, (
        index,
      ) {
        final row = combined[index];
        return LeagueDetailsPlayerStatRowUiModel(
          rank: '${index + 1}.',
          playerId: row.playerId,
          name: row.name,
          teamId: row.teamId,
          teamName: row.teamName,
          value: row.value,
          subtitleValue: row.subtitleValue,
          playerImageUrl: row.playerImageUrl,
          teamLogoUrl: row.teamLogoUrl,
        );
      }, growable: false);
    }

    return const <LeagueDetailsPlayerStatRowUiModel>[];
  }

  static String _normalizePlayerStatLabel(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll('&', 'and')
        .replaceAll(RegExp(r'[^a-z0-9]+'), '');
  }

  static String playerStatsSubtitleLabelFor(String filterLabel) {
    final normalized = filterLabel.toLowerCase();
    final normalizedCompact = _normalizePlayerStatLabel(filterLabel);
    if (Get.isRegistered<LeagueDetailsController>()) {
      final sections =
          Get.find<LeagueDetailsController>().state.value.playerStatsSections;
      final isApiSection = sections.any(
        (section) =>
            _normalizePlayerStatLabel(section.title) == normalizedCompact ||
            _normalizePlayerStatLabel(section.key) == normalizedCompact,
      );
      if (isApiSection) {
        return 'Team';
      }
    }

    if (normalized == 'minutes played') {
      return 'Minutes per 90';
    }

    if (normalized == 'assists') {
      return 'Big chances';
    }

    if (normalized == 'goals + assists') {
      return 'Assists';
    }

    if (normalized == 'big chances created' ||
        normalized == 'chances created') {
      return 'Chances';
    }

    if (normalized == 'big chances missed') {
      return 'Shots on target';
    }

    if (normalized == 'penalties awarded' || normalized == 'top scorer') {
      return 'Penalty goals';
    }

    if (normalized == 'tackles') {
      return 'Successful tackles';
    }

    if (normalized == 'interceptions' || normalized == 'defense contribution') {
      return 'Interceptions';
    }

    if (normalized == 'clearances') {
      return 'Aerial duels won';
    }

    if (normalized == 'blocks') {
      return 'Shot blocks';
    }

    if (normalized == 'recoveries') {
      return 'Possession won';
    }

    if (normalized == 'penalties conceded') {
      return 'Errors';
    }

    if (normalized == 'clean sheets') {
      return 'Goals conceded';
    }

    if (normalized == 'save percentage') {
      return 'Saves';
    }

    if (normalized == 'goals prevented') {
      return 'Goals conceded';
    }

    if (normalized == 'goals conceded') {
      return 'Clean sheets';
    }

    if (normalized == 'fouls committed') {
      return 'Yellow cards';
    }

    if (normalized == 'yellow cards') {
      return 'Fouls';
    }

    if (normalized == 'red cards') {
      return 'Yellow cards';
    }

    return 'Penalty goals';
  }
}

class LeagueDetailsBinding extends Bindings {
  @override
  void dependencies() {
    final arguments = Get.arguments;
    LeaguesTopLeagueUiModel? league;

    if (arguments is LeaguesTopLeagueUiModel) {
      league = arguments;
    } else if (arguments is Map<String, dynamic>) {
      final candidate = arguments['league'];
      if (candidate is LeaguesTopLeagueUiModel) {
        league = candidate;
      }
    }

    if (!Get.isRegistered<FollowingService>()) {
      Get.lazyPut<FollowingService>(
        () => FollowingService(
          apiClient: Get.find<ApiClient>(),
          storageService: Get.find<StorageService>(),
        ),
        fenix: true,
      );
    }

    if (!Get.isRegistered<LeagueDetailsService>()) {
      Get.lazyPut<LeagueDetailsService>(
        () => LeagueDetailsService(apiClient: Get.find<ApiClient>()),
        fenix: true,
      );
    }

    Get.lazyPut<LeagueDetailsController>(
      () => LeagueDetailsController(
        initialLeague: league,
        service: Get.find<LeagueDetailsService>(),
      ),
    );
  }
}

class LeagueDetailsPlayerStatsCategoryData {
  final String title;
  final List<String> availableFilters;
  final List<LeagueDetailsPlayerStatsCardData> cards;

  const LeagueDetailsPlayerStatsCategoryData({
    required this.title,
    required this.availableFilters,
    required this.cards,
  });
}

class LeagueDetailsPlayerStatsCardData {
  final String title;
  final String filterLabel;

  const LeagueDetailsPlayerStatsCardData({
    required this.title,
    required this.filterLabel,
  });
}

class LeagueDetailsPlayerStatsPreviewRowData {
  final String rank;
  final String playerId;
  final String name;
  final String teamId;
  final String teamName;
  final String value;
  final String playerImageUrl;

  const LeagueDetailsPlayerStatsPreviewRowData({
    required this.rank,
    this.playerId = '',
    required this.name,
    this.teamId = '',
    required this.teamName,
    required this.value,
    this.playerImageUrl = '',
  });
}

class LeagueDetailsPlayerStatsDetailRowData {
  final String rank;
  final String playerId;
  final String name;
  final String teamId;
  final String teamName;
  final String value;
  final String subtitleValue;
  final String playerImageUrl;
  final String teamLogoUrl;

  const LeagueDetailsPlayerStatsDetailRowData({
    required this.rank,
    this.playerId = '',
    required this.name,
    this.teamId = '',
    this.teamName = '',
    required this.value,
    required this.subtitleValue,
    this.playerImageUrl = '',
    this.teamLogoUrl = '',
  });
}
