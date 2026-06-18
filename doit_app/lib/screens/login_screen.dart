import 'package:doit_app/app_constants.dart';
import 'package:doit_app/screens/dashboard_screen.dart';
import 'package:doit_app/screens/forgot_password_screen.dart';
import 'package:doit_app/screens/signup_screen.dart';
import 'package:doit_app/services/auth_services.dart';
import 'package:doit_app/widgets/custom_button.dart';
import 'package:doit_app/widgets/custom_label.dart';
import 'package:doit_app/widgets/custom_text.dart';
import 'package:doit_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Form controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Local UI state
  bool _obscurePassword = true;
  bool _isLoading = false;

  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Login action (local validation + feedback)
  Future<void> _handleLogin() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _authService.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) {
        return;
      }

      if (result.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro inesperado. Tente novamente.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
            colors: [AppConstants.brandPurple, Colors.black],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header icon
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
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                ),

                // Title
                const SizedBox(height: 32),
                const CustomText(
                  text: 'Welcome Back',
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.left,
                  color: Colors.white,
                ),

                // Credentials form
                const SizedBox(height: 28),
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
                  hintText: 'Your password',
                  prefixIcon: Icons.lock,
                  obscureText: _obscurePassword,
                  sufixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Forgot password link
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const CustomText(
                      text: 'Forgot password?',
                      fontSize: 13,
                      color: Color(0xFFD8D8D8),
                    ),
                  ),
                ),

                // Primary action button
                const SizedBox(height: 24),
                CustomButton(
                  text: _isLoading ? 'A entrar...' : 'Login',
                  onPressed: _isLoading ? null : _handleLogin,
                  backgroundColor: AppConstants.brandPurple,
                  foregroundColor: Colors.white,
                ),

                // Secondary navigation link
                const SizedBox(height: 20),
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const CustomText(
                        text: 'New here? ',
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
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: const CustomText(
                          text: 'Create account',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Social section
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
                      size: 50,
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
    // Reusable social logo renderer.
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
