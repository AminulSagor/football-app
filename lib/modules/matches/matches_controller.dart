import 'package:get/get.dart';

import '../../core/services/api_error_handler.dart';
import '../bottom_nav_bar/search/matches_search_controller.dart';
import 'model/matches_models.dart';
import 'service/matches_service.dart';

class MatchesController extends GetxController {
  final MatchesService _service;

  MatchesController({required MatchesService service}) : _service = service;

  final Rx<MatchesViewModel> state = const MatchesViewModel().obs;

  @override
  void onInit() {
    super.onInit();
    _loadScheduleForSelectedSport();
  }

  Future<void> onSportSelected(String sportCode) async {
    if (sportCode == state.value.selectedSportCode) {
      return;
    }

    state.value = state.value.copyWith(
      selectedSportCode: sportCode,
      timelineFilter: MatchesTimelineFilter.ongoing,
      selectedDayIndex: 0,
      expandedLeagueIds: <String>{},
      schedule: null,
      errorCode: null,
    );

    await _loadScheduleForSelectedSport();
  }

  void onTimelineFilterChanged(MatchesTimelineFilter filter) {
    final normalizedFilter =
        !state.value.shouldShowOngoingTimelineFilter &&
            filter == MatchesTimelineFilter.ongoing
        ? MatchesTimelineFilter.byTime
        : filter;

    if (normalizedFilter == state.value.timelineFilter) {
      return;
    }

    state.value = state.value.copyWith(
      timelineFilter: normalizedFilter,
      expandedLeagueIds: <String>{},
    );
  }

  void showPreviousDay() {
    final previousIndex = state.value.previousDayIndex;
    if (previousIndex == null) {
      return;
    }

    _applyDaySelection(previousIndex);
  }

  void showNextDay() {
    final nextIndex = state.value.nextDayIndex;
    if (nextIndex == null) {
      return;
    }

    _applyDaySelection(nextIndex);
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
    if (selectedDay == null) {
      return const <MatchesLeagueUiModel>[];
    }

    final selectedFilter = state.value.timelineFilter;
    final leagues = <MatchesLeagueUiModel>[];

    for (final league in selectedDay.leagues) {
      final fixtures =
          league.fixtures
              .where(
                (fixture) => _matchesTimelineFilter(fixture, selectedFilter),
              )
              .toList(growable: false)
            ..sort(
              (left, right) => _fixtureSortValue(
                left,
                selectedFilter,
              ).compareTo(_fixtureSortValue(right, selectedFilter)),
            );

      if (fixtures.isEmpty) {
        continue;
      }

      leagues.add(
        league.copyWith(fixtureCount: fixtures.length, fixtures: fixtures),
      );
    }

    return leagues;
  }

  List<MatchesLeagueUiModel> nextDayPreviewLeagues() {
    final nextDay = state.value.nextDay;
    if (nextDay == null) {
      return const <MatchesLeagueUiModel>[];
    }

    return nextDay.leagues;
  }

  Future<void> _loadScheduleForSelectedSport() async {
    final selectedSportCode = state.value.selectedSportCode;
    if (selectedSportCode != MatchesSportCodes.football) {
      state.value = state.value.copyWith(
        isLoading: false,
        schedule: null,
        expandedLeagueIds: <String>{},
      );
      return;
    }

    state.value = state.value.copyWith(isLoading: true, errorCode: null);

    final response = await ApiErrorHandler.handle<MatchesSportScheduleUiModel>(
      () => _service.fetchSchedule(
        MatchesSchedulePayloadModel(sportCode: selectedSportCode),
      ),
      fallbackErrorCode: 'matches_schedule_fetch_failed',
      userMessage: 'Unable to load matches right now.',
    );

    if (isClosed) {
      return;
    }

    if (!response.success || response.data == null) {
      state.value = state.value.copyWith(
        isLoading: false,
        schedule: null,
        expandedLeagueIds: <String>{},
        errorCode: response.errorCode,
      );
      return;
    }

    final schedule = response.data!;
    final selectedDayIndex = _initialDayIndex(schedule.days);

    final loadedState = state.value.copyWith(
      isLoading: false,
      schedule: schedule,
      selectedDayIndex: selectedDayIndex,
      expandedLeagueIds: <String>{},
      errorCode: null,
    );

    state.value = loadedState.copyWith(
      timelineFilter: loadedState.shouldShowOngoingTimelineFilter
          ? loadedState.timelineFilter
          : MatchesTimelineFilter.byTime,
    );
  }

  void _applyDaySelection(int dayIndex) {
    final nextState = state.value.copyWith(selectedDayIndex: dayIndex);

    state.value = nextState.copyWith(
      timelineFilter: nextState.shouldShowOngoingTimelineFilter
          ? nextState.timelineFilter
          : MatchesTimelineFilter.byTime,
      expandedLeagueIds: <String>{},
    );
  }

  bool _matchesTimelineFilter(
    MatchesFixtureUiModel fixture,
    MatchesTimelineFilter filter,
  ) {
    if (filter == MatchesTimelineFilter.byTime) {
      return true;
    }

    return fixture.visibleInOngoing;
  }

  int _fixtureSortValue(
    MatchesFixtureUiModel fixture,
    MatchesTimelineFilter filter,
  ) {
    if (filter == MatchesTimelineFilter.byTime) {
      return fixture.kickoffOrder;
    }

    return (_statusOrder(fixture.statusCode) * 10000) + fixture.kickoffOrder;
  }

  int _statusOrder(String statusCode) {
    switch (statusCode) {
      case MatchesFixtureStatusCodes.live:
        return 0;
      case MatchesFixtureStatusCodes.upcoming:
        return 1;
      case MatchesFixtureStatusCodes.finished:
        return 2;
      default:
        return 3;
    }
  }

  int _initialDayIndex(List<MatchesDayUiModel> days) {
    final todayIndex = _todayIndex(days);
    if (todayIndex != null) {
      return todayIndex;
    }

    final today = _normalizedDate(DateTime.now());
    final minDate = today.subtract(const Duration(days: 30));
    final maxDate = today.add(const Duration(days: 7));

    for (var index = 0; index < days.length; index++) {
      final dayDate = _safeDayDate(days[index].dayId);
      if (dayDate == null) {
        return index;
      }

      if (!dayDate.isBefore(minDate) && !dayDate.isAfter(maxDate)) {
        return index;
      }
    }

    return 0;
  }

  int? _todayIndex(List<MatchesDayUiModel> days) {
    final today = _normalizedDate(DateTime.now());

    for (var index = 0; index < days.length; index++) {
      if (days[index].dayLabelCode == MatchesDayLabelCodes.today) {
        return index;
      }

      final dayDate = _safeDayDate(days[index].dayId);
      if (dayDate != null && dayDate == today) {
        return index;
      }
    }

    return null;
  }

  DateTime _normalizedDate(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  DateTime? _safeDayDate(String value) {
    final parsed = DateTime.tryParse(value);
    if (parsed == null) {
      return null;
    }

    return _normalizedDate(parsed);
  }
}

class MatchesBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<MatchesService>()) {
      Get.lazyPut<MatchesService>(() => MatchesService(), fenix: true);
    }

    MatchesSearchBinding().dependencies();

    if (!Get.isRegistered<MatchesController>()) {
      Get.lazyPut<MatchesController>(
        () => MatchesController(service: Get.find<MatchesService>()),
      );
    }
  }
}
