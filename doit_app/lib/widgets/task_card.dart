import 'package:doit_app/app_constants.dart';
import 'package:doit_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.title,
    required this.dueDate,
    required this.priority,
    required this.priorityColor,
    required this.completed,
    this.onToggle,
    this.onTap,
    this.onLongPress,
  });

  final String title;
  final String dueDate;
  final String priority;
  final Color priorityColor;
  final bool completed;

  final VoidCallback? onToggle;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, 
      onLongPress: onLongPress,

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Row(
          children: [
            // TOGGLE ICON
            GestureDetector(
              onTap: onToggle,
              child: Icon(
                completed
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_off_rounded,
                color: completed
                    ? AppConstants.brandPurple
                    : const Color(0xFF8A8F9F),
                size: 22,
              ),
            ),

            const SizedBox(width: 12),

            // TEXT AREA
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: completed ? Colors.white38 : Colors.white,
                      decoration:
                          completed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),

                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        size: 11,
                        color: Colors.white38,
                      ),
                      const SizedBox(width: 4),
                      CustomText(
                        text: dueDate,
                        fontSize: 11,
                        color: Colors.white38,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // PRIORITY BADGE
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: priorityColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: CustomText(
                text: priority,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: priorityColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}