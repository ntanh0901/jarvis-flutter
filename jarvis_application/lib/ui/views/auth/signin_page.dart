import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/containers.dart';
import '../../widgets/custom_divider.dart';
import '../../widgets/custom_gradient_button.dart';
import '../../widgets/google_auth_button.dart';
import '../../widgets/hover_text_button.dart';
import '../../widgets/text_form_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _submitted = false;

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
                    const SizedBox(height: 30),
                    const CustomDivider(middleText: 'or'),
                    const SizedBox(height: 20),
                    GoogleAuthButton(
                      label: 'Sign in with Google',
                      onPressed: () {
                        // Handle Google sign in logic
                      },
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
    return FormBuilder(
      key: _formKey,
      autovalidateMode:
          _submitted ? AutovalidateMode.always : AutovalidateMode.disabled,
      child: Column(
        children: [
          CustomFormBuilderTextField(
            name: 'email',
            label: 'Email',
            validators: [
              FormBuilderValidators.required(),
              FormBuilderValidators.email(),
            ],
          ),
          const SizedBox(height: 20),
          CustomFormBuilderTextField(
            name: 'password',
            label: 'Password',
            validators: [
              FormBuilderValidators.required(),
            ],
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
              onPressed: _handleSubmit,
              child: const Text('Sign in'),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmit() async {
    setState(() {
      _submitted = true;
    });

    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState?.value;
      final email = formData?['email'];
      final password = formData?['password'];

      try {
        await Provider.of<AuthProvider>(context, listen: false)
            .signIn(email, password);
        // Navigate to the home page or another page after successful sign-in
        context.go('/home');
      } catch (e) {
        // Handle sign-in error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign-in failed: $e')),
        );
      }
    }
  }
}
