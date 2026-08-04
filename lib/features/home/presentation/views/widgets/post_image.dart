import 'package:flutter/material.dart';

import '../../../../../constants.dart';

class PostImage extends StatelessWidget {
  const PostImage({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AspectRatio(
        aspectRatio: 326 / 178,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;

            return Container(
              color: const Color(0xFFE9E6F3),
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: const Color(0xFFE9E6F3),
              child: const Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: kTextSecondaryColor,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
