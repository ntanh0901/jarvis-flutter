import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/app_logo.dart';
import '../../widgets/containers.dart';
import '../../widgets/custom_divider.dart';
import '../../widgets/custom_gradient_button.dart';
import '../../widgets/google_auth_button.dart';
import '../../widgets/hover_text_button.dart';
import '../../widgets/text_form_field.dart';

class SignInPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 600;

    return Scaffold(
      body: GradientContainer(
        isLargeScreen: isLargeScreen,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: CardContainer(
                isLargeScreen: isLargeScreen,
                width: isLargeScreen ? 600 : size.width,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 40.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    const AppLogo(size: 24),
                    const SizedBox(height: 70),
                    _buildSignInForm(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormFieldWidget(
            label: 'Email',
            controller: _emailController,
          ),
          const SizedBox(height: 20),
          TextFormFieldWidget(
            label: 'Password',
            controller: _passwordController,
            obscureText: true,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: HoverTextButton(
              text: 'Forgot Password?',
              onPressed: () => context.go('/forgot-password'),
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: GradientButton(
              child: const Text('Sign in'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Handle sign in logic
                }
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Don't have an account?",
                style: TextStyle(color: Colors.black),
              ),
              HoverTextButton(
                text: 'Sign Up',
                onPressed: () => context.go('/sign-up'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const CustomDivider(middleText: 'or'),
          const SizedBox(height: 20),
          GoogleAuthButton(
            label: 'Sign in with Google',
            onPressed: () {
              // Handle Google Sign In
            },
          ),
        ],
      ),
    );
  }
}
