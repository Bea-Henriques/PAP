import 'package:doit_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class SectionLabel extends StatelessWidget {
  const SectionLabel({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(text: title, fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
        const SizedBox(height: 4),
        CustomText(text: subtitle, fontSize: 11, color: const Color(0xFF8A8F9F)),
      ],
    );
  }
}