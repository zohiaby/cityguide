import 'package:cached_network_image/cached_network_image.dart';
import 'package:cityguide/res/app_colors/app_clolrs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class FirestoreImageWidget extends StatelessWidget {
  static final customCacheManager = CacheManager(
    Config('customCacheKey',
        stalePeriod: const Duration(days: 7), maxNrOfCacheObjects: 50),
  );
  final String imageUrl;

  const FirestoreImageWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => const Center(
          child: Text(
        'Loading ...',
        style: TextStyle(
            color: Appcolor.buttonclolor,
            fontSize: 30,
            fontWeight: FontWeight.bold),
      )), // Placeholder widget while loading
      errorWidget: (context, url, error) =>
          const Icon(Icons.error), // Widget to display in case of an error
      fit: BoxFit.cover, // Adjust the image's fit inside the widget
      cacheManager: customCacheManager,
    );
  }
}
