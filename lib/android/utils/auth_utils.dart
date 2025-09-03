import 'package:email_validator/email_validator.dart';
import 'package:logging/logging.dart';
import 'package:logosophy/providers/database/database.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthUtils {
  final _logger = Logger('AuthUtils');

  Future<bool> registerWithEmail(String email, String password) async {
    final AuthResponse res = await supabase.client.auth.signUp(
      email: email,
      password: password,
    );

    return res.user != null;
  }

  void registerWithGoogle() {}

  void registerWithApple() {}

  bool isEmailValid(String email) {
    if (!EmailValidator.validate(email)) {
      return false;
    }
    return true;
  }
}
