import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/models/following_models.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/api_error_handler.dart';
import '../../../core/services/following_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../routes/routes.dart';
import '../../team/team_profile_model.dart' as team_models;
import '../matches_controller.dart';
import '../model/matches_models.dart';
import 'models/match_details_model.dart';
import 'services/match_detials_service.dart';

class MatchDetailsController extends GetxController {
  final MatchDetialsService _service;
  final FollowingService _followingService;

  MatchDetailsController({
    required MatchDetialsService service,
    required FollowingService followingService,
  }) : _service = service,
       _followingService = followingService;

  final Rx<MatchDetailsScreenUiModel> state = _buildScreen(
    MatchDetailsScenario.finished,
  ).obs;

  final RxBool isFixtureDetailsLoading = false.obs;
  final RxBool isFixtureDetailsNotFound = false.obs;
  final RxBool isTeamFormLoading = false.obs;
  final RxBool isHeadToHeadLoading = false.obs;
  final RxBool isHeadToHeadLoadingMore = false.obs;
  final RxBool canLoadMoreHeadToHead = false.obs;
  final RxBool isMatchFollowing = false.obs;
  final RxBool isFollowActionLoading = false.obs;
  final RxBool isAboutExpanded = false.obs;

  static const int _headToHeadPageSize = 5;
  Timer? _fixtureRefreshTimer;
  Worker? _followingWorker;
  bool _isFixtureRefreshInFlight = false;

  String teamId = '12345';
  String _fixtureId = '';
  String _leagueId = '';
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
      _fixtureId = _argumentString(argument, const <String>[
        'fixtureId',
        'fixture_id',
        'id',
      ], _fixtureId);
      _homeTeamId = _argumentString(argument, const <String>[
        'homeTeamId',
        'home_team_id',
        'homeId',
      ], _homeTeamId);
      _awayTeamId = _argumentString(argument, const <String>[
        'awayTeamId',
        'away_team_id',
        'awayId',
      ], _awayTeamId);
      teamId = _homeTeamId;
    }

    _pauseParentLiveRefresh();
    _syncFollowingState();
    _followingWorker = ever<int>(
      _followingService.revision,
      (_) => _syncFollowingState(),
    );
    loadScenario(selectedScenario);
    _loadInitialDetails();
  }

  @override
  void onClose() {
    _fixtureRefreshTimer?.cancel();
    _followingWorker?.dispose();
    _resumeParentLiveRefresh();
    super.onClose();
  }

  void _pauseParentLiveRefresh() {
    if (Get.isRegistered<MatchesController>()) {
      Get.find<MatchesController>().pauseLiveRefreshForMatchDetails();
    }
  }

  void _resumeParentLiveRefresh() {
    if (Get.isRegistered<MatchesController>()) {
      Get.find<MatchesController>().resumeLiveRefreshAfterMatchDetails();
    }
  }

  void onTeamNameTap([String? selectedTeamId]) {
    final nextTeamId = selectedTeamId?.trim();
    final resolvedTeamId = nextTeamId == null || nextTeamId.isEmpty
        ? teamId
        : nextTeamId;
    Get.toNamed(
      AppRoutes.teamProfile,
      arguments: <String, dynamic>{'teamId': resolvedTeamId},
    );
  }

  void loadScenario(MatchDetailsScenario scenario) {
    isAboutExpanded.value = false;
    state.value = _buildScreen(scenario);
  }

  void toggleAboutExpanded() {
    isAboutExpanded.value = !isAboutExpanded.value;
  }

  Future<void> follow() async {
    final entityId = _matchFollowEntityId;
    if (entityId.isEmpty || isFollowActionLoading.value) {
      return;
    }

    isFollowActionLoading.value = true;

    final payload = FollowEntityPayloadModel(
      entityType: FollowEntityType.match,
      entityId: entityId,
      entityName: _matchFollowName,
      notificationEnabled: true,
      metadata: _matchFollowMetadata,
    );

    final response = await ApiErrorHandler.handle<FollowingActionUiModel>(
      () => _followingService.follow(payload),
      fallbackErrorCode: 'match_follow_failed',
      userMessage: 'Could not follow this match right now.',
    );

    if (isClosed) {
      return;
    }

    isFollowActionLoading.value = false;
    if (response.success) {
      _syncFollowingState();
    }
  }

  Future<void> unfollow() async {
    final entityId = _matchFollowEntityId;
    if (entityId.isEmpty || isFollowActionLoading.value) {
      return;
    }

    isFollowActionLoading.value = true;

    final payload = UnfollowPayloadModel(
      entityType: FollowEntityType.match,
      entityId: entityId,
    );

    final response = await ApiErrorHandler.handle<FollowingActionUiModel>(
      () => _followingService.unfollow(payload),
      fallbackErrorCode: 'match_unfollow_failed',
      userMessage: 'Could not unfollow this match right now.',
    );

    if (isClosed) {
      return;
    }

    isFollowActionLoading.value = false;
    if (response.success) {
      _syncFollowingState();
    }
  }

  void _syncFollowingState() {
    final entityId = _matchFollowEntityId;
    isMatchFollowing.value =
        entityId.isNotEmpty &&
        _followingService.isFollowing(FollowEntityType.match, entityId);
  }

  String get _matchFollowEntityId {
    final trimmedFixtureId = _fixtureId.trim();
    if (trimmedFixtureId.isNotEmpty) {
      return trimmedFixtureId;
    }

    final homeId = _homeTeamId.trim();
    final awayId = _awayTeamId.trim();
    if (homeId.isNotEmpty && awayId.isNotEmpty) {
      return '$homeId-$awayId';
    }

    return '';
  }

  String get _matchFollowName {
    final header = state.value.header;
    return '${header.homeTeam.name} vs ${header.awayTeam.name}';
  }

  Map<String, dynamic> get _matchFollowMetadata {
    final header = state.value.header;
    return <String, dynamic>{
      'fixtureId': _fixtureId,
      'homeTeamId': _homeTeamId,
      'awayTeamId': _awayTeamId,
      'homeTeamName': header.homeTeam.name,
      'awayTeamName': header.awayTeam.name,
      'homeTeamLogo': header.homeTeam.logoUrl,
      'awayTeamLogo': header.awayTeam.logoUrl,
      'leagueId': _leagueId,
      'competition': header.metaCompetition,
      'dateTime': header.metaDateTime,
      'status': header.statusChipLabel,
    }..removeWhere((_, value) {
      if (value == null) {
        return true;
      }
      if (value is String) {
        return value.trim().isEmpty;
      }
      return false;
    });
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
    final matches = fixtures.map(_toHeadToHeadMatch).toList(growable: false);

    _headToHeadLast = last;
    canLoadMoreHeadToHead.value =
        matches.length >= last && matches.length > previousCount;

    state.value = state.value.copyWith(
      headToHeadSummary: _buildHeadToHeadSummary(fixtures),
      headToHeadMatches: matches,
    );
  }

  Future<void> _loadNextHeadToHeadMatches() async {
    final safeHomeTeamId = _homeTeamId.trim();
    final safeAwayTeamId = _awayTeamId.trim();

    if (safeHomeTeamId.isEmpty || safeAwayTeamId.isEmpty) {
      state.value = state.value.copyWith(
        nextMatches: const <MatchDetailsNextMatchUiModel>[],
      );
      return;
    }

    final response = await ApiErrorHandler.handle<FootballFixturesDataModel>(
      () => _service.fetchHeadToHead(
        homeTeamId: safeHomeTeamId,
        awayTeamId: safeAwayTeamId,
        next: 3,
      ),
      fallbackErrorCode: 'next_head_to_head_fetch_failed',
      userMessage: 'Unable to load next matches right now.',
      showUserError: false,
    );

    if (isClosed) return;

    final fixtures = response.success && response.data != null
        ? response.data!.response
        : const <FootballFixtureModel>[];

    state.value = state.value.copyWith(
      nextMatches: fixtures.map(_toNextMatch).toList(growable: false),
    );
  }

  Future<void> _loadInitialDetails() async {
    if (_fixtureId.isNotEmpty) {
      await _loadFixtureDetails();
    }

    final futures = <Future<void>>[];

    if (_leagueId.trim().isNotEmpty &&
        _homeTeamId.trim().isNotEmpty &&
        _awayTeamId.trim().isNotEmpty) {
      futures.add(_loadTeamForm());
    }

    if (_homeTeamId.trim().isNotEmpty && _awayTeamId.trim().isNotEmpty) {
      futures.add(
        _loadHeadToHead(last: _headToHeadPageSize, isLoadMore: false),
      );
      futures.add(_loadNextHeadToHeadMatches());
    }

    await Future.wait<void>(futures);
  }

  Future<void> _loadFixtureDetails({
    bool showLoading = true,
    bool refreshAbout = true,
  }) async {
    if (showLoading) {
      isFixtureDetailsLoading.value = true;
      isFixtureDetailsNotFound.value = false;
    }

    final response = await ApiErrorHandler.handle<FootballFixtureModel>(
      () => _service.fetchFixtureById(fixtureId: _fixtureId),
      fallbackErrorCode: 'fixture_details_fetch_failed',
      userMessage: 'Unable to load match details right now.',
    );

    if (isClosed) return;

    if (showLoading) {
      isFixtureDetailsLoading.value = false;
    }

    if (!response.success || response.data == null) {
      final code = response.errorCode ?? '';
      isFixtureDetailsNotFound.value =
          code.contains('fixture_not_found') || code.contains('empty_response');
      return;
    }

    final fixture = response.data!;
    _leagueId = fixture.league.id?.toString() ?? _leagueId;
    final homeId = fixture.teams.home.id?.toString() ?? '';
    final awayId = fixture.teams.away.id?.toString() ?? '';

    if (homeId.isNotEmpty) {
      _homeTeamId = homeId;
      teamId = homeId;
    }
    if (awayId.isNotEmpty) {
      _awayTeamId = awayId;
    }
    _syncFollowingState();

    final nextScenario = _scenarioFromFixture(fixture);
    final base = _buildScreen(nextScenario);
    final previousState = state.value;

    state.value = base.copyWith(
      visibleTabs: _visibleTabsForScenario(nextScenario, showKnockout: false),
      header: _buildHeader(fixture, nextScenario),
      venue: _buildVenue(fixture),
      meta: _buildMeta(fixture),
      topScorers: nextScenario == MatchDetailsScenario.upcoming
          ? previousState.topScorers
          : null,
      teamForm: refreshAbout ? _emptyTeamForm : previousState.teamForm,
      aboutText: refreshAbout
          ? _buildAboutText(fixture)
          : previousState.aboutText,
      playerOfTheMatch: _buildPlayerOfTheMatch(fixture),
      factsTopStats: _buildStatsSections(fixture, topOnly: true),
      events: _buildEvents(fixture),
      timelineMarkers: _buildTimelineMarkers(fixture),
      nextMatches: previousState.nextMatches,
      statsSections: _buildStatsSections(fixture, topOnly: false),
      headToHeadSummary: previousState.headToHeadSummary,
      headToHeadMatches: previousState.headToHeadMatches,
      lineup: _buildLineup(fixture),
    );

    _scheduleFixtureRefresh();
    if (refreshAbout) {
      final futures = <Future<void>>[_loadMatchAbout()];
      if (nextScenario == MatchDetailsScenario.upcoming) {
        futures.add(_loadUpcomingTopScorers(fixture));
      }
      unawaited(Future.wait<void>(futures));
    }
  }

  Future<void> _loadUpcomingTopScorers(FootballFixtureModel fixture) async {
    final leagueId = fixture.league.id;
    final season = fixture.league.season;
    final homeTeamId = fixture.teams.home.id?.toString() ?? _homeTeamId;
    final awayTeamId = fixture.teams.away.id?.toString() ?? _awayTeamId;

    if (leagueId == null || season == null) {
      state.value = state.value.copyWith(topScorers: null);
      return;
    }

    final responses =
        await Future.wait<
          ApiResponseModel<team_models.FootballTeamPlayersDataModel>
        >([
          ApiErrorHandler.handle<team_models.FootballTeamPlayersDataModel>(
            () => _service.fetchTeamPlayersForLeague(
              teamId: homeTeamId,
              season: season,
              leagueId: leagueId,
            ),
            fallbackErrorCode: 'home_top_scorers_fetch_failed',
            userMessage: 'Unable to load home team top scorers right now.',
            showUserError: false,
          ),
          ApiErrorHandler.handle<team_models.FootballTeamPlayersDataModel>(
            () => _service.fetchTeamPlayersForLeague(
              teamId: awayTeamId,
              season: season,
              leagueId: leagueId,
            ),
            fallbackErrorCode: 'away_top_scorers_fetch_failed',
            userMessage: 'Unable to load away team top scorers right now.',
            showUserError: false,
          ),
        ]);

    if (isClosed) return;

    final homeTopScorer = responses[0].success && responses[0].data != null
        ? _topScorerFromPlayers(responses[0].data!.response, leagueId)
        : null;
    final awayTopScorer = responses[1].success && responses[1].data != null
        ? _topScorerFromPlayers(responses[1].data!.response, leagueId)
        : null;

    if (homeTopScorer == null && awayTopScorer == null) {
      state.value = state.value.copyWith(topScorers: null);
      return;
    }

    state.value = state.value.copyWith(
      topScorers: MatchDetailsTopScorerCompareUiModel(
        title: 'Top scorers',
        competitionLabel: fixture.league.name.isNotEmpty
            ? fixture.league.name
            : fixture.league.country,
        homePlayerName: homeTopScorer?.name ?? '-',
        awayPlayerName: awayTopScorer?.name ?? '-',
        homePlayerPhotoUrl: homeTopScorer?.photoUrl,
        awayPlayerPhotoUrl: awayTopScorer?.photoUrl,
        metrics: <MatchDetailsCompareMetricUiModel>[
          MatchDetailsCompareMetricUiModel(
            label: 'GOALS',
            homeValue: _metricValue(homeTopScorer?.goals),
            awayValue: _metricValue(awayTopScorer?.goals),
          ),
          MatchDetailsCompareMetricUiModel(
            label: 'ASSISTS',
            homeValue: _metricValue(homeTopScorer?.assists),
            awayValue: _metricValue(awayTopScorer?.assists),
          ),
          MatchDetailsCompareMetricUiModel(
            label: 'MATCHES PLAYED',
            homeValue: _metricValue(homeTopScorer?.appearances),
            awayValue: _metricValue(awayTopScorer?.appearances),
          ),
        ],
      ),
    );
  }

  _MatchTopScorerUiData? _topScorerFromPlayers(
    List<team_models.FootballTeamPlayerItemModel> players,
    int leagueId,
  ) {
    if (players.isEmpty) return null;

    final sorted = List<team_models.FootballTeamPlayerItemModel>.from(players);
    sorted.sort((left, right) {
      final leftStat = left.statisticForLeague(leagueId);
      final rightStat = right.statisticForLeague(leagueId);

      final leftGoals = leftStat?.goals.total ?? 0;
      final rightGoals = rightStat?.goals.total ?? 0;
      if (rightGoals.compareTo(leftGoals) != 0) {
        return rightGoals.compareTo(leftGoals);
      }

      final leftAssists = leftStat?.goals.assists ?? 0;
      final rightAssists = rightStat?.goals.assists ?? 0;
      if (rightAssists.compareTo(leftAssists) != 0) {
        return rightAssists.compareTo(leftAssists);
      }

      final leftAppearances = leftStat?.games.appearences ?? 0;
      final rightAppearances = rightStat?.games.appearences ?? 0;
      if (rightAppearances.compareTo(leftAppearances) != 0) {
        return rightAppearances.compareTo(leftAppearances);
      }

      final leftRating = leftStat?.games.ratingValue ?? 0;
      final rightRating = rightStat?.games.ratingValue ?? 0;
      return rightRating.compareTo(leftRating);
    });

    final item = sorted.first;
    final stat = item.statisticForLeague(leagueId);
    return _MatchTopScorerUiData(
      name: item.player.name,
      photoUrl: item.player.photo,
      goals: stat?.goals.total ?? 0,
      assists: stat?.goals.assists ?? 0,
      appearances: stat?.games.appearences ?? 0,
    );
  }

  String _metricValue(int? value) {
    return value == null ? '-' : value.toString();
  }

  Future<void> _loadMatchAbout() async {
    if (_fixtureId.trim().isEmpty) {
      return;
    }

    final response = await ApiErrorHandler.handle<MatchDetailsAboutDataModel>(
      () => _service.fetchMatchAbout(fixtureId: _fixtureId),
      fallbackErrorCode: 'match_about_fetch_failed',
      userMessage: 'Unable to load match about information right now.',
    );

    if (isClosed || !response.success || response.data == null) {
      return;
    }

    final about = response.data!;
    if (about.follow.entityId.isNotEmpty) {
      _followingService.setLocalFollowState(
        FollowEntityType.match,
        about.follow.entityId,
        about.follow.isFollowed,
      );
    }

    state.value = state.value.copyWith(
      aboutText: about.about.trim().isEmpty
          ? state.value.aboutText
          : about.about.trim(),
    );
    isMatchFollowing.value = about.follow.isFollowed;
    _syncFollowingState();
  }

  void _scheduleFixtureRefresh() {
    if (_fixtureId.trim().isEmpty || _fixtureRefreshTimer?.isActive == true) {
      return;
    }

    _fixtureRefreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _refreshFixtureDetailsSilently();
    });
  }

  Future<void> _refreshFixtureDetailsSilently() async {
    if (isClosed || _isFixtureRefreshInFlight) return;

    _isFixtureRefreshInFlight = true;
    try {
      await _loadFixtureDetails(showLoading: false, refreshAbout: false);
    } finally {
      _isFixtureRefreshInFlight = false;
    }
  }

  Future<void> _loadTeamForm() async {
    final safeLeagueId = _leagueId.trim();
    final safeHomeTeamId = _homeTeamId.trim();
    final safeAwayTeamId = _awayTeamId.trim();

    if (safeLeagueId.isEmpty ||
        safeHomeTeamId.isEmpty ||
        safeAwayTeamId.isEmpty) {
      state.value = state.value.copyWith(teamForm: _emptyTeamForm);
      return;
    }

    isTeamFormLoading.value = true;

    final responses =
        await Future.wait<ApiResponseModel<FootballFixturesDataModel>>([
          ApiErrorHandler.handle<FootballFixturesDataModel>(
            () => _service.fetchTeamFormFixtures(
              leagueId: safeLeagueId,
              teamId: safeHomeTeamId,
              last: 3,
            ),
            fallbackErrorCode: 'home_team_form_fetch_failed',
            userMessage: 'Unable to load home team form right now.',
          ),
          ApiErrorHandler.handle<FootballFixturesDataModel>(
            () => _service.fetchTeamFormFixtures(
              leagueId: safeLeagueId,
              teamId: safeAwayTeamId,
              last: 3,
            ),
            fallbackErrorCode: 'away_team_form_fetch_failed',
            userMessage: 'Unable to load away team form right now.',
          ),
        ]);

    final homeResponse = responses[0];
    final awayResponse = responses[1];

    if (isClosed) return;

    isTeamFormLoading.value = false;

    final homeFixtures = homeResponse.success && homeResponse.data != null
        ? homeResponse.data!.response
        : const <FootballFixtureModel>[];
    final awayFixtures = awayResponse.success && awayResponse.data != null
        ? awayResponse.data!.response
        : const <FootballFixtureModel>[];

    state.value = state.value.copyWith(
      teamForm: _buildTeamFormFromTeamFixtures(
        homeFixtures: homeFixtures,
        awayFixtures: awayFixtures,
      ),
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

    if (fixture.fixture.status.elapsed != null)
      return MatchDetailsScenario.live;

    const liveStatuses = <String>{
      '1H',
      'HT',
      '2H',
      'ET',
      'BT',
      'P',
      'SUSP',
      'INT',
    };
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
    final stadiumName = fixture.fixture.venue.name?.trim() ?? '';
    final city = fixture.fixture.venue.city?.trim() ?? '';
    final surface = fixture.fixture.venue.surface?.trim() ?? '';

    return MatchDetailsVenueUiModel(
      stadiumName: stadiumName.isEmpty ? 'Unknown stadium' : stadiumName,
      city: city,
      surface: surface,
      mapLabel: 'Map',
    );
  }

  MatchDetailsMetaInfoUiModel _buildMeta(FootballFixtureModel fixture) {
    return MatchDetailsMetaInfoUiModel(
      dateTime: _dateTimeLabel(fixture.fixture.kickoffAt),
      competition: fixture.league.name.isNotEmpty
          ? fixture.league.name
          : fixture.league.country,
      referee: fixture.fixture.referee?.trim() ?? '',
      stage: fixture.league.round.isNotEmpty
          ? fixture.league.round
          : fixture.league.country,
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
    final location = <String?>[
      venue,
      city,
    ].where((item) => item != null && item.trim().isNotEmpty).join(', ');

    return '$home faces $away${location.isEmpty ? '' : ' at $location'} on ${_dateTimeLabel(fixture.fixture.kickoffAt)}. This match is part of $competition.';
  }

  MatchDetailsLineupUiModel _buildLineup(FootballFixtureModel fixture) {
    final photos = _playerPhotoLookup(fixture);
    final matchedHomeLineup = _findLineup(
      fixture.lineups,
      fixture.teams.home.id,
    );
    final matchedAwayLineup = _findLineup(
      fixture.lineups,
      fixture.teams.away.id,
    );
    final homeLineup =
        matchedHomeLineup ??
        _fallbackLineup(fixture.lineups, 0, matchedAwayLineup);
    final awayLineup =
        matchedAwayLineup ?? _fallbackLineup(fixture.lineups, 1, homeLineup);

    final homeBlock = homeLineup == null
        ? _emptyLineupTeamBlock(
            teamName: fixture.teams.home.name,
            logoUrl: fixture.teams.home.logo,
          )
        : _toLineupTeamBlock(
            homeLineup,
            photos,
            fallbackTeamName: fixture.teams.home.name,
            fallbackLogoUrl: fixture.teams.home.logo,
            isHome: true,
          );
    final awayBlock = awayLineup == null
        ? _emptyLineupTeamBlock(
            teamName: fixture.teams.away.name,
            logoUrl: fixture.teams.away.logo,
          )
        : _toLineupTeamBlock(
            awayLineup,
            photos,
            fallbackTeamName: fixture.teams.away.name,
            fallbackLogoUrl: fixture.teams.away.logo,
            isHome: false,
          );

    final sectionLineups = _uniqueLineups(<FootballLineupModel?>[
      homeLineup,
      awayLineup,
      ...fixture.lineups,
    ]);
    final coaches = <MatchDetailsLineupPlayerUiModel>[];
    final substitutes = <MatchDetailsLineupPlayerUiModel>[];
    final bench = <MatchDetailsLineupPlayerUiModel>[];

    for (final lineup in sectionLineups) {
      final coach = _toCoachLineupPlayer(lineup.coach, 0);
      if (coach != null) coaches.add(coach);

      final lineupPeople = _toPeopleList(lineup.substitutes, photos);
      substitutes.addAll(lineupPeople.take(5));
      bench.addAll(lineupPeople.skip(5).take(4));
    }

    final hasPitch =
        homeBlock.players.isNotEmpty && awayBlock.players.isNotEmpty;
    final hasExtraLineupData =
        coaches.isNotEmpty || substitutes.isNotEmpty || bench.isNotEmpty;

    return MatchDetailsLineupUiModel(
      isPredicted: false,
      hasData: hasPitch || hasExtraLineupData,
      showPitch: hasPitch,
      home: homeBlock,
      away: awayBlock,
      coaches: coaches,
      substitutes: substitutes,
      bench: bench,
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

  FootballLineupModel? _fallbackLineup(
    List<FootballLineupModel> lineups,
    int preferredIndex,
    FootballLineupModel? excludedLineup,
  ) {
    if (lineups.isEmpty) return null;

    final preferredLineup = preferredIndex < lineups.length
        ? lineups[preferredIndex]
        : lineups.last;
    if (!_isSameLineup(preferredLineup, excludedLineup)) {
      return preferredLineup;
    }

    for (final lineup in lineups) {
      if (!_isSameLineup(lineup, excludedLineup)) return lineup;
    }

    return null;
  }

  bool _isSameLineup(FootballLineupModel? first, FootballLineupModel? second) {
    if (first == null || second == null) return false;
    if (identical(first, second)) return true;

    final firstTeamId = first.team.id;
    final secondTeamId = second.team.id;
    return firstTeamId != null &&
        secondTeamId != null &&
        firstTeamId == secondTeamId;
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

  MatchDetailsLineupTeamBlockUiModel _emptyLineupTeamBlock({
    required String teamName,
    required String? logoUrl,
  }) {
    return MatchDetailsLineupTeamBlockUiModel(
      teamName: teamName,
      formation: 'N/A',
      players: const <MatchDetailsLineupPlayerUiModel>[],
      logoUrl: logoUrl,
    );
  }

  MatchDetailsLineupTeamBlockUiModel _toLineupTeamBlock(
    FootballLineupModel lineup,
    Map<int, String> photos, {
    required String fallbackTeamName,
    required String? fallbackLogoUrl,
    required bool isHome,
  }) {
    final startingPlayers = lineup.startXI
        .where(_hasLineupPlayerInfo)
        .toList(growable: false);
    final useDefaultFormation =
        _isFormationMissing(lineup.formation) ||
        !_hasAnyValidGrid(startingPlayers);
    final positionedPlayers = useDefaultFormation
        ? _defaultFormationOrderedPlayers(startingPlayers)
        : startingPlayers;
    final rows = useDefaultFormation
        ? _defaultFormationRows(positionedPlayers.length)
        : _gridRows(positionedPlayers);
    final players = positionedPlayers
        .asMap()
        .entries
        .map((entry) {
          final fallbackPosition = useDefaultFormation
              ? _defaultFormationGridPosition(
                  entry.key,
                  positionedPlayers.length,
                )
              : null;

          return _toLineupPlayer(
            entry.value.player,
            photos,
            rows,
            lineup.team.colors,
            fallbackPosition: fallbackPosition,
            isHome: isHome,
          );
        })
        .toList(growable: false);

    return MatchDetailsLineupTeamBlockUiModel(
      teamName: lineup.team.name.trim().isEmpty
          ? fallbackTeamName
          : lineup.team.name,
      formation: _formationLabel(lineup.formation),
      players: players,
      logoUrl: _preferFilledString(lineup.team.logo, fallbackLogoUrl),
    );
  }

  List<FootballLineupModel> _uniqueLineups(List<FootballLineupModel?> lineups) {
    final uniqueLineups = <FootballLineupModel>[];

    for (final lineup in lineups) {
      if (lineup == null) continue;

      final alreadyAdded = uniqueLineups.any((item) {
        final currentId = item.team.id;
        final newId = lineup.team.id;
        return identical(item, lineup) ||
            (currentId != null && newId != null && currentId == newId);
      });

      if (!alreadyAdded) uniqueLineups.add(lineup);
    }

    return uniqueLineups;
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

  Map<int, int> _defaultFormationRows(int playerCount) {
    final lineCounts = _defaultFormationLineCounts(playerCount);
    return <int, int>{
      for (int index = 0; index < lineCounts.length; index++)
        index + 1: lineCounts[index],
    };
  }

  List<FootballLineupPlayerWrapperModel> _defaultFormationOrderedPlayers(
    List<FootballLineupPlayerWrapperModel> players,
  ) {
    final indexedPlayers = players.asMap().entries.toList();
    indexedPlayers.sort((first, second) {
      final weightComparison = _lineupPositionWeight(
        first.value.player.pos,
      ).compareTo(_lineupPositionWeight(second.value.player.pos));
      if (weightComparison != 0) return weightComparison;

      return first.key.compareTo(second.key);
    });

    return indexedPlayers.map((entry) => entry.value).toList(growable: false);
  }

  int _lineupPositionWeight(String position) {
    switch (position.trim().toUpperCase()) {
      case 'G':
      case 'GK':
        return 0;
      case 'D':
      case 'DF':
      case 'DEF':
        return 1;
      case 'M':
      case 'MF':
      case 'MID':
        return 2;
      case 'F':
      case 'FW':
      case 'ST':
      case 'CF':
        return 3;
      default:
        return 4;
    }
  }

  List<int> _defaultFormationLineCounts(int playerCount) {
    if (playerCount <= 0) return const <int>[];

    const preferredLines = <int>[1, 4, 3, 3];
    final lineCounts = <int>[];
    var remaining = playerCount;

    for (final count in preferredLines) {
      if (remaining <= 0) break;
      final lineCount = remaining >= count ? count : remaining;
      lineCounts.add(lineCount);
      remaining -= lineCount;
    }

    while (remaining > 0) {
      lineCounts[lineCounts.length - 1] += 1;
      remaining -= 1;
    }

    return lineCounts;
  }

  _GridPosition _defaultFormationGridPosition(int index, int playerCount) {
    final lineCounts = _defaultFormationLineCounts(playerCount);
    var remainingIndex = index;

    for (int rowIndex = 0; rowIndex < lineCounts.length; rowIndex++) {
      final lineCount = lineCounts[rowIndex];
      if (remainingIndex < lineCount) {
        return _GridPosition(row: rowIndex + 1, column: remainingIndex + 1);
      }
      remainingIndex -= lineCount;
    }

    return _GridPosition(
      row: lineCounts.isEmpty ? 1 : lineCounts.length,
      column: lineCounts.isEmpty ? 1 : lineCounts.last,
    );
  }

  bool _hasAnyValidGrid(List<FootballLineupPlayerWrapperModel> players) {
    return players.any((item) => _parseGrid(item.player.grid) != null);
  }

  bool _hasLineupPlayerInfo(FootballLineupPlayerWrapperModel item) {
    final player = item.player;
    return player.id != null ||
        player.name.trim().isNotEmpty ||
        player.number != null ||
        player.pos.trim().isNotEmpty;
  }

  bool _isFormationMissing(String formation) {
    final normalized = formation.trim().toLowerCase();
    return normalized.isEmpty ||
        normalized == '-' ||
        normalized == 'n/a' ||
        normalized == 'na' ||
        normalized == 'null';
  }

  String _formationLabel(String formation) {
    return _isFormationMissing(formation) ? 'N/A' : formation.trim();
  }

  String? _preferFilledString(String? primary, String? fallback) {
    final primaryValue = primary?.trim();
    if (primaryValue != null && primaryValue.isNotEmpty) return primaryValue;

    final fallbackValue = fallback?.trim();
    if (fallbackValue != null && fallbackValue.isNotEmpty) return fallbackValue;

    return null;
  }

  MatchDetailsLineupPlayerUiModel _toLineupPlayer(
    FootballLineupPlayerModel player,
    Map<int, String> photos,
    Map<int, int> rowColumns,
    FootballTeamColorsModel? colors, {
    required bool isHome,
    _GridPosition? fallbackPosition,
  }) {
    final parsedGrid = fallbackPosition ?? _parseGrid(player.grid);
    final row = parsedGrid?.row ?? 1;
    final column = parsedGrid?.column ?? 1;
    final maxColumn = rowColumns[row] ?? 1;
    final maxRow = rowColumns.keys.isEmpty
        ? 5
        : rowColumns.keys.reduce(
            (value, element) => value > element ? value : element,
          );

    final rawY = row / (maxRow + 1);
    final y = isHome ? rawY : 1 - rawY;
    final circleHex = player.pos.toUpperCase() == 'G'
        ? colors?.goalkeeper.primary
        : colors?.player.primary;

    final playerId = player.id;

    return MatchDetailsLineupPlayerUiModel(
      x: column / (maxColumn + 1),
      y: y.clamp(0.06, 0.94).toDouble(),
      name: _lineupPlayerName(player),
      subtitle: player.number == null
          ? player.pos
          : '#${player.number} • ${player.pos}',
      photoUrl: playerId == null ? null : photos[playerId],
      circleColor: _colorFromApiHex(circleHex, const Color(0xFF2FBC8D)),
    );
  }

  List<MatchDetailsLineupPlayerUiModel> _toPeopleList(
    List<FootballLineupPlayerWrapperModel> players,
    Map<int, String> photos,
  ) {
    return players
        .where(_hasLineupPlayerInfo)
        .map((item) {
          final playerId = item.player.id;
          return MatchDetailsLineupPlayerUiModel(
            x: 0,
            y: 0,
            name: _lineupPlayerName(item.player),
            subtitle: item.player.number == null
                ? item.player.pos
                : '#${item.player.number} • ${item.player.pos}',
            photoUrl: playerId == null ? null : photos[playerId],
          );
        })
        .toList(growable: false);
  }

  MatchDetailsLineupPlayerUiModel? _toCoachLineupPlayer(
    FootballCoachModel coach,
    double x,
  ) {
    if (!_hasCoachInfo(coach)) return null;

    return MatchDetailsLineupPlayerUiModel(
      x: x,
      y: 0,
      name: coach.name.trim().isEmpty ? 'Coach' : coach.name,
      subtitle: 'Coach',
      photoUrl: coach.photo,
    );
  }

  bool _hasCoachInfo(FootballCoachModel coach) {
    return coach.id != null ||
        coach.name.trim().isNotEmpty ||
        (coach.photo?.trim().isNotEmpty ?? false);
  }

  String _lineupPlayerName(FootballLineupPlayerModel player) {
    final name = player.name.trim();
    if (name.isNotEmpty) return name;
    if (player.number != null) return '#${player.number}';

    final position = player.pos.trim();
    if (position.isNotEmpty) return position.toUpperCase();

    return 'Player';
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
    FootballFixtureModel fixture, {
    required bool topOnly,
  }) {
    if (fixture.statistics.length < 2)
      return const <MatchDetailsStatSectionUiModel>[];

    final homeTeamId = fixture.teams.home.id;
    final awayTeamId = fixture.teams.away.id;
    final homeStats = _statisticsForTeam(fixture.statistics, homeTeamId);
    final awayStats = _statisticsForTeam(fixture.statistics, awayTeamId);

    if (homeStats.isEmpty && awayStats.isEmpty) {
      return const <MatchDetailsStatSectionUiModel>[];
    }

    final topStats = _statRows(homeStats, awayStats, const <String>[
      'Ball Possession',
      'Total Shots',
      'Shots on Goal',
      'Shots off Goal',
      'Corner Kicks',
      'Fouls',
      'Yellow Cards',
      'Red Cards',
      'expected_goals',
    ]);

    if (topOnly) {
      return topStats.isEmpty
          ? const <MatchDetailsStatSectionUiModel>[]
          : <MatchDetailsStatSectionUiModel>[
              MatchDetailsStatSectionUiModel(
                title: 'Top stats',
                showPossessionBar:
                    topStats.first.label.toLowerCase() == 'ball possession',
                rows: topStats,
              ),
            ];
    }

    final sections = <MatchDetailsStatSectionUiModel>[];

    if (topStats.isNotEmpty) {
      sections.add(
        MatchDetailsStatSectionUiModel(
          title: 'Top stats',
          showPossessionBar:
              topStats.first.label.toLowerCase() == 'ball possession',
          rows: topStats,
        ),
      );
    }

    _addStatSection(
      sections,
      title: 'Shots',
      homeStats: homeStats,
      awayStats: awayStats,
      labels: const <String>[
        'Total Shots',
        'Shots on Goal',
        'Shots off Goal',
        'Blocked Shots',
        'Shots insidebox',
        'Shots outsidebox',
      ],
    );

    _addStatSection(
      sections,
      title: 'Passing',
      homeStats: homeStats,
      awayStats: awayStats,
      labels: const <String>['Total passes', 'Passes accurate', 'Passes %'],
    );

    _addStatSection(
      sections,
      title: 'Discipline',
      homeStats: homeStats,
      awayStats: awayStats,
      labels: const <String>['Fouls', 'Yellow Cards', 'Red Cards'],
    );

    _addStatSection(
      sections,
      title: 'Defence',
      homeStats: homeStats,
      awayStats: awayStats,
      labels: const <String>['Goalkeeper Saves', 'goals_prevented', 'Offsides'],
    );

    return sections;
  }

  List<FootballStatisticItemModel> _statisticsForTeam(
    List<FootballTeamStatisticsModel> allStats,
    int? teamId,
  ) {
    if (teamId == null) return const <FootballStatisticItemModel>[];
    for (final item in allStats) {
      if (item.team.id == teamId) return item.statistics;
    }
    return const <FootballStatisticItemModel>[];
  }

  void _addStatSection(
    List<MatchDetailsStatSectionUiModel> sections, {
    required String title,
    required List<FootballStatisticItemModel> homeStats,
    required List<FootballStatisticItemModel> awayStats,
    required List<String> labels,
  }) {
    final rows = _statRows(homeStats, awayStats, labels);
    if (rows.isEmpty) return;

    sections.add(MatchDetailsStatSectionUiModel(title: title, rows: rows));
  }

  List<MatchDetailsStatRowUiModel> _statRows(
    List<FootballStatisticItemModel> homeStats,
    List<FootballStatisticItemModel> awayStats,
    List<String> labels,
  ) {
    final rows = <MatchDetailsStatRowUiModel>[];

    for (final label in labels) {
      final homeValue = _statValue(homeStats, label);
      final awayValue = _statValue(awayStats, label);

      if (homeValue == '-' && awayValue == '-') continue;

      rows.add(
        MatchDetailsStatRowUiModel(
          label: _statLabel(label),
          homeValue: homeValue,
          awayValue: awayValue,
        ),
      );
    }

    return rows;
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

  MatchDetailsPlayerOfMatchUiModel? _buildPlayerOfTheMatch(
    FootballFixtureModel fixture,
  ) {
    final winningTeamId = _winningTeamId(fixture);
    if (winningTeamId == null) return null;

    FootballPlayerMatchModel? selectedPlayer;
    FootballTeamModel? selectedTeam;
    double bestRating = -1;

    for (final teamPlayers in fixture.players) {
      if (teamPlayers.team.id != winningTeamId) continue;

      for (final player in teamPlayers.players) {
        if (player.statistics.isEmpty) continue;
        final rating = double.tryParse(
          player.statistics.first.games.rating ?? '',
        );
        if (rating == null || rating <= bestRating) continue;
        bestRating = rating;
        selectedPlayer = player;
        selectedTeam = teamPlayers.team;
      }
    }

    if (selectedPlayer == null || selectedTeam == null) return null;

    return MatchDetailsPlayerOfMatchUiModel(
      name: selectedPlayer.player.name,
      teamName: selectedTeam.name,
      photoUrl: selectedPlayer.player.photo,
    );
  }

  int? _winningTeamId(FootballFixtureModel fixture) {
    if (fixture.teams.home.winner == true) return fixture.teams.home.id;
    if (fixture.teams.away.winner == true) return fixture.teams.away.id;

    final homeGoals = fixture.goals.home;
    final awayGoals = fixture.goals.away;
    if (homeGoals == null || awayGoals == null || homeGoals == awayGoals) {
      return null;
    }

    return homeGoals > awayGoals
        ? fixture.teams.home.id
        : fixture.teams.away.id;
  }

  List<MatchDetailsEventUiModel> _buildEvents(FootballFixtureModel fixture) {
    if (fixture.events.isEmpty) return const <MatchDetailsEventUiModel>[];

    return fixture.events
        .map((event) {
          final type = _eventType(event);
          final playerName = event.player.name?.trim();
          final assistName = event.assist.name?.trim();
          final scoreLabel = type == MatchDetailsEventType.goal
              ? ' (${fixture.goals.home ?? '-'} - ${fixture.goals.away ?? '-'})'
              : '';

          return MatchDetailsEventUiModel(
            minute: _eventMinute(event.time),
            elapsedMinute: event.time.elapsed,
            isHomeSide: event.team.id == fixture.teams.home.id,
            type: type,
            primaryText:
                '${playerName == null || playerName.isEmpty ? event.detail : playerName}$scoreLabel',
            secondaryText: event.detail.isEmpty ? null : event.detail,
            assistText: assistName == null || assistName.isEmpty
                ? null
                : 'assist by $assistName',
            emphasizePrimary: type == MatchDetailsEventType.substitution,
          );
        })
        .toList(growable: false);
  }

  MatchDetailsEventType _eventType(FootballFixtureEventModel event) {
    final rawType = event.type.toLowerCase();
    final detail = event.detail.toLowerCase();

    if (rawType.contains('goal')) return MatchDetailsEventType.goal;
    if (rawType.contains('subst')) return MatchDetailsEventType.substitution;
    if (detail.contains('red card')) return MatchDetailsEventType.redCard;
    if (detail.contains('yellow card') || rawType.contains('card')) {
      return MatchDetailsEventType.yellowCard;
    }

    return MatchDetailsEventType.info;
  }

  String _eventMinute(FootballEventTimeModel time) {
    final elapsed = time.elapsed;
    if (elapsed == null) return '-';
    final extra = time.extra;
    if (extra != null && extra > 0) return '$elapsed+$extra’';
    return '$elapsed’';
  }

  List<MatchDetailsTimelineMarkerUiModel> _buildTimelineMarkers(
    FootballFixtureModel fixture,
  ) {
    final markers = <MatchDetailsTimelineMarkerUiModel>[];
    final halfHome = fixture.score.halftime.home;
    final halfAway = fixture.score.halftime.away;
    final fullHome = fixture.score.fulltime.home;
    final fullAway = fixture.score.fulltime.away;

    if (halfHome != null && halfAway != null) {
      markers.add(
        MatchDetailsTimelineMarkerUiModel(
          label: 'HT $halfHome - $halfAway',
          minute: 45,
        ),
      );
    }

    if (fullHome != null && fullAway != null) {
      final fullMinute =
          fixture.fixture.status.elapsed == null ||
              fixture.fixture.status.elapsed! < 90
          ? 90
          : fixture.fixture.status.elapsed!;
      markers.add(
        MatchDetailsTimelineMarkerUiModel(
          label: 'FT $fullHome - $fullAway',
          minute: fullMinute,
        ),
      );
    }

    return markers;
  }

  MatchDetailsTeamFormUiModel _buildTeamFormFromTeamFixtures({
    required List<FootballFixtureModel> homeFixtures,
    required List<FootballFixtureModel> awayFixtures,
  }) {
    return MatchDetailsTeamFormUiModel(
      title: 'Team form',
      homeMatches: _teamFormMatches(homeFixtures, _homeTeamId),
      awayMatches: _teamFormMatches(awayFixtures, _awayTeamId),
    );
  }

  List<MatchDetailsTeamFormMatchUiModel> _teamFormMatches(
    List<FootballFixtureModel> fixtures,
    String teamId,
  ) {
    final matches = <MatchDetailsTeamFormMatchUiModel>[];

    for (final fixture in fixtures) {
      if (matches.length >= 3) break;

      final homeId = fixture.teams.home.id?.toString() ?? '';
      final awayId = fixture.teams.away.id?.toString() ?? '';
      if (teamId != homeId && teamId != awayId) continue;

      final homeGoals = fixture.goals.home;
      final awayGoals = fixture.goals.away;
      if (homeGoals == null || awayGoals == null) continue;

      matches.add(
        MatchDetailsTeamFormMatchUiModel(
          scoreLabel: '$homeGoals - $awayGoals',
          result: _teamResultLabel(fixture, teamId),
          homeLogoUrl: fixture.teams.home.logo,
          awayLogoUrl: fixture.teams.away.logo,
        ),
      );
    }

    return matches;
  }

  String _teamResultLabel(FootballFixtureModel fixture, String teamId) {
    final homeId = fixture.teams.home.id?.toString() ?? '';
    final awayId = fixture.teams.away.id?.toString() ?? '';
    final homeGoals = fixture.goals.home;
    final awayGoals = fixture.goals.away;

    if (homeGoals == null || awayGoals == null || homeGoals == awayGoals) {
      return 'D';
    }

    if ((teamId == homeId && homeGoals > awayGoals) ||
        (teamId == awayId && awayGoals > homeGoals)) {
      return 'W';
    }

    return 'L';
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

  MatchDetailsNextMatchUiModel _toNextMatch(FootballFixtureModel fixture) {
    final competition = fixture.league.name.isNotEmpty
        ? fixture.league.name
        : fixture.league.country;

    return MatchDetailsNextMatchUiModel(
      title: fixture.league.round.isNotEmpty
          ? fixture.league.round
          : competition,
      timeLabel: _timeLabel12(fixture.fixture.kickoffAt),
      statusText: _dateLabel(fixture.fixture.kickoffAt),
      homeTeam: _toDetailsTeam(fixture.teams.home),
      awayTeam: _toDetailsTeam(fixture.teams.away),
    );
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
      leagueLogoUrl: fixture.league.logo,
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

  static const MatchDetailsTeamFormUiModel _emptyTeamForm =
      MatchDetailsTeamFormUiModel(
        title: 'Team form',
        homeResults: <String>[],
        awayResults: <String>[],
      );

  static const MatchDetailsTeamFormUiModel _teamForm = _emptyTeamForm;

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
        MatchDetailsTimelineMarkerUiModel(label: 'HT 0 - 1', minute: 45),
        MatchDetailsTimelineMarkerUiModel(label: 'FT 0 - 2', minute: 90),
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
      MatchDetailsHeadToHeadSummaryUiModel(homeWins: 0, draws: 0, awayWins: 0);

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

  static const MatchDetailsKnockoutUiModel _knockout =
      MatchDetailsKnockoutUiModel(
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

  static List<MatchDetailsTabType> _visibleTabsForScenario(
    MatchDetailsScenario scenario, {
    required bool showKnockout,
  }) {
    switch (scenario) {
      case MatchDetailsScenario.live:
      case MatchDetailsScenario.upcoming:
        return <MatchDetailsTabType>[
          MatchDetailsTabType.preview,
          MatchDetailsTabType.lineup,
          if (showKnockout) MatchDetailsTabType.knockout,
          MatchDetailsTabType.headToHead,
        ];
      case MatchDetailsScenario.finished:
        return <MatchDetailsTabType>[
          MatchDetailsTabType.facts,
          MatchDetailsTabType.lineup,
          if (showKnockout) MatchDetailsTabType.knockout,
          MatchDetailsTabType.stats,
          MatchDetailsTabType.headToHead,
        ];
    }
  }

  static MatchDetailsScreenUiModel _buildScreen(MatchDetailsScenario scenario) {
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
          visibleTabs: _visibleTabsForScenario(scenario, showKnockout: false),
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
          visibleTabs: _visibleTabsForScenario(scenario, showKnockout: false),
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
          visibleTabs: _visibleTabsForScenario(scenario, showKnockout: false),
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

class _MatchTopScorerUiData {
  final String name;
  final String photoUrl;
  final int goals;
  final int assists;
  final int appearances;

  const _MatchTopScorerUiData({
    required this.name,
    required this.photoUrl,
    required this.goals,
    required this.assists,
    required this.appearances,
  });
}

class _GridPosition {
  final int row;
  final int column;

  const _GridPosition({required this.row, required this.column});
}

class MatchDetailsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<FollowingService>()) {
      Get.lazyPut<FollowingService>(
        () => FollowingService(
          apiClient: Get.find<ApiClient>(),
          storageService: Get.find<StorageService>(),
        ),
        fenix: true,
      );
    }

    if (!Get.isRegistered<MatchDetialsService>()) {
      Get.lazyPut<MatchDetialsService>(
        () => MatchDetialsService(apiClient: Get.find<ApiClient>()),
        fenix: true,
      );
    }

    Get.lazyPut<MatchDetailsController>(
      () => MatchDetailsController(
        service: Get.find<MatchDetialsService>(),
        followingService: Get.find<FollowingService>(),
      ),
    );
  }
}
