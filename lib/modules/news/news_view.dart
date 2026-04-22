import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/themes/app_text_styles.dart';
import '../shared/following_ui.dart';
import 'news_controller.dart';
import 'news_details_view.dart';
import 'news_model.dart';

class NewsView extends GetView<NewsController> {
  const NewsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.scaffoldBackgroundColor,
            theme.colorScheme.surface.withAlpha(
              theme.brightness == Brightness.dark ? 34 : 16,
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: Obx(() {
          final state = controller.state.value;
          final hero = state.heroArticle;
          if (hero == null) {
            return const SizedBox.shrink();
          }

          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
            children: [
              _HeroArticleCard(
                article: hero,
                onTap: () => _openDetails(context, hero),
              ),
              SizedBox(height: 18.h),
              for (var index = 0; index < state.secondaryArticles.length; index++) ...[
                _NewsListTile(
                  article: state.secondaryArticles[index],
                  onTap: () => _openDetails(context, state.secondaryArticles[index]),
                ),
                if (index != state.secondaryArticles.length - 1)
                  SizedBox(height: 18.h),
              ],
            ],
          );
        }),
      ),
    );
  }

  void _openDetails(BuildContext context, NewsArticleUiModel article) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => NewsDetailsView(article: article)),
    );
  }
}

class _HeroArticleCard extends StatelessWidget {
  final NewsArticleUiModel article;
  final VoidCallback onTap;

  const _HeroArticleCard({required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(0),
        child: Container(
          height: 448.h,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white.withAlpha(12), width: 1.w)),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF2D0C0C), Color(0xFF080D0C), Color(0xFF080D0C)],
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 180.w,
                  height: 260.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.r),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF26353F), Color(0xFF111417)],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'IMAGE',
                    style: TextStyle(
                      color: Colors.white.withAlpha(70),
                      fontSize: AppTextStyles.sizeBody.sp,
                      fontWeight: FontWeight.w700,
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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      children: [
                        Text(
                          article.source.toUpperCase(),
                          style: TextStyle(
                            color: const Color(0xFF54E1BB),
                            fontSize: AppTextStyles.sizeBody.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Container(
                          width: 4.r,
                          height: 4.r,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white54,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          article.relativeTime,
                          style: TextStyle(
                            color: Colors.white.withAlpha(170),
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
    );
  }
}

class _NewsListTile extends StatelessWidget {
  final NewsArticleUiModel article;
  final VoidCallback onTap;

  const _NewsListTile({required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
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
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.45,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Text(
                        article.source.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white.withAlpha(160),
                          fontSize: AppTextStyles.sizeBody.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        article.relativeTime.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white.withAlpha(160),
                          fontSize: AppTextStyles.sizeBody.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Container(
              width: 84.w,
              height: 80.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1B2A35), Color(0xFF0D1012)],
                ),
              ),
              alignment: Alignment.center,
              child: SeedCircleAvatar(seed: article.sourceSeed, size: 34, fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }
}
