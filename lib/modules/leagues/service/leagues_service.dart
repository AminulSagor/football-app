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

    final data = await fetchCountries();
    return LeaguesFeedUiModel.fromFootballCountriesData(data);
  }

  Future<FootballCountriesDataModel> fetchCountries() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/countries',
    );

    final responseData = response.data;
    if (responseData == null) {
      throw Exception('empty_response');
    }

    final parsed = FootballCountriesApiResponseModel.fromJson(responseData);
    if (!parsed.success) {
      throw Exception(
        parsed.message.isEmpty ? 'countries_fetch_failed' : parsed.message,
      );
    }

    return parsed.data;
  }

  Future<FootballLeaguesByCountryDataModel> fetchLeaguesByCountry({
    required String country,
    required int season,
    int page = 1,
    int limit = 20,
  }) async {
    final safeCountry = country.trim();
    if (safeCountry.isEmpty) {
      throw Exception('missing_country');
    }

    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/leagues/by-country',
      queryParameters: <String, dynamic>{
        'country': safeCountry,
        'season': season,
        'page': page,
        'limit': limit,
      },
    );

    final responseData = response.data;
    if (responseData == null) {
      throw Exception('empty_response');
    }

    final parsed = FootballLeaguesByCountryApiResponseModel.fromJson(
      responseData,
    );
    if (!parsed.success) {
      throw Exception(
        parsed.message.isEmpty ? 'country_leagues_fetch_failed' : parsed.message,
      );
    }

    return parsed.data;
  }
}
