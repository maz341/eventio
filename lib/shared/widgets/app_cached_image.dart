
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppCachedImage extends StatelessWidget {
  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: double.infinity,
      memCacheWidth: 900,
      maxWidthDiskCache: 1200,
      placeholder: (context, url) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      errorWidget: (context, url, error) {
        return const Center(
          child: Icon(Icons.broken_image_outlined, size: 36),
        );
      },
    );
  }
}
