enum MatchesTimelineFilter { ongoing, byTime }

class MatchesSportCodes {
  static const String football = 'football';
  static const String cricket = 'cricket';
  static const String basketball = 'basketball';
}

class MatchesDayLabelCodes {
  static const String today = 'today';
  static const String tomorrow = 'tomorrow';
  static const String old = 'old';
}

class MatchesFixtureStatusCodes {
  static const String live = 'live';
  static const String finished = 'finished';
  static const String upcoming = 'upcoming';
}

class MatchesSchedulePayloadModel {
  final String sportCode;

  const MatchesSchedulePayloadModel({required this.sportCode});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'sport_code': sportCode};
  }
}

class MatchesTeamUiModel {
  final String teamId;
  final String teamName;
  final String shortName;
  final String badgeHex;

  const MatchesTeamUiModel({
    required this.teamId,
    required this.teamName,
    required this.shortName,
    required this.badgeHex,
  });

  factory MatchesTeamUiModel.fromJson(Map<String, dynamic> json) {
    return MatchesTeamUiModel(
      teamId: json['team_id'] as String? ?? '',
      teamName: json['team_name'] as String? ?? '',
      shortName: json['short_name'] as String? ?? '',
      badgeHex: json['badge_hex'] as String? ?? '#324844',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'team_id': teamId,
      'team_name': teamName,
      'short_name': shortName,
      'badge_hex': badgeHex,
    };
  }
}

class MatchesFixtureUiModel {
  final String fixtureId;
  final MatchesTeamUiModel homeTeam;
  final MatchesTeamUiModel awayTeam;
  final int? homeScore;
  final int? awayScore;
  final String statusCode;
  final String statusLabel;
  final String statusDetail;
  final int kickoffOrder;
  final bool visibleInOngoing;

  const MatchesFixtureUiModel({
    required this.fixtureId,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.statusCode,
    required this.statusLabel,
    required this.statusDetail,
    required this.kickoffOrder,
    required this.visibleInOngoing,
  });

  bool get isLive => statusCode == MatchesFixtureStatusCodes.live;

  factory MatchesFixtureUiModel.fromJson(Map<String, dynamic> json) {
    return MatchesFixtureUiModel(
      fixtureId: json['fixture_id'] as String? ?? '',
      homeTeam: MatchesTeamUiModel.fromJson(
        (json['home_team'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
      awayTeam: MatchesTeamUiModel.fromJson(
        (json['away_team'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
      homeScore: _toIntOrNull(json['home_score']),
      awayScore: _toIntOrNull(json['away_score']),
      statusCode: json['status_code'] as String? ?? '',
      statusLabel: json['status_label'] as String? ?? '',
      statusDetail: json['status_detail'] as String? ?? '',
      kickoffOrder: _toIntOrNull(json['kickoff_order']) ?? 0,
      visibleInOngoing: json['visible_in_ongoing'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'fixture_id': fixtureId,
      'home_team': homeTeam.toJson(),
      'away_team': awayTeam.toJson(),
      'home_score': homeScore,
      'away_score': awayScore,
      'status_code': statusCode,
      'status_label': statusLabel,
      'status_detail': statusDetail,
      'kickoff_order': kickoffOrder,
      'visible_in_ongoing': visibleInOngoing,
    };
  }
}

class MatchesLeagueUiModel {
  final String leagueId;
  final String leagueName;
  final String stageName;
  final String badgeSeed;
  final int fixtureCount;
  final List<MatchesFixtureUiModel> fixtures;

  const MatchesLeagueUiModel({
    required this.leagueId,
    required this.leagueName,
    required this.stageName,
    required this.badgeSeed,
    required this.fixtureCount,
    required this.fixtures,
  });

  factory MatchesLeagueUiModel.fromJson(Map<String, dynamic> json) {
    final fixturesJson =
        (json['fixtures'] as List<dynamic>? ?? const <dynamic>[])
            .whereType<Map<String, dynamic>>()
            .toList();

    final fixtures = fixturesJson
        .map(MatchesFixtureUiModel.fromJson)
        .toList(growable: false);

    return MatchesLeagueUiModel(
      leagueId: json['league_id'] as String? ?? '',
      leagueName: json['league_name'] as String? ?? '',
      stageName: json['stage_name'] as String? ?? '',
      badgeSeed: json['badge_seed'] as String? ?? '',
      fixtureCount: _toIntOrNull(json['fixture_count']) ?? fixtures.length,
      fixtures: fixtures,
    );
  }

  MatchesLeagueUiModel copyWith({
    String? leagueId,
    String? leagueName,
    String? stageName,
    String? badgeSeed,
    int? fixtureCount,
    List<MatchesFixtureUiModel>? fixtures,
  }) {
    return MatchesLeagueUiModel(
      leagueId: leagueId ?? this.leagueId,
      leagueName: leagueName ?? this.leagueName,
      stageName: stageName ?? this.stageName,
      badgeSeed: badgeSeed ?? this.badgeSeed,
      fixtureCount: fixtureCount ?? this.fixtureCount,
      fixtures: fixtures ?? this.fixtures,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'league_id': leagueId,
      'league_name': leagueName,
      'stage_name': stageName,
      'badge_seed': badgeSeed,
      'fixture_count': fixtureCount,
      'fixtures': fixtures.map((fixture) => fixture.toJson()).toList(),
    };
  }
}

class MatchesDayUiModel {
  final String dayId;
  final String dayLabelCode;
  final String displayDate;
  final List<MatchesLeagueUiModel> leagues;

  const MatchesDayUiModel({
    required this.dayId,
    required this.dayLabelCode,
    required this.displayDate,
    required this.leagues,
  });

  factory MatchesDayUiModel.fromJson(Map<String, dynamic> json) {
    final leaguesJson =
        (json['leagues'] as List<dynamic>? ?? const <dynamic>[])
            .whereType<Map<String, dynamic>>()
            .toList();

    return MatchesDayUiModel(
      dayId: json['day_id'] as String? ?? '',
      dayLabelCode: json['day_label_code'] as String? ?? '',
      displayDate: json['display_date'] as String? ?? '',
      leagues: leaguesJson
          .map(MatchesLeagueUiModel.fromJson)
          .toList(growable: false),
    );
  }

  MatchesDayUiModel copyWith({
    String? dayId,
    String? dayLabelCode,
    String? displayDate,
    List<MatchesLeagueUiModel>? leagues,
  }) {
    return MatchesDayUiModel(
      dayId: dayId ?? this.dayId,
      dayLabelCode: dayLabelCode ?? this.dayLabelCode,
      displayDate: displayDate ?? this.displayDate,
      leagues: leagues ?? this.leagues,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'day_id': dayId,
      'day_label_code': dayLabelCode,
      'display_date': displayDate,
      'leagues': leagues.map((league) => league.toJson()).toList(),
    };
  }
}

class MatchesSportScheduleUiModel {
  final String sportCode;
  final List<MatchesDayUiModel> days;

  const MatchesSportScheduleUiModel({
    required this.sportCode,
    required this.days,
  });

  factory MatchesSportScheduleUiModel.fromJson(Map<String, dynamic> json) {
    final daysJson = (json['days'] as List<dynamic>? ?? const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .toList();

    return MatchesSportScheduleUiModel(
      sportCode: json['sport_code'] as String? ?? MatchesSportCodes.football,
      days: daysJson.map(MatchesDayUiModel.fromJson).toList(growable: false),
    );
  }

  MatchesSportScheduleUiModel copyWith({
    String? sportCode,
    List<MatchesDayUiModel>? days,
  }) {
    return MatchesSportScheduleUiModel(
      sportCode: sportCode ?? this.sportCode,
      days: days ?? this.days,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'sport_code': sportCode,
      'days': days.map((day) => day.toJson()).toList(),
    };
  }
}

class MatchesViewModel {
  static const Object _unset = Object();

  final bool isLoading;
  final String selectedSportCode;
  final MatchesTimelineFilter timelineFilter;
  final int selectedDayIndex;
  final MatchesSportScheduleUiModel? schedule;
  final Set<String> expandedLeagueIds;
  final String? errorCode;

  const MatchesViewModel({
    this.isLoading = false,
    this.selectedSportCode = MatchesSportCodes.football,
    this.timelineFilter = MatchesTimelineFilter.ongoing,
    this.selectedDayIndex = 0,
    this.schedule,
    this.expandedLeagueIds = const <String>{},
    this.errorCode,
  });

  bool get isFootballSelected {
    return selectedSportCode == MatchesSportCodes.football;
  }

  MatchesDayUiModel? get selectedDay {
    final currentSchedule = schedule;

    if (currentSchedule == null || currentSchedule.days.isEmpty) {
      return null;
    }

    if (selectedDayIndex < 0 ||
        selectedDayIndex >= currentSchedule.days.length) {
      return null;
    }

    return currentSchedule.days[selectedDayIndex];
  }

  bool get shouldShowOngoingTimelineFilter {
    final day = selectedDay;
    if (day == null) return false;

    if (day.dayLabelCode == MatchesDayLabelCodes.today) {
      return true;
    }

    final dayDate = _dayDate(day.dayId);
    if (dayDate == null) return false;

    return dayDate == _todayDate;
  }

  int? get previousDayIndex {
    final currentSchedule = schedule;
    if (currentSchedule == null || currentSchedule.days.isEmpty) {
      return null;
    }

    final previousIndex = selectedDayIndex - 1;
    if (previousIndex < 0) return null;

    return previousIndex;
  }

  int? get nextDayIndex {
    final currentSchedule = schedule;
    if (currentSchedule == null || currentSchedule.days.isEmpty) {
      return null;
    }

    final nextIndex = selectedDayIndex + 1;
    if (nextIndex >= currentSchedule.days.length) return null;

    return nextIndex;
  }

  bool get canGoPreviousDay {
    return schedule != null && selectedDay != null;
  }

  bool get canGoNextDay {
    return schedule != null && selectedDay != null;
  }

  MatchesDayUiModel? get nextDay {
    final currentSchedule = schedule;
    final selected = selectedDay;

    if (currentSchedule == null || selected == null) {
      return null;
    }

    final selectedDate = _dayDate(selected.dayId);
    if (selectedDate == null) return null;

    final targetDate = selectedDate.add(const Duration(days: 1));

    for (final day in currentSchedule.days) {
      final dayDate = _dayDate(day.dayId);
      if (dayDate != null && dayDate == targetDate) {
        return day;
      }
    }

    return null;
  }

  DateTime get _todayDate {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime? _dayDate(String value) {
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return null;

    return DateTime(parsed.year, parsed.month, parsed.day);
  }

  MatchesViewModel copyWith({
    bool? isLoading,
    String? selectedSportCode,
    MatchesTimelineFilter? timelineFilter,
    int? selectedDayIndex,
    Object? schedule = _unset,
    Object? expandedLeagueIds = _unset,
    Object? errorCode = _unset,
  }) {
    return MatchesViewModel(
      isLoading: isLoading ?? this.isLoading,
      selectedSportCode: selectedSportCode ?? this.selectedSportCode,
      timelineFilter: timelineFilter ?? this.timelineFilter,
      selectedDayIndex: selectedDayIndex ?? this.selectedDayIndex,
      schedule: identical(schedule, _unset)
          ? this.schedule
          : schedule as MatchesSportScheduleUiModel?,
      expandedLeagueIds: identical(expandedLeagueIds, _unset)
          ? this.expandedLeagueIds
          : expandedLeagueIds as Set<String>,
      errorCode: identical(errorCode, _unset)
          ? this.errorCode
          : errorCode as String?,
    );
  }
}

int? _toIntOrNull(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);

  return null;
}