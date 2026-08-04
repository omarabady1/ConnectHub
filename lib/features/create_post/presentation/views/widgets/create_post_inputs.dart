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
            style: AppTextStyles.createPostTitleInput,
            decoration: InputDecoration(
              hintText: 'Post title...',
              hintStyle: AppTextStyles.createPostTitleHint,
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
          style: AppTextStyles.createPostDescInput,
          maxLines: null,
          minLines: 8,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            hintText: "What's on your mind?",
            hintStyle: AppTextStyles.createPostDescHint,
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
