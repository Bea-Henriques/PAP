import 'package:doit_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.progress,
    required this.color,
    this.onTap,
  });

  final String title;
  final String description;
  final String dueDate;
  final double progress;
  final Color color;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final double progressValue =
        double.tryParse(progress.toString().replaceAll('%', '')) ?? 0.0;

    return GestureDetector(
      onTap: onTap, // 👈 AQUI ESTÁ O CLICK NO CARD TODO
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomText(
                    text: title,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined,
                        size: 13, color: Color(0xFF6B7280)),
                    const SizedBox(width: 4),
                    CustomText(
                      text: dueDate,
                      fontSize: 11,
                      color: const Color(0xFF8A8F9F),
                    ),
                  ],
                ),
              ],
            ),

            if (description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8A8F9F),
                    height: 1.3,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        text: 'Progress',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
                      ),
                      CustomText(
                        text: '${progressValue.round()}%',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: progressValue / 100,
                      backgroundColor: Colors.white10,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}