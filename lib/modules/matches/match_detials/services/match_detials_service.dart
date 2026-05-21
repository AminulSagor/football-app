import '../../../../core/services/api_client.dart';
import '../../model/matches_models.dart';
import '../models/match_details_model.dart';

class MatchDetialsService {
  final ApiClient _apiClient;

  MatchDetialsService({required ApiClient apiClient}) : _apiClient = apiClient;



  Future<MatchDetailsAboutDataModel> fetchMatchAbout({
    required String fixtureId,
  }) async {
    final safeFixtureId = fixtureId.trim();

    if (safeFixtureId.isEmpty) {
      throw Exception('missing_fixture_id');
    }

    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/matches/$safeFixtureId/about',
    );

    final responseData = response.data;
    if (responseData == null) {
      throw Exception('empty_response');
    }

    final parsed = MatchDetailsAboutApiResponseModel.fromJson(responseData);
    if (!parsed.success) {
      throw Exception(
        parsed.message.isEmpty ? 'match_about_fetch_failed' : parsed.message,
      );
    }

    return parsed.data;
  }

  Future<FootballFixtureModel> fetchFixtureById({
    required String fixtureId,
  }) async {
    final safeFixtureId = fixtureId.trim();

    if (safeFixtureId.isEmpty) {
      throw Exception('missing_fixture_id');
    }

    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/fixtures/$safeFixtureId',
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

    if (parsed.data.response.isEmpty) {
      throw Exception('fixture_not_found');
    }

    return parsed.data.response.first;
  }

  Future<FootballFixturesDataModel> fetchHeadToHead({
    required String homeTeamId,
    required String awayTeamId,
    int last = 5,
  }) async {
    final safeHomeTeamId = homeTeamId.trim();
    final safeAwayTeamId = awayTeamId.trim();

    if (safeHomeTeamId.isEmpty || safeAwayTeamId.isEmpty) {
      throw Exception('missing_team_ids');
    }

    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/fixtures/head-to-head',
      queryParameters: <String, dynamic>{
        'h2h': '$safeHomeTeamId-$safeAwayTeamId',
        'last': last,
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

  Future<FootballFixturesDataModel> fetchTeamFormFixtures({
    required String leagueId,
    required String teamId,
    int last = 3,
  }) async {
    final safeLeagueId = leagueId.trim();
    final safeTeamId = teamId.trim();

    if (safeLeagueId.isEmpty) {
      throw Exception('missing_league_id');
    }

    final queryParameters = <String, dynamic>{
      'league': safeLeagueId,
      'last': last,
      'status': 'ft',
    };

    if (safeTeamId.isNotEmpty) {
      queryParameters['team'] = safeTeamId;
    }

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

}
