import 'dart:convert';
import '../../models/session.dart';
import 'join_service.dart';

class QrService {
  /// Build QR payload string from session.
  static String buildPayload(Session session) {
    return jsonEncode(session.toJson());
  }

  /// Parse QR scanned string into Session.
  static Session? parseScannedValue(String value) {
    return JoinService.parsePayload(value);
  }
}
