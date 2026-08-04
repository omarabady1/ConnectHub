import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import '../../../../../utils/app_text_styles.dart';

class PostCardActions extends StatefulWidget {
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final Color borderColor;
  final VoidCallback? onLikePressed;
  final VoidCallback? onCommentPressed;

  const PostCardActions({
    super.key,
    required this.likesCount,
    required this.commentsCount,
    this.isLiked = false,
    this.borderColor = kCardBorderColor,
    this.onLikePressed,
    this.onCommentPressed,
  });

  @override
  State<PostCardActions> createState() => _PostCardActionsState();
}

class _PostCardActionsState extends State<PostCardActions> {
  late bool _liked;
  late int _count;

  @override
  void initState() {
    super.initState();
    _liked = widget.isLiked;
    _count = widget.likesCount;
  }

  void _toggleLike() {
    setState(() {
      _liked = !_liked;
      _count += _liked ? 1 : -1;
    });
    if (widget.onLikePressed != null) {
      widget.onLikePressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color activeColor = kBrandIndigo;
    final Color inactiveColor = kTextSecondaryColor;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: widget.borderColor, width: 1),
        ),
      ),
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          InkWell(
            onTap: _toggleLike,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _liked ? Icons.favorite : Icons.favorite_border,
                    color: _liked ? activeColor : inactiveColor,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$_count',
                    style: AppTextStyles.medium12.copyWith(
                      color: _liked ? activeColor : inactiveColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          InkWell(
            onTap: widget.onCommentPressed ?? () {},
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    color: inactiveColor,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.commentsCount}',
                    style: AppTextStyles.medium12.copyWith(
                      color: inactiveColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
