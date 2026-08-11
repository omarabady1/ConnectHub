import 'package:connect_hub/constants.dart';
import 'package:connect_hub/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.isPasswordField = false,
    this.inputType = TextInputType.text,
    this.suffixIcon,
    this.onChanged,
    this.errorText,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final bool isPasswordField;
  final TextInputType inputType;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPasswordField || widget.obscureText;
  }

  @override
  void didUpdateWidget(covariant AuthTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.obscureText != widget.obscureText &&
        !widget.isPasswordField) {
      _obscureText = widget.obscureText;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget? effectiveSuffixIcon;

    if (widget.isPasswordField) {
      final visibilityButton = IconButton(
        icon: Icon(
          _obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: const Color(0xFF9CA3AF),
          size: 20,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );

      if (widget.suffixIcon != null) {
        effectiveSuffixIcon = Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [widget.suffixIcon!, visibilityButton],
          ),
        );
      } else {
        effectiveSuffixIcon = visibilityButton;
      }
    } else {
      effectiveSuffixIcon = widget.suffixIcon;
    }

    return TextField(
      controller: widget.controller,
      keyboardType: widget.inputType,
      obscureText: _obscureText,
      onChanged: widget.onChanged,
      style: AppTextStyles.medium15.copyWith(color: const Color(0xFF111827)),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: AppTextStyles.medium15.copyWith(
          color: const Color(0xFF9CA3AF),
        ),
        prefixIcon: Icon(widget.icon, color: const Color(0xFF9CA3AF)),
        suffixIcon: effectiveSuffixIcon,
        errorText: widget.errorText,
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
