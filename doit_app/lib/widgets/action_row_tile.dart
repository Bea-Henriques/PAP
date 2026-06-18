import 'package:doit_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class ActionRowTile extends StatelessWidget {
  const ActionRowTile({
    required this.icon, 
    required this.iconColor,
    required this.title, 
    required this.subtitle, 
    required this.onTap,
  });
  
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      tileColor: Colors.white.withValues(alpha: 0.03),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: CustomText(text: title, fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
      subtitle: CustomText(text: subtitle, fontSize: 11, color: const Color(0xFF8A8F9F)),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white24, size: 20),
      onTap: onTap,
    );
  }
}