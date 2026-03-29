import 'dart:collection';
import '../../../models/audio_packet.dart';

class JitterBuffer {
  final int targetDepthMs;
  final int maxDepthMs;
  final int minDepthMs;

  final SplayTreeMap<int, AudioPacket> _buffer = SplayTreeMap();
  int _lastPlayedSeq = -1;
  int _adaptiveDepthMs;

  JitterBuffer({
    required this.targetDepthMs,
    required this.maxDepthMs,
    required this.minDepthMs,
  }) : _adaptiveDepthMs = targetDepthMs;

  int get size => _buffer.length;
  int get adaptiveDepthMs => _adaptiveDepthMs;

  void insert(AudioPacket packet) {
    _buffer[packet.sequenceNumber] = packet;
  }

  /// Get next packet ready for playback based on current time.
  AudioPacket? dequeue(int nowUs) {
    if (_buffer.isEmpty) return null;
    final firstKey = _buffer.firstKey()!;
    final packet = _buffer[firstKey]!;
    final scheduledUs = packet.timestampUs;
    final bufferUs = _adaptiveDepthMs * 1000;

    if (nowUs >= scheduledUs - bufferUs) {
      _buffer.remove(firstKey);
      _lastPlayedSeq = packet.sequenceNumber;
      return packet;
    }
    return null;
  }

  /// Drop packets older than max depth.
  void dropStale(int nowUs) {
    final cutoff = nowUs - (maxDepthMs * 1000);
    final staleKeys =
        _buffer.keys.where((k) => (_buffer[k]!.timestampUs) < cutoff).toList();
    for (final k in staleKeys) {
      _buffer.remove(k);
    }
  }

  /// Adapt buffer depth based on jitter.
  void adapt(int jitterMs) {
    if (jitterMs > _adaptiveDepthMs * 0.7) {
      _adaptiveDepthMs = (_adaptiveDepthMs + 10).clamp(minDepthMs, maxDepthMs);
    } else if (jitterMs < _adaptiveDepthMs * 0.3) {
      _adaptiveDepthMs = (_adaptiveDepthMs - 10).clamp(minDepthMs, maxDepthMs);
    }
  }

  void flush() {
    _buffer.clear();
    _lastPlayedSeq = -1;
  }

  bool get isEmpty => _buffer.isEmpty;
}
