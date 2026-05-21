import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/models/following_models.dart';
import '../../core/services/api_client.dart';
import '../../core/services/api_error_handler.dart';
import '../../core/services/following_service.dart';
import '../../core/services/storage_service.dart';
import '../matches/model/matches_models.dart' hide FootballPlayerStatisticModel;
import '../leagues/model/leagues_models.dart';
import 'team_profile_model.dart';
import 'team_profile_service.dart';

class TeamProfileBinding extends Bindings {
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
    if (!Get.isRegistered<TeamProfileService>()) {
      Get.lazyPut<TeamProfileService>(
        () => TeamProfileService(apiClient: Get.find<ApiClient>()),
        fenix: true,
      );
    }
    Get.lazyPut<TeamProfileController>(
      () => TeamProfileController(
        followingService: Get.find<FollowingService>(),
        service: Get.find<TeamProfileService>(),
      ),
    );
  }
}

class TeamProfileController extends GetxController {
  TeamProfileController({
    required FollowingService followingService,
    required TeamProfileService service,
  }) : _followingService = followingService,
       _service = service;

  static const int _matchesPageSize = 5;
  static const int _overviewPreviousLimit = 6;

  final FollowingService _followingService;
  final TeamProfileService _service;
  final Rx<TeamProfileViewModel> state = _initialState.obs;

  Worker? _worker;
  int initialTabIndex = 0;
  String _teamId = '33';
  int _previousLimit = _overviewPreviousLimit;
  int _upcomingLimit = _matchesPageSize;

  @override
  void onInit() {
    super.onInit();
<<<<<<< HEAD
    final argument = Get.arguments;
    if (argument is String) {
      initialTabIndex = _tabIndexFrom(argument);
    } else if (argument is Map<String, dynamic>) {
      initialTabIndex = _tabIndexFrom(argument['tab']?.toString() ?? '');
      final teamId = argument['teamId']?.toString();
      if (teamId != null && teamId.isNotEmpty) {
        _applyTeamId(teamId);
      }
    }

=======
    _readArguments();
>>>>>>> origin/riaz
    _syncFollowingState();
    _worker = ever<int>(
      _followingService.revision,
      (_) => _syncFollowingState(),
    );
    _loadInitialData();
  }

  @override
  void onClose() {
    _worker?.dispose();
    super.onClose();
  }

  Future<void> follow() async {
    final payload = FollowEntityPayloadModel(
      entityType: FollowEntityType.team,
      entityId: _teamId,
      entityName: state.value.team.name,
      notificationEnabled: true,
    );

    await ApiErrorHandler.handle<FollowingActionUiModel>(
      () => _followingService.follow(payload),
      fallbackErrorCode: 'team_follow_failed',
      userMessage: 'Could not follow this team right now.',
    );
  }

  Future<void> unfollow() async {
    final payload = UnfollowPayloadModel(
      entityType: FollowEntityType.team,
      entityId: _teamId,
    );

    await ApiErrorHandler.handle<FollowingActionUiModel>(
      () => _followingService.unfollow(payload),
      fallbackErrorCode: 'team_unfollow_failed',
      userMessage: 'Could not unfollow this team right now.',
    );
  }

  void toggleAboutExpanded() {
    state.value = state.value.copyWith(
      isAboutExpanded: !state.value.isAboutExpanded,
    );
  }

  void selectSeason(String season) {
    if (season == state.value.selectedSeason) {
      return;
    }
    state.value = state.value.copyWith(selectedSeason: season);
    _loadSeasonScopedData();
  }

  void toggleTeamLeaguesExpanded() {
    state.value = state.value.copyWith(
      isTeamLeaguesExpanded: !state.value.isTeamLeaguesExpanded,
    );
  }

  List<FootballTeamPlayerItemModel> get topPlayers {
    final leagueId = state.value.domesticLeague?.league.id;
    final players = List<FootballTeamPlayerItemModel>.from(state.value.players);
    players.sort((left, right) {
      final leftStat = left.statisticForLeague(leagueId);
      final rightStat = right.statisticForLeague(leagueId);
      final leftRating = leftStat?.games.ratingValue ?? 0;
      final rightRating = rightStat?.games.ratingValue ?? 0;
      if (rightRating.compareTo(leftRating) != 0) {
        return rightRating.compareTo(leftRating);
      }
      final leftAppearances = leftStat?.games.appearences ?? 0;
      final rightAppearances = rightStat?.games.appearences ?? 0;
      return rightAppearances.compareTo(leftAppearances);
    });
    return players.take(3).toList(growable: false);
  }

  Map<String, List<FootballTeamPlayerItemModel>> get playersByPosition {
    final leagueId = state.value.domesticLeague?.league.id;
    final grouped = <String, List<FootballTeamPlayerItemModel>>{
      'Goalkeepers': <FootballTeamPlayerItemModel>[],
      'Defenders': <FootballTeamPlayerItemModel>[],
      'Midfielders': <FootballTeamPlayerItemModel>[],
      'Attackers': <FootballTeamPlayerItemModel>[],
      'Others': <FootballTeamPlayerItemModel>[],
    };

    for (final player in state.value.players) {
      final position = player.statisticForLeague(leagueId)?.games.position.toLowerCase() ?? '';
      if (position.contains('goalkeeper')) {
        grouped['Goalkeepers']!.add(player);
      } else if (position.contains('defender')) {
        grouped['Defenders']!.add(player);
      } else if (position.contains('midfielder')) {
        grouped['Midfielders']!.add(player);
      } else if (position.contains('attacker') || position.contains('forward')) {
        grouped['Attackers']!.add(player);
      } else {
        grouped['Others']!.add(player);
      }
    }

    grouped.removeWhere((_, value) => value.isEmpty);
    return grouped;
  }

  FootballPlayerStatisticModel? playerStatistic(
    FootballTeamPlayerItemModel player,
  ) {
    return player.statisticForLeague(state.value.domesticLeague?.league.id);
  }

  String get domesticLeagueTitle {
    final name = state.value.domesticLeague?.league.name ?? '';
    return name.isEmpty ? 'League table' : name;
  }

  Future<void> loadMorePreviousMatches() async {
    final current = state.value;
    if (current.isPreviousMatchesLoading || current.isPreviousMatchesLoadingMore) {
      return;
    }
    if (!current.canLoadMorePreviousMatches) {
      return;
    }

    await _loadPreviousFixtures(
      limit: _boundedLimit(current.visiblePreviousMatches + _matchesPageSize),
      isLoadMore: true,
    );
  }

  Future<void> loadMoreUpcomingMatches() async {
    final current = state.value;
    if (current.isUpcomingMatchesLoading || current.isUpcomingMatchesLoadingMore) {
      return;
    }
    if (!current.canLoadMoreUpcomingMatches) {
      return;
    }

    await _loadUpcomingFixtures(
      limit: _boundedLimit(current.visibleUpcomingMatches + _matchesPageSize),
      isLoadMore: true,
    );
  }

  void loadMoreTrophies() {
    final current = state.value;
    if (!current.canLoadMoreTrophies) {
      return;
    }

    state.value = current.copyWith(
      visibleTrophies: current.visibleTrophies + 2,
    );
  }

  Future<void> _loadInitialData() async {
    await Future.wait(<Future<void>>[
      _loadTeamInfo(),
      _loadUpcomingFixtures(limit: _matchesPageSize, isLoadMore: false),
      _loadPreviousFixtures(limit: _overviewPreviousLimit, isLoadMore: false),
      _loadTeamPlayers(),
      _loadTeamCoaches(),
      _loadTeamLeaguesAndStandings(),
    ]);
  }

  Future<void> _loadSeasonScopedData() async {
    await Future.wait(<Future<void>>[
      _loadTeamPlayers(),
      _loadTeamLeaguesAndStandings(),
    ]);
  }

  Future<void> _loadTeamPlayers() async {
    state.value = state.value.copyWith(isPlayersLoading: true);

    final response = await ApiErrorHandler.handle<FootballTeamPlayersDataModel>(
      () => _service.fetchTeamPlayers(
        teamId: _teamId,
        season: _selectedSeasonYear,
      ),
      fallbackErrorCode: 'team_players_fetch_failed',
      userMessage: 'Unable to load team players right now.',
    );

    if (isClosed) return;
    state.value = state.value.copyWith(isPlayersLoading: false);

    if (!response.success || response.data == null) {
      return;
    }

    state.value = state.value.copyWith(players: response.data!.response);
  }

  Future<void> _loadTeamCoaches() async {
    state.value = state.value.copyWith(isCoachesLoading: true);

    final response = await ApiErrorHandler.handle<FootballTeamCoachesDataModel>(
      () => _service.fetchTeamCoaches(_teamId),
      fallbackErrorCode: 'team_coaches_fetch_failed',
      userMessage: 'Unable to load team coach right now.',
    );

    if (isClosed) return;
    state.value = state.value.copyWith(isCoachesLoading: false);

    if (!response.success || response.data == null) {
      return;
    }

    final coach = _latestCoach(response.data!.response);
    state.value = state.value.copyWith(
      latestCoach: coach,
      coach: coach == null ? state.value.coach : _coachUiFromApi(coach),
    );
  }

  Future<void> _loadTeamLeaguesAndStandings() async {
    state.value = state.value.copyWith(
      isTeamLeaguesLoading: true,
      isStandingsLoading: true,
    );

    final response = await ApiErrorHandler.handle<FootballLeaguesDataModel>(
      () => _service.fetchTeamLeagues(
        teamId: _teamId,
        season: _selectedSeasonYear,
      ),
      fallbackErrorCode: 'team_leagues_fetch_failed',
      userMessage: 'Unable to load team leagues right now.',
    );

    if (isClosed) return;
    state.value = state.value.copyWith(isTeamLeaguesLoading: false);

    if (!response.success || response.data == null) {
      state.value = state.value.copyWith(isStandingsLoading: false);
      return;
    }

    final leagues = response.data!.response;
    final domesticLeague = _firstDomesticLeague(leagues);
    final overview = state.value.overview.copyWith(
      leagues: leagues.map(_teamLeagueUiFromApi).toList(growable: false),
    );
    state.value = state.value.copyWith(
      teamLeagues: leagues,
      domesticLeague: domesticLeague,
      overview: overview,
      isTeamLeaguesExpanded: false,
    );

    final leagueId = domesticLeague?.league.id;
    if (leagueId == null) {
      state.value = state.value.copyWith(
        isStandingsLoading: false,
        standingRows: <FootballStandingRowModel>[],
        standings: <TeamProfileStandingsRowUiModel>[],
      );
      return;
    }

    final standingsResponse = await ApiErrorHandler.handle<FootballStandingsDataModel>(
      () => _service.fetchStandings(
        leagueId: leagueId,
        season: _selectedSeasonYear,
      ),
      fallbackErrorCode: 'team_standings_fetch_failed',
      userMessage: 'Unable to load standings right now.',
    );

    if (isClosed) return;
    state.value = state.value.copyWith(isStandingsLoading: false);

    if (!standingsResponse.success || standingsResponse.data == null) {
      return;
    }

    final rows = standingsResponse.data!.response.isEmpty
        ? <FootballStandingRowModel>[]
        : standingsResponse.data!.response.first.standings
            .expand((group) => group)
            .toList(growable: false);

    state.value = state.value.copyWith(
      standingRows: rows,
      standings: rows.map(_standingUiFromApi).toList(growable: false),
    );
  }

  Future<void> _loadTeamInfo() async {
    state.value = state.value.copyWith(isTeamInfoLoading: true);

    final response = await ApiErrorHandler.handle<FootballTeamInfoItemModel?>(
      () => _service.fetchTeamInfo(_teamId),
      fallbackErrorCode: 'team_info_fetch_failed',
      userMessage: 'Unable to load team information right now.',
    );

    if (isClosed) return;
    state.value = state.value.copyWith(isTeamInfoLoading: false);

    final item = response.data;
    if (!response.success || item == null) {
      return;
    }

    final team = item.team;
    final venue = item.venue;
    final teamUi = TeamProfileTeamUiModel(
      teamId: '${team.id ?? _teamId}',
      name: team.name.isEmpty ? state.value.team.name : team.name,
      country: team.country,
      badgeSeed: _seed(team.code.isNotEmpty ? team.code : team.name),
      badgeColor: _badgeColor(team.id),
      logoUrl: team.logo,
    );

    final overview = state.value.overview.copyWith(
      venue: TeamProfileVenueUiModel(
        stadiumName: venue.name,
        city: venue.city,
        capacity: venue.capacity == null ? '-' : '${venue.capacity}',
        surface: venue.surface.isEmpty ? '-' : venue.surface,
        opened: team.founded == null ? '-' : '${team.founded}',
        imageUrl: venue.image,
        address: venue.address,
      ),
      aboutText: _aboutText(team: team, venue: venue),
    );

    state.value = state.value.copyWith(team: teamUi, overview: overview);
    _syncFollowingState();
  }

  Future<void> _loadUpcomingFixtures({
    required int limit,
    required bool isLoadMore,
  }) async {
    if (isLoadMore) {
      state.value = state.value.copyWith(isUpcomingMatchesLoadingMore: true);
    } else {
      state.value = state.value.copyWith(isUpcomingMatchesLoading: true);
    }

    final previousCount = state.value.upcomingMatches.length;
    final response = await ApiErrorHandler.handle<FootballFixturesDataModel>(
      () => _service.fetchUpcomingFixtures(teamId: _teamId, next: limit),
      fallbackErrorCode: 'team_upcoming_fixtures_fetch_failed',
      userMessage: 'Unable to load upcoming fixtures right now.',
    );

    if (isClosed) return;

    if (isLoadMore) {
      state.value = state.value.copyWith(isUpcomingMatchesLoadingMore: false);
    } else {
      state.value = state.value.copyWith(isUpcomingMatchesLoading: false);
    }

    if (!response.success || response.data == null) {
      return;
    }

    _upcomingLimit = limit;
    final fixtures = response.data!.response;
    final rows = fixtures
        .map((fixture) => _matchRowFromFixture(fixture, isUpcoming: true))
        .toList(growable: false);

    final overview = state.value.overview.copyWith(
      nextMatches: rows
          .take(2)
          .map(_nextMatchFromRow)
          .toList(growable: false),
    );

    state.value = state.value.copyWith(
      overview: overview,
      upcomingMatches: rows,
      visibleUpcomingMatches: _minInt(rows.length, limit),
      canLoadMoreUpcomingMatchesFromApi:
          rows.length >= limit && rows.length > previousCount,
    );
  }

  Future<void> _loadPreviousFixtures({
    required int limit,
    required bool isLoadMore,
  }) async {
    if (isLoadMore) {
      state.value = state.value.copyWith(isPreviousMatchesLoadingMore: true);
    } else {
      state.value = state.value.copyWith(isPreviousMatchesLoading: true);
    }

    final previousCount = state.value.previousMatches.length;
    final response = await ApiErrorHandler.handle<FootballFixturesDataModel>(
      () => _service.fetchPreviousFixtures(teamId: _teamId, last: limit),
      fallbackErrorCode: 'team_previous_fixtures_fetch_failed',
      userMessage: 'Unable to load previous fixtures right now.',
    );

    if (isClosed) return;

    if (isLoadMore) {
      state.value = state.value.copyWith(isPreviousMatchesLoadingMore: false);
    } else {
      state.value = state.value.copyWith(isPreviousMatchesLoading: false);
    }

    if (!response.success || response.data == null) {
      return;
    }

    _previousLimit = limit;
    final fixtures = response.data!.response;
    final rows = fixtures
        .map((fixture) => _matchRowFromFixture(fixture, isUpcoming: false))
        .toList(growable: false);
    final formResults = fixtures
        .take(_overviewPreviousLimit)
        .map(_formResultFromFixture)
        .toList(growable: false);

    final overview = state.value.overview.copyWith(
      leftResults: formResults.take(3).toList(growable: false),
      rightResults: formResults.skip(3).take(3).toList(growable: false),
    );

    state.value = state.value.copyWith(
      overview: overview,
      previousMatches: rows,
      visiblePreviousMatches: isLoadMore
          ? _minInt(rows.length, limit)
          : _minInt(rows.length, _matchesPageSize),
      canLoadMorePreviousMatchesFromApi:
          rows.length >= limit && rows.length > previousCount,
    );
  }


  int get _selectedSeasonYear {
    final firstPart = state.value.selectedSeason.split('/').first.trim();
    return int.tryParse(firstPart) ?? DateTime.now().year;
  }

  FootballLeagueApiItemModel? _firstDomesticLeague(
    List<FootballLeagueApiItemModel> leagues,
  ) {
    for (final item in leagues) {
      if (item.country.name.toLowerCase() != 'world' &&
          item.league.type.toLowerCase() == 'league') {
        return item;
      }
    }
    for (final item in leagues) {
      if (item.country.name.toLowerCase() != 'world') {
        return item;
      }
    }
    return leagues.isEmpty ? null : leagues.first;
  }

  FootballTeamCoachModel? _latestCoach(List<FootballTeamCoachModel> coaches) {
    FootballTeamCoachModel? selected;
    DateTime? selectedStart;

    for (final coach in coaches) {
      for (final career in coach.career) {
        if ('${career.team.id ?? ''}' != _teamId || career.end != null) {
          continue;
        }
        final start = career.startDate ?? DateTime(1900);
        if (selected == null ||
            selectedStart == null ||
            start.isAfter(selectedStart)) {
          selected = coach;
          selectedStart = start;
        }
      }
    }

    if (selected != null) return selected;

    for (final coach in coaches) {
      for (final career in coach.career) {
        if ('${career.team.id ?? ''}' != _teamId) continue;
        final start = career.startDate ?? DateTime(1900);
        if (selected == null ||
            selectedStart == null ||
            start.isAfter(selectedStart)) {
          selected = coach;
          selectedStart = start;
        }
      }
    }

    return selected ?? (coaches.isEmpty ? null : coaches.last);
  }

  TeamProfileSquadPersonUiModel _coachUiFromApi(FootballTeamCoachModel coach) {
    return TeamProfileSquadPersonUiModel(
      name: coach.name,
      countryFlag: '',
      countryName: coach.nationality ?? '-',
      shirtNumber: '-',
      age: coach.age == null ? '-' : '${coach.age}',
      badgeSeed: _seed(coach.name),
      badgeColor: _badgeColor(coach.id),
    );
  }

  TeamProfileLeagueItemUiModel _teamLeagueUiFromApi(
    FootballLeagueApiItemModel item,
  ) {
    return TeamProfileLeagueItemUiModel(
      title: item.league.name,
      seasonLabel: _leagueSeasonLabel(item),
      badgeSeed: _seed(item.league.name),
      badgeColor: _badgeColor(item.league.id),
      logoUrl: item.league.logo,
    );
  }

  String _leagueSeasonLabel(FootballLeagueApiItemModel item) {
    final year = item.currentSeasonYear;
    final country = item.country.name;
    if (year == null && country.isEmpty) return '-';
    if (country.isEmpty) return '$year';
    if (year == null) return country;
    return '$country • $year';
  }

  TeamProfileStandingsRowUiModel _standingUiFromApi(
    FootballStandingRowModel row,
  ) {
    final goalsFor = row.all.goals.goalsFor ?? 0;
    final goalsAgainst = row.all.goals.against ?? 0;
    return TeamProfileStandingsRowUiModel(
      rank: '${row.rank ?? '-'}',
      teamName: row.team.name,
      badgeSeed: _seed(row.team.name),
      badgeColor: _badgeColor(row.team.id),
      played: '${row.all.played ?? '-'}',
      plusMinus: '$goalsFor-$goalsAgainst',
      goalDifference: row.goalsDiff == null ? '-' : '${row.goalsDiff}',
      points: '${row.points ?? '-'}',
      logoUrl: row.team.logo,
    );
  }

  TeamProfileMatchRowUiModel _matchRowFromFixture(
    FootballFixtureModel fixture, {
    required bool isUpcoming,
  }) {
    final kickoffAt = fixture.fixture.kickoffAt;
    return TeamProfileMatchRowUiModel(
      fixtureId: '${fixture.fixture.id ?? ''}',
      dateLabel: _dateLabel(kickoffAt),
      competitionLabel: fixture.league.name,
      homeTeam: _teamFromFootball(fixture.teams.home),
      awayTeam: _teamFromFootball(fixture.teams.away),
      centerLabel: isUpcoming ? _timeLabel(kickoffAt) : _scoreLabel(fixture),
      isUpcoming: isUpcoming,
    );
  }

  TeamProfileNextMatchUiModel _nextMatchFromRow(
    TeamProfileMatchRowUiModel row,
  ) {
    return TeamProfileNextMatchUiModel(
      competitionLabel: row.competitionLabel,
      timeLabel: row.centerLabel,
      statusLabel: row.dateLabel,
      homeTeam: row.homeTeam,
      awayTeam: row.awayTeam,
    );
  }

  TeamProfileFormResultUiModel _formResultFromFixture(
    FootballFixtureModel fixture,
  ) {
    final homeId = '${fixture.teams.home.id ?? ''}';
    final awayId = '${fixture.teams.away.id ?? ''}';
    final isHomeTeam = homeId == _teamId;
    final isAwayTeam = awayId == _teamId;
    final homeGoals = fixture.goals.home ?? fixture.score.fulltime.home;
    final awayGoals = fixture.goals.away ?? fixture.score.fulltime.away;
    final score = _scoreLabel(fixture);

    bool isDraw = false;
    bool isPositive = false;
    String logoUrl = fixture.league.logo ?? '';
    String teamName = fixture.league.name;

    if (isHomeTeam || isAwayTeam) {
      final ownGoals = isHomeTeam ? homeGoals : awayGoals;
      final opponentGoals = isHomeTeam ? awayGoals : homeGoals;
      isDraw = ownGoals != null && opponentGoals != null && ownGoals == opponentGoals;
      isPositive = ownGoals != null && opponentGoals != null && ownGoals > opponentGoals;
      final opponent = isHomeTeam ? fixture.teams.away : fixture.teams.home;
      logoUrl = opponent.logo ?? '';
      teamName = opponent.name;
    } else {
      isDraw = fixture.teams.home.winner == null && fixture.teams.away.winner == null;
      isPositive = fixture.teams.home.winner == true || fixture.teams.away.winner == true;
      logoUrl = fixture.teams.home.logo ?? fixture.teams.away.logo ?? '';
      teamName = fixture.teams.home.name;
    }

    return TeamProfileFormResultUiModel(
      scoreLabel: score,
      isPositive: isPositive,
      isDraw: isDraw,
      logoUrl: logoUrl,
      teamName: teamName,
    );
  }

  TeamProfileTeamUiModel _teamFromFootball(FootballTeamModel team) {
    return TeamProfileTeamUiModel(
      teamId: '${team.id ?? ''}',
      name: team.name,
      country: '',
      badgeSeed: _seed(team.name),
      badgeColor: _badgeColor(team.id),
      logoUrl: team.logo ?? '',
    );
  }

  void _readArguments() {
    final argument = Get.arguments;
    if (argument is String) {
      final raw = argument.trim();
      if (_looksLikeTeamId(raw)) {
        _teamId = raw;
      } else {
        initialTabIndex = _tabIndexFrom(raw);
      }
      return;
    }

    if (argument is Map) {
      initialTabIndex = _tabIndexFrom(argument['tab']?.toString() ?? '');
      _teamId = _argumentString(
        argument,
        const <String>['teamId', 'team_id', 'id'],
        _teamId,
      );
    }
  }

  void _syncFollowingState() {
    state.value = state.value.copyWith(
      isFollowing: _followingService.isFollowing(
        FollowEntityType.team,
        _teamId,
      ),
    );
  }

  bool _looksLikeTeamId(String value) {
    return int.tryParse(value) != null;
  }

  String _argumentString(Map<dynamic, dynamic> argument, List<String> keys, String fallback) {
    for (final key in keys) {
      final value = argument[key]?.toString().trim();
      if (value != null && value.isNotEmpty) {
        return value;
      }
    }
    return fallback;
  }

  int _tabIndexFrom(String value) {
    switch (value.toLowerCase()) {
      case 'table':
        return 1;
      case 'matches':
        return 2;
      case 'squad':
      case 'squads':
        return 3;
      case 'trophies':
        return 4;
      default:
        return 0;
    }
  }


  int _boundedLimit(int value) {
    if (value < _matchesPageSize) return _matchesPageSize;
    if (value > 100) return 100;
    return value;
  }

  int _minInt(int left, int right) {
    return left < right ? left : right;
  }

  String _scoreLabel(FootballFixtureModel fixture) {
    final home = fixture.goals.home ?? fixture.score.fulltime.home;
    final away = fixture.goals.away ?? fixture.score.fulltime.away;
    if (home == null || away == null) {
      return '-';
    }
    return '$home - $away';
  }

  String _dateLabel(DateTime? date) {
    if (date == null) return '-';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = target.difference(today).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff == -1) return 'Yesterday';
    return '${date.day} ${_monthName(date.month)}';
  }

  String _timeLabel(DateTime? date) {
    if (date == null) return '-';
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _monthName(int month) {
    const names = <String>[
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
    return names[month - 1];
  }

  String _seed(String value) {
    final clean = value.trim();
    if (clean.isEmpty) return '?';
    final parts = clean.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return clean.substring(0, clean.length < 3 ? clean.length : 3).toUpperCase();
    }
    return parts.take(3).map((part) => part[0]).join().toUpperCase();
  }

  Color _badgeColor(int? id) {
    const colors = <Color>[
      Color(0xFFC13329),
      Color(0xFF2F6FE4),
      Color(0xFF0E8B67),
      Color(0xFF8B1D2C),
      Color(0xFF274C93),
      Color(0xFF6B1CC2),
    ];
    if (id == null) return colors.first;
    return colors[id.abs() % colors.length];
  }

  String _aboutText({
    required FootballTeamInfoModel team,
    required FootballTeamVenueInfoModel venue,
  }) {
    final founded = team.founded == null ? '' : ' Founded in ${team.founded}.';
    final venueText = venue.name.isEmpty
        ? ''
        : ' They play their home matches at ${venue.name}${venue.city.isEmpty ? '' : ', ${venue.city}'}.';
    final capacity = venue.capacity == null
        ? ''
        : ' Stadium capacity is ${venue.capacity}.';
    return '${team.name} is a football team from ${team.country}.$founded$venueText$capacity';
  }

  static const TeamProfileTeamUiModel _defaultTeam = TeamProfileTeamUiModel(
    teamId: '33',
    name: 'Manchester United',
    country: 'England',
    badgeSeed: 'MUN',
    badgeColor: Color(0xFFC13329),
    logoUrl: 'https://media.api-sports.io/football/teams/33.png',
  );

  static const List<String> _seasons = <String>[
    '2025/2026',
    '2024/2025',
    '2023/2024',
  ];

  static const TeamProfileOverviewUiModel _overview = TeamProfileOverviewUiModel(
    nextMatches: <TeamProfileNextMatchUiModel>[],
    leftResults: <TeamProfileFormResultUiModel>[],
    rightResults: <TeamProfileFormResultUiModel>[],
    topPlayers: <TeamProfileTopPlayerUiModel>[],
    leagues: <TeamProfileLeagueItemUiModel>[],
    rankings: <TeamProfileRankingItemUiModel>[],
    venue: TeamProfileVenueUiModel(
      stadiumName: 'Old Trafford',
      city: 'Manchester',
      capacity: '-',
      surface: '-',
      opened: '-',
    ),
    aboutText: 'Team information will appear here once it is loaded.',
  );

  static const TeamProfileViewModel _initialState = TeamProfileViewModel(
    team: _defaultTeam,
    isFollowing: false,
    seasons: _seasons,
    selectedSeason: '2025/2026',
    overview: _overview,
    standings: <TeamProfileStandingsRowUiModel>[],
    previousMatches: <TeamProfileMatchRowUiModel>[],
    upcomingMatches: <TeamProfileMatchRowUiModel>[],
    visiblePreviousMatches: 5,
    visibleUpcomingMatches: 5,
    trophies: <TeamProfileTrophySectionUiModel>[],
    visibleTrophies: 4,
  );
}
