import 'package:flutter/material.dart';
import '../../../../../constants.dart';

class CreatePostAddButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const CreatePostAddButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: kBrandIndigo,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: kBrandIndigo.withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed ?? () {},
          customBorder: const CircleBorder(),
          child: const Center(
            child: Icon(Icons.add_rounded, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
}
