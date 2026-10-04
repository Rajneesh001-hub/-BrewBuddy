// ─── Cached Coffee Image Widget ──────────────────────────────────────────────
// Optimized image widget with caching for coffee.png
// Automatically handles sizing, loading states, and memory optimization

import 'package:flutter/material.dart';

class CachedCoffeeImage extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const CachedCoffeeImage({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    // Pre-cache the image on first load
    precacheImage(
      const AssetImage('assets/images/coffee.png'),
      context,
    );

    final widget = Image.asset(
      'assets/images/coffee.png',
      width: width,
      height: height,
      fit: fit,
      cacheWidth: width?.toInt(),
      cacheHeight: height?.toInt(),
    );

    // Apply border radius if provided
    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: widget,
      );
    }

    return widget;
  }
}
