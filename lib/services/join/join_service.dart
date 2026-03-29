import 'dart:convert';
import '../../models/session.dart';

class JoinService {
  /// Parses join payload from ANY source — QR, NFC, or deep link.
  /// All three produce the same JSON structure.
  static Session? parsePayload(String payload) {
    try {
      final json = jsonDecode(payload) as Map<String, dynamic>;
      if (json['app'] != 'soundbridge') return null;
      return Session.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  /// Parse deep link URI into session.
  /// Format: soundbridge://join?ip=...&ap=5555&cp=5556&hp=5557&s=...&h=...
  static Session? parseDeepLink(Uri uri) {
    try {
      final ip = uri.queryParameters['ip'] ?? '';
      final s = uri.queryParameters['s'] ?? '';
      final h = uri.queryParameters['h'] ?? '';
      final ap = int.tryParse(uri.queryParameters['ap'] ?? '') ?? 5555;
      final cp = int.tryParse(uri.queryParameters['cp'] ?? '') ?? 5556;
      final hp = int.tryParse(uri.queryParameters['hp'] ?? '') ?? 5557;
      if (ip.isEmpty || s.isEmpty) return null;
      return Session.fromJson({
        'ip': ip,
        'audioPort': ap,
        'controlPort': cp,
        'httpPort': hp,
        'sessionId': s,
        'hostName': h,
      });
    } catch (_) {
      return null;
    }
  }

  /// Build deep link URL from session.
  static String buildDeepLink(Session session) {
    return 'soundbridge://join'
        '?ip=${session.ip}'
        '&ap=${session.audioPort}'
        '&cp=${session.controlPort}'
        '&hp=${session.httpPort}'
        '&s=${session.id}'
        '&h=${Uri.encodeComponent(session.hostName)}';
  }
}
