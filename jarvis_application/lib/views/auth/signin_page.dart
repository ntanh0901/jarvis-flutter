import 'package:flutter/material.dart';
import 'package:jarvis_application/views/auth/forget_password_page.dart';
import 'package:jarvis_application/views/auth/signup_page.dart';
import 'package:jarvis_application/widgets/custom_gradient_button.dart';
import 'package:jarvis_application/widgets/custom_input_decorator.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscured = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                            color: Colors.white.withOpacity(0.5),
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
                    const SizedBox(height: 30),
                    const _AppLogo(),
                    const SizedBox(height: 30),
                    _SignInForm(
                      formKey: _formKey,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      isObscured: _isObscured,
                      toggleObscured: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
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
}

class _AppLogo extends StatelessWidget {
  const _AppLogo();

  @override
  Widget build(BuildContext context) {
    return const Row(
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
    );
  }
}

class _SignInForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isObscured;
  final VoidCallback toggleObscured;

  const _SignInForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isObscured,
    required this.toggleObscured,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _EmailInput(controller: emailController),
          const SizedBox(height: 20),
          _PasswordInput(
            controller: passwordController,
            isObscured: isObscured,
            toggleObscured: toggleObscured,
          ),
          _ForgotPasswordButton(),
          const SizedBox(height: 30),
          _SignInButton(formKey: formKey),
          const SizedBox(height: 20),
          _SignUpPrompt(),
          const SizedBox(height: 20),
          const _OrDivider(),
          const SizedBox(height: 20),
          _GoogleSignInButton(),
        ],
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  final TextEditingController controller;

  const _EmailInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email',
          style: TextStyle(color: Colors.black),
        ),
        const SizedBox(height: 5),
        TextFormField(
          decoration: CustomInputDecorator.baseDecoration,
          controller: controller,
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }
}

class _PasswordInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isObscured;
  final VoidCallback toggleObscured;

  const _PasswordInput({
    required this.controller,
    required this.isObscured,
    required this.toggleObscured,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(color: Colors.black),
        ),
        const SizedBox(height: 5),
        TextFormField(
          obscureText: isObscured,
          controller: controller,
          decoration: CustomInputDecorator.baseDecoration.copyWith(
            suffixIcon: IconButton(
              icon: Icon(
                isObscured ? Icons.visibility_off : Icons.visibility,
                color: Colors.black54,
              ),
              onPressed: toggleObscured,
            ),
          ),
        ),
      ],
    );
  }
}

class _ForgotPasswordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ForgotPasswordPage()),
            );
          },
          child: const Text(
            'Forgot Password?',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _SignInButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const _SignInButton({required this.formKey});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomGradientButton(
        child: const Text('Sign In'),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            // Handle sign in logic
          }
        },
      ),
    );
  }
}

class _SignUpPrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(color: Colors.black),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SignupPage()),
            );
          },
          child: const Text(
            'Sign up',
            style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Divider(
            color: Color(0xffd9dade),
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'or',
            style: TextStyle(color: Colors.black),
          ),
        ),
        Expanded(
          child: Divider(
            color: Color(0xffd9dade),
            thickness: 1,
          ),
        ),
      ],
    );
  }
}

class _GoogleSignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // Handle Google Sign In
      },
      icon: Image.asset(
        'assets/google_icon.png',
        height: 24,
        width: 24,
      ),
      label: const Text(
        'Sign in with Google',
        style: TextStyle(color: Colors.black87),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
      ),
    );
  }
}
