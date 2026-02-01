import 'package:doit_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

/// Reusable label widget for input fields
/// Displays text aligned left with consistent styling
class CustomLabel extends StatelessWidget {
  /// Creates a custom label
  /// [text] - Label text to display
  const CustomLabel({
    super.key,
    required this.text,
  });

    final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: CustomText(
        text: text, 
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white),
    );
  }
}