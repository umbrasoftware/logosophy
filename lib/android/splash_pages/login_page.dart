import 'package:flutter/material.dart';
import 'package:logosophy/gen/strings.g.dart';

import 'registration_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {}
  }

  void _loginWithGoogle() {}

  void _loginWithApple() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t.btnActions.logIn)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: textDecorator(t.btnActions.email),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return t.authMessages.prompt.askEmail;
                  }
                  if (!value.contains('@')) {
                    return t.authMessages.error.emailAddressInvalid;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: textDecorator(t.btnActions.password),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return t.authMessages.prompt.askPassword;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 64),
              ElevatedButton(
                onPressed: _login,
                child: Text(t.btnActions.logIn),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.g_mobiledata,
                ), // Replace with actual Google icon if available
                label: const Text(
                  'Login with Google',
                  style: TextStyle(color: Colors.black87),
                ),
                onPressed: _loginWithGoogle,
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.apple,
                ), // Replace with actual Apple icon if available
                label: const Text('Login with Apple'),
                onPressed: _loginWithApple,
                style: ElevatedButton.styleFrom(),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  );
                },
                child: Text(t.authMessages.prompt.dontHaveAccount),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration textDecorator(String hintText) {
    return InputDecoration(
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      filled: true,
      hintText: hintText,
    );
  }
}
