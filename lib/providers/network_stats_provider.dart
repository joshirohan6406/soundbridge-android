import 'package:flutter_riverpod/flutter_riverpod.dart';

class NetworkStats {
  final int latencyMs;
  final int jitterMs;
  final String qualityLabel;

  const NetworkStats({
    this.latencyMs = 0,
    this.jitterMs = 0,
    this.qualityLabel = 'Connecting',
  });

  NetworkStats copyWith({
    int? latencyMs,
    int? jitterMs,
    String? qualityLabel,
  }) =>
      NetworkStats(
        latencyMs: latencyMs ?? this.latencyMs,
        jitterMs: jitterMs ?? this.jitterMs,
        qualityLabel: qualityLabel ?? this.qualityLabel,
      );
}

class NetworkStatsNotifier extends StateNotifier<NetworkStats> {
  NetworkStatsNotifier() : super(const NetworkStats());

  void update(int latencyMs, int jitterMs) {
    String label;
    if (latencyMs < 80)
      label = 'Excellent';
    else if (latencyMs < 150)
      label = 'Good';
    else if (latencyMs < 250)
      label = 'Fair';
    else
      label = 'Poor';

    state = state.copyWith(
      latencyMs: latencyMs,
      jitterMs: jitterMs,
      qualityLabel: label,
    );
  }

  void reset() => state = const NetworkStats();
}

final networkStatsProvider =
    StateNotifierProvider<NetworkStatsNotifier, NetworkStats>(
  (ref) => NetworkStatsNotifier(),
);
