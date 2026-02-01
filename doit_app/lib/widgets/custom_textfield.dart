import 'package:flutter/material.dart';

/// Reusable text field widget with consistent styling
/// Supports prefix/suffix icons, obscure text, and custom keyboard types
class CustomTextfield extends StatelessWidget {
  /// Creates a custom text field
  /// [controller] - Text editing controller
  /// [hintText] - Placeholder text
  /// [prefixIcon] - Icon displayed at the start
  /// [sufixIcon] - Optional widget displayed at the end (typically an icon button)
  /// [obscureText] - Whether to hide text (for passwords)
  /// [keyboardType] - Type of keyboard to show
  const CustomTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.sufixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final Widget? sufixIcon;
  final bool obscureText ; 
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
        prefixIcon: Icon(prefixIcon, color: Colors.white.withOpacity(0.7)),
        suffixIcon: sufixIcon,
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
      ),
    );
  }
}