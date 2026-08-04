import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import '../../../../../utils/app_text_styles.dart';

class PostDetailCard extends StatefulWidget {
  final String authorName;
  final String timeAgo;
  final String avatarUrl;
  final String imageUrl;
  final String caption;
  final String likesCount;
  final String commentsCount;
  final List<Map<String, dynamic>> tags;

  const PostDetailCard({
    super.key,
    this.authorName = 'User Name',
    this.timeAgo = '2 hours ago',
    this.avatarUrl =
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=250',
    this.imageUrl =
        'https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&q=80&w=800',
    this.caption =
        'This is a post about programming. It is a post about the importance of programming. It is a post about the impact of programming. It is a post about the future of programming.',
    this.likesCount = '1.2k',
    this.commentsCount = '342',
    this.tags = const [
      {'label': '#DesignLife', 'isPrimary': true},
      {'label': '#MorningInspiration', 'isPrimary': true},
      {'label': '#Minimalism', 'isPrimary': false},
    ],
  });

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
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFE1E0FF),
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: Image.network(
                          widget.avatarUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.authorName,
                          style: AppTextStyles.postAuthorNameSemibold,
                        ),
                        const SizedBox(height: 2),
                        Text(widget.timeAgo, style: AppTextStyles.postSubtitle),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          ClipRRect(
            child: AspectRatio(
              aspectRatio: 356 / 194,
              child: Image.network(
                widget.imageUrl,
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
                                widget.likesCount,
                                style: AppTextStyles.actionCounterText.copyWith(
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
                              widget.commentsCount,
                              style: AppTextStyles.actionCounterText,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.caption,
                  style: AppTextStyles.postBody.copyWith(
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
