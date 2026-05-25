class NewsArticleUiModel {
  final String id;
  final String uuid;
  final String image;
  final String imageUrl;
  final String title;
  final String description;
  final String snippet;
  final String url;
  final String source;
  final String sourceSeed;
  final DateTime? publishedAt;
  final List<String> categories;

  const NewsArticleUiModel({
    required this.id,
    required this.uuid,
    required this.image,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.snippet,
    required this.url,
    required this.source,
    required this.sourceSeed,
    required this.publishedAt,
    required this.categories,
  });

  factory NewsArticleUiModel.fromJson(Map<String, dynamic> json) {
    final source = _readString(json, 'source');

    return NewsArticleUiModel(
      id: _readString(json, 'id'),
      uuid: _readString(json, 'uuid'),
      image: 'assets/images/Background (1).png',
      imageUrl: _readString(json, 'imageUrl'),
      title: _readString(json, 'title'),
      description: _readString(json, 'description'),
      snippet: _readString(json, 'snippet'),
      url: _readString(json, 'url'),
      source: source,
      sourceSeed: _buildSourceSeed(source),
      publishedAt: DateTime.tryParse(
        _readString(json, 'publishedAt'),
      )?.toLocal(),
      categories: _readStringList(json['categories']),
    );
  }

  String get bodyLead {
    final cleanDescription = description.trim();
    final cleanSnippet = snippet.trim();

    if (cleanDescription.isNotEmpty) {
      return cleanDescription;
    }

    if (cleanSnippet.isNotEmpty) {
      return cleanSnippet;
    }

    return 'Open the source link to read the full story.';
  }

  List<String> get paragraphs => const <String>[];

  String get relativeTime {
    final date = publishedAt;

    if (date == null) {
      return 'Recently';
    }

    final difference = DateTime.now().difference(date);

    if (difference.isNegative || difference.inMinutes < 1) {
      return 'Just now';
    }

    if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    }

    if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    }

    return '${difference.inDays ~/ 7}w ago';
  }

  String get publishedLabel {
    final date = publishedAt;

    if (date == null) {
      return 'Published recently';
    }

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

    return 'Published ${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String get readTimeLabel {
    final words = '$title $bodyLead'
        .split(RegExp(r'\s+'))
        .where((word) => word.trim().isNotEmpty)
        .length;

    final minutes = (words / 220).ceil().clamp(1, 20);

    return '$minutes min read';
  }

  bool get hasUsableNetworkImage {
    final cleanUrl = imageUrl.trim().toLowerCase();

    return cleanUrl.startsWith('http') &&
        !cleanUrl.endsWith('.ico') &&
        !cleanUrl.contains('favicon');
  }

  static String _readString(Map<String, dynamic> json, String key) {
    return json[key]?.toString() ?? '';
  }

  static List<String> _readStringList(dynamic value) {
    if (value is! List) {
      return const <String>[];
    }

    return value
        .map((item) => item?.toString() ?? '')
        .where((item) => item.trim().isNotEmpty)
        .toList(growable: false);
  }

  static String _buildSourceSeed(String source) {
    final clean = source.trim();

    if (clean.isEmpty) {
      return 'NW';
    }

    final parts = clean
        .replaceAll(RegExp(r'[^A-Za-z0-9. ]'), ' ')
        .split(RegExp(r'[ .]+'))
        .where((part) => part.trim().isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return 'NW';
    }

    if (parts.length == 1) {
      final value = parts.first;
      return value
          .substring(0, value.length >= 3 ? 3 : value.length)
          .toUpperCase();
    }

    return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
  }
}

class NewsPaginationUiModel {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const NewsPaginationUiModel({
    this.page = 1,
    this.limit = 20,
    this.total = 0,
    this.totalPages = 1,
  });

  factory NewsPaginationUiModel.fromJson(Map<String, dynamic> json) {
    return NewsPaginationUiModel(
      page: _readInt(json['page'], fallback: 1),
      limit: _readInt(json['limit'], fallback: 20),
      total: _readInt(json['total']),
      totalPages: _readInt(json['totalPages'], fallback: 1),
    );
  }

  static int _readInt(dynamic value, {int fallback = 0}) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}

class NewsListResultUiModel {
  final List<NewsArticleUiModel> articles;
  final NewsPaginationUiModel pagination;

  const NewsListResultUiModel({
    required this.articles,
    required this.pagination,
  });
}

class SimilarNewsResultUiModel {
  final NewsArticleUiModel article;
  final List<NewsArticleUiModel> similarArticles;

  const SimilarNewsResultUiModel({
    required this.article,
    required this.similarArticles,
  });
}

class NewsViewModel {
  final List<NewsArticleUiModel> articles;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasLoadedOnce;

  const NewsViewModel({
    this.articles = const <NewsArticleUiModel>[],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.page = 0,
    this.limit = 20,
    this.total = 0,
    this.totalPages = 1,
    this.hasLoadedOnce = false,
  });

  NewsArticleUiModel? get heroArticle =>
      articles.isEmpty ? null : articles.first;

  List<NewsArticleUiModel> get secondaryArticles {
    if (articles.length <= 1) {
      return const <NewsArticleUiModel>[];
    }

    return articles.sublist(1);
  }

  bool get hasMore => page < totalPages;

  bool get isInitialLoading => isLoading && articles.isEmpty;

  bool get showEmptyState => hasLoadedOnce && articles.isEmpty && !isLoading;

  NewsViewModel copyWith({
    List<NewsArticleUiModel>? articles,
    bool? isLoading,
    bool? isLoadingMore,
    Object? errorMessage = _unset,
    int? page,
    int? limit,
    int? total,
    int? totalPages,
    bool? hasLoadedOnce,
  }) {
    return NewsViewModel(
      articles: articles ?? this.articles,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      total: total ?? this.total,
      totalPages: totalPages ?? this.totalPages,
      hasLoadedOnce: hasLoadedOnce ?? this.hasLoadedOnce,
    );
  }

  static const Object _unset = Object();
}

class NewsDetailsViewModel {
  final NewsArticleUiModel? article;
  final List<NewsArticleUiModel> similarArticles;
  final bool isLoadingSimilar;
  final String? errorMessage;

  const NewsDetailsViewModel({
    this.article,
    this.similarArticles = const <NewsArticleUiModel>[],
    this.isLoadingSimilar = false,
    this.errorMessage,
  });

  NewsDetailsViewModel copyWith({
    Object? article = _unset,
    List<NewsArticleUiModel>? similarArticles,
    bool? isLoadingSimilar,
    Object? errorMessage = _unset,
  }) {
    return NewsDetailsViewModel(
      article: identical(article, _unset)
          ? this.article
          : article as NewsArticleUiModel?,
      similarArticles: similarArticles ?? this.similarArticles,
      isLoadingSimilar: isLoadingSimilar ?? this.isLoadingSimilar,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  static const Object _unset = Object();
}
