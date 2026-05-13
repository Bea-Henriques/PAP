import 'package:doit_app/app_constants.dart';
import 'package:doit_app/screens/reset_password_email_sent_screen.dart';
import 'package:doit_app/widgets/custom_button.dart';
import 'package:doit_app/widgets/custom_label.dart';
import 'package:doit_app/widgets/custom_text.dart';
import 'package:doit_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSendReset() {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira o seu email.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // For now, just navigate to confirmation screen (backend will be added later)
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const ResetPasswordEmailSentScreen(),
      ),
    );
  }

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                const SizedBox(height: 16),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),

                // Header icon
                const SizedBox(height: 24),
                Center(
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppConstants.brandPurple,
                    ),
                    child: const Icon(
                      Icons.lock_outline,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                ),

                // Title
                const SizedBox(height: 32),
                const CustomText(
                  text: 'Recuperar Senha',
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.left,
                  color: Colors.white,
                ),

                // Subtitle
                const SizedBox(height: 12),
                const CustomText(
                  text: 'Insira o seu email para recuperar a sua senha',
                  fontSize: 14,
                  color: Color(0xFFAAAAAA),
                  textAlign: TextAlign.left,
                ),

                // Email form
                const SizedBox(height: 32),
                const CustomLabel(text: 'Email'),
                const SizedBox(height: 8),
                CustomTextfield(
                  controller: _emailController,
                  hintText: 'your@email.com',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),

                // Send reset button
                const SizedBox(height: 32),
                CustomButton(
                  text: 'Enviar Link',
                  onPressed: _handleSendReset,
                  backgroundColor: AppConstants.brandPurple,
                  foregroundColor: Colors.white,
                ),

                // Back to login link
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const CustomText(
                      text: 'Voltar para Login',
                      fontSize: 14,
                      color: Color(0xFFD8D8D8),
                    ),
                  ),
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
