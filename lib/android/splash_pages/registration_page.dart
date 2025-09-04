import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logosophy/android/utils/auth_utils.dart';
import 'package:logosophy/gen/strings.g.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    // First, validate the form before proceeding.
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isLoading = true);

    // Use the static AuthUtils class and handle the result.
    final errorMessage = await AuthUtils.registerWithEmailAndPassword(
      _emailController.text,
      _passwordController.text,
    );

    // Check if the widget is still in the tree before updating the state.
    if (!mounted) return;

    setState(() => _isLoading = false);

    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } else {
      // Success: Show confirmation and navigate. You will need to add this key.
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.btnActions.registrationSuccess)));
      GoRouter.of(context).go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t.btnActions.register)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                    // Your translation file specifies 8 characters.
                    if (value.length < 8) {
                      return t.authMessages.error.passwordTooShort;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: textDecorator(
                    t.authMessages.prompt.retypePassword,
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return t.authMessages.prompt.retypePassword;
                    }
                    if (value != _passwordController.text) {
                      return t.authMessages.error.passwordMismatch;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text(t.btnActions.register),
                ),
                const SizedBox(height: 64),
                ElevatedButton.icon(
                  // Note: You'll need to add 'btnActions.registerWithGoogle' to your i18n files.
                  icon: const Icon(Icons.g_mobiledata),
                  label: Text(t.btnActions.registerWithGoogle),
                  onPressed: null,
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  // Note: You'll need to add 'btnActions.registerWithApple' to your i18n files.
                  icon: const Icon(Icons.apple),
                  label: Text(t.btnActions.registerWithApple),
                  onPressed: null,
                ),
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () => GoRouter.of(context).go('/login'),
                  child: Text(t.authMessages.prompt.alreadyHaveAccount),
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
