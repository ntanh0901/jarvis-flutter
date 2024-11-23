import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/containers.dart';
import '../../widgets/custom_divider.dart';
import '../../widgets/custom_gradient_button.dart';
import '../../widgets/google_auth_button.dart';
import '../../widgets/hover_text_button.dart';
import '../../widgets/text_form_field.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 600;
    final authViewModel = ref.watch(authViewModelProvider.notifier);

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
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.black),
                        ),
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
    final authViewModel = ref.watch(authViewModelProvider.notifier);
    final authState = ref.watch(authViewModelProvider);

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
              FormBuilderValidators.required(),
            ],
          ),
          const SizedBox(height: 20),
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
            isPasswordField: true,
            validators: [
              FormBuilderValidators.required(),
            ],
          ),
          const SizedBox(height: 30),
          CustomFormBuilderTextField(
            name: 're-password',
            label: 'Confirm password',
            isPasswordField: true,
            validators: [
              FormBuilderValidators.required(),
              (val) {
                if (val != null &&
                    val != _formKey.currentState?.fields['password']?.value) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: GradientButton(
              onPressed: authState is AsyncLoading
                  ? null
                  : () => _handleSubmit(authViewModel),
              child: authState is AsyncLoading
                  ? const CircularProgressIndicator()
                  : const Text('Sign up'),
            ),
          ),
          const SizedBox(height: 30),
          const CustomDivider(middleText: 'or'),
          const SizedBox(height: 20),
          _buildGoogleSignInButton(authViewModel),
        ],
      ),
    );
  }

  Widget _buildGoogleSignInButton(AuthViewModel authViewModel) {
    return GoogleAuthButton(
      label: 'Sign up with Google',
      onPressed: () async {
        try {
          await authViewModel.googleSignIn();
          _showMessage('Sign up with Google successful', Colors.green);
          context.go('/chat');
        } catch (e) {
          _showMessage('Sign up with Google failed', Colors.red);
        }
      },
    );
  }

  void _handleSubmit(AuthViewModel authViewModel) async {
    setState(() {
      _submitted = true;
    });

    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState?.value;
      final username = formData?['username'];
      final email = formData?['email'];
      final password = formData?['password'];

      try {
        await authViewModel.signUp(username, email, password);
        final errorMessage = authViewModel.errorMessage;
        if (errorMessage != null) {
          _showMessage(errorMessage, Colors.red);
        } else {
          _showMessage('Sign up successful', Colors.green);
          context.go('/chat');
        }
      } catch (e) {
        _showMessage('Sign up failed', Colors.red);
      } finally {
        setState(() {
          _submitted = false;
        });
      }
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
