import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/app_logo.dart';
import '../../widgets/containers.dart';
import '../../widgets/custom_divider.dart';
import '../../widgets/custom_gradient_button.dart';
import '../../widgets/hover_text_button.dart';
import '../../widgets/text_form_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
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
                    const SizedBox(height: 50),
                    Text(
                      'Forgot Password?',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Enter your email address and we\'ll send you a link to reset your password.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    _buildForgotPasswordForm(context),
                    const SizedBox(height: 30),
                    const CustomDivider(middleText: 'or'),
                    const SizedBox(height: 20),
                    HoverTextButton(
                      text: 'Back to Sign In',
                      onPressed: () => context.go('/sign-in'),
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

  Widget _buildForgotPasswordForm(BuildContext context) {
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
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: GradientButton(
              onPressed: _handleSubmit,
              child: const Text('Reset Password'),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmit() {
    setState(() {
      _submitted = true;
    });

    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState?.value;
      final email = formData?['email'];

      // Handle the password reset logic here.
      debugPrint('Email: $email');
    }
  }
}
