 import 'package:connect_hub/constants.dart';
import 'package:connect_hub/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

Future<dynamic> showConfirmDialog(BuildContext context) {
    return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Email Sent',
              style: AppTextStyles.bold20,
            ),
            content: Text(
              'A password reset link has been sent to your email address. Please check your inbox.',
              style: AppTextStyles.regular14.copyWith(
                color: const Color(0xFF4B5563),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: AppTextStyles.bold16.copyWith(
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
        );
  }