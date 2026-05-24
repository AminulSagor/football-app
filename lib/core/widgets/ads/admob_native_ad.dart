import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../services/admob_service.dart';
import 'admob_page_ad_limiter.dart';

class AdMobNativeAd extends StatefulWidget {
  final double? height;
  final EdgeInsetsGeometry margin;
  final TemplateType templateType;
  final String? placementId;

  const AdMobNativeAd({
    super.key,
    this.height,
    this.margin = EdgeInsets.zero,
    this.templateType = TemplateType.medium,
    this.placementId,
  });

  @override
  State<AdMobNativeAd> createState() => _AdMobNativeAdState();
}

class _AdMobNativeAdState extends State<AdMobNativeAd>
    with AutomaticKeepAliveClientMixin<AdMobNativeAd> {
  @override
  bool get wantKeepAlive => true;

  NativeAd? _nativeAd;
  bool _isLoaded = false;
  bool _isLoading = false;
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

          AdMobPageAdLimiter.releaseUnloadedSlot(context, _placementId);
          setState(() {
            _isLoaded = false;
            _isLoading = false;
            _isAdSlotAllowed = false;
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

  double _resolvedHeight(double availableWidth) {
    if (widget.height != null) return widget.height!;

    if (widget.templateType == TemplateType.small) {
      return (availableWidth * 0.34).clamp(100.h, 140.h).toDouble();
    }

    return (availableWidth * 0.96).clamp(330.h, 430.h).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final nativeAd = _nativeAd;
    if (!_isAdSlotAllowed || !_isLoaded || nativeAd == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 20.h),

      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : MediaQuery.of(context).size.width - 56.w;
          final adHeight = _resolvedHeight(availableWidth);

          return ClipRRect(
            borderRadius: BorderRadius.circular(0.r),
            child: SizedBox(
              height: adHeight,
              width: availableWidth,
              child: AdWidget(ad: nativeAd),
            ),
          );
        },
      ),
    );
  }
}
