import 'package:connect_hub/constants.dart';
import 'package:connect_hub/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.inputType = TextInputType.text,
    this.suffixIcon,
    this.onChanged,
    this.errorText,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextInputType inputType;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      obscureText: obscureText,
      onChanged: onChanged,
      style: AppTextStyles.medium15.copyWith(color: const Color(0xFF111827)),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.medium15.copyWith(
          color: const Color(0xFF9CA3AF),
        ),
        prefixIcon: Icon(icon, color: const Color(0xFF9CA3AF)),
        suffixIcon: suffixIcon,
        errorText: errorText,
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: kPrimaryColor),
        ),
      ),
    );
  }
}
