import 'package:flutter/material.dart';
import '../../../utils/app_text_styles.dart';


class UserAvatar extends StatelessWidget {
  final String? avatarUrl;

  final String initial;

  final double size;

  final Border? border;

  const UserAvatar({
    super.key,
    this.avatarUrl,
    required this.initial,
    this.size = 40,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: border,
      ),
      child: avatarUrl != null && avatarUrl!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: Image.network(
                avatarUrl!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: const Color(0xFFE9E6F3),
                    child: const Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return _InitialAvatar(
                    initial: initial,
                    textStyle: _textStyleForSize,
                  );
                },
              ),
            )
          : _InitialAvatar(
              initial: initial,
              textStyle: _textStyleForSize,
            ),
    );
  }

  TextStyle get _textStyleForSize {
    if (size >= 44) {
      return AppTextStyles.semiBold20.copyWith(color: Colors.white);
    }
    return AppTextStyles.semiBold16.copyWith(color: Colors.white);
  }
}

class _InitialAvatar extends StatelessWidget {
  final String initial;
  final TextStyle textStyle;

  const _InitialAvatar({
    required this.initial,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF6C748B),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(initial, style: textStyle),
      ),
    );
  }
}
