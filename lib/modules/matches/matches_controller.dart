import 'dart:async';

import 'package:get/get.dart';

import '../../core/services/api_client.dart';
import '../../core/services/api_error_handler.dart';
import '../bottom_nav_bar/search/matches_search_controller.dart';
import 'model/matches_models.dart';
import 'service/matches_service.dart';

class MatchesController extends GetxController {
  final MatchesService _service;

  MatchesController({required MatchesService service}) : _service = service;

  final Rx<MatchesViewModel> state = const MatchesViewModel().obs;
  Timer? _liveRefreshTimer;

  @override
  void onInit() {
    super.onInit();
    _loadInitialFootballData();
    // _startLiveRefreshTimer();
  }

  @override
  void onClose() {
    _liveRefreshTimer?.cancel();
    super.onClose();
  }

  Future<void> onSportSelected(String sportCode) async {
    if (sportCode == state.value.selectedSportCode) return;

    state.value = state.value.copyWith(
      selectedSportCode: sportCode,
      errorCode: null,
    );

    if (sportCode == MatchesSportCodes.football &&
        state.value.schedule == null) {
      await _loadInitialFootballData();
    }
  }

  void onDateSelected(DateTime date) {
    _loadFixturesByDate(date);
  }

  void clearDateFilter() {
    _loadFixturesByDate(DateTime.now());
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

      leagues.add(
        league.copyWith(fixtureCount: fixtures.length, fixtures: fixtures),
      );
    }

    return leagues;
  }

  List<MatchesLeagueUiModel> nextDayPreviewLeagues() {
    final nextDay = state.value.nextDay;
    if (nextDay == null) return const <MatchesLeagueUiModel>[];
    return nextDay.leagues;
  }

  Future<void> _loadInitialFootballData() async {
    state.value = state.value.copyWith(
      isLoading: state.value.schedule == null,
      isLeagueListLoading: state.value.schedule != null,
      errorCode: null,
    );

    final response = await ApiErrorHandler.handle<_MatchesInitialLoadResult>(
      () async {
        final schedule = await _service.fetchFixturesByDate(DateTime.now());
        final liveResult = await _fetchLiveOrUpcomingMatches();

        return _MatchesInitialLoadResult(
          schedule: schedule,
          liveMatches: liveResult.matches,
          isShowingUpcomingFallback: liveResult.isShowingUpcomingFallback,
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
        schedule: state.value.schedule,
        expandedLeagueIds: state.value.expandedLeagueIds,
        errorCode: response.errorCode,
        liveMatches:
            state.value.liveMatches ?? const <MatchesLiveMatchUiModel>[],
        isShowingUpcomingFallback: state.value.isShowingUpcomingFallback,
      );
      return;
    }

    state.value = state.value.copyWith(
      isLoading: false,
      isLeagueListLoading: false,
      schedule: response.data!.schedule,
      selectedDayIndex: 0,
      expandedLeagueIds: <String>{},
      errorCode: null,
      timelineFilter: MatchesTimelineFilter.byTime,
      liveMatches: response.data!.liveMatches,
      isShowingUpcomingFallback: response.data!.isShowingUpcomingFallback,
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
    );

    final response = await ApiErrorHandler.handle<MatchesSportScheduleUiModel>(
      () => _service.fetchFixturesByDate(date),
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
    );
  }

  void _startLiveRefreshTimer() {
    _liveRefreshTimer?.cancel();
    _liveRefreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _refreshLiveMatches();
    });
  }

  Future<void> _refreshLiveMatches() async {
    final response = await ApiErrorHandler.handle<_MatchesLiveLoadResult>(
      _fetchLiveOrUpcomingMatches,
      fallbackErrorCode: 'live_matches_refresh_failed',
      userMessage: 'Unable to refresh live matches right now.',
    );

    if (isClosed || !response.success || response.data == null) return;

    state.value = state.value.copyWith(
      liveMatches: response.data!.matches,
      isShowingUpcomingFallback: response.data!.isShowingUpcomingFallback,
    );
  }

  Future<_MatchesLiveLoadResult> _fetchLiveOrUpcomingMatches() async {
    final liveMatches = await _service.fetchLiveMatches();

    if (liveMatches.isNotEmpty) {
      return _MatchesLiveLoadResult(
        matches: liveMatches,
        isShowingUpcomingFallback: false,
      );
    }

    final nextMatches = await _service.fetchNextMatches(limit: 5);
    return _MatchesLiveLoadResult(
      matches: nextMatches,
      isShowingUpcomingFallback: true,
    );
  }
}

class _MatchesInitialLoadResult {
  final MatchesSportScheduleUiModel schedule;
  final List<MatchesLiveMatchUiModel> liveMatches;
  final bool isShowingUpcomingFallback;

  const _MatchesInitialLoadResult({
    required this.schedule,
    required this.liveMatches,
    required this.isShowingUpcomingFallback,
  });
}

class _MatchesLiveLoadResult {
  final List<MatchesLiveMatchUiModel> matches;
  final bool isShowingUpcomingFallback;

  const _MatchesLiveLoadResult({
    required this.matches,
    required this.isShowingUpcomingFallback,
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
