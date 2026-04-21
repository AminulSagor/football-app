import 'matches_search_models.dart';

class MatchesSearchService {
  Future<List<MatchesSearchResultUiModel>> fetchSearchResults(
    MatchesSearchPayloadModel payload,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 240));

    final payloadJson = payload.toJson();
    final query = (payloadJson['query'] as String? ?? '').trim().toLowerCase();
    final filterCode =
        payloadJson['filter_code'] as String? ?? MatchesSearchFilterCodes.all;

    if (query.isEmpty) {
      return const <MatchesSearchResultUiModel>[];
    }

    final responseJson = _searchResponseJson();
    final itemsJson =
        (responseJson['items'] as List<dynamic>? ?? const <dynamic>[])
            .whereType<Map<String, dynamic>>();

    return itemsJson
        .where((item) => _matchesFilter(item, filterCode))
        .where((item) => _matchesQuery(item, query))
        .map(MatchesSearchResultUiModel.fromJson)
        .toList(growable: false);
  }

  bool _matchesFilter(Map<String, dynamic> item, String filterCode) {
    if (filterCode == MatchesSearchFilterCodes.all) {
      return true;
    }

    final entityTypeCode = item['entity_type_code'] as String? ?? '';
    switch (filterCode) {
      case MatchesSearchFilterCodes.teams:
        return entityTypeCode == MatchesSearchEntityTypeCodes.team;
      case MatchesSearchFilterCodes.leagues:
        return entityTypeCode == MatchesSearchEntityTypeCodes.league;
      case MatchesSearchFilterCodes.players:
        return entityTypeCode == MatchesSearchEntityTypeCodes.player;
      default:
        return true;
    }
  }

  bool _matchesQuery(Map<String, dynamic> item, String query) {
    final searchTokens =
        (item['search_tokens'] as List<dynamic>? ?? const <dynamic>[]).map(
          (token) => token.toString().toLowerCase(),
        );

    return searchTokens.any((token) => token.contains(query));
  }

  Map<String, dynamic> _searchResponseJson() {
    return <String, dynamic>{
      'items': <Map<String, dynamic>>[
        <String, dynamic>{
          'id': 'team-portugal',
          'title': 'Portugal',
          'subtitle': 'National Team',
          'entity_type_code': MatchesSearchEntityTypeCodes.team,
          'avatar_seed': 'PT',
          'avatar_hex': '#D92332',
          'search_tokens': <String>[
            'portugal',
            'national team',
            'team portugal',
          ],
        },
        <String, dynamic>{
          'id': 'team-fc-porto',
          'title': 'FC Porto',
          'subtitle': 'Liga Portugal',
          'entity_type_code': MatchesSearchEntityTypeCodes.team,
          'avatar_seed': 'FCP',
          'avatar_hex': '#265FA3',
          'search_tokens': <String>['fc porto', 'porto', 'liga portugal'],
        },
        <String, dynamic>{
          'id': 'league-liga-portugal',
          'title': 'Liga Portugal',
          'subtitle': 'Portugal',
          'entity_type_code': MatchesSearchEntityTypeCodes.league,
          'avatar_seed': 'LP',
          'avatar_hex': '#2D3842',
          'search_tokens': <String>[
            'liga portugal',
            'portugal league',
            'porto league',
          ],
        },
        <String, dynamic>{
          'id': 'player-ryan-porteous',
          'title': 'Ryan Porteous',
          'subtitle': 'Los Angeles FC',
          'entity_type_code': MatchesSearchEntityTypeCodes.player,
          'avatar_seed': 'RP',
          'avatar_hex': '#0E6C4E',
          'search_tokens': <String>['ryan porteous', 'porteous', 'port'],
        },
        <String, dynamic>{
          'id': 'player-portu',
          'title': 'Portu',
          'subtitle': 'Girona',
          'entity_type_code': MatchesSearchEntityTypeCodes.player,
          'avatar_seed': 'PO',
          'avatar_hex': '#A74040',
          'search_tokens': <String>['portu', 'girona', 'player portu'],
        },
        <String, dynamic>{
          'id': 'player-juan-carlos-portillo',
          'title': 'Juan Carlos Portillo',
          'subtitle': 'River Plate',
          'entity_type_code': MatchesSearchEntityTypeCodes.player,
          'avatar_seed': 'JP',
          'avatar_hex': '#D1D7DB',
          'search_tokens': <String>[
            'juan carlos portillo',
            'portillo',
            'river plate',
          ],
        },
        <String, dynamic>{
          'id': 'team-portimonense-sc',
          'title': 'Portimonense SC',
          'subtitle': 'Liga Portugal',
          'entity_type_code': MatchesSearchEntityTypeCodes.team,
          'avatar_seed': 'PSC',
          'avatar_hex': '#A88639',
          'search_tokens': <String>[
            'portimonense sc',
            'portimonense',
            'liga portugal',
          ],
        },
      ],
    };
  }
}
