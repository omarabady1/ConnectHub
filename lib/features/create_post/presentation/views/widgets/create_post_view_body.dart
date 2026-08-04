import 'dart:io';

import 'package:flutter/material.dart';
import 'create_post_attachment_toolkit.dart';
import 'create_post_image_preview.dart';
import 'create_post_inputs.dart';
import 'create_post_user_info.dart';

class CreatePostViewBody extends StatelessWidget {
  final TextEditingController? titleController;
  final TextEditingController? descriptionController;
  final ValueChanged<String>? onTitleChanged;
  final ValueChanged<String>? onDescriptionChanged;
  final VoidCallback? onAddImagePressed;
  final VoidCallback? onRemoveImagePressed;
  final File? selectedImage;

  const CreatePostViewBody({
    super.key,
    this.titleController,
    this.descriptionController,
    this.onTitleChanged,
    this.onDescriptionChanged,
    this.onAddImagePressed,
    this.onRemoveImagePressed,
    this.selectedImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CreatePostUserInfo(),
                const SizedBox(height: 20),
                CreatePostInputs(
                  titleController: titleController,
                  descriptionController: descriptionController,
                  onTitleChanged: onTitleChanged,
                  onDescriptionChanged: onDescriptionChanged,
                ),
                if (selectedImage != null) ...[
                  const SizedBox(height: 20),
                  CreatePostImagePreview(
                    image: selectedImage!,
                    onRemovePressed: onRemoveImagePressed,
                  ),
                ],
              ],
            ),
          ),
        ),
        CreatePostAttachmentToolkit(onAddImagePressed: onAddImagePressed),
      ],
    );
  }
}
