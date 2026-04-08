import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';

class HostScreen extends StatelessWidget {
  const HostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SBColors.bg,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Host mode',
                style: TextStyle(
                  fontFamily: SBFonts.syne,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: SBColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Coming soon — Android host\nmode is being built',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: SBFonts.dmSans,
                  fontSize: 15,
                  color: SBColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: SBColors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => context.go('/home'),
                child: Text(
                  'Go back',
                  style: TextStyle(
                    fontFamily: SBFonts.dmSans,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
