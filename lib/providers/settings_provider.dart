import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/audio_mode.dart';
import '../services/storage/preferences_service.dart';

class SettingsState {
  final String displayName;
  final AudioMode defaultMode;
  final bool lowData;
  final bool batteryAware;
  final bool nfcEnabled;

  const SettingsState({
    this.displayName = 'My Phone',
    this.defaultMode = AudioMode.music,
    this.lowData = false,
    this.batteryAware = true,
    this.nfcEnabled = true,
  });

  SettingsState copyWith({
    String? displayName,
    AudioMode? defaultMode,
    bool? lowData,
    bool? batteryAware,
    bool? nfcEnabled,
  }) =>
      SettingsState(
        displayName: displayName ?? this.displayName,
        defaultMode: defaultMode ?? this.defaultMode,
        lowData: lowData ?? this.lowData,
        batteryAware: batteryAware ?? this.batteryAware,
        nfcEnabled: nfcEnabled ?? this.nfcEnabled,
      );
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState()) {
    _load();
  }

  Future<void> _load() async {
    final name = await PreferencesService.getDisplayName();
    final mode = await PreferencesService.getDefaultMode();
    final lowData = await PreferencesService.getLowData();
    final batteryAware = await PreferencesService.getBatteryAware();
    final nfc = await PreferencesService.getNfcEnabled();
    state = SettingsState(
      displayName: name,
      defaultMode: mode,
      lowData: lowData,
      batteryAware: batteryAware,
      nfcEnabled: nfc,
    );
  }

  Future<void> setDisplayName(String name) async {
    await PreferencesService.setDisplayName(name);
    state = state.copyWith(displayName: name);
  }

  Future<void> setDefaultMode(AudioMode mode) async {
    await PreferencesService.setDefaultMode(mode);
    state = state.copyWith(defaultMode: mode);
  }

  Future<void> setLowData(bool value) async {
    await PreferencesService.setLowData(value);
    state = state.copyWith(lowData: value);
  }

  Future<void> setBatteryAware(bool value) async {
    await PreferencesService.setBatteryAware(value);
    state = state.copyWith(batteryAware: value);
  }

  Future<void> setNfcEnabled(bool value) async {
    await PreferencesService.setNfcEnabled(value);
    state = state.copyWith(nfcEnabled: value);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) => SettingsNotifier(),
);
