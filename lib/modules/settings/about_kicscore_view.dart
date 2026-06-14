import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/themes/app_text_styles.dart';
import '../../core/widgets/app_bar_view.dart';

class AboutKicscoreView extends StatelessWidget {
  const AboutKicscoreView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.scaffoldBackgroundColor,
              theme.colorScheme.surface.withAlpha(
                theme.brightness == Brightness.dark ? 40 : 14,
              ),
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 28.h),
            children: [
              CustomAppBar(
                title: 'About Kicscore',
                showBackButton: true,
                padding: EdgeInsets.only(top: 2.h, bottom: 12.h),
                titleStyle: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontSize: (AppTextStyles.sizeTitle + 2).sp,
                  fontWeight: FontWeight.w700,
                ),
                titleWidget: Text(
                  'About Kicscore',
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontSize: (AppTextStyles.sizeTitle + 2).sp,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  color: theme.colorScheme.surface,
                  border: Border.all(color: theme.dividerColor, width: 1.w),
                ),
                padding: EdgeInsets.all(22.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48.r,
                          height: 48.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.primary.withAlpha(35),
                          ),
                          child: Icon(
                            Icons.sports_soccer_rounded,
                            color: theme.colorScheme.primary,
                            size: 26.r,
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'KICSCORE',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                  fontSize: AppTextStyles.sizeHeading.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Football scores, stats, and news',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface.withAlpha(170),
                                  fontSize: AppTextStyles.sizeBodySmall.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 22.h),
                    _AboutParagraph(
                      text:
                          'KICSCORE helps football fans follow live scores, fixtures, match details, league tables, team profiles, player profiles, coach details, and football news in one place.',
                    ),
                    SizedBox(height: 14.h),
                    _AboutParagraph(
                      text:
                          'You can follow your favorite leagues, teams, players, coaches, and matches to keep your football experience personalized across the app.',
                    ),
                    SizedBox(height: 14.h),
                    _AboutParagraph(
                      text:
                          'KICSCORE is ad-supported and may show banner or native ads from third-party advertising partners to help keep the service available.',
                    ),
                    SizedBox(height: 14.h),
                    _AboutParagraph(
                      text:
                          'For support, contact us at hello@kicscore.com.',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  color: theme.colorScheme.surface,
                  border: Border.all(color: theme.dividerColor, width: 1.w),
                ),
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: theme.colorScheme.primary,
                      size: 22.r,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        'Version 1.0.1',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: AppTextStyles.sizeBody.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

class _AboutParagraph extends StatelessWidget {
  final String text;

  const _AboutParagraph({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      text,
      style: TextStyle(
        color: theme.colorScheme.onSurface.withAlpha(185),
        fontSize: AppTextStyles.sizeBody.sp,
        fontWeight: FontWeight.w500,
        height: 1.55,
      ),
    );
  }
}
