import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../models/audio_mode.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      backgroundColor: SBColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _header(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _section('Profile'),
                  _inputTile(
                    icon: Icons.person_rounded,
                    label: 'Display name',
                    value: settings.displayName,
                    onTap: () => _editName(context, notifier, settings.displayName),
                  ),
                  const SizedBox(height: 20),
                  _section('Audio'),
                  _modeTile(
                    settings.defaultMode,
                    (mode) => notifier.setDefaultMode(mode),
                  ),
                  const SizedBox(height: 20),
                  _section('Network'),
                  _switchTile(
                    icon: Icons.data_saver_on_rounded,
                    label: 'Low data mode',
                    subtitle: 'Reduces bitrate for weak WiFi',
                    value: settings.lowData,
                    onChanged: notifier.setLowData,
                  ),
                  const SizedBox(height: 10),
                  _switchTile(
                    icon: Icons.battery_saver_rounded,
                    label: 'Battery-aware mode',
                    subtitle: 'Increases buffer below 20% battery',
                    value: settings.batteryAware,
                    onChanged: notifier.setBatteryAware,
                  ),
                  const SizedBox(height: 10),
                  _switchTile(
                    icon: Icons.nfc_rounded,
                    label: 'NFC joining',
                    subtitle: 'Allow others to tap to join',
                    value: settings.nfcEnabled,
                    onChanged: notifier.setNfcEnabled,
                  ),
                  const SizedBox(height: 28),
                  _version(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: SBColors.surface2,
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: SBColors.border1),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: SBColors.textPrimary,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            'Settings',
            style: TextStyle(
              fontFamily: SBFonts.syne,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: SBColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontFamily: SBFonts.dmSans,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: SBColors.textTertiary,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  Widget _inputTile({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: SBColors.surface2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: SBColors.border1),
        ),
        child: Row(
          children: [
            Icon(icon, color: SBColors.blue, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: SBFonts.dmSans,
                      fontSize: 13,
                      color: SBColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontFamily: SBFonts.dmSans,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: SBColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.edit_rounded,
              color: SBColors.textTertiary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _modeTile(
    AudioMode current,
    void Function(AudioMode) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SBColors.surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: SBColors.border1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.graphic_eq_rounded,
                color: SBColors.blue,
                size: 20,
              ),
              const SizedBox(width: 14),
              Text(
                'Default audio mode',
                style: TextStyle(
                  fontFamily: SBFonts.dmSans,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: SBColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: AudioMode.values
                .where((m) => m != AudioMode.custom)
                .map((m) {
              final active = m == current;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(m),
                  child: Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: active
                          ? SBColors.blueAccent
                          : SBColors.surface3,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: active
                            ? SBColors.blue.withValues(alpha: 0.4)
                            : SBColors.border1,
                      ),
                    ),
                    child: Text(
                      m.label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: SBFonts.dmSans,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: active
                            ? SBColors.blue
                            : SBColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _switchTile({
    required IconData icon,
    required String label,
    required String subtitle,
    required bool value,
    required Future<void> Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SBColors.surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: SBColors.border1),
      ),
      child: Row(
        children: [
          Icon(icon, color: SBColors.blue, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: SBFonts.dmSans,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: SBColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: SBFonts.dmSans,
                    fontSize: 12,
                    color: SBColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: SBColors.blue,
            inactiveTrackColor: SBColors.surface3,
          ),
        ],
      ),
    );
  }

  Widget _version() {
    return Center(
      child: Text(
        'SoundBridge v1.0.0',
        style: TextStyle(
          fontFamily: SBFonts.dmSans,
          fontSize: 12,
          color: SBColors.textTertiary,
        ),
      ),
    );
  }

  Future<void> _editName(
    BuildContext context,
    SettingsNotifier notifier,
    String current,
  ) async {
    final ctrl = TextEditingController(text: current);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: SBColors.surface2,
        title: Text(
          'Display name',
          style: TextStyle(
            fontFamily: SBFonts.syne,
            color: SBColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: TextField(
          controller: ctrl,
          style: TextStyle(
            color: SBColors.textPrimary,
            fontFamily: SBFonts.dmSans,
          ),
          decoration: InputDecoration(
            hintText: 'My Phone',
            hintStyle: TextStyle(color: SBColors.textTertiary),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: SBColors.border2),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: SBColors.blue),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(color: SBColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: Text(
              'Save',
              style: TextStyle(color: SBColors.blue),
            ),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      await notifier.setDisplayName(result);
    }
  }
}