import 'join_method.dart';
import 'audio_mode.dart';

class SessionHistoryEntry {
  final String id;
  final String hostName;
  final DateTime date;
  final Duration duration;
  final AudioMode mode;
  final int avgLatencyMs;
  final JoinMethod joinMethod;

  SessionHistoryEntry({
    required this.id,
    required this.hostName,
    required this.date,
    required this.duration,
    required this.mode,
    required this.avgLatencyMs,
    required this.joinMethod,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'hostName': hostName,
    'date': date.toIso8601String(),
    'durationSeconds': duration.inSeconds,
    'mode': mode.name,
    'avgLatencyMs': avgLatencyMs,
    'joinMethod': joinMethod.name,
  };

  static SessionHistoryEntry fromJson(Map<String, dynamic> json) =>
      SessionHistoryEntry(
        id: json['id'] as String,
        hostName: json['hostName'] as String,
        date: DateTime.parse(json['date'] as String),
        duration: Duration(seconds: (json['durationSeconds'] as num).toInt()),
        mode: AudioMode.fromName(json['mode'] as String),
        avgLatencyMs: (json['avgLatencyMs'] as num).toInt(),
        joinMethod: JoinMethod.values.firstWhere(
          (j) => j.name == json['joinMethod'],
          orElse: () => JoinMethod.qr,
        ),
      );
}
