// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logosophy/gen/strings.g.dart';
import 'package:logosophy/utils/auth_utils.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    // First, validate the form before proceeding.
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isLoading = true);

    // Use the static AuthUtils class and handle the result.
    final errorMessage = await AuthUtils.signInWithEmailAndPassword(
      _emailController.text,
      _passwordController.text,
    );

    // Check if the widget is still in the tree before updating the state.
    if (!mounted) return;

    setState(() => _isLoading = false);

    if (errorMessage != null) {
      await AuthUtils().loadDocuments(ref);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t.btnActions.logIn)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Use SingleChildScrollView to prevent overflow when the keyboard appears.
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: textDecorator(t.btnActions.email),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return t.authMessages.prompt.askEmail;
                    }
                    if (!AuthUtils.isEmailValid(value)) {
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
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text(t.btnActions.logIn),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.g_mobiledata,
                  ), // Replace with actual Google icon if available
                  label: Text(
                    t.btnActions.registerWithGoogle,
                    style: TextStyle(color: Colors.black87),
                  ),
                  onPressed: null,
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.apple,
                  ), // Replace with actual Apple icon if available
                  label: Text(t.btnActions.registerWithApple),
                  onPressed: null,
                  style: ElevatedButton.styleFrom(),
                ),
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () => GoRouter.of(context).go('/register'),
                  child: Text(t.authMessages.prompt.dontHaveAccount),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration textDecorator(String labelText) {
    return InputDecoration(
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      filled: true,
      labelText: labelText,
    );
  }
}
