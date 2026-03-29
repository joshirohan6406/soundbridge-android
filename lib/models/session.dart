import 'audio_mode.dart';

class Session {
  final String id;
  final String hostName;
  final String ip;
  final int audioPort;
  final int controlPort;
  final int httpPort;
  final AudioMode mode;
  final bool hasPassword;
  final DateTime startedAt;
  final bool nfcActive;

  Session({
    required this.id,
    required this.hostName,
    required this.ip,
    required this.audioPort,
    required this.controlPort,
    required this.httpPort,
    required this.mode,
    required this.hasPassword,
    required this.startedAt,
    this.nfcActive = false,
  });

  Session copyWith({AudioMode? mode, bool? nfcActive, bool? hasPassword}) {
    return Session(
      id: id,
      hostName: hostName,
      ip: ip,
      audioPort: audioPort,
      controlPort: controlPort,
      httpPort: httpPort,
      mode: mode ?? this.mode,
      hasPassword: hasPassword ?? this.hasPassword,
      startedAt: startedAt,
      nfcActive: nfcActive ?? this.nfcActive,
    );
  }

  Map<String, dynamic> toJson() => {
    'app': 'soundbridge',
    'v': '1',
    'ip': ip,
    'audioPort': audioPort,
    'controlPort': controlPort,
    'httpPort': httpPort,
    'sessionId': id,
    'hostName': hostName,
  };

  static Session fromJson(Map<String, dynamic> json) => Session(
    id: json['sessionId'] as String,
    hostName: json['hostName'] as String,
    ip: json['ip'] as String,
    audioPort: (json['audioPort'] as num).toInt(),
    controlPort: (json['controlPort'] as num).toInt(),
    httpPort: (json['httpPort'] as num).toInt(),
    mode: AudioMode.music,
    hasPassword: false,
    startedAt: DateTime.now(),
  );
}
