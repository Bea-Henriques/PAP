import 'package:doit_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

/// Reusable elevated button widget with consistent styling
/// Uses [CustomText] for text rendering
class CustomButton extends StatelessWidget {
  /// Creates a custom button
  /// [onPressed] - Callback when button is pressed
  /// [text] - Button label text
  /// [backgroundColor] - Button background color
  /// [foregroundColor] - Text and ripple color
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, 
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: CustomText(
        text: text, 
        fontSize: 16,
        fontWeight: FontWeight.bold,),);
  }
}