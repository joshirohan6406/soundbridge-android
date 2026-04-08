import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../models/connection_status.dart';
import '../../../widgets/pulse_dot.dart';

class ConnectionStatusBar extends StatelessWidget {
  final ConnectionStatus status;

  const ConnectionStatusBar({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case ConnectionStatus.connected:
        color = SBColors.green;
        label = 'Synced';
        icon = Icons.check_circle_rounded;
        break;
      case ConnectionStatus.reconnecting:
        color = SBColors.amber;
        label = 'Reconnecting...';
        icon = Icons.sync_rounded;
        break;
      case ConnectionStatus.connecting:
        color = SBColors.blue;
        label = 'Connecting...';
        icon = Icons.sync_rounded;
        break;
      default:
        color = SBColors.textTertiary;
        label = 'Disconnected';
        icon = Icons.wifi_off_rounded;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PulseDot(color: color, size: 7),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontFamily: SBFonts.dmSans,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
