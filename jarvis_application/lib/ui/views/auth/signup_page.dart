import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/form_validators.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/custom_divider.dart';
import '../../widgets/custom_gradient_button.dart';
import '../../widgets/google_auth_button.dart';
import '../../widgets/hover_text_button.dart';
import '../../widgets/text_form_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 600;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isLargeScreen
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
                )
              : null,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: isLargeScreen ? 600 : size.width,
              padding: EdgeInsets.symmetric(
                horizontal: isLargeScreen ? 70.0 : 40.0,
                vertical: 20.0,
              ),
              decoration: isLargeScreen
                  ? BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    )
                  : null,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const AppLogo(size: 24),
                  const SizedBox(height: 50),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormFieldWidget(
                          label: 'Username',
                          controller: _usernameController,
                          validator: (value) {
                            return Validators.validateUsername(
                              value: value,
                              customMessage: 'Please enter a valid username',
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormFieldWidget(
                          label: 'Email',
                          controller: _emailController,
                          validator: (value) {
                            return Validators.validateEmail(
                              value: value,
                              customMessage:
                                  'Please enter a valid email address',
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormFieldWidget(
                          label: 'Password',
                          controller: _passwordController,
                          obscureText: true,
                          validator: (value) {
                            return Validators.validatePassword(
                              value: value,
                              confirmPassword: _confirmPasswordController.text,
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormFieldWidget(
                          label: 'Confirm Password',
                          controller: _confirmPasswordController,
                          obscureText: true,
                          validator: (value) {
                            return Validators.validatePassword(
                              value: value,
                              confirmPassword: _passwordController.text,
                              customMessage: 'Passwords do not match',
                            );
                          },
                        ),
                        const SizedBox(height: 50),
                        SizedBox(
                          width: double.infinity,
                          child: GradientButton(
                            child: const Text('Sign up'),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Handle sign up logic
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'By continuing, you agree to our Terms of Service and Privacy Policy',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        _buildSignInRow(context),
                        const SizedBox(height: 15),
                        const SizedBox(height: 15),
                        const CustomDivider(middleText: 'or'),
                        const SizedBox(height: 15),
                        GoogleAuthButton(
                          label: 'Sign up with Google',
                          onPressed: () {
                            // Handle Google Sign Up
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account?",
          style: TextStyle(color: Colors.black),
        ),
        HoverTextButton(
          text: 'Sign in',
          onPressed: () {
            GoRouter.of(context).go('/sign-in');
          },
        ),
      ],
    );
  }
}
