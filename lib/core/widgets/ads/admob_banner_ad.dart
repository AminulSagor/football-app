import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../services/admob_service.dart';

class AdMobBannerAd extends StatefulWidget {
  final AdSize size;
  final EdgeInsetsGeometry margin;

  const AdMobBannerAd({
    super.key,
    this.size = AdSize.largeBanner,
    this.margin = EdgeInsets.zero,
  });

  const AdMobBannerAd.largeBanner({
    super.key,
    this.margin = EdgeInsets.zero,
  }) : size = AdSize.largeBanner;

  @override
  State<AdMobBannerAd> createState() => _AdMobBannerAdState();
}

class _AdMobBannerAdState extends State<AdMobBannerAd> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
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

          setState(() {
            _isLoaded = false;
          });
        },
      ),
    );

    bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    final bannerAd = _bannerAd;
    if (!_isLoaded || bannerAd == null) return const SizedBox.shrink();

    return Padding(
      padding: widget.margin,
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
