import 'package:doit_app/app_constants.dart';
import 'package:doit_app/screens/login_screen.dart';
import 'package:doit_app/widgets/custom_button.dart';
import 'package:doit_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class ResetPasswordEmailSentScreen extends StatelessWidget {
  const ResetPasswordEmailSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppConstants.brandPurple, Colors.black],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // Success icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                ),

                const SizedBox(height: 32),

                // Title
                const CustomText(
                  text: 'Email Enviado!',
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Subtitle
                const CustomText(
                  text: 'Verifique o seu email para as instruções de recuperação da senha.',
                  fontSize: 14,
                  color: Color(0xFFAAAAAA),
                  textAlign: TextAlign.center,
                  height: 1.5,
                ),

                const SizedBox(height: 16),

                // Additional info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white24),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const CustomText(
                    text: 'O link de recuperação expira em 24 horas. Se não receber o email, verifique a pasta de spam.',
                    fontSize: 12,
                    color: Color(0xFFCCCCCC),
                    textAlign: TextAlign.center,
                    height: 1.5,
                  ),
                ),

                const Spacer(flex: 2),

                // Back to login button
                CustomButton(
                  text: 'Voltar para Login',
                  backgroundColor: AppConstants.brandPurple,
                  foregroundColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  },
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
