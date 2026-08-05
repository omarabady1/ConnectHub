import 'package:connect_hub/features/home/domain/models/post_model.dart';
import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import '../../../../../core/utils/user_avatar.dart';
import '../../../../../utils/app_text_styles.dart';

class PostDetailCard extends StatefulWidget {
  final PostModel post;
  const PostDetailCard({super.key, required this.post});

  @override
  State<PostDetailCard> createState() => _PostDetailCardState();
}

class _PostDetailCardState extends State<PostDetailCard> {
  bool _isLiked = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kCardBorderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: kBrandIndigo.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFE4E1ED), width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    UserAvatar(
                      avatarUrl: widget.post.avatarUrl,
                      initial: widget.post.avatarInitial ??
                          (widget.post.authorName.isNotEmpty
                              ? widget.post.authorName[0]
                              : '?'),
                      border: Border.all(
                        color: const Color(0xFFE1E0FF),
                        width: 2,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.post.authorName,
                          style: AppTextStyles.semiBold12.copyWith(
                            color: const Color(0xFF1B1B23),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.post.timeAgo,
                          style: AppTextStyles.regular14.copyWith(
                            color: const Color(0xFF5C5F61),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (widget.post.mainImageUrl != null &&
              widget.post.mainImageUrl!.isNotEmpty)
            ClipRRect(
              child: AspectRatio(
                aspectRatio: 356 / 194,
                child: Image.network(
                  widget.post.mainImageUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: const Color(0xFFEFECF8),
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFEFECF8),
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isLiked = !_isLiked;
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                _isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: _isLiked
                                    ? kBrandIndigo
                                    : kTextSecondaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.post.likesCount.toString(),
                                style: AppTextStyles.medium12.copyWith(
                                  color: _isLiked
                                      ? kBrandIndigo
                                      : kTextSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Row(
                          children: [
                            const Icon(
                              Icons.chat_bubble_outline,
                              color: kTextSecondaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.post.commentsCount.toString(),
                              style: AppTextStyles.medium12.copyWith(
                                color: kTextSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.post.postContent,
                  style: AppTextStyles.regular16.copyWith(
                    color: kTextDarkColor,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
