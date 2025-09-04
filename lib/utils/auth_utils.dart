import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';
import 'package:logosophy/gen/strings.g.dart';

class AuthUtils {
  static final logger = Logger('AuthUtils');

  /// Registers a user with email and password, then creates their profile.
  /// Returns `null` on success, or an error message string on failure.
  static Future<String?> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final res = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (res.user != null) {
        await createUserProfileInFirestore(res.user!);
        return null;
      }
      return t.authMessages.error.unknown;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        logger.info('The password provided is too weak.');
        return t.authMessages.error.weakPassword;
      } else if (e.code == 'email-already-in-use') {
        logger.info('The account already exists for that email.');
        return t.authMessages.error.emailExists;
      }
      logger.severe(
        'Unhandled FirebaseAuthException during registration: ${e.code}',
      );
      return t.authMessages.error.unknown;
    } catch (e) {
      logger.severe('Error occurred during registration: $e');
      return t.authMessages.error.unknown;
    }
  }

  static void registerWithGoogle() {}

  static void registerWithApple() {}

  /// Creates a user profile document in Firestore after registration.
  static Future<bool> createUserProfileInFirestore(User user) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final userRef = firestore.collection('users').doc(user.uid);

    final docSnapshot = await userRef.get();

    if (!docSnapshot.exists) {
      await userRef.set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });
      logger.info('Documents created for user with UID: ${user.uid}');
      return true;
    } else {
      logger.info('User document already exists for UID: ${user.uid}');
      return false;
      // Optional: you can update fields if desired
      // await userRef.update({'lastSignIn': FieldValue.serverTimestamp()});
    }
  }

  /// Signs in a user with their email and password.
  /// Returns `null` on success, or an error message string on failure.
  static Future<String?> signInWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      logger.warning('FirebaseAuthException during sign-in: ${e.code}');
      // 'invalid-credential' is the modern, more secure error code for wrong email/password.
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        return t.authMessages.error.invalidCredentials;
      }
      return t.authMessages.error.unknown;
    } catch (e) {
      logger.severe('Error occurred during sign-in: $e');
      return t.authMessages.error.unknown;
    }
  }

  /// Validates if the given string is a valid email address.
  static bool isEmailValid(String email) {
    return EmailValidator.validate(email);
  }
}
