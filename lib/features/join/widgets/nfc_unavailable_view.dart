import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class NfcUnavailableView extends StatelessWidget {
  const NfcUnavailableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: SBColors.surface2,
                shape: BoxShape.circle,
                border: Border.all(color: SBColors.border1),
              ),
              child: const Icon(
                Icons.nfc_rounded,
                color: SBColors.textTertiary,
                size: 36,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'NFC not available',
              style: TextStyle(
                fontFamily: SBFonts.syne,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: SBColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Your device does not support NFC.\nUse QR scan to join instead.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: SBFonts.dmSans,
                fontSize: 14,
                color: SBColors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: SBColors.blueAccent,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: SBColors.blue.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: SBColors.blue,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Switch to the QR scan tab — it works on every Android device.',
                      style: TextStyle(
                        fontFamily: SBFonts.dmSans,
                        fontSize: 13,
                        color: SBColors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
