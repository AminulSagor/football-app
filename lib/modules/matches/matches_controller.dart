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
    if (sportCode == state.value.selectedSportCode) return;

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

    if (normalizedFilter == state.value.timelineFilter) return;

    state.value = state.value.copyWith(
      timelineFilter: normalizedFilter,
      expandedLeagueIds: <String>{},
    );
  }

  void showPreviousDay() {
    _moveSelectedDateBy(-1);
  }

  void showNextDay() {
    _moveSelectedDateBy(1);
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

    final selectedFilter = state.value.timelineFilter;
    final leagues = <MatchesLeagueUiModel>[];

    for (final league in selectedDay.leagues) {
      final fixtures =
          league.fixtures
              .where((fixture) {
                return _matchesTimelineFilter(fixture, selectedFilter);
              })
              .toList(growable: false)
            ..sort((left, right) {
              return _fixtureSortValue(left, selectedFilter)
                  .compareTo(_fixtureSortValue(right, selectedFilter));
            });

      if (fixtures.isEmpty) continue;

      leagues.add(
        league.copyWith(
          fixtureCount: fixtures.length,
          fixtures: fixtures,
        ),
      );
    }

    return leagues;
  }

  List<MatchesLeagueUiModel> nextDayPreviewLeagues() {
    final nextDay = state.value.nextDay;
    if (nextDay == null) return const <MatchesLeagueUiModel>[];
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

    if (isClosed) return;

    if (!response.success || response.data == null) {
      final fallbackSchedule = _buildInitialDummySchedule();

      state.value = state.value.copyWith(
        isLoading: false,
        schedule: fallbackSchedule,
        selectedDayIndex: _initialDayIndex(fallbackSchedule.days),
        expandedLeagueIds: <String>{},
        errorCode: null,
        timelineFilter: MatchesTimelineFilter.ongoing,
      );
      return;
    }

    final schedule = _normalizeScheduleWithDummyRange(response.data!);
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
          ? MatchesTimelineFilter.ongoing
          : MatchesTimelineFilter.byTime,
    );
  }

  void _moveSelectedDateBy(int amount) {
    final schedule = state.value.schedule;
    final selectedDay = state.value.selectedDay;

    if (schedule == null || selectedDay == null) return;

    final currentDate = _safeDayDate(selectedDay.dayId);
    if (currentDate == null) return;

    final targetDate = currentDate.add(Duration(days: amount));
    final nextSchedule = _ensureDayExists(schedule, targetDate);

    final targetIndex = nextSchedule.days.indexWhere((day) {
      final dayDate = _safeDayDate(day.dayId);
      return dayDate != null && dayDate == targetDate;
    });

    if (targetIndex == -1) return;

    final nextState = state.value.copyWith(
      schedule: nextSchedule,
      selectedDayIndex: targetIndex,
      expandedLeagueIds: <String>{},
    );

    state.value = nextState.copyWith(
      timelineFilter: nextState.shouldShowOngoingTimelineFilter
          ? MatchesTimelineFilter.ongoing
          : MatchesTimelineFilter.byTime,
    );
  }

  MatchesSportScheduleUiModel _ensureDayExists(
    MatchesSportScheduleUiModel schedule,
    DateTime targetDate,
  ) {
    final normalizedTarget = _normalizedDate(targetDate);

    final exists = schedule.days.any((day) {
      final dayDate = _safeDayDate(day.dayId);
      return dayDate != null && dayDate == normalizedTarget;
    });

    if (exists) return schedule;

    final nextDays = List<MatchesDayUiModel>.from(schedule.days)
      ..add(_buildDummyDay(normalizedTarget))
      ..sort((a, b) {
        final aDate = _safeDayDate(a.dayId) ?? DateTime(1900);
        final bDate = _safeDayDate(b.dayId) ?? DateTime(1900);
        return aDate.compareTo(bDate);
      });

    return schedule.copyWith(days: nextDays);
  }

  MatchesSportScheduleUiModel _normalizeScheduleWithDummyRange(
    MatchesSportScheduleUiModel schedule,
  ) {
    var nextSchedule = schedule;
    final today = _normalizedDate(DateTime.now());

    for (var offset = -10; offset <= 15; offset++) {
      nextSchedule = _ensureDayExists(
        nextSchedule,
        today.add(Duration(days: offset)),
      );
    }

    return nextSchedule;
  }

  MatchesSportScheduleUiModel _buildInitialDummySchedule() {
    final today = _normalizedDate(DateTime.now());

    final days = <MatchesDayUiModel>[
      for (var offset = -10; offset <= 15; offset++)
        _buildDummyDay(today.add(Duration(days: offset))),
    ];

    return MatchesSportScheduleUiModel(
      sportCode: MatchesSportCodes.football,
      days: days,
    );
  }

  MatchesDayUiModel _buildDummyDay(DateTime date) {
    final today = _normalizedDate(DateTime.now());
    final difference = date.difference(today).inDays;

    final dayId = _dateId(date);
    final hasMatches = difference % 3 != 0;

    return MatchesDayUiModel(
      dayId: dayId,
      displayDate: _displayDate(date),
      dayLabelCode: _dayLabelCode(difference),
      leagues: hasMatches ? _dummyLeagues(dayId, difference) : const [],
    );
  }

  List<MatchesLeagueUiModel> _dummyLeagues(String dayId, int difference) {
    final isPast = difference < 0;
    final isToday = difference == 0;
    final isFuture = difference > 0;

    return [
      MatchesLeagueUiModel(
        leagueId: 'premier-league-$dayId',
        leagueName: 'Premier League',
        stageName: 'Regular Season',
        badgeSeed: 'PL',
        fixtureCount: 3,
        fixtures: [
          _fixture(
            idSeed: '$dayId-pl-1',
            home: 'Arsenal',
            away: 'Chelsea',
            homeShort: 'ARS',
            awayShort: 'CHE',
            kickoffOrder: 1400,
            statusCode: isPast
                ? MatchesFixtureStatusCodes.finished
                : isToday
                    ? MatchesFixtureStatusCodes.live
                    : MatchesFixtureStatusCodes.upcoming,
            statusLabel: isPast
                ? 'FT'
                : isToday
                    ? '67'
                    : '14:00',
            statusDetail: isToday ? 'LIVE' : '',
            homeScore: isFuture ? null : 2,
            awayScore: isFuture ? null : 1,
            visibleInOngoing: isToday,
          ),
          _fixture(
            idSeed: '$dayId-pl-2',
            home: 'Liverpool',
            away: 'Everton',
            homeShort: 'LIV',
            awayShort: 'EVE',
            kickoffOrder: 1730,
            statusCode: isFuture
                ? MatchesFixtureStatusCodes.upcoming
                : MatchesFixtureStatusCodes.finished,
            statusLabel: isFuture ? '17:30' : 'FT',
            statusDetail: '',
            homeScore: isFuture ? null : 1,
            awayScore: isFuture ? null : 1,
            visibleInOngoing: false,
          ),
          _fixture(
            idSeed: '$dayId-pl-3',
            home: 'Manchester City',
            away: 'Tottenham',
            homeShort: 'MCI',
            awayShort: 'TOT',
            kickoffOrder: 2100,
            statusCode: MatchesFixtureStatusCodes.upcoming,
            statusLabel: '21:00',
            statusDetail: '',
            homeScore: null,
            awayScore: null,
            visibleInOngoing: false,
          ),
        ],
      ),
      MatchesLeagueUiModel(
        leagueId: 'champions-league-$dayId',
        leagueName: 'UEFA Champions League',
        stageName: 'Knockout Round',
        badgeSeed: 'UCL',
        fixtureCount: 2,
        fixtures: [
          _fixture(
            idSeed: '$dayId-ucl-1',
            home: 'Real Madrid',
            away: 'Bayern Munich',
            homeShort: 'RMA',
            awayShort: 'BAY',
            kickoffOrder: 2000,
            statusCode: isFuture
                ? MatchesFixtureStatusCodes.upcoming
                : MatchesFixtureStatusCodes.finished,
            statusLabel: isFuture ? '20:00' : 'FT',
            statusDetail: '',
            homeScore: isFuture ? null : 3,
            awayScore: isFuture ? null : 2,
            visibleInOngoing: false,
          ),
          _fixture(
            idSeed: '$dayId-ucl-2',
            home: 'PSG',
            away: 'Inter Milan',
            homeShort: 'PSG',
            awayShort: 'INT',
            kickoffOrder: 2300,
            statusCode: MatchesFixtureStatusCodes.upcoming,
            statusLabel: '23:00',
            statusDetail: '',
            homeScore: null,
            awayScore: null,
            visibleInOngoing: false,
          ),
        ],
      ),
    ];
  }

  MatchesFixtureUiModel _fixture({
    required String idSeed,
    required String home,
    required String away,
    required String homeShort,
    required String awayShort,
    required int kickoffOrder,
    required String statusCode,
    required String statusLabel,
    required String statusDetail,
    required int? homeScore,
    required int? awayScore,
    required bool visibleInOngoing,
  }) {
    return MatchesFixtureUiModel(
      fixtureId: idSeed,
      homeTeam: MatchesTeamUiModel(
        teamId: '$idSeed-home',
        teamName: home,
        shortName: homeShort,
        badgeHex: '#1F6E80',
      ),
      awayTeam: MatchesTeamUiModel(
        teamId: '$idSeed-away',
        teamName: away,
        shortName: awayShort,
        badgeHex: '#78B9B5',
      ),
      homeScore: homeScore,
      awayScore: awayScore,
      statusCode: statusCode,
      statusLabel: statusLabel,
      statusDetail: statusDetail,
      kickoffOrder: kickoffOrder,
      visibleInOngoing: visibleInOngoing,
    );
  }

  bool _matchesTimelineFilter(
    MatchesFixtureUiModel fixture,
    MatchesTimelineFilter filter,
  ) {
    if (filter == MatchesTimelineFilter.byTime) return true;
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
    if (todayIndex != null) return todayIndex;
    return 0;
  }

  int? _todayIndex(List<MatchesDayUiModel> days) {
    final today = _normalizedDate(DateTime.now());

    for (var index = 0; index < days.length; index++) {
      final dayDate = _safeDayDate(days[index].dayId);
      if (dayDate != null && dayDate == today) return index;

      if (days[index].dayLabelCode == MatchesDayLabelCodes.today) {
        return index;
      }
    }

    return null;
  }

  String _dayLabelCode(int difference) {
    if (difference == 0) return MatchesDayLabelCodes.today;
    if (difference == 1) return MatchesDayLabelCodes.tomorrow;
    if (difference < 0) return MatchesDayLabelCodes.old;
    return MatchesDayLabelCodes.upcoming;
  }

  String _dateId(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  String _displayDate(DateTime date) {
    const months = [
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

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  DateTime _normalizedDate(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  DateTime? _safeDayDate(String value) {
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return null;
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