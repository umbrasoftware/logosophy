import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/stream/chacha20.dart';

/// Class responsible for holding and authenticating user credentials.
/// It encrypts and decrypts text using the credentials.
class EncryptionUtils {
  static final EncryptionUtils _instance = EncryptionUtils._internal();
  EncryptionUtils._internal();

  final _logger = Logger('Encryption');
  final chacha = ChaCha20Engine();

  /// The user encrypted DEK (Data Encryption Key) key.
  late Uint8List encryptionKey;

  factory EncryptionUtils() {
    return _instance;
  }

  Future<void> loadEncryptionKey() async {
    final storage = FlutterSecureStorage();
    String? key = await storage.read(key: 'encryptionKey');

    if (key == null) {
      _logger.info('Encryption key not found. Fetching from Secret Manager');

      key = await callGetAndroidKey();

      if (key != null) {
        _logger.info('Got key from cloud function.');
        await storage.write(key: 'encryptionKey', value: key);
        encryptionKey = base64.decode(key);
      } else {
        _logger.shout('Failed to get key from cloud function.');
      }
    } else {
      _logger.info('Got key from secure storage.');
      encryptionKey = base64.decode(key);
    }
  }

  /// Calls the 'getAndroidKey' callable Cloud Function.
  /// The Firebase SDK automatically handles App Check and Auth tokens.
  Future<String?> callGetAndroidKey() async {
    try {
      final callable = FirebaseFunctions.instance.httpsCallable(
        'getAndroidKey',
      );
      final result = await callable.call();
      final data = result.data as Map<String, dynamic>?;
      final key = data?['data'] as String?;
      _logger.info('Successfully called getAndroidKey function.');
      return key;
    } on FirebaseFunctionsException catch (e) {
      _logger.shout('FirebaseFunctionsException: ${e.code} - ${e.message}');
    } catch (e) {
      _logger.shout('Generic error calling getAndroidKey: $e');
    }
    return null;
  }

  /// Encrypts the given plaintext.
  /// Returns the encrypted text as a base64 string.
  /// The result is a concatenation of the 8-byte iv and the ciphertext.
  String? encrypt(String plainText) {
    try {
      final plainTextBytes = utf8.encode(plainText);
      final iv = generateRandomBytes(8); // 64-bit nonce

      chacha.init(
        true, // for encryption
        ParametersWithIV<KeyParameter>(KeyParameter(encryptionKey), iv),
      );

      final cipherText = Uint8List(plainTextBytes.length);
      chacha.processBytes(
        plainTextBytes,
        0,
        plainTextBytes.length,
        cipherText,
        0,
      );

      final encryptedBytes = Uint8List.fromList(iv + cipherText);
      return base64.encode(encryptedBytes);
    } catch (e) {
      _logger.shout('Encryption failed: $e');
      return null;
    }
  }

  /// Decrypts the given base64 encrypted text.
  /// The input is expected to be a concatenation of the 8-byte iv and the ciphertext.
  String? decrypt(String? encryptedText) {
    if (encryptedText == null) return null;

    try {
      final encryptedBytes = base64.decode(encryptedText);
      final iv = encryptedBytes.sublist(0, 8);
      final cipherText = encryptedBytes.sublist(8);

      chacha.init(
        false, // for decryption
        ParametersWithIV<KeyParameter>(KeyParameter(encryptionKey), iv),
      );

      final decryptedBytes = Uint8List(cipherText.length);
      chacha.processBytes(cipherText, 0, cipherText.length, decryptedBytes, 0);

      return utf8.decode(decryptedBytes);
    } catch (e) {
      _logger.shout('Decryption failed: $e');
      return null;
    }
  }

  /// Generate a list of random bytes of 8-bit unsigned integers.
  Uint8List generateRandomBytes(int length) {
    final random = Random.secure();
    return Uint8List.fromList(
      List<int>.generate(length, (_) => random.nextInt(256)),
    );
  }
}
