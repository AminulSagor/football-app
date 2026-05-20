import '../../core/services/api_client.dart';
import '../matches/model/matches_models.dart';
import '../leagues/model/leagues_models.dart';
import 'team_profile_model.dart';

class TeamProfileService {
  final ApiClient _apiClient;

  TeamProfileService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<FootballTeamInfoItemModel?> fetchTeamInfo(String teamId) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/teams',
      queryParameters: <String, dynamic>{'id': teamId},
    );

    final responseData = response.data;
    if (responseData == null) {
      throw Exception('empty_response');
    }

    final parsed = FootballTeamInfoApiResponseModel.fromJson(responseData);
    if (!parsed.success) {
      throw Exception(
        parsed.message.isEmpty ? 'team_info_fetch_failed' : parsed.message,
      );
    }

    if (parsed.data.response.isEmpty) {
      return null;
    }

    return parsed.data.response.first;
  }


  Future<FootballTeamPlayersDataModel> fetchTeamPlayers({
    required String teamId,
    required int season,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/players',
      queryParameters: <String, dynamic>{
        'team': teamId,
        'season': season,
      },
    );

    final responseData = response.data;
    if (responseData == null) {
      throw Exception('empty_response');
    }

    final parsed = FootballTeamPlayersApiResponseModel.fromJson(responseData);
    if (!parsed.success) {
      throw Exception(
        parsed.message.isEmpty ? 'team_players_fetch_failed' : parsed.message,
      );
    }

    return parsed.data;
  }

  Future<FootballLeaguesDataModel> fetchTeamLeagues({
    required String teamId,
    required int season,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/leagues',
      queryParameters: <String, dynamic>{
        'team': teamId,
        'season': season,
      },
    );

    final responseData = response.data;
    if (responseData == null) {
      throw Exception('empty_response');
    }

    final parsed = FootballLeaguesApiResponseModel.fromJson(responseData);
    if (!parsed.success) {
      throw Exception(
        parsed.message.isEmpty ? 'team_leagues_fetch_failed' : parsed.message,
      );
    }

    return parsed.data;
  }

  Future<FootballStandingsDataModel> fetchStandings({
    required int leagueId,
    required int season,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/standings',
      queryParameters: <String, dynamic>{
        'league': leagueId,
        'season': season,
      },
    );

    final responseData = response.data;
    if (responseData == null) {
      throw Exception('empty_response');
    }

    final parsed = FootballStandingsApiResponseModel.fromJson(responseData);
    if (!parsed.success) {
      throw Exception(
        parsed.message.isEmpty ? 'team_standings_fetch_failed' : parsed.message,
      );
    }

    return parsed.data;
  }

  Future<FootballTeamCoachesDataModel> fetchTeamCoaches(String teamId) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/coaches',
      queryParameters: <String, dynamic>{'team': teamId},
    );

    final responseData = response.data;
    if (responseData == null) {
      throw Exception('empty_response');
    }

    final parsed = FootballTeamCoachesApiResponseModel.fromJson(responseData);
    if (!parsed.success) {
      throw Exception(
        parsed.message.isEmpty ? 'team_coaches_fetch_failed' : parsed.message,
      );
    }

    return parsed.data;
  }

  Future<FootballFixturesDataModel> fetchUpcomingFixtures({
    required String teamId,
    required int next,
  }) {
    return _fetchFixtures(
      teamId: teamId,
      queryParameters: <String, dynamic>{'next': next},
    );
  }

  Future<FootballFixturesDataModel> fetchPreviousFixtures({
    required String teamId,
    required int last,
  }) {
    return _fetchFixtures(
      teamId: teamId,
      queryParameters: <String, dynamic>{'last': last},
    );
  }

  Future<FootballFixturesDataModel> _fetchFixtures({
    required String teamId,
    required Map<String, dynamic> queryParameters,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/fixtures',
      queryParameters: <String, dynamic>{
        ...queryParameters,
        'team': teamId,
      },
    );

    final responseData = response.data;
    if (responseData == null) {
      throw Exception('empty_response');
    }

    final parsed = FootballFixturesApiResponseModel.fromJson(responseData);
    if (!parsed.success) {
      throw Exception(
        parsed.message.isEmpty ? 'team_fixtures_fetch_failed' : parsed.message,
      );
    }

    return parsed.data;
  }
}
