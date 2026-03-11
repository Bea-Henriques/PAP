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
    this.readOnly = false,
    this.onTap,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final Widget? sufixIcon;
  final bool obscureText ; 
  final TextInputType keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onTap: onTap,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.blueGrey[400]),
        prefixIcon: Icon(prefixIcon, color: Colors.white),
        suffixIcon: sufixIcon,
        filled: true,
        fillColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
      ),
    );
  }
}