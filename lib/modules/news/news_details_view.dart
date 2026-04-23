import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/themes/app_text_styles.dart';
import '../shared/following_ui.dart';
import 'model/news_model.dart';

class NewsDetailsView extends StatelessWidget {
  final NewsArticleUiModel article;

  const NewsDetailsView({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF8CECF0), Color(0xFF315D57), Color(0xFF030908)],
          ),
        ),
        child: SafeArea(
          child: ListView(
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
                      child: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24.r),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 220.h),
              Text(
                article.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppTextStyles.sizeTitle.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.35,
                ),
              ),
              SizedBox(height: 22.h),
              Row(
                children: [
                  // SeedSquareBadge(seed: article.sourceSeed, color: Colors.white, size: 40),
                  Image.asset(article.image, width: 40.w, height: 40.h),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.source,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppTextStyles.sizeBodyLarge.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '${article.publishedLabel} • ${article.readTimeLabel}',
                          style: TextStyle(
                            color: Colors.white.withAlpha(180),
                            fontSize: AppTextStyles.sizeBodySmall.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 34.h),
              Text(
                article.bodyLead,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppTextStyles.sizeHeading.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.45,
                ),
              ),
              SizedBox(height: 28.h),
              for (var index = 0; index < article.paragraphs.length; index++) ...[
                if (index == 1)
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: Text(
                      'The Weight of History',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppTextStyles.sizeHeading.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                Text(
                  article.paragraphs[index],
                  style: TextStyle(
                    color: Colors.white.withAlpha(210),
                    fontSize: AppTextStyles.sizeBodyLarge.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.85,
                  ),
                ),
                SizedBox(height: 22.h),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
