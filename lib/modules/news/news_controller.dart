import 'package:get/get.dart';

import '../../core/services/api_client.dart';
import '../../core/services/api_error_handler.dart';
import 'model/news_model.dart';
import 'news_service.dart';

class NewsController extends GetxController {
  final NewsService _newsService;

  NewsController({required NewsService newsService})
    : _newsService = newsService;

  final Rx<NewsViewModel> state = const NewsViewModel().obs;

  final Rx<NewsDetailsViewModel> detailsState =
      const NewsDetailsViewModel().obs;

  String? _activeSimilarNewsUuid;

  @override
  void onInit() {
    super.onInit();
    fetchFirstPage();
  }

  Future<void> fetchFirstPage() async {
    await _fetchNews(page: 1, replace: true);
  }

  Future<void> refreshNews() async {
    await _fetchNews(
      page: 1,
      replace: true,
      keepCurrentArticlesWhileLoading: true,
    );
  }

  Future<void> loadMoreNews() async {
    final current = state.value;

    if (current.isLoading || current.isLoadingMore || !current.hasMore) {
      return;
    }

    await _fetchNews(page: current.page + 1, replace: false);
  }

  Future<void> openArticle(NewsArticleUiModel article) async {
    final uuid = article.uuid.trim();

    detailsState.value = NewsDetailsViewModel(
      article: article,
      isLoadingSimilar: uuid.isNotEmpty,
    );

    if (uuid.isEmpty) {
      return;
    }

    _activeSimilarNewsUuid = uuid;

    final response = await ApiErrorHandler.handle<SimilarNewsResultUiModel>(
      () => _newsService.fetchSimilarNews(uuid: uuid),
      fallbackErrorCode: 'similar_news_fetch_failed',
      userMessage: 'Unable to load similar news right now.',
    );

    if (isClosed || _activeSimilarNewsUuid != uuid) {
      return;
    }

    if (!response.success || response.data == null) {
      detailsState.value = detailsState.value.copyWith(
        isLoadingSimilar: false,
        errorMessage: 'Similar news is unavailable right now.',
      );
      return;
    }

    detailsState.value = NewsDetailsViewModel(
      article: response.data!.article,
      similarArticles: response.data!.similarArticles,
      isLoadingSimilar: false,
    );
  }

  Future<void> _fetchNews({
    required int page,
    required bool replace,
    bool keepCurrentArticlesWhileLoading = false,
  }) async {
    final current = state.value;

    if (current.isLoading || current.isLoadingMore) {
      return;
    }

    state.value = current.copyWith(
      isLoading: replace && !keepCurrentArticlesWhileLoading,
      isLoadingMore: !replace,
      errorMessage: null,
    );

    final response = await ApiErrorHandler.handle<NewsListResultUiModel>(
      () => _newsService.fetchSportsNews(page: page, limit: current.limit),
      fallbackErrorCode: 'sports_news_fetch_failed',
      userMessage: 'Unable to load sports news right now.',
    );

    if (isClosed) {
      return;
    }

    if (!response.success || response.data == null) {
      state.value = state.value.copyWith(
        isLoading: false,
        isLoadingMore: false,
        hasLoadedOnce: true,
        errorMessage: state.value.articles.isEmpty
            ? 'Could not load sports news. Pull down or tap retry.'
            : null,
      );
      return;
    }

    final result = response.data!;

    final articles = replace
        ? result.articles
        : <NewsArticleUiModel>[...state.value.articles, ...result.articles];

    state.value = state.value.copyWith(
      articles: articles,
      isLoading: false,
      isLoadingMore: false,
      errorMessage: null,
      page: result.pagination.page,
      limit: result.pagination.limit,
      total: result.pagination.total,
      totalPages: result.pagination.totalPages,
      hasLoadedOnce: true,
    );
  }
}

class NewsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<NewsService>()) {
      Get.lazyPut<NewsService>(
        () => NewsService(apiClient: Get.find<ApiClient>()),
        fenix: true,
      );
    }

    if (!Get.isRegistered<NewsController>()) {
      Get.lazyPut<NewsController>(
        () => NewsController(newsService: Get.find<NewsService>()),
        fenix: true,
      );
    }
  }
}
