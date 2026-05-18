import '../../../core/services/api_client.dart';
import '../model/leagues_models.dart';

class LeaguesService {
  final ApiClient _apiClient;

  LeaguesService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<LeaguesFeedUiModel> fetchLeagues(
    LeaguesFeedPayloadModel payload,
  ) async {
    final payloadJson = payload.toJson();
    final sportCode = payloadJson['sport_code'] as String? ?? '';

    if (sportCode != LeaguesSportCodes.football) {
      return const LeaguesFeedUiModel(
        sportCode: LeaguesSportCodes.football,
        topLeagues: <LeaguesTopLeagueUiModel>[],
        countries: <LeaguesCountryUiModel>[],
      );
    }

    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/leagues',
      queryParameters: const <String, dynamic>{'current': true},
    );

    final responseData = response.data;
    if (responseData == null) {
      throw Exception('empty_response');
    }

    final parsed = FootballLeaguesApiResponseModel.fromJson(responseData);
    if (!parsed.success) {
      throw Exception(
        parsed.message.isEmpty ? 'leagues_fetch_failed' : parsed.message,
      );
    }

    return LeaguesFeedUiModel.fromFootballLeaguesData(parsed.data);
  }
}
