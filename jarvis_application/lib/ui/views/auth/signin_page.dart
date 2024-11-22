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

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _submitted = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 600;
    final authProvider = Provider.of<AuthProvider>(context);

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
                    _buildSignInForm(authProvider),
                    const SizedBox(height: 30),
                    const CustomDivider(middleText: 'or'),
                    const SizedBox(height: 20),
                    GoogleAuthButton(
                      label: 'Sign in with Google',
                      onPressed: () {
                        // Handle Google sign-in logic
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

  Widget _buildSignInForm(AuthProvider authProvider) {
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
              onPressed: _isLoading ? null : () => _handleSubmit(context),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Sign in'),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmit(BuildContext context) async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Check if the form is valid
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState?.value;
      final email = formData?['email'];
      final password = formData?['password'];

      // Use AuthProvider's signIn method to log in the user
      final signInSuccess = await authProvider.signIn(email, password);

      // Handle the response from the AuthProvider
      if (signInSuccess) {
        _showMessage('Sign in successful', Colors.green);
        context.go('/chat'); // Redirect to chat page
      } else {
        _showMessage(authProvider.errorMessage ?? 'Sign in failed', Colors.red);
      }
    }
    setState(() {
      _isLoading = false;
    });
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
