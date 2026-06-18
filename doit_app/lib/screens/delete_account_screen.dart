import 'package:flutter/material.dart';
import 'package:doit_app/widgets/custom_text.dart';

class DeleteAccountScreen extends StatelessWidget {
  final VoidCallback onDelete;

  const DeleteAccountScreen({
    super.key,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF21112E), Color(0xFF0F1117)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning_amber_rounded, size: 80, color: Color(0xFFFF5B5B)),
              const SizedBox(height: 24),
              const CustomText(
                text: 'Delete Account',
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              const CustomText(
                text: 'This action is permanent and cannot be undone. All your projects and tasks will be erased.',
                fontSize: 14,
                color: Colors.white60,
                textAlign: TextAlign.center,
                height: 1.5,
              ),
              const SizedBox(height: 48),

              // Botão de Eliminação
              ElevatedButton(
                onPressed: onDelete, // Callback disparado aqui
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5B5B),
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const CustomText(
                  text: 'Delete Account Permanently',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              // Botão de Cancelar
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const CustomText(
                  text: 'Cancel',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}