import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _submitted = false;
  bool _isLoading = false;

  @override
  build(BuildContext context) {
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
                    _buildSignUpForm(),
                    const SizedBox(height: 30),
                    const CustomDivider(middleText: 'or'),
                    const SizedBox(height: 20),
                    GoogleAuthButton(
                      label: 'Sign up with Google',
                      onPressed: () {
                        // Handle Google sign-up logic
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?'),
                        HoverTextButton(
                          text: 'Sign In',
                          onPressed: () => context.go('/sign-in'),
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

  Widget _buildSignUpForm() {
    return FormBuilder(
      key: _formKey,
      autovalidateMode:
          _submitted ? AutovalidateMode.always : AutovalidateMode.disabled,
      child: Column(
        children: [
          CustomFormBuilderTextField(
              name: 'username',
              label: 'Username',
              validators: [
                FormBuilderValidators.required(
                    errorText: 'Please enter a username'),
                FormBuilderValidators.minLength(3),
                FormBuilderValidators.maxLength(20),
                FormBuilderValidators.match(RegExp(r'^[a-zA-Z0-9]+$'),
                    errorText: 'No special characters allowed'),
              ]),
          const SizedBox(height: 20),
          CustomFormBuilderTextField(
              name: 'email',
              label: 'Email',
              validators: [
                FormBuilderValidators.required(
                    errorText: 'Please enter an email'),
                FormBuilderValidators.email(),
              ]),
          const SizedBox(height: 20),
          CustomFormBuilderTextField(
              name: 'password',
              label: 'Password',
              isPasswordField: true,
              validators: [
                FormBuilderValidators.required(
                    errorText: 'Please enter a password'),
                FormBuilderValidators.minLength(8),
                FormBuilderValidators.match(RegExp(r'(?=.*[A-Z])'),
                    errorText:
                        'Password must contain at least one uppercase letter'),
                FormBuilderValidators.match(RegExp(r'(?=.*[a-z])'),
                    errorText:
                        'Password must contain at least one lowercase letter'),
                FormBuilderValidators.match(RegExp(r'(?=.*\d)'),
                    errorText: 'Password must contain at least one number'),
                FormBuilderValidators.match(RegExp(r'(?=.*[@$!%*?&])'),
                    errorText:
                        'Password must contain at least one special character'),
              ]),
          const SizedBox(height: 20),
          CustomFormBuilderTextField(
              name: 're-password',
              label: 'Confirm password',
              isPasswordField: true,
              validators: [
                FormBuilderValidators.required(),
                (value) {
                  if (value !=
                      _formKey.currentState?.fields['password']?.value) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ]),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: GradientButton(
              onPressed: _isLoading ? null : () => _handleSubmit(),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Sign up'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      String name, String label, List<String? Function(String?)> validators) {
    return CustomFormBuilderTextField(
      name: name,
      label: label,
      validators: validators,
    );
  }

  void _handleSubmit() async {
    setState(() {
      _submitted = true;
    });

    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final formData = _formKey.currentState?.value;
      final username = formData?['username'];
      final email = formData?['email'];
      final password = formData?['password'];

      final success = await authProvider.signUp(username, email, password);

      if (success) {
        _showMessage('Sign-up successful and logged in', Colors.green);
        context.go('/chat');
      } else {
        _showMessage(authProvider.errorMessage ?? 'Sign-up failed', Colors.red);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showMessage(String message, Color backgroundColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
