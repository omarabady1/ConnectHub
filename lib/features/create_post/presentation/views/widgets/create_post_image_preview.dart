import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../../constants.dart';

class CreatePostImagePreview extends StatelessWidget {
  const CreatePostImagePreview({
    super.key,
    required this.image,
    this.onRemovePressed,
  });

  final File image;
  final VoidCallback? onRemovePressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            image,
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
        Positioned(
          top: 8,
          right: 8,
          child: Material(
            color: Colors.black.withValues(alpha: 0.55),
            shape: const CircleBorder(),
            child: IconButton(
              onPressed: onRemovePressed,
              icon: const Icon(Icons.close_rounded),
              color: Colors.white,
              iconSize: 18,
              constraints: const BoxConstraints.tightFor(width: 34, height: 34),
              padding: EdgeInsets.zero,
              tooltip: 'Remove image',
            ),
          ),
        ),
      ],
    );
  }
}
