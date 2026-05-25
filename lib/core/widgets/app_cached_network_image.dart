import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

typedef AppCachedImageBuilder = Widget Function(BuildContext context);

class AppCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Alignment alignment;
  final AppCachedImageBuilder? placeholderBuilder;
  final AppCachedImageBuilder? errorBuilder;

  const AppCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.alignment = Alignment.center,
    this.placeholderBuilder,
    this.errorBuilder,
  });

  bool get _isFootballLogoUrl {
    final lowerUrl = imageUrl.toLowerCase();
    return lowerUrl.contains('/football/teams/') ||
        lowerUrl.contains('/football/leagues/');
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      imageBuilder: _isFootballLogoUrl
          ? (context, imageProvider) => _AdaptiveLogoBackgroundImage(
              imageProvider: imageProvider,
              width: width,
              height: height,
              fit: fit,
              alignment: alignment,
            )
          : null,
      placeholder: placeholderBuilder == null
          ? null
          : (context, _) => placeholderBuilder!(context),
      errorWidget: (context, _, _) {
        final fallback = errorBuilder;
        if (fallback != null) {
          return fallback(context);
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _AdaptiveLogoBackgroundImage extends StatefulWidget {
  final ImageProvider imageProvider;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Alignment alignment;

  const _AdaptiveLogoBackgroundImage({
    required this.imageProvider,
    required this.width,
    required this.height,
    required this.fit,
    required this.alignment,
  });

  @override
  State<_AdaptiveLogoBackgroundImage> createState() =>
      _AdaptiveLogoBackgroundImageState();
}

class _AdaptiveLogoBackgroundImageState
    extends State<_AdaptiveLogoBackgroundImage> {
  static final Map<Object, bool> _darkLogoCache = <Object, bool>{};

  ImageStream? _imageStream;
  ImageStreamListener? _imageStreamListener;
  bool _useWhiteBackground = false;

  @override
  void initState() {
    super.initState();
    _resolveLogoColor();
  }

  @override
  void didUpdateWidget(covariant _AdaptiveLogoBackgroundImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageProvider != widget.imageProvider) {
      _removeImageListener();
      _useWhiteBackground = false;
      _resolveLogoColor();
    }
  }

  @override
  void dispose() {
    _removeImageListener();
    super.dispose();
  }

  void _resolveLogoColor() {
    final cacheKey = widget.imageProvider;
    final cachedResult = _darkLogoCache[cacheKey];
    if (cachedResult != null) {
      _useWhiteBackground = cachedResult;
      return;
    }

    final imageStream = widget.imageProvider.resolve(
      const ImageConfiguration(),
    );

    late final ImageStreamListener listener;
    listener = ImageStreamListener(
      (imageInfo, _) {
        unawaited(_sampleLogoDarkness(cacheKey, imageInfo.image));
      },
      onError: (_, _) {
        _darkLogoCache[cacheKey] = false;
      },
    );

    _imageStream = imageStream;
    _imageStreamListener = listener;
    imageStream.addListener(listener);
  }

  void _removeImageListener() {
    final imageStream = _imageStream;
    final listener = _imageStreamListener;
    if (imageStream != null && listener != null) {
      imageStream.removeListener(listener);
    }
    _imageStream = null;
    _imageStreamListener = null;
  }

  Future<void> _sampleLogoDarkness(Object cacheKey, ui.Image image) async {
    try {
      final byteData = await image.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      );
      if (byteData == null) {
        _darkLogoCache[cacheKey] = false;
        return;
      }

      final width = image.width;
      final height = image.height;
      final bytes = byteData.buffer.asUint8List();
      final totalPixels = math.max(1, width * height);
      final step = math.max(1, math.sqrt(totalPixels / 2500).floor());

      var sampledPixels = 0;
      var luminanceTotal = 0.0;

      for (var y = 0; y < height; y += step) {
        for (var x = 0; x < width; x += step) {
          final offset = ((y * width) + x) * 4;
          if (offset + 3 >= bytes.length) continue;

          final alpha = bytes[offset + 3];
          if (alpha < 32) continue;

          final red = bytes[offset];
          final green = bytes[offset + 1];
          final blue = bytes[offset + 2];
          luminanceTotal += (0.299 * red) + (0.587 * green) + (0.114 * blue);
          sampledPixels++;
        }
      }

      final isDarkLogo =
          sampledPixels > 0 && (luminanceTotal / sampledPixels) < 128.0;
      _darkLogoCache[cacheKey] = isDarkLogo;

      if (!mounted || _useWhiteBackground == isDarkLogo) return;
      setState(() => _useWhiteBackground = isDarkLogo);
    } catch (_) {
      _darkLogoCache[cacheKey] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: _useWhiteBackground ? Colors.white : Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Image(
          image: widget.imageProvider,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          alignment: widget.alignment,
        ),
      ),
    );
  }
}
