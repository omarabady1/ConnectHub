import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../../constants.dart';

class PostImage extends StatefulWidget {
  const PostImage({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  State<PostImage> createState() => _PostImageState();
}

class _PostImageState extends State<PostImage> {
  static final Set<String> _loadedImageUrls = <String>{};

  late bool _wasLoadedBefore;
  late CachedNetworkImageProvider _imageProvider;

  @override
  void initState() {
    super.initState();
    _setImageProvider();
  }

  @override
  void didUpdateWidget(covariant PostImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl == widget.imageUrl) return;

    _setImageProvider();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AspectRatio(
        aspectRatio: 326 / 178,
        child: Image(
          image: _imageProvider,
          fit: BoxFit.cover,
          gaplessPlayback: true,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded || frame != null) {
              _markImageLoaded();
              return child;
            }

            if (_wasLoadedBefore) return child;

            return const _PostImageLoadingPlaceholder();
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null || _wasLoadedBefore) return child;

            return const _PostImageLoadingPlaceholder();
          },
          errorBuilder: (context, error, stackTrace) =>
              const _PostImageErrorPlaceholder(),
        ),
      ),
    );
  }

  void _setImageProvider() {
    _wasLoadedBefore = _loadedImageUrls.contains(widget.imageUrl);
    _imageProvider = CachedNetworkImageProvider(
      widget.imageUrl,
      cacheKey: widget.imageUrl,
    );
  }

  void _markImageLoaded() {
    if (_loadedImageUrls.add(widget.imageUrl)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        setState(() {
          _wasLoadedBefore = true;
        });
      });
    }
  }
}

class _PostImageLoadingPlaceholder extends StatelessWidget {
  const _PostImageLoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE9E6F3),
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}

class _PostImageErrorPlaceholder extends StatelessWidget {
  const _PostImageErrorPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE9E6F3),
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: kTextSecondaryColor,
        ),
      ),
    );
  }
}
