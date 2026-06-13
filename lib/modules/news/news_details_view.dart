import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../core/themes/app_colors.dart';

import '../../core/themes/app_text_styles.dart';
import '../../core/widgets/app_cached_network_image.dart';
import '../../core/widgets/facebook_banner_ad_widget.dart';
import 'model/news_model.dart';
import 'news_controller.dart';

bool _isIcoImageUrl(String url) {
  final lower = url.trim().toLowerCase();
  return RegExp(r'\.ico(\?|#|$)').hasMatch(lower);
}

class NewsDetailsView extends GetView<NewsController> {
  final NewsArticleUiModel article;

  const NewsDetailsView({super.key, required this.article});

  void _openSource(BuildContext context, NewsArticleUiModel currentArticle) {
    final url = currentArticle.url.trim();

    if (url.isEmpty) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _NewsSourceWebView(
          url: url,
          title: currentArticle.source.isEmpty
              ? 'News Source'
              : currentArticle.source,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.scaffoldBackgroundColor,
              theme.colorScheme.surface.withAlpha(isDark ? 220 : 240),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Obx(() {
            final detailsState = controller.detailsState.value;
            final currentArticle = detailsState.article ?? article;

            return ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18.r),
                      onTap: () => Navigator.of(context).maybePop(),
                      child: Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: theme.colorScheme.onSurface,
                          size: 24.r,
                        ),
                      ),
                    ),
                  ),
                ),
                _DetailsHeroHeader(article: currentArticle),
                SizedBox(height: 22.h),
                Row(
                  children: [
                    SizedBox(width: 14.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _openSource(context, currentArticle),
                        behavior: HitTestBehavior.opaque,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    currentArticle.source.isEmpty
                                        ? 'Unknown Source'
                                        : currentArticle.source.toUpperCase(),
                                    style: TextStyle(
                                      color: AppColors.switchTrackActive
                                          .withAlpha(180),
                                      fontSize: AppTextStyles.sizeBodyLarge.sp,
                                      fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Icon(
                                  Icons.open_in_new,
                                  size: 14.r,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '${currentArticle.publishedLabel} • ${currentArticle.readTimeLabel}',
                              style: TextStyle(
                                color: theme.colorScheme.onSurface.withAlpha(
                                  180,
                                ),
                                fontSize: AppTextStyles.sizeBodySmall.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 34.h),
                Text(
                  currentArticle.bodyLead,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: AppTextStyles.sizeHeading.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.45,
                  ),
                ),
                SizedBox(height: 24.h),
                const FacebookBannerAdWidget(),
                _SimilarNewsSection(
                  isLoading: detailsState.isLoadingSimilar,
                  errorMessage: detailsState.errorMessage,
                  articles: detailsState.similarArticles,
                  onArticleTap: (similarArticle) {
                    controller.openArticle(similarArticle);

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            NewsDetailsView(article: similarArticle),
                      ),
                    );
                  },
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _NewsSourceWebView extends StatefulWidget {
  final String url;
  final String title;

  const _NewsSourceWebView({required this.url, required this.title});

  @override
  State<_NewsSourceWebView> createState() => _NewsSourceWebViewState();
}

class _NewsSourceWebViewState extends State<_NewsSourceWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}

class _SimilarNewsSection extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final List<NewsArticleUiModel> articles;
  final ValueChanged<NewsArticleUiModel> onArticleTap;

  const _SimilarNewsSection({
    required this.isLoading,
    required this.errorMessage,
    required this.articles,
    required this.onArticleTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 20.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withAlpha(isDark ? 220 : 255),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: theme.colorScheme.onSurface.withAlpha(isDark ? 28 : 18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 60 : 28),
            blurRadius: 24.r,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.stacked_bar_chart_rounded,
                color: theme.colorScheme.secondary,
                size: 20.r,
              ),
              SizedBox(width: 10.w),
              Text(
                'Similar News',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: AppTextStyles.sizeHeading.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Container(
            width: 64.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary.withAlpha(180),
              borderRadius: BorderRadius.circular(999.r),
            ),
          ),
          SizedBox(height: 18.h),
          if (isLoading)
            const _SimilarNewsLoadingList()
          else if (articles.isEmpty)
            _SimilarNewsEmpty(message: errorMessage)
          else
            for (var index = 0; index < articles.length; index++) ...[
              _SimilarNewsTile(
                article: articles[index],
                onTap: () => onArticleTap(articles[index]),
              ),
              if (index != articles.length - 1) SizedBox(height: 18.h),
            ],
        ],
      ),
    );
  }
}

class _SimilarNewsTile extends StatelessWidget {
  final NewsArticleUiModel article;
  final VoidCallback onTap;

  const _SimilarNewsTile({required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIco = _isIcoImageUrl(article.imageUrl);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: AppTextStyles.sizeBodyLarge.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.45,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                article.source.toUpperCase(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.switchTrackActive,
                                  fontSize: AppTextStyles.sizeBody.sp,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Icon(
                              Icons.open_in_new,
                              size: 14.r,
                              color: theme.colorScheme.secondary,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        article.relativeTime.toUpperCase(),
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withAlpha(180),
                          fontSize: AppTextStyles.sizeBody.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (!isIco) ...[
              SizedBox(width: 16.w),
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: SizedBox(
                  width: 84.w,
                  height: 80.h,
                  child: _NetworkArticleImage(article: article),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NetworkArticleImage extends StatelessWidget {
  final NewsArticleUiModel article;

  const _NetworkArticleImage({required this.article});

  @override
  Widget build(BuildContext context) {
    if (!article.hasUsableNetworkImage) {
      return _ImageFallback(seed: article.sourceSeed);
    }

    return AppCachedNetworkImage(
      imageUrl: article.imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context) => _ImageFallback(seed: article.sourceSeed),
      placeholderBuilder: (context) =>
          _ImageFallback(seed: article.sourceSeed, isLoading: true),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  final String seed;
  final bool isLoading;

  const _ImageFallback({required this.seed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surface.withAlpha(170),
      alignment: Alignment.center,
      child: isLoading
          ? SizedBox(
              width: 18.r,
              height: 18.r,
              child: CircularProgressIndicator(
                strokeWidth: 2.w,
                color: theme.colorScheme.secondary,
              ),
            )
          : Text(
              seed,
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: AppTextStyles.sizeCaption.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
    );
  }
}

class _SimilarNewsEmpty extends StatelessWidget {
  final String? message;

  const _SimilarNewsEmpty({this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      message ?? 'No similar news found for this story.',
      style: TextStyle(
        color: theme.colorScheme.onSurface.withAlpha(180),
        fontSize: AppTextStyles.sizeBodyLarge.sp,
        fontWeight: FontWeight.w400,
        height: 1.7,
      ),
    );
  }
}

class _SimilarNewsLoadingList extends StatelessWidget {
  const _SimilarNewsLoadingList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onSurface.withAlpha(18);

    return Column(
      children: List.generate(3, (index) {
        return Padding(
          padding: EdgeInsets.only(bottom: index == 2 ? 0 : 18.h),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Skeleton(
                      width: double.infinity,
                      height: 18.h,
                      color: color,
                    ),
                    SizedBox(height: 8.h),
                    _Skeleton(width: 180.w, height: 18.h, color: color),
                    SizedBox(height: 12.h),
                    _Skeleton(width: 120.w, height: 13.h, color: color),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              _Skeleton(width: 84.w, height: 80.h, color: color),
            ],
          ),
        );
      }),
    );
  }
}

class _Skeleton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const _Skeleton({
    required this.width,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }
}

class _DetailsHeroHeader extends StatelessWidget {
  final NewsArticleUiModel article;

  const _DetailsHeroHeader({required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIco = _isIcoImageUrl(article.imageUrl);

    if (isIco) {
      return Text(
        article.title,
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: AppTextStyles.sizeTitle.sp,
          fontWeight: FontWeight.w800,
          height: 1.35,
        ),
      );
    }

    return SizedBox(
      height: 300.h,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _NetworkArticleImage(article: article),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withAlpha(20),
                    Colors.black.withAlpha(100),
                    Colors.black.withAlpha(225),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 18.w,
              right: 18.w,
              bottom: 22.h,
              child: Text(
                article.title,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppTextStyles.sizeTitle.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
