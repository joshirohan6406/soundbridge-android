import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../models/eq_preset.dart';

class EqualizerScreen extends StatefulWidget {
  const EqualizerScreen({super.key});

  @override
  State<EqualizerScreen> createState() => _EqualizerScreenState();
}

class _EqualizerScreenState extends State<EqualizerScreen> {
  final List<String> _labels = ['60Hz', '250Hz', '1kHz', '4kHz', '16kHz'];
  List<double> _bands = [0, 0, 0, 0, 0];
  EqPreset _preset = EqPreset.flat;

  void _applyPreset(EqPreset preset) {
    setState(() {
      _preset = preset;
      _bands = preset.bands.map((b) => b.toDouble()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SBColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(context),
            const SizedBox(height: 20),
            _presets(),
            const SizedBox(height: 32),
            _bandsSection(),
            const Spacer(),
            _applyButton(context),
            const SizedBox(height: 24),
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
            'Equalizer',
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

  Widget _presets() {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: EqPreset.values.map((p) {
          final active = p == _preset;
          return GestureDetector(
            onTap: () => _applyPreset(p),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: active ? SBColors.blueAccent : SBColors.surface2,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: active
                      ? SBColors.blue.withValues(alpha: 0.4)
                      : SBColors.border1,
                ),
              ),
              child: Text(
                p.label,
                style: TextStyle(
                  fontFamily: SBFonts.dmSans,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: active ? SBColors.blue : SBColors.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _bandsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(5, (i) => _band(i)),
      ),
    );
  }

  Widget _band(int index) {
    final db = _bands[index].round();
    return Column(
      children: [
        Text(
          '${db >= 0 ? '+' : ''}$db',
          style: TextStyle(
            fontFamily: SBFonts.jetbrains,
            fontSize: 11,
            color: SBColors.blue,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 160,
          child: RotatedBox(
            quarterTurns: 3,
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: SBColors.blue,
                inactiveTrackColor: SBColors.surface3,
                thumbColor: SBColors.blue,
                overlayColor: SBColors.blueAccent,
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 8,
                ),
              ),
              child: Slider(
                value: _bands[index],
                min: -12,
                max: 12,
                divisions: 24,
                onChanged: (v) {
                  setState(() {
                    _bands[index] = v;
                    _preset = EqPreset.flat;
                  });
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _labels[index],
          style: TextStyle(
            fontFamily: SBFonts.dmSans,
            fontSize: 11,
            color: SBColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _applyButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: SBColors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: () => context.pop(),
          child: Text(
            'Apply & return',
            style: TextStyle(
              fontFamily: SBFonts.dmSans,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}