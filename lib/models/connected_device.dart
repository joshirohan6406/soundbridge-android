import 'join_method.dart';
import 'connection_status.dart';

class ConnectedDevice {
  final String id;
  final String displayName;
  final String ip;
  final JoinMethod joinMethod;
  final DateTime joinedAt;
  double volume;
  int delayOffsetMs;
  int latencyMs;
  ConnectionStatus status;
  final List<int> _latencyHistory = [];

  ConnectedDevice({
    required this.id,
    required this.displayName,
    required this.ip,
    required this.joinMethod,
    required this.joinedAt,
    this.volume = 1.0,
    this.delayOffsetMs = 0,
    this.latencyMs = 0,
    this.status = ConnectionStatus.connected,
  });

  void addLatency(int ms) {
    latencyMs = ms;
    _latencyHistory.add(ms);
    if (_latencyHistory.length > 30) {
      _latencyHistory.removeAt(0);
    }
  }

  List<int> get latencyHistory => List.unmodifiable(_latencyHistory);

  Map<String, dynamic> toJson() => {
    'id': id,
    'displayName': displayName,
    'ip': ip,
    'joinMethod': joinMethod.name,
    'latencyMs': latencyMs,
    'volume': volume,
    'status': status.name,
  };
}
