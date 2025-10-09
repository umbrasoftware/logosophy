import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:logosophy/database/annotations/annotations_provider.dart';
import 'package:logosophy/database/notes/notes_provider.dart';
import 'package:logosophy/gen/strings.g.dart';
import 'package:logosophy/utils/pdf_utils.dart';

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
        final success = await createUserProfileInFirestore(res.user!);
        return success ? null : t.authMessages.error.unknown;
      }
      return t.authMessages.error.unknown;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          logger.info('The password provided is too weak.');
          return t.authMessages.error.weakPassword;
        case 'email-already-in-use':
          logger.info('The account already exists for that email.');
          return t.authMessages.error.emailExists;
        default:
          logger.severe(
            'Unhandled FirebaseAuthException during registration: ${e.code}',
          );
          return t.authMessages.error.unknown;
      }
    } catch (e) {
      logger.severe('Error occurred during registration: $e');
      return t.authMessages.error.unknown;
    }
  }

  static void registerWithGoogle() {}

  static void registerWithApple() {}

  static Future<bool> createUserProfileInFirestore(User user) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final userRef = firestore.collection('users').doc(user.uid);
    final docSnapshot = await userRef.get();

    if (!docSnapshot.exists) {
      try {
        final batch = firestore.batch();

        batch.set(userRef, <String, dynamic>{
          'uid': user.uid,
          'email': user.email,
          'displayName': user.displayName ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        });

        final userDataCollectionRef = userRef.collection('userData');
        final annotationsRef = userDataCollectionRef.doc('annotations');
        batch.set(annotationsRef, bookInitMapFirebase);

        final notesRef = userDataCollectionRef.doc('notes');
        batch.set(notesRef, <String, dynamic>{});

        await batch.commit();
        logger.info('User profile and data created for UID: ${user.uid}');
        return true;
      } catch (e) {
        logger.severe('Failed to create user profile for ${user.uid}: $e');
        return false;
      }
    } else {
      logger.info('User document already exists for UID: ${user.uid}');
      return false;
    }
  }

  /// Signs in a user with their email and password.
  /// Returns `null` on success, or an error message string on failure.
  static Future<String?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
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

  Future<void> loadDocuments(WidgetRef ref) async {
    final annoProvider = ref.read(annotationsProvider.notifier);
    final notesNotifier = ref.read(notesProvider.notifier);

    await annoProvider.getDocument();
    await notesNotifier.getDocument();
  }
}
