import 'dart:async';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../services/facebook_ads_service.dart';

class FacebookNativeAdWidget extends StatefulWidget {
  final EdgeInsetsGeometry? margin;
  final double height;
  final bool deferUntilScrollIdle;

  const FacebookNativeAdWidget({
    super.key,
    this.margin,
    this.height = 280,
    this.deferUntilScrollIdle = true,
  });

  @override
  State<FacebookNativeAdWidget> createState() => _FacebookNativeAdWidgetState();
}

class _FacebookNativeAdWidgetState extends State<FacebookNativeAdWidget> {
  Timer? _loadTimer;
  ScrollPosition? _scrollPosition;
  bool _shouldBuildAd = false;

  @override
  void initState() {
    super.initState();
    _scheduleLoad();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _attachScrollPosition();
  }

  @override
  void didUpdateWidget(covariant FacebookNativeAdWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.deferUntilScrollIdle != widget.deferUntilScrollIdle) {
      _scheduleLoad();
    }
  }

  @override
  void dispose() {
    _loadTimer?.cancel();
    _scrollPosition?.isScrollingNotifier.removeListener(_handleScrollChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final facebookAdsService = _facebookAdsService;

    if (facebookAdsService == null || !facebookAdsService.canShowNativeAd) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return Padding(
      padding: widget.margin ?? EdgeInsets.only(bottom: 12.h),
      child: RepaintBoundary(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22.r),
          child: Container(
            width: double.infinity,
            height: widget.height.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22.r),
              border: Border.all(
                color: theme.dividerColor.withAlpha(120),
                width: 1.w,
              ),
            ),
            child: _shouldBuildAd
                ? FacebookNativeAd(
                    placementId: facebookAdsService.nativePlacementId,
                    adType: NativeAdType.NATIVE_AD,
                    width: double.infinity,
                    height: widget.height.h,
                    backgroundColor: theme.colorScheme.surface,
                    titleColor: theme.colorScheme.onSurface,
                    descriptionColor: theme.colorScheme.onSurface.withAlpha(165),
                    buttonColor: theme.colorScheme.secondary,
                    buttonTitleColor: theme.colorScheme.onSecondary,
                    buttonBorderColor: theme.colorScheme.secondary,
                    keepAlive: false,
                    keepExpandedWhileLoading: false,
                    expandAnimationDuraion: 0,
                    listener: (result, value) {
                      if (!kDebugMode) return;
                      debugPrint('Facebook native ad: $result -> $value');
                    },
                  )
                : const SizedBox.expand(),
          ),
        ),
      ),
    );
  }

  FacebookAdsService? get _facebookAdsService {
    if (!Get.isRegistered<FacebookAdsService>()) return null;
    return Get.find<FacebookAdsService>();
  }

  void _attachScrollPosition() {
    final nextPosition = Scrollable.maybeOf(context)?.position;
    if (identical(_scrollPosition, nextPosition)) return;

    _scrollPosition?.isScrollingNotifier.removeListener(_handleScrollChanged);
    _scrollPosition = nextPosition;
    _scrollPosition?.isScrollingNotifier.addListener(_handleScrollChanged);
  }

  void _handleScrollChanged() {
    if (_shouldBuildAd || !mounted) return;
    if (_scrollPosition?.isScrollingNotifier.value ?? false) return;

    _scheduleLoad(delay: const Duration(milliseconds: 120));
  }

  void _scheduleLoad({Duration delay = const Duration(milliseconds: 180)}) {
    if (_shouldBuildAd) return;

    _loadTimer?.cancel();
    _loadTimer = Timer(delay, _tryBuildAd);
  }

  void _tryBuildAd() {
    if (!mounted || _shouldBuildAd) return;

    final shouldDefer = widget.deferUntilScrollIdle &&
        ((Scrollable.recommendDeferredLoadingForContext(context)) ||
            (_scrollPosition?.isScrollingNotifier.value ?? false));

    if (shouldDefer) {
      _scheduleLoad(delay: const Duration(milliseconds: 220));
      return;
    }

    setState(() => _shouldBuildAd = true);
  }
}
