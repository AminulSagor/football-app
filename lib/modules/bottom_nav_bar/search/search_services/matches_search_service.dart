import 'package:dio/dio.dart' as dio;

import '../../../../core/services/api_client.dart';
import '../search_models/matches_search_models.dart';

class MatchesSearchService {
  final ApiClient _apiClient;

  MatchesSearchService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<MatchesSearchResultUiModel>> fetchSearchResults(
    MatchesSearchPayloadModel payload,
  ) async {
    final payloadJson = payload.toJson();
    final query = _stringValue(payloadJson['search']);
    if (query.isEmpty) {
      return const <MatchesSearchResultUiModel>[];
    }

    final filterCode = _stringValue(payloadJson['filter_code']);
    final season = _stringValue(payloadJson['season']);
    final page = _intValue(payloadJson['page'], fallback: 1);
    final limit = _intValue(payloadJson['limit'], fallback: 10);

    switch (filterCode) {
      case MatchesSearchFilterCodes.teams:
        return _fetchTeams(query);
      case MatchesSearchFilterCodes.leagues:
        return _fetchLeagues(query);
      case MatchesSearchFilterCodes.players:
        return _fetchPlayers(query, page, limit);
      case MatchesSearchFilterCodes.all:
      default:
        return _fetchCombinedSearch(query, _resolveSeason(season));
    }
  }

  Future<List<MatchesSearchResultUiModel>> _fetchTeams(String query) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/teams',
      queryParameters: <String, dynamic>{'search': query},
      options: dio.Options(
        headers: <String, dynamic>{'Content-Type': 'application/json'},
      ),
    );

    final responseData = response.data;
    _ensureSuccess(responseData, fallbackErrorCode: 'teams_search_failed');

    final dataJson = _readData(responseData);
    final items = _readResponseItems(dataJson['response']);

    return _mapTeams(items);
  }

  Future<List<MatchesSearchResultUiModel>> _fetchLeagues(String query) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/leagues',
      queryParameters: <String, dynamic>{'search': query},
      options: dio.Options(
        headers: <String, dynamic>{'Content-Type': 'application/json'},
      ),
    );

    final responseData = response.data;
    _ensureSuccess(responseData, fallbackErrorCode: 'leagues_search_failed');

    final dataJson = _readData(responseData);
    final items = _readResponseItems(dataJson['response']);

    return _mapLeagues(items);
  }

  Future<List<MatchesSearchResultUiModel>> _fetchPlayers(
    String query,
    int page,
    int limit,
  ) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/players/profiles',
      queryParameters: <String, dynamic>{
        'search': query,
        'limit': limit,
        'page': page,
      },
      options: dio.Options(
        headers: <String, dynamic>{'Content-Type': 'application/json'},
      ),
    );

    final responseData = response.data;
    _ensureSuccess(responseData, fallbackErrorCode: 'players_search_failed');

    final dataJson = _readData(responseData);
    final items = _readResponseItems(dataJson['response']);

    return _mapPlayers(items);
  }

  Future<List<MatchesSearchResultUiModel>> _fetchCombinedSearch(
    String query,
    String season,
  ) async {
    final queryParameters = <String, dynamic>{'q': query, 'season': season};

    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/search',
      queryParameters: queryParameters,
      options: dio.Options(
        headers: <String, dynamic>{'Content-Type': 'application/json'},
      ),
    );

    final responseData = response.data;
    _ensureSuccess(responseData, fallbackErrorCode: 'search_fetch_failed');

    final dataJson = _readData(responseData);
    final teams = _readSectionResponse(dataJson, 'teams');
    final leagues = _readSectionResponse(dataJson, 'leagues');
    final players = _readSectionResponse(dataJson, 'players');

    return <MatchesSearchResultUiModel>[
      ..._mapTeams(teams),
      ..._mapLeagues(leagues),
      ..._mapPlayers(players),
    ];
  }

  List<MatchesSearchResultUiModel> _mapTeams(List<Map<String, dynamic>> items) {
    return items
        .map(_mapTeamItem)
        .whereType<MatchesSearchResultUiModel>()
        .where((item) => item.title.trim().isNotEmpty)
        .toList(growable: false);
  }

  MatchesSearchResultUiModel? _mapTeamItem(Map<String, dynamic> item) {
    final teamJson = item['team'];
    if (teamJson is! Map) {
      return null;
    }

    final team = Map<String, dynamic>.from(teamJson);
    final name = _stringValue(team['name']);
    final idValue = _stringValue(team['id']);
    final country = _stringValue(team['country']);
    final code = _stringValue(team['code']);
    final logo = _firstNonEmptyString(<dynamic>[team['logo'], item['logo']]);

    final resolvedId = idValue.isNotEmpty ? idValue : name;
    if (resolvedId.isEmpty) {
      return null;
    }

    return MatchesSearchResultUiModel.fromJson(<String, dynamic>{
      'id': resolvedId,
      'title': name,
      'subtitle': country,
      'entity_type_code': MatchesSearchEntityTypeCodes.team,
      'avatar_seed': _seedFromCodeOrName(code, name),
      'avatar_image_url': logo,
    });
  }

  List<MatchesSearchResultUiModel> _mapLeagues(
    List<Map<String, dynamic>> items,
  ) {
    return items
        .map(_mapLeagueItem)
        .whereType<MatchesSearchResultUiModel>()
        .where((item) => item.title.trim().isNotEmpty)
        .toList(growable: false);
  }

  MatchesSearchResultUiModel? _mapLeagueItem(Map<String, dynamic> item) {
    final leagueJson = item['league'];
    if (leagueJson is! Map) {
      return null;
    }

    final league = Map<String, dynamic>.from(leagueJson);
    final countryJson = item['country'];
    final country = countryJson is Map
        ? Map<String, dynamic>.from(countryJson)
        : <String, dynamic>{};

    final name = _stringValue(league['name']);
    final idValue = _stringValue(league['id']);
    final countryName = _stringValue(country['name']);
    final type = _stringValue(league['type']);
    final logo = _firstNonEmptyString(<dynamic>[league['logo'], item['logo']]);

    final resolvedId = idValue.isNotEmpty ? idValue : name;
    if (resolvedId.isEmpty) {
      return null;
    }

    final subtitle = countryName.isNotEmpty ? countryName : type;

    return MatchesSearchResultUiModel.fromJson(<String, dynamic>{
      'id': resolvedId,
      'title': name,
      'subtitle': subtitle,
      'entity_type_code': MatchesSearchEntityTypeCodes.league,
      'avatar_seed': _seedFromName(name),
      'avatar_image_url': logo,
    });
  }

  List<MatchesSearchResultUiModel> _mapPlayers(
    List<Map<String, dynamic>> items,
  ) {
    return items
        .map((item) {
          final playerJson = item['player'];
          if (playerJson is! Map) {
            return null;
          }

          final player = Map<String, dynamic>.from(playerJson);
          const String nameKey = 'name';
          // Postman does not contain the proper variable name
          final name = _stringValue(player[nameKey]);
          if (name.isEmpty) {
            return null;
          }

          final idValue = _stringValue(player['id']);
          final nationality = _stringValue(player['nationality']);
          final photo = _firstNonEmptyString(<dynamic>[player['photo'], item['photo']]);
          final resolvedId = idValue.isNotEmpty ? idValue : name;

          return MatchesSearchResultUiModel.fromJson(<String, dynamic>{
            'id': resolvedId,
            'title': name,
            'subtitle': nationality,
            'entity_type_code': MatchesSearchEntityTypeCodes.player,
            'avatar_seed': _seedFromName(name),
            'avatar_image_url': photo,
          });
        })
        .whereType<MatchesSearchResultUiModel>()
        .toList(growable: false);
  }

  List<Map<String, dynamic>> _readResponseItems(dynamic value) {
    if (value is! List) {
      return const <Map<String, dynamic>>[];
    }

    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList(growable: false);
  }

  List<Map<String, dynamic>> _readSectionResponse(
    Map<String, dynamic> dataJson,
    String key,
  ) {
    final section = dataJson[key];
    if (section is! Map) {
      return const <Map<String, dynamic>>[];
    }

    final response = Map<String, dynamic>.from(section)['response'];
    return _readResponseItems(response);
  }

  Map<String, dynamic> _readData(Map<String, dynamic>? responseData) {
    if (responseData == null) {
      throw Exception('empty_response');
    }

    final dataJson = responseData['data'];
    if (dataJson is! Map) {
      throw Exception('missing_data');
    }

    return Map<String, dynamic>.from(dataJson);
  }

  void _ensureSuccess(
    Map<String, dynamic>? responseData, {
    required String fallbackErrorCode,
  }) {
    if (responseData == null) {
      throw Exception('empty_response');
    }

    final success = responseData['success'];
    if (success is bool && !success) {
      final message = _extractMessage(responseData['message']);
      if (message != null) {
        throw Exception(message);
      }

      throw Exception(fallbackErrorCode);
    }
  }

  String? _extractMessage(dynamic rawMessage) {
    if (rawMessage is String && rawMessage.trim().isNotEmpty) {
      return rawMessage.trim();
    }

    if (rawMessage is List && rawMessage.isNotEmpty) {
      final firstMessage = rawMessage.first;
      if (firstMessage is String && firstMessage.trim().isNotEmpty) {
        return firstMessage.trim();
      }
    }

    return null;
  }

  String _firstNonEmptyString(List<dynamic> values) {
    for (final value in values) {
      final stringValue = _stringValue(value);
      if (stringValue.isNotEmpty) {
        return stringValue;
      }
    }

    return '';
  }

  String _stringValue(dynamic value) {
    if (value == null) {
      return '';
    }

    return value.toString().trim();
  }

  int _intValue(dynamic value, {int fallback = 0}) {
    if (value == null) {
      return fallback;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value.toString().trim()) ?? fallback;
  }

  String _seedFromCodeOrName(String code, String name) {
    final trimmedCode = code.trim();
    if (trimmedCode.isNotEmpty) {
      return trimmedCode;
    }

    return _seedFromName(name);
  }

  String _seedFromName(String name) {
    final tokens = name.split(RegExp(r'\s+')).where((token) => token != '');
    final tokenList = tokens.toList(growable: false);
    if (tokenList.isEmpty) {
      return '';
    }

    final first = tokenList.first;
    final last = tokenList.length > 1 ? tokenList.last : '';
    final firstChar = first.isNotEmpty ? first[0] : '';
    final lastChar = last.isNotEmpty ? last[0] : '';
    return '$firstChar$lastChar'.toUpperCase();
  }

  String _resolveSeason(String season) {
    final trimmed = season.trim();
    if (trimmed.isNotEmpty) {
      return trimmed;
    }

    return DateTime.now().year.toString();
  }
}
