import 'dart:math';
import 'package:network_info_plus/network_info_plus.dart';

class SBUtils {
  static Future<String> getLocalIp() async {
    try {
      final info = NetworkInfo();
      final ip = await info.getWifiIP();
      return ip ?? '0.0.0.0';
    } catch (_) {
      return '0.0.0.0';
    }
  }

  static String generateDeviceId() {
    final rand = Random.secure();
    final bytes = List<int>.generate(16, (_) => rand.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  static String formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (h > 0) {
      return '${h}h ${m}m';
    }
    return '${m}m ${s}s';
  }

  static String formatBytes(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
}