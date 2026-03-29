import 'package:flutter/material.dart';
import '../core/theme.dart';

class SbBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color bgColor;

  const SbBadge({
    super.key,
    required this.label,
    required this.color,
    required this.bgColor,
  });

  factory SbBadge.latency(int ms) {
    final color = latencyColor(ms);
    return SbBadge(
      label: '${ms}ms',
      color: color,
      bgColor: color.withValues(alpha: 0.15),
    );
  }

  factory SbBadge.mode(String label) => SbBadge(
        label: label,
        color: SBColors.blue,
        bgColor: SBColors.blueAccent,
      );

  factory SbBadge.nfc() => const SbBadge(
        label: 'NFC',
        color: SBColors.teal,
        bgColor: SBColors.tealAccent,
      );

  factory SbBadge.qr() => SbBadge(
        label: 'QR',
        color: SBColors.blue,
        bgColor: SBColors.blue.withValues(alpha: 0.15),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: SBRadius.full,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          fontFamily: SBFonts.dmSans,
        ),
      ),
    );
  }
}
