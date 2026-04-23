class NewsArticleUiModel {
  final String id;
  final String image;
  final String title;
  final String source;
  final String sourceSeed;
  final String relativeTime;
  final String publishedLabel;
  final String readTimeLabel;
  final String bodyLead;
  final List<String> paragraphs;

  const NewsArticleUiModel({
    required this.id,
    required this.image,
    required this.title,
    required this.source,
    required this.sourceSeed,
    required this.relativeTime,
    required this.publishedLabel,
    required this.readTimeLabel,
    required this.bodyLead,
    required this.paragraphs,
  });
}

class NewsViewModel {
  final List<NewsArticleUiModel> articles;

  const NewsViewModel({this.articles = const <NewsArticleUiModel>[]});

  NewsArticleUiModel? get heroArticle => articles.isEmpty ? null : articles.first;
  List<NewsArticleUiModel> get secondaryArticles =>
      articles.length <= 1 ? const <NewsArticleUiModel>[] : articles.sublist(1);
}
