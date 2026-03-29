import 'dart:async';
import '../../../core/constants.dart';

class NetworkMonitor {
  final List<int> _latencyHistory = [];
  int _latencyMs = 0;
  int _jitterMs = 0;
  Timer? _reportTimer;

  void Function(int latencyMs, int jitterMs)? onStats;

  int get latencyMs => _latencyMs;
  int get jitterMs => _jitterMs;

  String get qualityLabel {
    if (_latencyMs < 80) return 'Excellent';
    if (_latencyMs < 150) return 'Good';
    if (_latencyMs < 250) return 'Fair';
    return 'Poor';
  }

  void recordPacket(int sentAtUs, int receivedAtUs) {
    final latency = ((receivedAtUs - sentAtUs) ~/ 1000).abs();
    _latencyMs = latency;
    _latencyHistory.add(latency);
    if (_latencyHistory.length > 30) {
      _latencyHistory.removeAt(0);
    }
    _computeJitter();
  }

  void _computeJitter() {
    if (_latencyHistory.length < 2) return;
    int sum = 0;
    for (int i = 1; i < _latencyHistory.length; i++) {
      sum += (_latencyHistory[i] - _latencyHistory[i - 1]).abs();
    }
    _jitterMs = sum ~/ (_latencyHistory.length - 1);
  }

  void startReporting(
      void Function(Map<String, dynamic>) send, String deviceId) {
    _reportTimer?.cancel();
    _reportTimer = Timer.periodic(
      Duration(seconds: SBConstants.pingIntervalSeconds),
      (_) => send({
        'type': SBConstants.msgLatencyReport,
        'deviceId': deviceId,
        'latencyMs': _latencyMs,
        'jitterMs': _jitterMs,
      }),
    );
  }

  void stop() {
    _reportTimer?.cancel();
    _latencyHistory.clear();
    _latencyMs = 0;
    _jitterMs = 0;
  }
}
