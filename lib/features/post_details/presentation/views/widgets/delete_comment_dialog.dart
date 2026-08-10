import 'package:flutter/material.dart';

class DeleteCommentDialog extends StatelessWidget {
  const DeleteCommentDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => const DeleteCommentDialog(),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete comment?'),
      content: const Text(
        'This comment will be permanently removed.',
      ),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () =>
              Navigator.of(context).pop(true),
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFFD92D20),
          ),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
