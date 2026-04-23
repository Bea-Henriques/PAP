import 'package:doit_app/screens/signup_screen.dart';
import 'package:doit_app/widgets/custom_button.dart';
import 'package:doit_app/widgets/custom_text.dart';
import 'package:doit_app/app_constants.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});


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
            colors: [
              AppConstants.brandPurple,
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),

                // TODO: substituir pelo logo real da aplicação
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppConstants.brandPurple,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 44,
                  ),
                ),

                const SizedBox(height: 20),

                // TODO: substituir pela fonte real da aplicação
                const CustomText(
                  text: 'DoIt',
                  fontSize: 52,
                  fontFamily: 'DancingScript', 
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),

                const Spacer(flex: 2),

                // Texto descritivo
                const CustomText(
                  text: 'Imagine if you did it...\nNow, make it real!',
                  fontSize: 16,
                  color: Color(0xFFCCCCCC),
                  textAlign: TextAlign.center,
                  height: 1.5,
                ),

                const Spacer(flex: 3),

                // Botão "Get Started"
                CustomButton(
                  text: 'Get Started',
                  backgroundColor: AppConstants.brandPurple,
                  foregroundColor: Colors.white,
                  onPressed: () {
                    // Navegar para a página de sign up
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
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
