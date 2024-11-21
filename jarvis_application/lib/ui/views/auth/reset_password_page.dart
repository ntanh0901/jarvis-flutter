import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/app_logo.dart';
import '../../widgets/custom_gradient_button.dart';
import '../../widgets/hover_text_button.dart';
import '../../widgets/text_form_field.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _submitted = false;

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
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: isLargeScreen ? 600 : size.width,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 40.0,
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
                  children: [
                    const SizedBox(height: 50),
                    const AppLogo(size: 24),
                    const SizedBox(height: 50),
                    Text(
                      'Reset Password',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF757575),
                              ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Reset your password to get access to your account.',
                    ),
                    const SizedBox(height: 20),
                    FormBuilder(
                      key: _formKey,
                      autovalidateMode: _submitted
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 30),
                          CustomFormBuilderTextField(
                            name: 'newPassword',
                            label: 'New Password',
                            validators: [
                              FormBuilderValidators.required(),
                              FormBuilderValidators.minLength(8),
                              FormBuilderValidators.match(
                                  RegExp(r'(?=.*[A-Z])'),
                                  errorText:
                                      'Password must contain at least one uppercase letter'),
                              FormBuilderValidators.match(
                                  RegExp(r'(?=.*[a-z])'),
                                  errorText:
                                      'Password must contain at least one lowercase letter'),
                              FormBuilderValidators.match(RegExp(r'(?=.*\d)'),
                                  errorText:
                                      'Password must contain at least one number'),
                              FormBuilderValidators.match(
                                  RegExp(r'(?=.*[@$!%*?&])'),
                                  errorText:
                                      'Password must contain at least one special character'),
                            ],
                          ),
                          const SizedBox(height: 30),
                          CustomFormBuilderTextField(
                            name: 'confirmPassword',
                            label: 'Confirm New Password',
                            validators: [
                              FormBuilderValidators.required(),
                              (value) {
                                if (value !=
                                    _formKey.currentState?.fields['password']
                                        ?.value) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ],
                          ),
                          const SizedBox(height: 30),
                          GradientButton(
                            onPressed: _handleSubmit,
                            child: const Text('Reset Password'),
                          ),
                          const SizedBox(height: 20),
                          HoverTextButton(
                              text: 'Back to Sign In',
                              onPressed: () => context.go('/sign-in')),
                        ],
                      ),
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

  void _handleSubmit() {
    setState(() {
      _submitted = true;
    });

    if (_formKey.currentState?.saveAndValidate() ?? false) {
      // TODO: Implement actual password reset logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password has been reset')),
      );
      // Navigate to login page after successful reset
      context.go('/sign-in');
    }
  }
}
