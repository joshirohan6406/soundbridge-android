import 'dart:convert';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/ndef.dart' as ndef;
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

  /// Read NDEF payload and parse into Session (client mode).
  static Future<Session?> readSession() async {
    try {
      await FlutterNfcKit.poll(timeout: const Duration(seconds: 10));
      final records = await FlutterNfcKit.readNDEFRecords();
      await FlutterNfcKit.finish();
      for (final record in records) {
        if (record is ndef.TextRecord) {
          final text = record.text;
          if (text != null) {
            final session = JoinService.parsePayload(text);
            if (session != null) return session;
          }
        }
      }
      return null;
    } catch (_) {
      try {
        await FlutterNfcKit.finish();
      } catch (_) {}
      return null;
    }
  }

  /// Write session payload as NDEF Text Record (host mode).
  static Future<bool> writeSessionPayload(Session session) async {
    try {
      await FlutterNfcKit.poll(timeout: const Duration(seconds: 10));
      final payload = jsonEncode(session.toJson());
      await FlutterNfcKit.writeNDEFRecords([
        ndef.TextRecord(text: payload, language: 'en'),
      ]);
      await FlutterNfcKit.finish();
      return true;
    } catch (_) {
      try {
        await FlutterNfcKit.finish();
      } catch (_) {}
      return false;
    }
  }
}
