import 'package:doit_app/app_constants.dart';
import 'package:doit_app/screens/login_screen.dart';
import 'package:doit_app/widgets/custom_button.dart';
import 'package:doit_app/widgets/custom_label.dart';
import 'package:doit_app/widgets/custom_text.dart';
import 'package:doit_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
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
            colors: [
              AppConstants.brandPurple,
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Center(
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppConstants.brandPurple,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const CustomText(
                  text: 'Create Account',
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.left,
                  color: Colors.white,
                ),
                const SizedBox(height: 28),
                const CustomLabel(text: 'Name'),
                const SizedBox(height: 8),
                CustomTextfield(
                  controller: _nameController,
                  hintText: 'Your name',
                  prefixIcon: Icons.person,
                ),
                const SizedBox(height: 20),
                const CustomLabel(text: 'Email'),
                const SizedBox(height: 8),
                CustomTextfield(
                  controller: _emailController,
                  hintText: 'your@email.com',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                const CustomLabel(text: 'Password'),
                const SizedBox(height: 8),
                CustomTextfield(
                  controller: _passwordController,
                  hintText: 'At least 6 characters',
                  prefixIcon: Icons.lock,
                  obscureText: _obscurePassword,
                  sufixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: 'Sign Up',
                  onPressed: _handleSignUp,
                  backgroundColor: AppConstants.brandPurple,
                  foregroundColor: Colors.white,
                ),
                const SizedBox(height: 20),
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const CustomText(
                        text: 'Already have an account? ',
                        fontSize: 14,
                        color: Color(0xFFAAAAAA),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const CustomText(
                          text: 'Login',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Center(
                  child: CustomText(
                    text: 'or',
                    fontSize: 14,
                    color: Color(0xFFAAAAAA),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    _SocialNetworkLogo(
                      assetPath: 'assets/images/google_logo.png',
                    ),
                    SizedBox(width: 28),
                    _SocialNetworkLogo(
                      assetPath: 'assets/images/facebook_logo.png',
                    ),
                    SizedBox(width: 28),
                    _SocialNetworkLogo(
                      assetPath: 'assets/images/apple_logo.png',
                      size: 54,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialNetworkLogo extends StatelessWidget {
  const _SocialNetworkLogo({required this.assetPath, this.size = 40});

  final String assetPath;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        assetPath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.image_not_supported_outlined,
          color: Colors.white70,
          size: 24,
        ),
      ),
    );
  }
}