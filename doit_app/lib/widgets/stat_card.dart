import 'package:doit_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  const StatCard({required this.title, required this.value, required this.subtitle, required this.accent});
  final String title;
  final String value;
  final String subtitle;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: accent, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Expanded(
                child: CustomText(text: title, fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFFB5B9C8)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          CustomText(text: value, fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
          const SizedBox(height: 2),
          CustomText(text: subtitle, fontSize: 9, color: Colors.white38),
        ],
      ),
    );
  }
}