import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/session_history_entry.dart';

class HistoryService {
  static const _key = 'session_history';

  static Future<List<SessionHistoryEntry>> getAll() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getStringList(_key) ?? [];
    return raw
        .map((s) {
          try {
            return SessionHistoryEntry.fromJson(
              jsonDecode(s) as Map<String, dynamic>,
            );
          } catch (_) {
            return null;
          }
        })
        .whereType<SessionHistoryEntry>()
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  static Future<void> add(SessionHistoryEntry entry) async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getStringList(_key) ?? [];
    raw.insert(0, jsonEncode(entry.toJson()));
    if (raw.length > 50) raw.removeLast();
    await p.setStringList(_key, raw);
  }

  static Future<void> clear() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_key);
  }
}
