import 'dart:convert';
import 'package:crypto/crypto.dart';

class SessionPasswordService {
  static String hash(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  static bool verify(String input, String storedHash) {
    return hash(input) == storedHash;
  }
}
