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

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      placeholder: placeholderBuilder == null
          ? null
          : (context, _) => placeholderBuilder!(context),
      errorWidget: (context, _, __) {
        final fallback = errorBuilder;
        if (fallback != null) {
          return fallback(context);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
