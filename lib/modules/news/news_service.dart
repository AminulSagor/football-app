import 'package:dio/dio.dart' as dio;

import '../../core/services/api_client.dart';
import 'model/news_model.dart';

class NewsService {
  final ApiClient _apiClient;

  NewsService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<NewsListResultUiModel> fetchSportsNews({
    required int page,
    required int limit,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/news/sports',
      queryParameters: <String, dynamic>{'page': page, 'limit': limit},
      options: dio.Options(
        headers: <String, dynamic>{'Content-Type': 'application/json'},
      ),
    );

    final responseData = response.data;

    _ensureSuccess(responseData, fallbackErrorCode: 'sports_news_fetch_failed');

    final dataJson = _readData(responseData);
    final paginationJson = dataJson['pagination'];

    return NewsListResultUiModel(
      articles: _readArticles(dataJson['articles']),
      pagination: paginationJson is Map
          ? NewsPaginationUiModel.fromJson(
              Map<String, dynamic>.from(paginationJson),
            )
          : const NewsPaginationUiModel(),
    );
  }

  Future<SimilarNewsResultUiModel> fetchSimilarNews({
    required String uuid,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/news/$uuid/similar',
      options: dio.Options(
        headers: <String, dynamic>{'Content-Type': 'application/json'},
      ),
    );

    final responseData = response.data;

    _ensureSuccess(
      responseData,
      fallbackErrorCode: 'similar_news_fetch_failed',
    );

    final dataJson = _readData(responseData);
    final articleJson = dataJson['article'];

    if (articleJson is! Map) {
      throw Exception('missing_article');
    }

    return SimilarNewsResultUiModel(
      article: NewsArticleUiModel.fromJson(
        Map<String, dynamic>.from(articleJson),
      ),
      similarArticles: _readArticles(dataJson['similar']),
    );
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

  List<NewsArticleUiModel> _readArticles(dynamic value) {
    if (value is! List) {
      return const <NewsArticleUiModel>[];
    }

    return value
        .whereType<Map>()
        .map(
          (item) =>
              NewsArticleUiModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .where((article) => article.uuid.trim().isNotEmpty)
        .toList(growable: false);
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
}
