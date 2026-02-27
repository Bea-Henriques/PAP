import 'package:doit_app/screens/home_screen.dart';
import 'package:doit_app/screens/login_screen.dart';
import 'package:doit_app/services/auth_services.dart';
import 'package:doit_app/services/users_services.dart';
import 'package:doit_app/widgets/custom_button.dart';
import 'package:doit_app/widgets/custom_label.dart';
import 'package:doit_app/widgets/custom_text.dart';
import 'package:doit_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

/// Sign up screen for new user registration
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Text field controllers
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Password visibility state
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Background gradient
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo/Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade500.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.check_circle_outline,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 32),

                  // Title
                  CustomText(
                    text: 'Bem-vindo',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800
                  ),
                  SizedBox(height: 8),
                  CustomText(
                    text: 'Crie uma conta para começar',
                    fontSize: 14,
                    color: Colors.blue.shade800
                  ),
                  SizedBox(height: 32),

                  // Username Field
                  CustomLabel(text: 'Username'),
                  SizedBox(height: 8),
                  CustomTextfield(
                    controller: _usernameController,
                    hintText: 'Insira o seu username',
                    prefixIcon: Icons.person,
                  ),
                  SizedBox(height: 24),

                  // Email Field
                  CustomLabel(text: 'Email'),
                  SizedBox(height: 8),
                  CustomTextfield(
                    controller: _emailController,
                    hintText: 'Insira o seu email',
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 24),

                  // Password Field
                  CustomLabel(text: 'Password'),
                  SizedBox(height: 8),
                  CustomTextfield(
                    controller: _passwordController,
                    hintText: 'Insira a sua password',
                    prefixIcon: Icons.lock,
                    obscureText: _obscurePassword,
                    sufixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.blue.shade500,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 32),

                  // Sign Up Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: CustomButton(
                      onPressed: _handleSignUp,
                      text: 'Criar Conta',
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: 'Já tem uma conta? ',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueGrey[600]
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: CustomText(
                          text: 'Inicie sessão',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Handles sign up button press
  Future<void> _handleSignUp() async {
    // Validate that all fields are filled
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, preencha todos os campos.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Register user with Firebase Auth
    final result = await AuthService().register(
      _emailController.text,
      _passwordController.text,
    );

    // If registration successful, create user document and navigate
    if (result.user != null) {
      await UsersService().createUser(
        result.user!.uid,
        _usernameController.text,
        _emailController.text,
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
      return;
    }

    // Show error message when registration fails
    if (result.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
