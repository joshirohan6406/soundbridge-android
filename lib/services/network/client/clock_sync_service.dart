import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ClockSyncService {
  int _offsetUs = 0;

  int get offsetUs => _offsetUs;

  /// Perform NTP-style clock sync with host.
  Future<void> sync(String ip, int httpPort) async {
    try {
      final clientT1 = DateTime.now().microsecondsSinceEpoch;
      final url = Uri.parse('http://$ip:$httpPort/time');
      final response = await http.get(url).timeout(
            const Duration(seconds: 3),
          );
      final clientT2 = DateTime.now().microsecondsSinceEpoch;
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final serverT = (data['serverTimeUs'] as num).toInt();
        final rtt = clientT2 - clientT1;
        _offsetUs = serverT - clientT1 - (rtt ~/ 2);
      }
    } catch (_) {
      _offsetUs = 0;
    }
  }

  /// Convert host timestamp to local time.
  int toLocalUs(int hostTimestampUs) {
    return hostTimestampUs - _offsetUs;
  }

  void reset() {
    _offsetUs = 0;
  }
}
