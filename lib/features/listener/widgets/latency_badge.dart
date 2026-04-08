import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../widgets/pulse_dot.dart';

class LatencyBadge extends StatelessWidget {
  final int latencyMs;

  const LatencyBadge({super.key, required this.latencyMs});

  @override
  Widget build(BuildContext context) {
    final color = latencyColor(latencyMs);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PulseDot(color: color, size: 7),
          const SizedBox(width: 6),
          Text(
            latencyMs == 0 ? 'Connecting...' : '${latencyMs}ms',
            style: TextStyle(
              fontFamily: SBFonts.jetbrains,
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
