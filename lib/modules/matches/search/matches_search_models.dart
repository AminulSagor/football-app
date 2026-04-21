class MatchesSearchFilterCodes {
  static const String all = 'all';
  static const String teams = 'teams';
  static const String leagues = 'leagues';
  static const String players = 'players';
}

class MatchesSearchEntityTypeCodes {
  static const String team = 'team';
  static const String league = 'league';
  static const String player = 'player';
}

class MatchesSearchPayloadModel {
  final String query;
  final String filterCode;

  const MatchesSearchPayloadModel({
    required this.query,
    required this.filterCode,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'query': query, 'filter_code': filterCode};
  }
}

class MatchesSearchResultUiModel {
  final String id;
  final String title;
  final String subtitle;
  final String entityTypeCode;
  final String avatarSeed;
  final String avatarHex;

  const MatchesSearchResultUiModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.entityTypeCode,
    required this.avatarSeed,
    required this.avatarHex,
  });

  factory MatchesSearchResultUiModel.fromJson(Map<String, dynamic> json) {
    return MatchesSearchResultUiModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      entityTypeCode: json['entity_type_code'] as String? ?? '',
      avatarSeed: json['avatar_seed'] as String? ?? '',
      avatarHex: json['avatar_hex'] as String? ?? '#1C4037',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'entity_type_code': entityTypeCode,
      'avatar_seed': avatarSeed,
      'avatar_hex': avatarHex,
    };
  }
}

class MatchesSearchViewModel {
  static const Object _unset = Object();

  final bool isLoading;
  final String query;
  final String selectedFilterCode;
  final List<MatchesSearchResultUiModel> results;
  final String? errorCode;

  const MatchesSearchViewModel({
    this.isLoading = false,
    this.query = '',
    this.selectedFilterCode = MatchesSearchFilterCodes.all,
    this.results = const <MatchesSearchResultUiModel>[],
    this.errorCode,
  });

  bool get showEmptyState {
    return query.trim().isNotEmpty &&
        !isLoading &&
        errorCode == null &&
        results.isEmpty;
  }

  MatchesSearchViewModel copyWith({
    bool? isLoading,
    String? query,
    String? selectedFilterCode,
    Object? results = _unset,
    Object? errorCode = _unset,
  }) {
    return MatchesSearchViewModel(
      isLoading: isLoading ?? this.isLoading,
      query: query ?? this.query,
      selectedFilterCode: selectedFilterCode ?? this.selectedFilterCode,
      results: identical(results, _unset)
          ? this.results
          : results as List<MatchesSearchResultUiModel>,
      errorCode: identical(errorCode, _unset)
          ? this.errorCode
          : errorCode as String?,
    );
  }
}
