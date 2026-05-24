import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../services/admob_service.dart';
import 'admob_page_ad_limiter.dart';

class AdMobBannerAd extends StatefulWidget {
  final AdSize size;
  final EdgeInsetsGeometry margin;
  final String? placementId;

  const AdMobBannerAd({
    super.key,
    this.size = AdSize.largeBanner,
    this.margin = EdgeInsets.zero,
    this.placementId,
  });

  const AdMobBannerAd.largeBanner({
    super.key,
    this.margin = EdgeInsets.zero,
    this.placementId,
  }) : size = AdSize.largeBanner;

  @override
  State<AdMobBannerAd> createState() => _AdMobBannerAdState();
}

class _AdMobBannerAdState extends State<AdMobBannerAd>
    with AutomaticKeepAliveClientMixin<AdMobBannerAd> {
  @override
  bool get wantKeepAlive => true;

  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _didRequestAdSlot = false;
  bool _isAdSlotAllowed = false;
  late String _placementId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didRequestAdSlot) return;

    _didRequestAdSlot = true;
    _placementId = widget.placementId ??
        AdMobPageAdLimiter.fallbackPlacementId(
          context: context,
          widget: widget,
          key: widget.key,
        );
    _isAdSlotAllowed = AdMobPageAdLimiter.reserveSlot(
      context,
      _placementId,
    );
    if (_isAdSlotAllowed) {
      _loadAd();
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _loadAd() {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return;

    final bannerAd = BannerAd(
      adUnitId: AdMobAdUnitIds.banner,
      size: widget.size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }

          setState(() {
            _bannerAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (!mounted) return;

          AdMobPageAdLimiter.releaseUnloadedSlot(context, _placementId);
          setState(() {
            _isLoaded = false;
            _isAdSlotAllowed = false;
          });
        },
      ),
    );

    bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bannerAd = _bannerAd;
    if (!_isAdSlotAllowed || !_isLoaded || bannerAd == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Center(
        child: SizedBox(
          width: bannerAd.size.width.toDouble(),
          height: bannerAd.size.height.toDouble(),
          child: AdWidget(ad: bannerAd),
        ),
      ),
    );
  }
}
