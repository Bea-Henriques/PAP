import 'package:doit_app/app_constants.dart';
import 'package:doit_app/models/user_model.dart';
import 'package:doit_app/screens/dashboard_screen.dart';
import 'package:doit_app/screens/login_screen.dart';
import 'package:doit_app/services/auth_services.dart';
import 'package:doit_app/services/users_services.dart';
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
  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  // Local UI state
  bool _obscurePassword = true;
  bool _isLoading = false;

  final AuthService _authService = AuthService();
  final UsersService _usersService = UsersService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  // Handles sign up button press
  Future<void> _handleSignUp() async {
    // Validate that all fields are filled
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _passwordConfirmController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate that password and confirmation match
    if (_passwordController.text != _passwordConfirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('As senhas não coincidem.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _authService.register(
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

      if (result.user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nao foi possivel criar a conta.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      User newUser = User(
        uid: result.user!.uid,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
      );

      await _usersService.createUser(newUser);

      if (!mounted) {
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
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppConstants.brandPurple,
                    ),
                    child: const Icon(
                      Icons.person_add_alt_1_rounded,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                ),

                // Title
                const SizedBox(height: 32),
                const CustomText(
                  text: 'Create Account',
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.left,
                  color: Colors.white,
                ),

                // Account form
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
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const CustomLabel(text: 'Confirm Password'),
                const SizedBox(height: 8),
                CustomTextfield(
                  controller: _passwordConfirmController,
                  hintText: 'Confirm your password',
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

                // Primary action button
                const SizedBox(height: 32),
                CustomButton(
                  text: _isLoading ? 'A criar conta...' : 'Sign Up',
                  onPressed: _isLoading ? null : _handleSignUp,
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
