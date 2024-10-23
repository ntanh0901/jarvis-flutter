import 'package:flutter/material.dart';
import 'package:jarvis_application/widgets/custom_gradient_button.dart';
import 'package:jarvis_application/widgets/custom_input_decorator.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

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
            child: Center(
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
                        // Logo
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: AssetImage('assets/app_circle_icon.png'),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Jarvis',
                              style: TextStyle(
                                fontSize: 30,
                                color: Color(0xff1450a3),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Email',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  const SizedBox(height: 5),
                                  TextFormField(
                                    decoration: CustomInputDecorator.baseDecoration,
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email address';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              // Reset password button
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomGradientButton(
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Remember your password?",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Sign in',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
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
      ),
    );
  }
}
