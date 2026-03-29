import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../widgets/animated_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) context.go('/home');
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SBColors.bg,
      body: FadeTransition(
        opacity: _fade,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const Spacer(flex: 2),
                const AnimatedLogo(size: 100),
                const SizedBox(height: 20),
                Text(
                  'SoundBridge',
                  style: TextStyle(
                    fontFamily: SBFonts.syne,
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: SBColors.textPrimary,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Same music. Every earbud. Zero lag.',
                  style: TextStyle(
                    fontFamily: SBFonts.dmSans,
                    fontSize: 15,
                    color: SBColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 48),
                _featureRow(
                  Icons.sync_rounded,
                  SBColors.blue,
                  'Perfect sync',
                  'Under 80ms latency on local WiFi',
                ),
                const SizedBox(height: 14),
                _featureRow(
                  Icons.nfc_rounded,
                  SBColors.teal,
                  'QR scan or NFC tap',
                  'Join in under 2 seconds',
                ),
                const SizedBox(height: 14),
                _featureRow(
                  Icons.wifi_off_rounded,
                  SBColors.pink,
                  '100% offline',
                  'No internet. No accounts. No limits.',
                ),
                const Spacer(flex: 3),
                LinearProgressIndicator(
                  backgroundColor: SBColors.surface2,
                  valueColor: AlwaysStoppedAnimation<Color>(SBColors.blue),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _featureRow(
    IconData icon,
    Color color,
    String title,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: SBColors.surface1,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: SBColors.border1),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: SBFonts.dmSans,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
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
        ],
      ),
    );
  }
}
