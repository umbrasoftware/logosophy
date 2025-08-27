import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement Supabase registration logic
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
      // Example: final response = await supabase.auth.signUp(email: _emailController.text, password: _passwordController.text);
      // Handle response
    }
  }

  void _registerWithGoogle() {
    // TODO: Implement Google Sign-Up
    print('Register with Google');
  }

  void _registerWithApple() {
    // TODO: Implement Apple Sign-Up
    print('Register with Apple');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 64),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.g_mobiledata,
                ), // Replace with actual Google icon if available
                label: const Text(
                  'Register with Google',
                  style: TextStyle(color: Colors.black87),
                ),
                onPressed: _registerWithGoogle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white70,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.apple,
                ), // Replace with actual Apple icon if available
                label: const Text(
                  'Register with Apple',
                  style: TextStyle(color: Colors.black87),
                ),
                onPressed: _registerWithApple,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white70,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Go back to LoginPage
                },
                child: const Text(
                  'Already have an account? Login',
                  style: TextStyle(color: Colors.deepOrange),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
