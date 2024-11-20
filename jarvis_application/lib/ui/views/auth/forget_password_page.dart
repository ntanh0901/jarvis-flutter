import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jarvis_application/ui/widgets/custom_gradient_button.dart';

import '../../../core/utils/form_validators.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/text_form_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Scrollbar(
              thumbVisibility: false,
              child: SingleChildScrollView(
                child: Container(
                  width: isLargeScreen ? 600 : size.width,
                  padding: const EdgeInsets.all(30.0),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      const AppLogo(size: 24),
                      const SizedBox(height: 50),
                      Text(
                        'Forgot Password',
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Enter your email address and we\'ll send you a link to reset your password.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      // Forgot password form
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormFieldWidget(
                              label: 'Email',
                              controller: _emailController,
                              hintText: 'Enter your email to reset password',
                              validator: (value) {
                                return Validators.validateEmail(
                                  value: value,
                                );
                              },
                            ),
                            const SizedBox(height: 30),
                            // Reset password button
                            Row(
                              children: [
                                Expanded(
                                  child: GradientButton(
                                    child: const Text('Reset Password'),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        // Implement password reset logic
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: () {
                                GoRouter.of(context).go('/sign-in');
                              },
                              child: const Text(
                                'Back to Sign in',
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue,
                                ),
                              ),
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
        ),
      ),
    );
  }
}
