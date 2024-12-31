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

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 600;
    final authViewModel = ref.watch(authViewModelProvider.notifier);
    final authState = ref.watch(authViewModelProvider);

    return SafeArea(
      child: Scaffold(
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
                      _buildSignInForm(authViewModel, authState),
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
      ),
    );
  }

  Widget _buildSignInForm(
      AuthViewModel authViewModel, AsyncValue<void> authState) {
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
            isPasswordField: true,
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
            height: 50,
            child: GradientButton(
              onPressed: authState is AsyncLoading
                  ? null
                  : () => _handleSubmit(authViewModel),
              child: authState is AsyncLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : const Text('Sign in'),
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
      label: 'Sign in with Google',
      onPressed: () async {
        try {
          await authViewModel.signInWithGoogle();
          _showMessage('Sign in with Google successful', Colors.green);
        } catch (e) {
          _showMessage('Sign in with Google failed', Colors.red);
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
      final email = formData?['email'];
      final password = formData?['password'];

      await authViewModel.signIn(email, password);
      final errorMessage = authViewModel.errorMessage;
      if (errorMessage != null) {
        _showMessage(errorMessage, Colors.red);
      } else {
        context.go('/chat');
        // get curren user
        final user = await authViewModel.getCurrentUser();
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
