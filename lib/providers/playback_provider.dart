import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/connection_status.dart';
import '../models/join_method.dart';
import '../models/audio_mode.dart';

class PlaybackState {
  final ConnectionStatus status;
  final String hostName;
  final AudioMode mode;
  final JoinMethod joinMethod;
  final double volume;
  final bool isBackground;

  const PlaybackState({
    this.status = ConnectionStatus.idle,
    this.hostName = '',
    this.mode = AudioMode.music,
    this.joinMethod = JoinMethod.qr,
    this.volume = 1.0,
    this.isBackground = false,
  });

  PlaybackState copyWith({
    ConnectionStatus? status,
    String? hostName,
    AudioMode? mode,
    JoinMethod? joinMethod,
    double? volume,
    bool? isBackground,
  }) =>
      PlaybackState(
        status: status ?? this.status,
        hostName: hostName ?? this.hostName,
        mode: mode ?? this.mode,
        joinMethod: joinMethod ?? this.joinMethod,
        volume: volume ?? this.volume,
        isBackground: isBackground ?? this.isBackground,
      );
}

class PlaybackNotifier extends StateNotifier<PlaybackState> {
  PlaybackNotifier() : super(const PlaybackState());

  void setConnecting(String hostName, JoinMethod method) {
    state = state.copyWith(
      status: ConnectionStatus.connecting,
      hostName: hostName,
      joinMethod: method,
    );
  }

  void setConnected() {
    state = state.copyWith(status: ConnectionStatus.connected);
  }

  void setReconnecting() {
    state = state.copyWith(status: ConnectionStatus.reconnecting);
  }

  void setDisconnected() {
    state = state.copyWith(status: ConnectionStatus.disconnected);
  }

  void setMode(AudioMode mode) {
    state = state.copyWith(mode: mode);
  }

  void setVolume(double volume) {
    state = state.copyWith(volume: volume);
  }

  void reset() => state = const PlaybackState();
}

final playbackProvider = StateNotifierProvider<PlaybackNotifier, PlaybackState>(
  (ref) => PlaybackNotifier(),
);
