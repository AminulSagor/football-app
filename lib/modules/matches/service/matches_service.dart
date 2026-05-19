import '../../../core/services/api_client.dart';
import '../model/matches_models.dart';

class MatchesService {
  final ApiClient _apiClient;

  MatchesService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<MatchesSportScheduleUiModel> fetchSchedule(
    MatchesSchedulePayloadModel payload,
  ) async {
    final payloadJson = payload.toJson();
    final sportCode = payloadJson['sport_code'] as String? ?? '';

    if (sportCode != MatchesSportCodes.football) {
      return const MatchesSportScheduleUiModel(
        sportCode: MatchesSportCodes.football,
        days: <MatchesDayUiModel>[],
      );
    }

    return fetchLeagueFixturesByDate(DateTime.now(), page: 1, limit: 10);
  }

  Future<MatchesSportScheduleUiModel> fetchFixturesByDate(DateTime date) async {
    final data = await _fetchFixtures(<String, dynamic>{
      'date': _apiDate(date),
    });
    return _buildScheduleFromFixtures(data.response, date);
  }

  Future<MatchesSportScheduleUiModel> fetchLeagueFixturesByDate(
    DateTime date, {
    int page = 1,
    int limit = 10,
  }) async {
    final data = await _fetchLeagueFixtures(
      date: date,
      page: page,
      limit: limit,
    );
    return _buildScheduleFromLeagueItems(data, date);
  }

  Future<List<MatchesLiveMatchUiModel>> fetchLiveMatches() async {
    final data = await fetchLiveFixturesPage(page: 1, limit: 3);
    return data.response
        .map(
          (match) => MatchesLiveMatchUiModel.fromFootballFixture(
            match,
            isUpcoming: false,
          ),
        )
        .toList(growable: false);
  }

  Future<FootballFixturesDataModel> fetchLiveFixturesPage({
    int page = 1,
    int limit = 3,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/fixtures/live',
      queryParameters: <String, dynamic>{
        'page': page,
        'limit': limit,
      },
    );

    final responseData = response.data;
    if (responseData == null) {
      throw Exception('empty_response');
    }

    final parsed = FootballFixturesApiResponseModel.fromJson(responseData);
    if (!parsed.success) {
      throw Exception(
        parsed.message.isEmpty ? 'request_failed' : parsed.message,
      );
    }

    return parsed.data;
  }

  Future<List<MatchesLiveMatchUiModel>> fetchNextMatches({
    int limit = 5,
  }) async {
    final data = await _fetchFixtures(<String, dynamic>{'next': limit});
    return data.response
        .take(limit)
        .map(
          (match) => MatchesLiveMatchUiModel.fromFootballFixture(
            match,
            isUpcoming: true,
          ),
        )
        .toList(growable: false);
  }

  Future<FootballFixturesDataModel> _fetchFixtures(
    Map<String, dynamic> queryParameters,
  ) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/fixtures',
      queryParameters: queryParameters,
    );

    final responseData = response.data;
    if (responseData == null) {
      throw Exception('empty_response');
    }

    final parsed = FootballFixturesApiResponseModel.fromJson(responseData);
    if (!parsed.success) {
      throw Exception(
        parsed.message.isEmpty ? 'request_failed' : parsed.message,
      );
    }

    return parsed.data;
  }

  Future<FootballLeagueFixturesDataModel> _fetchLeagueFixtures({
    required DateTime date,
    required int page,
    required int limit,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/league',
      queryParameters: <String, dynamic>{
        'date': _apiDate(date),
        'page': page,
        'limit': limit,
      },
    );

    final responseData = response.data;
    if (responseData == null) {
      throw Exception('empty_response');
    }

    final parsed = FootballLeagueFixturesApiResponseModel.fromJson(responseData);
    if (!parsed.success) {
      throw Exception(
        parsed.message.isEmpty ? 'request_failed' : parsed.message,
      );
    }

    return parsed.data;
  }

  MatchesSportScheduleUiModel _buildScheduleFromLeagueItems(
    FootballLeagueFixturesDataModel data,
    DateTime selectedDate,
  ) {
    final leagues = data.items
        .map((item) {
          final fixtureItems = item.fixtures
              .map(MatchesFixtureUiModel.fromFootballFixture)
              .toList(growable: false)
            ..sort(
              (left, right) => left.kickoffOrder.compareTo(right.kickoffOrder),
            );

          return MatchesLeagueUiModel.fromFootballLeague(
            league: item.league,
            fixtures: fixtureItems,
            fixtureCount: item.matchCount,
          );
        })
        .where((league) => league.fixtures.isNotEmpty)
        .toList(growable: false);

    final normalizedDate = _normalizedDate(selectedDate);
    final meta = data.meta;

    return MatchesSportScheduleUiModel(
      sportCode: MatchesSportCodes.football,
      leaguePage: meta.page,
      leagueLimit: meta.limit,
      totalLeaguePages: meta.totalPages,
      totalLeagues: meta.totalLeagues,
      totalMatches: meta.totalMatches,
      days: <MatchesDayUiModel>[
        MatchesDayUiModel(
          dayId: data.date.isNotEmpty ? data.date : _apiDate(normalizedDate),
          dayLabelCode: _dayLabelCode(normalizedDate),
          displayDate: _displayDate(normalizedDate),
          leagues: leagues,
        ),
      ],
    );
  }

  MatchesSportScheduleUiModel _buildScheduleFromFixtures(
    List<FootballFixtureModel> fixtures,
    DateTime selectedDate,
  ) {
    final groups = <String, List<FootballFixtureModel>>{};

    for (final fixture in fixtures) {
      final league = fixture.league;
      final groupKey =
          '${league.id ?? 0}-${league.season ?? 0}-${league.round}';
      groups.putIfAbsent(groupKey, () => <FootballFixtureModel>[]).add(fixture);
    }

    final leagues =
        groups.values
            .map((items) {
              final fixtureItems =
                  items
                      .map(MatchesFixtureUiModel.fromFootballFixture)
                      .toList(growable: false)
                    ..sort(
                      (left, right) =>
                          left.kickoffOrder.compareTo(right.kickoffOrder),
                    );

              return MatchesLeagueUiModel.fromFootballLeague(
                league: items.first.league,
                fixtures: fixtureItems,
              );
            })
            .toList(growable: false)
          ..sort((left, right) => left.leagueName.compareTo(right.leagueName));

    final normalizedDate = _normalizedDate(selectedDate);

    return MatchesSportScheduleUiModel(
      sportCode: MatchesSportCodes.football,
      days: <MatchesDayUiModel>[
        MatchesDayUiModel(
          dayId: _apiDate(normalizedDate),
          dayLabelCode: _dayLabelCode(normalizedDate),
          displayDate: _displayDate(normalizedDate),
          leagues: leagues,
        ),
      ],
    );
  }

  DateTime _normalizedDate(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  String _apiDate(DateTime date) {
    final normalized = _normalizedDate(date);
    final month = normalized.month.toString().padLeft(2, '0');
    final day = normalized.day.toString().padLeft(2, '0');
    return '${normalized.year}-$month-$day';
  }

  String _dayLabelCode(DateTime date) {
    final today = _normalizedDate(DateTime.now());
    final difference = date.difference(today).inDays;

    if (difference == 0) return MatchesDayLabelCodes.today;
    if (difference == 1) return MatchesDayLabelCodes.tomorrow;
    if (difference < 0) return MatchesDayLabelCodes.old;
    return MatchesDayLabelCodes.upcoming;
  }

  String _displayDate(DateTime date) {
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

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
