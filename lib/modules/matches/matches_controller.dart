import 'dart:async';
import 'dart:math' as math;

import 'package:get/get.dart';

import '../../core/services/api_client.dart';
import '../../core/services/api_error_handler.dart';
import '../bottom_nav_bar/search/matches_search_controller.dart';
import 'model/matches_models.dart';
import 'service/matches_service.dart';

class MatchesController extends GetxController {
  final MatchesService _service;

  MatchesController({required MatchesService service}) : _service = service;

  static const int _leaguePageLimit = 10;
  static const int _livePageLimit = 3;
  static const int _upcomingFallbackLimit = 3;

  final Rx<MatchesViewModel> state = const MatchesViewModel().obs;
  Timer? _liveRefreshTimer;
  bool _isActiveBottomTab = true;

  @override
  void onInit() {
    super.onInit();
    _loadInitialFootballData();
    _startLiveRefreshTimer();
  }

  @override
  void onClose() {
    _liveRefreshTimer?.cancel();
    super.onClose();
  }

  void onBottomTabVisibilityChanged(bool isActive) {
    if (_isActiveBottomTab == isActive) return;

    _isActiveBottomTab = isActive;

    if (isActive) {
      _startLiveRefreshTimer();
      _refreshLiveMatches();
    } else {
      _liveRefreshTimer?.cancel();
      _liveRefreshTimer = null;
    }
  }

  Future<void> onSportSelected(String sportCode) async {
    if (sportCode == state.value.selectedSportCode) return;

    state.value = state.value.copyWith(
      selectedSportCode: sportCode,
      errorCode: null,
    );

    if (sportCode == MatchesSportCodes.football) {
      if (_isActiveBottomTab) _startLiveRefreshTimer();
      if (state.value.schedule == null) {
        await _loadInitialFootballData();
      }
    } else {
      _liveRefreshTimer?.cancel();
      _liveRefreshTimer = null;
    }
  }

  void onDateSelected(DateTime date) {
    _loadFixturesByDate(date);
  }

  void clearDateFilter() {
    _loadFixturesByDate(DateTime.now());
  }

  Future<void> refreshFootballPage() async {
    if (state.value.selectedSportCode != MatchesSportCodes.football) return;

    final selectedDate = _dateFromSelectedDay() ?? DateTime.now();
    final liveLimit = math.max(_livePageLimit, state.value.liveMatches?.length ?? 0);

    final response = await ApiErrorHandler.handle<_MatchesInitialLoadResult>(
      () async {
        final schedule = await _service.fetchLeagueFixturesByDate(
          selectedDate,
          page: 1,
          limit: _leaguePageLimit,
        );
        final liveResult = await _fetchLiveOrUpcomingMatches(
          page: 1,
          limit: liveLimit,
        );

        return _MatchesInitialLoadResult(
          schedule: schedule,
          liveResult: liveResult,
        );
      },
      fallbackErrorCode: 'matches_refresh_failed',
      userMessage: 'Unable to refresh matches right now.',
    );

    if (isClosed || !response.success || response.data == null) return;

    final liveResult = response.data!.liveResult;
    final loadedCount = liveResult.matches.length;

    state.value = state.value.copyWith(
      schedule: response.data!.schedule,
      selectedDayIndex: 0,
      errorCode: null,
      liveMatches: liveResult.matches,
      isShowingUpcomingFallback: liveResult.isShowingUpcomingFallback,
      livePage: _resolvedLivePage(liveResult, loadedCount),
      liveLimit: liveResult.limit,
      liveTotal: liveResult.total,
      canLoadMoreLiveMatches: _canLoadMoreLive(liveResult, loadedCount),
      isLiveMatchesRefreshing: false,
      isLoadingMoreLiveMatches: false,
    );
  }

  void toggleLeagueExpanded(String leagueId) {
    final nextExpandedIds = Set<String>.from(state.value.expandedLeagueIds);

    if (nextExpandedIds.contains(leagueId)) {
      nextExpandedIds.remove(leagueId);
    } else {
      nextExpandedIds.add(leagueId);
    }

    state.value = state.value.copyWith(expandedLeagueIds: nextExpandedIds);
  }

  Future<void> loadMoreLiveMatches() async {
    final current = state.value;
    if (current.selectedSportCode != MatchesSportCodes.football) return;
    if (current.isShowingUpcomingFallback) return;
    if (!current.canLoadMoreLiveMatches || current.isLoadingMoreLiveMatches) {
      return;
    }

    final nextPage = current.livePage + 1;
    state.value = current.copyWith(isLoadingMoreLiveMatches: true);

    final response = await ApiErrorHandler.handle<_MatchesLiveLoadResult>(
      () => _fetchLiveOrUpcomingMatches(
        page: nextPage,
        limit: _livePageLimit,
        allowUpcomingFallback: false,
      ),
      fallbackErrorCode: 'live_matches_load_more_failed',
      userMessage: 'Unable to load more live matches right now.',
    );

    if (isClosed) return;

    if (!response.success || response.data == null) {
      state.value = state.value.copyWith(isLoadingMoreLiveMatches: false);
      return;
    }

    final result = response.data!;
    final mergedMatches = <MatchesLiveMatchUiModel>[
      ...?state.value.liveMatches,
      ...result.matches,
    ];

    state.value = state.value.copyWith(
      liveMatches: mergedMatches,
      isShowingUpcomingFallback: false,
      livePage: result.page,
      liveLimit: result.limit,
      liveTotal: result.total,
      canLoadMoreLiveMatches: _canLoadMoreLive(result, mergedMatches.length),
      isLoadingMoreLiveMatches: false,
      isLiveMatchesRefreshing: false,
    );
  }

  List<MatchesLeagueUiModel> filteredLeagues() {
    final selectedDay = state.value.selectedDay;
    if (selectedDay == null) return const <MatchesLeagueUiModel>[];

    final leagues = <MatchesLeagueUiModel>[];

    for (final league in selectedDay.leagues) {
      final fixtures = List<MatchesFixtureUiModel>.from(league.fixtures)
        ..sort((left, right) {
          return left.kickoffOrder.compareTo(right.kickoffOrder);
        });

      if (fixtures.isEmpty) continue;

      leagues.add(league.copyWith(fixtures: fixtures));
    }

    return leagues;
  }

  List<MatchesLeagueUiModel> nextDayPreviewLeagues() {
    final nextDay = state.value.nextDay;
    if (nextDay == null) return const <MatchesLeagueUiModel>[];
    return nextDay.leagues;
  }

  DateTime? _dateFromSelectedDay() {
    final dayId = state.value.selectedDay?.dayId;
    if (dayId == null || dayId.trim().isEmpty) return null;
    return DateTime.tryParse(dayId);
  }

  Future<void> _loadInitialFootballData() async {
    state.value = state.value.copyWith(
      isLoading: state.value.schedule == null,
      isLeagueListLoading: state.value.schedule != null,
      isLiveMatchesRefreshing: true,
      errorCode: null,
      isLoadingMoreLeagues: false,
      isLoadingMoreLiveMatches: false,
    );

    final response = await ApiErrorHandler.handle<_MatchesInitialLoadResult>(
      () async {
        final schedule = await _service.fetchLeagueFixturesByDate(
          DateTime.now(),
          page: 1,
          limit: _leaguePageLimit,
        );
        final liveResult = await _fetchLiveOrUpcomingMatches(
          page: 1,
          limit: _livePageLimit,
        );

        return _MatchesInitialLoadResult(
          schedule: schedule,
          liveResult: liveResult,
        );
      },
      fallbackErrorCode: 'matches_fetch_failed',
      userMessage: 'Unable to load matches right now.',
    );

    if (isClosed) return;

    if (!response.success || response.data == null) {
      state.value = state.value.copyWith(
        isLoading: false,
        isLeagueListLoading: false,
        isLiveMatchesRefreshing: false,
        schedule: state.value.schedule,
        expandedLeagueIds: state.value.expandedLeagueIds,
        errorCode: response.errorCode,
        liveMatches:
            state.value.liveMatches ?? const <MatchesLiveMatchUiModel>[],
        isShowingUpcomingFallback: state.value.isShowingUpcomingFallback,
      );
      return;
    }

    final liveResult = response.data!.liveResult;
    final loadedCount = liveResult.matches.length;

    state.value = state.value.copyWith(
      isLoading: false,
      isLeagueListLoading: false,
      isLiveMatchesRefreshing: false,
      schedule: response.data!.schedule,
      selectedDayIndex: 0,
      expandedLeagueIds: <String>{},
      errorCode: null,
      timelineFilter: MatchesTimelineFilter.byTime,
      liveMatches: liveResult.matches,
      isShowingUpcomingFallback: liveResult.isShowingUpcomingFallback,
      livePage: _resolvedLivePage(liveResult, loadedCount),
      liveLimit: liveResult.limit,
      liveTotal: liveResult.total,
      canLoadMoreLiveMatches: _canLoadMoreLive(liveResult, loadedCount),
      isLoadingMoreLiveMatches: false,
    );
  }

  Future<void> _loadFixturesByDate(DateTime date) async {
    if (state.value.selectedSportCode != MatchesSportCodes.football) return;

    final hasExistingSchedule = state.value.schedule != null;
    state.value = state.value.copyWith(
      isLoading: !hasExistingSchedule,
      isLeagueListLoading: hasExistingSchedule,
      errorCode: null,
      expandedLeagueIds: <String>{},
      isLoadingMoreLeagues: false,
    );

    final response = await ApiErrorHandler.handle<MatchesSportScheduleUiModel>(
      () => _service.fetchLeagueFixturesByDate(
        date,
        page: 1,
        limit: _leaguePageLimit,
      ),
      fallbackErrorCode: 'matches_by_date_fetch_failed',
      userMessage: 'Unable to load matches for this date.',
    );

    if (isClosed) return;

    if (!response.success || response.data == null) {
      state.value = state.value.copyWith(
        isLoading: false,
        isLeagueListLoading: false,
        errorCode: hasExistingSchedule ? null : response.errorCode,
      );
      return;
    }

    state.value = state.value.copyWith(
      isLoading: false,
      isLeagueListLoading: false,
      schedule: response.data!,
      selectedDayIndex: 0,
      expandedLeagueIds: <String>{},
      errorCode: null,
      timelineFilter: MatchesTimelineFilter.byTime,
      isLoadingMoreLeagues: false,
    );
  }

  Future<void> loadMoreLeagueFixtures() async {
    if (state.value.selectedSportCode != MatchesSportCodes.football) return;
    if (!state.value.canLoadMoreLeagues) return;

    final currentSchedule = state.value.schedule;
    final currentDay = state.value.selectedDay;
    final selectedDate = _dateFromSelectedDay();

    if (currentSchedule == null || currentDay == null || selectedDate == null) {
      return;
    }

    final nextPage = currentSchedule.leaguePage + 1;

    state.value = state.value.copyWith(
      isLoadingMoreLeagues: true,
      errorCode: null,
    );

    final response = await ApiErrorHandler.handle<MatchesSportScheduleUiModel>(
      () => _service.fetchLeagueFixturesByDate(
        selectedDate,
        page: nextPage,
        limit: _leaguePageLimit,
      ),
      fallbackErrorCode: 'matches_leagues_load_more_failed',
      userMessage: 'Unable to load more leagues right now.',
    );

    if (isClosed) return;

    if (!response.success || response.data == null) {
      state.value = state.value.copyWith(isLoadingMoreLeagues: false);
      return;
    }

    final nextSchedule = response.data!;
    final nextDay = nextSchedule.days.isEmpty ? null : nextSchedule.days.first;

    if (nextDay == null || nextDay.leagues.isEmpty) {
      state.value = state.value.copyWith(
        isLoadingMoreLeagues: false,
        schedule: currentSchedule.copyWith(
          leaguePage: nextSchedule.leaguePage,
          leagueLimit: nextSchedule.leagueLimit,
          totalLeaguePages: nextSchedule.totalLeaguePages,
          totalLeagues: nextSchedule.totalLeagues,
          totalMatches: nextSchedule.totalMatches,
        ),
      );
      return;
    }

    final mergedLeagues = <MatchesLeagueUiModel>[
      ...currentDay.leagues,
      ...nextDay.leagues,
    ];

    final updatedDays = List<MatchesDayUiModel>.from(currentSchedule.days);
    updatedDays[state.value.selectedDayIndex] = currentDay.copyWith(
      leagues: mergedLeagues,
    );

    state.value = state.value.copyWith(
      isLoadingMoreLeagues: false,
      schedule: currentSchedule.copyWith(
        days: updatedDays,
        leaguePage: nextSchedule.leaguePage,
        leagueLimit: nextSchedule.leagueLimit,
        totalLeaguePages: nextSchedule.totalLeaguePages,
        totalLeagues: nextSchedule.totalLeagues,
        totalMatches: nextSchedule.totalMatches,
      ),
      errorCode: null,
    );
  }

  void _startLiveRefreshTimer() {
    if (!_isActiveBottomTab) return;
    if (state.value.selectedSportCode != MatchesSportCodes.football) return;

    _liveRefreshTimer?.cancel();
    _liveRefreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _refreshLiveMatches();
    });
  }

  Future<void> _refreshLiveMatches() async {
    if (!_isActiveBottomTab) return;
    if (state.value.selectedSportCode != MatchesSportCodes.football) return;
    if (state.value.isLoadingMoreLiveMatches) return;

    final currentCount = state.value.liveMatches?.length ?? 0;
    final refreshLimit = math.max(_livePageLimit, currentCount);

    state.value = state.value.copyWith(isLiveMatchesRefreshing: true);

    final response = await ApiErrorHandler.handle<_MatchesLiveLoadResult>(
      () => _fetchLiveOrUpcomingMatches(page: 1, limit: refreshLimit),
      fallbackErrorCode: 'live_matches_refresh_failed',
      userMessage: 'Unable to refresh live matches right now.',
    );

    if (isClosed) return;

    if (!response.success || response.data == null) {
      state.value = state.value.copyWith(isLiveMatchesRefreshing: false);
      return;
    }

    final result = response.data!;
    final loadedCount = result.matches.length;

    state.value = state.value.copyWith(
      liveMatches: result.matches,
      isShowingUpcomingFallback: result.isShowingUpcomingFallback,
      livePage: _resolvedLivePage(result, loadedCount),
      liveLimit: result.limit,
      liveTotal: result.total,
      canLoadMoreLiveMatches: _canLoadMoreLive(result, loadedCount),
      isLiveMatchesRefreshing: false,
      isLoadingMoreLiveMatches: false,
    );
  }

  Future<_MatchesLiveLoadResult> _fetchLiveOrUpcomingMatches({
    int page = 1,
    int limit = _livePageLimit,
    bool allowUpcomingFallback = true,
  }) async {
    final liveData = await _service.fetchLiveFixturesPage(page: page, limit: limit);
    final liveMatches = liveData.response
        .map(
          (match) => MatchesLiveMatchUiModel.fromFootballFixture(
            match,
            isUpcoming: false,
          ),
        )
        .toList(growable: false);

    if (liveMatches.isNotEmpty || !allowUpcomingFallback || page > 1) {
      return _MatchesLiveLoadResult(
        matches: liveMatches,
        isShowingUpcomingFallback: false,
        page: page,
        limit: limit,
        total: liveData.results,
        pagingTotal: liveData.paging.total,
      );
    }

    final nextMatches = await _service.fetchNextMatches(
      limit: _upcomingFallbackLimit,
    );
    return _MatchesLiveLoadResult(
      matches: nextMatches,
      isShowingUpcomingFallback: true,
      page: 1,
      limit: _upcomingFallbackLimit,
      total: nextMatches.length,
      pagingTotal: 1,
    );
  }

  int _resolvedLivePage(_MatchesLiveLoadResult result, int loadedCount) {
    if (result.isShowingUpcomingFallback || loadedCount <= 0) return result.page;
    return math.max(result.page, (loadedCount / _livePageLimit).ceil());
  }

  bool _canLoadMoreLive(_MatchesLiveLoadResult result, int loadedCount) {
    if (result.isShowingUpcomingFallback) return false;
    if (result.pagingTotal > result.page) return true;
    if (result.total > loadedCount) return true;
    return result.total == 0 && result.matches.length >= _livePageLimit;
  }
}

class _MatchesInitialLoadResult {
  final MatchesSportScheduleUiModel schedule;
  final _MatchesLiveLoadResult liveResult;

  const _MatchesInitialLoadResult({
    required this.schedule,
    required this.liveResult,
  });
}

class _MatchesLiveLoadResult {
  final List<MatchesLiveMatchUiModel> matches;
  final bool isShowingUpcomingFallback;
  final int page;
  final int limit;
  final int total;
  final int pagingTotal;

  const _MatchesLiveLoadResult({
    required this.matches,
    required this.isShowingUpcomingFallback,
    required this.page,
    required this.limit,
    required this.total,
    required this.pagingTotal,
  });
}

class MatchesBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<MatchesService>()) {
      Get.lazyPut<MatchesService>(
        () => MatchesService(apiClient: Get.find<ApiClient>()),
        fenix: true,
      );
    }

    MatchesSearchBinding().dependencies();

    if (!Get.isRegistered<MatchesController>()) {
      Get.lazyPut<MatchesController>(
        () => MatchesController(service: Get.find<MatchesService>()),
      );
    }
  }
}
