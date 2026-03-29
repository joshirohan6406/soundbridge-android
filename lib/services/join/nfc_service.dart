import 'dart:convert';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import '../../models/session.dart';
import 'join_service.dart';

class NfcService {
  static Future<bool> get isAvailable async {
    try {
      final availability = await FlutterNfcKit.nfcAvailability;
      return availability == NFCAvailability.available;
    } catch (_) {
      return false;
    }
  }

  /// Write session payload as NDEF Text Record (host mode).
  static Future<bool> writeSessionPayload(Session session) async {
    try {
      await FlutterNfcKit.poll(timeout: const Duration(seconds: 10));
      final payload = jsonEncode(session.toJson());
      await FlutterNfcKit.writeNDEFRecords([NDEFRecord.plain(payload)]);
      await FlutterNfcKit.finish();
      return true;
    } catch (_) {
      await FlutterNfcKit.finish();
      return false;
    }
  }

  /// Read NDEF payload and parse into Session (client mode).
  static Future<Session?> readSession() async {
    try {
      await FlutterNfcKit.poll(timeout: const Duration(seconds: 10));
      final records = await FlutterNfcKit.readNDEFRecords();
      await FlutterNfcKit.finish();
      for (final record in records) {
        final text = record.payload;
        if (text != null) {
          final session = JoinService.parsePayload(text);
          if (session != null) return session;
        }
      }
      return null;
    } catch (_) {
      await FlutterNfcKit.finish();
      return null;
    }
  }
}
