import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../core/constants.dart';

class WebSocketClient {
  WebSocketChannel? _channel;
  Timer? _pingTimer;
  Timer? _reconnectTimer;
  bool _shouldReconnect = true;
  String? _ip;
  int? _port;

  // Callbacks
  void Function(Map<String, dynamic> msg)? onMessage;
  void Function()? onConnected;
  void Function()? onDisconnected;

  bool get isConnected => _channel != null;

  Future<void> connect(String ip, int port) async {
    _ip = ip;
    _port = port;
    _shouldReconnect = true;
    await _connect();
  }

  Future<void> _connect() async {
    try {
      final uri = Uri.parse('ws://$_ip:$_port');
      _channel = WebSocketChannel.connect(uri);
      await _channel!.ready;
      onConnected?.call();
      _startPing();
      _channel!.stream.listen(
        (message) {
          try {
            final data = jsonDecode(message as String) as Map<String, dynamic>;
            _handleMessage(data);
          } catch (_) {}
        },
        onDone: _onDisconnected,
        onError: (_) => _onDisconnected(),
      );
    } catch (_) {
      _onDisconnected();
    }
  }

  void _handleMessage(Map<String, dynamic> data) {
    final type = data['type'] as String? ?? '';
    if (type == SBConstants.msgPing) {
      send({
        'type': SBConstants.msgPong,
        'timestamp': data['timestamp'],
      });
      return;
    }
    onMessage?.call(data);
  }

  void send(Map<String, dynamic> data) {
    try {
      _channel?.sink.add(jsonEncode(data));
    } catch (_) {}
  }

  void _startPing() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(
      Duration(seconds: SBConstants.pingIntervalSeconds),
      (_) => send({
        'type': SBConstants.msgPing,
        'timestamp': DateTime.now().microsecondsSinceEpoch,
      }),
    );
  }

  void _onDisconnected() {
    _pingTimer?.cancel();
    _channel = null;
    onDisconnected?.call();
    if (_shouldReconnect) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    int attempts = 0;
    _reconnectTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      attempts++;
      if (attempts > 7 || !_shouldReconnect) {
        timer.cancel();
        return;
      }
      await _connect();
      if (isConnected) timer.cancel();
    });
  }

  Future<void> disconnect() async {
    _shouldReconnect = false;
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    await _channel?.sink.close();
    _channel = null;
  }
}
