import 'dart:async';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../services/facebook_ads_service.dart';

class FacebookBannerAdWidget extends StatefulWidget {
  final EdgeInsetsGeometry? margin;
  final double height;
  final bool deferUntilScrollIdle;

  const FacebookBannerAdWidget({
    super.key,
    this.margin,
    this.height = 50,
    this.deferUntilScrollIdle = true,
  });

  @override
  State<FacebookBannerAdWidget> createState() => _FacebookBannerAdWidgetState();
}

class _FacebookBannerAdWidgetState extends State<FacebookBannerAdWidget>
    with AutomaticKeepAliveClientMixin<FacebookBannerAdWidget> {
  Timer? _loadTimer;
  ScrollPosition? _scrollPosition;
  bool _shouldBuildAd = false;
  late final Key _adKey = UniqueKey();

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
  void didUpdateWidget(covariant FacebookBannerAdWidget oldWidget) {
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
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final facebookAdsService = _facebookAdsService;

    if (facebookAdsService == null || !facebookAdsService.canShowBannerAd) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: widget.margin ?? EdgeInsets.only(bottom: 16.h),
      child: RepaintBoundary(
        child: SizedBox(
          width: double.infinity,
          height: widget.height.h,
          child: Center(
            child: _shouldBuildAd
                ? FacebookBannerAd(
                    key: _adKey,
                    placementId: facebookAdsService.bannerPlacementId,
                    bannerSize: BannerSize.STANDARD,
                  )
                : const SizedBox.shrink(),
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

    _scheduleLoad(delay: const Duration(milliseconds: 90));
  }

  void _scheduleLoad({Duration delay = const Duration(milliseconds: 120)}) {
    if (_shouldBuildAd) return;

    _loadTimer?.cancel();
    _loadTimer = Timer(delay, _tryBuildAd);
  }

  void _tryBuildAd() {
    if (!mounted || _shouldBuildAd) return;

    final shouldDefer =
        widget.deferUntilScrollIdle &&
        ((Scrollable.recommendDeferredLoadingForContext(context)) ||
            (_scrollPosition?.isScrollingNotifier.value ?? false));

    if (shouldDefer) {
      _scheduleLoad(delay: const Duration(milliseconds: 180));
      return;
    }

    setState(() => _shouldBuildAd = true);
  }
}
