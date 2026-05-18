import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/themes/app_text_styles.dart';
import 'model/news_model.dart';
import 'news_controller.dart';
import 'news_details_view.dart';

bool _isIcoImageUrl(String url) {
  final lower = url.trim().toLowerCase();
  return RegExp(r'\.ico(\?|#|$)').hasMatch(lower);
}

class NewsView extends GetView<NewsController> {
  const NewsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.scaffoldBackgroundColor,
            isDark
                ? theme.colorScheme.surface.withAlpha(34)
                : theme.colorScheme.surface.withAlpha(16),
          ],
        ),
      ),
      child: SafeArea(
        child: Obx(() {
          final newsState = controller.state.value;
          final hero = newsState.heroArticle;

          if (newsState.isInitialLoading) {
            return const _NewsLoadingView();
          }

          if (hero == null) {
            return _NewsEmptyView(
              message: newsState.errorMessage ?? 'No sports news found.',
              onRetry: controller.fetchFirstPage,
            );
          }

          return RefreshIndicator(
            onRefresh: controller.refreshNews,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
              children: [
                _HeroArticleCard(
                  article: hero,
                  onTap: () => _openDetails(context, hero),
                ),
                SizedBox(height: 45.h),
                for (
                  var index = 0;
                  index < newsState.secondaryArticles.length;
                  index++
                ) ...[
                  _NewsListTile(
                    article: newsState.secondaryArticles[index],
                    onTap: () => _openDetails(
                      context,
                      newsState.secondaryArticles[index],
                    ),
                  ),
                  if (index != newsState.secondaryArticles.length - 1)
                    SizedBox(height: 10.h),
                  Divider(
                    color: theme.dividerColor.withAlpha(isDark ? 150 : 100),
                  ),
                  SizedBox(height: 10.h),
                ],
                SizedBox(height: 18.h),
                _LoadMoreButton(
                  hasMore: newsState.hasMore,
                  isLoading: newsState.isLoadingMore,
                  onTap: controller.loadMoreNews,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  void _openDetails(BuildContext context, NewsArticleUiModel article) {
    controller.openArticle(article);

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => NewsDetailsView(article: article),
      ),
    );
  }
}

class _HeroArticleCard extends StatelessWidget {
  final NewsArticleUiModel article;
  final VoidCallback onTap;

  const _HeroArticleCard({required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isIco = _isIcoImageUrl(article.imageUrl);

    if (isIco) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 10.h, 0, 18.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.dividerColor.withAlpha(isDark ? 120 : 80),
                  width: 1.w,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: AppTextStyles.sizeTitle.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 14.h),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        article.source.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontSize: AppTextStyles.sizeBody.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Container(
                      width: 4.r,
                      height: 4.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.onSurface.withAlpha(160),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      article.relativeTime,
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
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          height: 448.h,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: theme.dividerColor.withAlpha(isDark ? 120 : 80),
                width: 1.w,
              ),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: Stack(
              children: [
                Positioned.fill(
                  child: _NetworkArticleImage(
                    article: article,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withAlpha(40),
                          Colors.black.withAlpha(220),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 24.w,
                  right: 24.w,
                  bottom: 26.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppTextStyles.sizeTitle.sp,
                          fontWeight: FontWeight.w800,
                          height: 1.25,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              article.source.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: theme.colorScheme.secondary,
                                fontSize: AppTextStyles.sizeBody.sp,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Container(
                            width: 4.r,
                            height: 4.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withAlpha(160),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            article.relativeTime,
                            style: TextStyle(
                              color: Colors.white.withAlpha(210),
                              fontSize: AppTextStyles.sizeBody.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NewsListTile extends StatelessWidget {
  final NewsArticleUiModel article;
  final VoidCallback onTap;

  const _NewsListTile({required this.article, required this.onTap});

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
                        child: Text(
                          article.source.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: theme.colorScheme.secondary,
                            fontSize: AppTextStyles.sizeBody.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        article.relativeTime.toUpperCase(),
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withAlpha(160),
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
  final BoxFit fit;

  const _NetworkArticleImage({required this.article, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    if (!article.hasUsableNetworkImage) {
      return _ImageFallback(seed: article.sourceSeed);
    }

    return Image.network(
      article.imageUrl,
      fit: fit,
      errorBuilder: (_, __, ___) => _ImageFallback(seed: article.sourceSeed),
      loadingBuilder: (context, child, progress) {
        if (progress == null) {
          return child;
        }

        return _ImageFallback(seed: article.sourceSeed, isLoading: true);
      },
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.surface.withAlpha(230),
            theme.scaffoldBackgroundColor,
          ],
        ),
      ),
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

class _LoadMoreButton extends StatelessWidget {
  final bool hasMore;
  final bool isLoading;
  final VoidCallback onTap;

  const _LoadMoreButton({
    required this.hasMore,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!hasMore) {
      return Padding(
        padding: EdgeInsets.only(top: 6.h, bottom: 10.h),
        child: Text(
          'You are all caught up.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: theme.colorScheme.onSurface.withAlpha(150),
            fontSize: AppTextStyles.sizeBodySmall.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return TextButton(
      onPressed: isLoading ? null : onTap,
      child: isLoading
          ? SizedBox(
              width: 18.r,
              height: 18.r,
              child: CircularProgressIndicator(strokeWidth: 2.w),
            )
          : Text(
              'Load more news',
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: AppTextStyles.sizeBody.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
    );
  }
}

class _NewsEmptyView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _NewsEmptyView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(24.w, 120.h, 24.w, 24.h),
      children: [
        Icon(
          Icons.article_outlined,
          size: 46.r,
          color: theme.colorScheme.secondary,
        ),
        SizedBox(height: 16.h),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: AppTextStyles.sizeHeading.sp,
            fontWeight: FontWeight.w700,
            height: 1.4,
          ),
        ),
        SizedBox(height: 18.h),
        TextButton(onPressed: onRetry, child: const Text('Retry')),
      ],
    );
  }
}

class _NewsLoadingView extends StatelessWidget {
  const _NewsLoadingView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onSurface.withAlpha(18);

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
      children: [
        Container(height: 448.h, color: color),
        SizedBox(height: 18.h),
        for (var index = 0; index < 3; index++) ...[
          Row(
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
          SizedBox(height: 18.h),
        ],
      ],
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
