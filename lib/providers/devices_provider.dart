import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/connected_device.dart';

class DevicesNotifier extends StateNotifier<List<ConnectedDevice>> {
  DevicesNotifier() : super([]);

  void addDevice(ConnectedDevice device) {
    state = [...state, device];
  }

  void removeDevice(String deviceId) {
    state = state.where((d) => d.id != deviceId).toList();
  }

  void updateLatency(String deviceId, int latencyMs) {
    state = state.map((d) {
      if (d.id == deviceId) {
        d.addLatency(latencyMs);
        return d;
      }
      return d;
    }).toList();
  }

  void setVolume(String deviceId, double volume) {
    state = state.map((d) {
      if (d.id == deviceId) {
        d.volume = volume;
        return d;
      }
      return d;
    }).toList();
  }

  void clear() => state = [];
}

final devicesProvider =
    StateNotifierProvider<DevicesNotifier, List<ConnectedDevice>>(
  (ref) => DevicesNotifier(),
);
