import 'package:flutter/material.dart';
import '../core/theme.dart';

class ErrorStateView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorStateView({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 48,
              color: SBColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                color: SBColors.textSecondary,
                fontSize: 15,
                fontFamily: SBFonts.dmSans,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              TextButton(
                onPressed: onRetry,
                child: Text(
                  'Try again',
                  style: TextStyle(
                    color: SBColors.blue,
                    fontFamily: SBFonts.dmSans,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
