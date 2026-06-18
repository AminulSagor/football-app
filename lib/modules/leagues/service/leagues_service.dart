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

    final results = await Future.wait<dynamic>([
      fetchCountries(),
      fetchTopLeagues(page: 1, limit: 20),
    ]);

    final countriesFeed = LeaguesFeedUiModel.fromFootballCountriesData(
      results[0] as FootballCountriesDataModel,
    );

    final topLeaguesData = results[1] as FootballLeaguesDataModel;
    final topLeagues = topLeaguesData.response
        .map(LeaguesTopLeagueUiModel.fromFootballLeague)
        .toList(growable: false);

    return LeaguesFeedUiModel(
      sportCode: LeaguesSportCodes.football,
      topLeagues: topLeagues,
      countries: countriesFeed.countries,
    );
  }

  Future<FootballLeaguesDataModel> fetchTopLeagues({
    int page = 1,
    int limit = 100,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/leagues/top',
      queryParameters: <String, dynamic>{'page': page, 'limit': limit},
    );

    final responseData = response.data;
    if (responseData == null) {
      throw Exception('empty_response');
    }

    final parsed = FootballLeaguesApiResponseModel.fromJson(responseData);
    if (!parsed.success) {
      throw Exception(
        parsed.message.isEmpty ? 'top_leagues_fetch_failed' : parsed.message,
      );
    }

    return parsed.data;
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
        parsed.message.isEmpty
            ? 'country_leagues_fetch_failed'
            : parsed.message,
      );
    }

    return parsed.data;
  }
}
