import 'package:doit_app/widgets/custom_button.dart';
import 'package:doit_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF15002B), // roxo escuro
            Color(0xFF000000), // preto
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 200),
                Icon(Icons.check_circle_outline, size: 100, color: Colors.white),
                SizedBox(height: 70),
                CustomText(
                  text: 'DoIt',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                SizedBox(height: 16),
                CustomText(
                  text: 'Mais foco na execução, menos distração.',
                  fontSize: 18,
                  color: Colors.white70,
                ),
                SizedBox(height: 300),
                SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: CustomButton(
                      onPressed: () {},
                      text: 'Começar',
                      backgroundColor: Colors.purple.shade900,
                      foregroundColor: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}