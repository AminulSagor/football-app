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
  final String season;
  final int page;
  final int limit;

  const MatchesSearchPayloadModel({
    required this.query,
    required this.filterCode,
    this.season = '',
    this.page = 1,
    this.limit = 10,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'search': query,
      'filter_code': filterCode,
      'season': season,
      'page': page,
      'limit': limit,
    };
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
  final bool isLoadingMore;
  final String query;
  final String selectedFilterCode;
  final List<MatchesSearchResultUiModel> results;
  final int visibleCount;
  final bool canLoadMore;
  final String? errorCode;

  const MatchesSearchViewModel({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.query = '',
    this.selectedFilterCode = MatchesSearchFilterCodes.all,
    this.results = const <MatchesSearchResultUiModel>[],
    this.visibleCount = 0,
    this.canLoadMore = false,
    this.errorCode,
  });

  bool get showEmptyState {
    return query.trim().isNotEmpty &&
        !isLoading &&
        errorCode == null &&
        results.isEmpty;
  }

  bool get isQueryTooShort {
    final trimmed = query.trim();
    return trimmed.isNotEmpty && trimmed.length < 3;
  }

  bool get hasMore {
    if (selectedFilterCode == MatchesSearchFilterCodes.players) {
      return canLoadMore;
    }

    return results.length > visibleCount;
  }

  List<MatchesSearchResultUiModel> get visibleResults {
    if (visibleCount <= 0 || results.isEmpty) {
      return const <MatchesSearchResultUiModel>[];
    }

    return results.take(visibleCount).toList(growable: false);
  }

  MatchesSearchViewModel copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    String? query,
    String? selectedFilterCode,
    Object? results = _unset,
    int? visibleCount,
    bool? canLoadMore,
    Object? errorCode = _unset,
  }) {
    return MatchesSearchViewModel(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      query: query ?? this.query,
      selectedFilterCode: selectedFilterCode ?? this.selectedFilterCode,
      results: identical(results, _unset)
          ? this.results
          : results as List<MatchesSearchResultUiModel>,
      visibleCount: visibleCount ?? this.visibleCount,
      canLoadMore: canLoadMore ?? this.canLoadMore,
      errorCode: identical(errorCode, _unset)
          ? this.errorCode
          : errorCode as String?,
    );
  }
}
