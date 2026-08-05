import 'dart:developer' as developer;

import 'package:connect_hub/core/functions/setup_service_locator.dart';
import 'package:connect_hub/features/post_details/data/services/post_interaction_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import '../../../../../utils/app_text_styles.dart';

class PostCardActions extends StatefulWidget {
  final String postId;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final Color borderColor;
  final VoidCallback? onCommentPressed;

  const PostCardActions({
    super.key,
    required this.postId,
    required this.likesCount,
    required this.commentsCount,
    this.isLiked = false,
    this.borderColor = kCardBorderColor,
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

  @override
  void didUpdateWidget(covariant PostCardActions oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLiked != widget.isLiked ||
        oldWidget.likesCount != widget.likesCount) {
      _liked = widget.isLiked;
      _count = widget.likesCount;
    }
  }

  Future<void> _toggleLike() async {
    final previousLiked = _liked;
    final previousCount = _count;

    setState(() {
      _liked = !_liked;
      _count += _liked ? 1 : -1;
    });

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      await getIt<PostInteractionService>().toggleLike(
        postId: widget.postId,
        userId: userId,
        currentlyLiked: previousLiked,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _liked = previousLiked;
        _count = previousCount;
      });
      developer.log(
        'Like toggle reverted for ${widget.postId}',
        name: 'PostCardActions',
        error: e,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not update like. Try again.'),
        ),
      );
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
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 8,
              ),
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
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 8,
              ),
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
