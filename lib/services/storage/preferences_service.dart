import 'package:shared_preferences/shared_preferences.dart';
import '../../models/audio_mode.dart';

class PreferencesService {
  static const _keyDisplayName = 'display_name';
  static const _keyDefaultMode = 'default_mode';
  static const _keyLowData = 'low_data';
  static const _keyBatteryAware = 'battery_aware';
  static const _keyNfcEnabled = 'nfc_enabled';
  static const _keyTheme = 'theme';

  static Future<SharedPreferences> get _prefs =>
      SharedPreferences.getInstance();

  static Future<String> getDisplayName() async {
    final p = await _prefs;
    return p.getString(_keyDisplayName) ?? 'My Phone';
  }

  static Future<void> setDisplayName(String name) async {
    final p = await _prefs;
    await p.setString(_keyDisplayName, name);
  }

  static Future<AudioMode> getDefaultMode() async {
    final p = await _prefs;
    final name = p.getString(_keyDefaultMode) ?? 'music';
    return AudioMode.fromName(name);
  }

  static Future<void> setDefaultMode(AudioMode mode) async {
    final p = await _prefs;
    await p.setString(_keyDefaultMode, mode.name);
  }

  static Future<bool> getLowData() async {
    final p = await _prefs;
    return p.getBool(_keyLowData) ?? false;
  }

  static Future<void> setLowData(bool value) async {
    final p = await _prefs;
    await p.setBool(_keyLowData, value);
  }

  static Future<bool> getBatteryAware() async {
    final p = await _prefs;
    return p.getBool(_keyBatteryAware) ?? true;
  }

  static Future<void> setBatteryAware(bool value) async {
    final p = await _prefs;
    await p.setBool(_keyBatteryAware, value);
  }

  static Future<bool> getNfcEnabled() async {
    final p = await _prefs;
    return p.getBool(_keyNfcEnabled) ?? true;
  }

  static Future<void> setNfcEnabled(bool value) async {
    final p = await _prefs;
    await p.setBool(_keyNfcEnabled, value);
  }
}
