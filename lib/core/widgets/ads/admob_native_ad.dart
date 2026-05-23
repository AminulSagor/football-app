import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../services/admob_service.dart';

class AdMobNativeAd extends StatefulWidget {
  final double height;
  final EdgeInsetsGeometry margin;
  final TemplateType templateType;

  const AdMobNativeAd({
    super.key,
    required this.height,
    this.margin = EdgeInsets.zero,
    this.templateType = TemplateType.medium,
  });

  @override
  State<AdMobNativeAd> createState() => _AdMobNativeAdState();
}

class _AdMobNativeAdState extends State<AdMobNativeAd> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  void _loadAd() {
    if (_isLoading || _nativeAd != null) return;
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return;

    _isLoading = true;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final nativeAd = NativeAd(
      adUnitId: AdMobAdUnitIds.native,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }

          setState(() {
            _nativeAd = ad as NativeAd;
            _isLoaded = true;
            _isLoading = false;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (!mounted) return;

          setState(() {
            _isLoaded = false;
            _isLoading = false;
          });
        },
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: widget.templateType,
        mainBackgroundColor: colorScheme.surface,
        cornerRadius: 18,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: colorScheme.onSecondary,
          backgroundColor: colorScheme.secondary,
          style: NativeTemplateFontStyle.bold,
          size: 14,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: colorScheme.onSurface,
          backgroundColor: colorScheme.surface,
          style: NativeTemplateFontStyle.bold,
          size: 16,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: colorScheme.onSurface.withAlpha(170),
          backgroundColor: colorScheme.surface,
          style: NativeTemplateFontStyle.normal,
          size: 13,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: colorScheme.onSurface.withAlpha(130),
          backgroundColor: colorScheme.surface,
          style: NativeTemplateFontStyle.normal,
          size: 12,
        ),
      ),
    );

    nativeAd.load();
  }

  @override
  Widget build(BuildContext context) {
    final nativeAd = _nativeAd;
    if (!_isLoaded || nativeAd == null) return const SizedBox.shrink();

    return Padding(
      padding: widget.margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          height: widget.height,
          width: double.infinity,
          child: AdWidget(ad: nativeAd),
        ),
      ),
    );
  }
}
