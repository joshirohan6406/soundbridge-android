import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/audio_mode.dart';

class AudioModeNotifier extends StateNotifier<AudioMode> {
  AudioModeNotifier() : super(AudioMode.music);

  void setMode(AudioMode mode) => state = mode;
}

final audioModeProvider = StateNotifierProvider<AudioModeNotifier, AudioMode>(
  (ref) => AudioModeNotifier(),
);
