import 'dart:io';
import 'package:uuid/uuid.dart';
import '../../models/session.dart';
import '../../models/connected_device.dart';
import '../../models/audio_mode.dart';
import '../../models/join_method.dart';
import '../../core/constants.dart';
import 'session_password_service.dart';

class SessionManager {
  Session? _session;
  final Map<String, ConnectedDevice> _devices = {};
  String? _passwordHash;

  void Function(ConnectedDevice device)? onDeviceJoined;
  void Function(String deviceId, String reason)? onDeviceLeft;
  void Function()? onSessionEnded;

  Session? get currentSession => _session;
  List<ConnectedDevice> get devices => _devices.values.toList();
  int get deviceCount => _devices.length;
  bool get hasSession => _session != null;

  Future<Session> createSession({
    required String ip,
    AudioMode mode = AudioMode.music,
    String? password,
  }) async {
    final id = const Uuid().v4();
    String hostName;
    try {
      hostName = Platform.localHostname;
    } catch (_) {
      hostName = 'SoundBridge Host';
    }
    _passwordHash = (password != null && password.isNotEmpty)
        ? SessionPasswordService.hash(password)
        : null;
    _session = Session(
      id: id,
      hostName: hostName,
      ip: ip,
      audioPort: SBConstants.audioPort,
      controlPort: SBConstants.controlPort,
      httpPort: SBConstants.httpPort,
      mode: mode,
      hasPassword: password != null && password.isNotEmpty,
      startedAt: DateTime.now(),
    );
    _devices.clear();
    return _session!;
  }

  String? validateJoin({
    required String deviceId,
    String? passwordHash,
    int maxDevices = 10,
  }) {
    if (_session == null) return 'no_session';
    if (_devices.length >= maxDevices) return 'session_full';
    if (_passwordHash != null && passwordHash != _passwordHash) {
      return 'wrong_password';
    }
    return null;
  }

  ConnectedDevice registerDevice({
    required String deviceId,
    required String displayName,
    required String ip,
    required JoinMethod joinMethod,
  }) {
    final device = ConnectedDevice(
      id: deviceId,
      displayName: displayName,
      ip: ip,
      joinMethod: joinMethod,
      joinedAt: DateTime.now(),
    );
    _devices[deviceId] = device;
    onDeviceJoined?.call(device);
    return device;
  }

  void removeDevice(String deviceId, {String reason = 'voluntary'}) {
    if (_devices.containsKey(deviceId)) {
      _devices.remove(deviceId);
      onDeviceLeft?.call(deviceId, reason);
    }
  }

  void updateLatency(String deviceId, int latencyMs) {
    _devices[deviceId]?.addLatency(latencyMs);
  }

  void setVolume(String deviceId, double volume) {
    _devices[deviceId]?.volume = volume;
  }

  void setMode(AudioMode mode) {
    if (_session != null) {
      _session = _session!.copyWith(mode: mode);
    }
  }

  void endSession() {
    _devices.clear();
    _session = null;
    _passwordHash = null;
    onSessionEnded?.call();
  }

  bool verifyPassword(String hash) =>
      _passwordHash == null || _passwordHash == hash;
}
