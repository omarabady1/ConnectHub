import 'package:flutter/material.dart';
import '../../../../../utils/app_text_styles.dart';

class CreatePostInputs extends StatelessWidget {
  final TextEditingController? titleController;
  final TextEditingController? descriptionController;
  final ValueChanged<String>? onTitleChanged;
  final ValueChanged<String>? onDescriptionChanged;

  const CreatePostInputs({
    super.key,
    this.titleController,
    this.descriptionController,
    this.onTitleChanged,
    this.onDescriptionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFFE4E1ED), width: 1),
            ),
          ),
          padding: const EdgeInsets.only(bottom: 12),
          child: TextField(
            controller: titleController,
            onChanged: onTitleChanged,
            style: AppTextStyles.semiBold20.copyWith(
              color: const Color(0xFF1B1B23),
            ),
            decoration: InputDecoration(
              hintText: 'Post title...',
              hintStyle: AppTextStyles.semiBold20.copyWith(
                color: const Color(0xFF767586),
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: descriptionController,
          onChanged: onDescriptionChanged,
          style: AppTextStyles.regular16.copyWith(
            color: const Color(0xFF1B1B23),
            height: 1.5,
          ),
          maxLines: null,
          minLines: 8,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            hintText: "What's on your mind?",
            hintStyle: AppTextStyles.regular16.copyWith(
              color: const Color(0xFF767586),
              height: 1.5,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
