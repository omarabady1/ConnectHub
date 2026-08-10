import 'package:flutter/material.dart';

class DeletePostDialog extends StatelessWidget {
  const DeletePostDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => const DeletePostDialog(),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete post?'),
      content: const Text(
        'This post will be removed from your feed.',
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
