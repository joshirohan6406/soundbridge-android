import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../models/session.dart';
import '../../../services/join/nfc_service.dart';
import '../../../widgets/pulse_dot.dart';

class NfcTapView extends StatefulWidget {
  final void Function(Session session) onSessionFound;

  const NfcTapView({super.key, required this.onSessionFound});

  @override
  State<NfcTapView> createState() => _NfcTapViewState();
}

class _NfcTapViewState extends State<NfcTapView> with TickerProviderStateMixin {
  late final List<AnimationController> _rings;
  late final List<Animation<double>> _scales;
  late final List<Animation<double>> _opacities;
  bool _reading = false;

  @override
  void initState() {
    super.initState();
    _rings = List.generate(
      3,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2400),
      ),
    );
    _scales = List.generate(
      3,
      (i) => Tween<double>(begin: 0.75, end: 1.15).animate(
        CurvedAnimation(parent: _rings[i], curve: Curves.easeOut),
      ),
    );
    _opacities = List.generate(
      3,
      (i) => Tween<double>(begin: 0.8, end: 0.0).animate(
        CurvedAnimation(parent: _rings[i], curve: Curves.easeOut),
      ),
    );
    for (int i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: i * 550), () {
        if (mounted) _rings[i].repeat();
      });
    }
    _startListening();
  }

  Future<void> _startListening() async {
    if (_reading) return;
    setState(() => _reading = true);
    final session = await NfcService.readSession();
    if (session != null && mounted) {
      widget.onSessionFound(session);
    } else if (mounted) {
      setState(() => _reading = false);
      _startListening();
    }
  }

  @override
  void dispose() {
    for (final r in _rings) r.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ...List.generate(
                      3,
                      (i) => AnimatedBuilder(
                            animation: _rings[i],
                            builder: (_, __) => Opacity(
                              opacity: _opacities[i].value,
                              child: Transform.scale(
                                scale: _scales[i].value,
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: SBColors.teal,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: SBColors.tealAccent,
                      border: Border.all(color: SBColors.teal, width: 1.5),
                    ),
                    child: const Icon(
                      Icons.nfc_rounded,
                      color: SBColors.teal,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Hold near host',
              style: TextStyle(
                fontFamily: SBFonts.syne,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: SBColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Touch the back of your phone\nagainst the host device',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: SBFonts.dmSans,
                fontSize: 14,
                color: SBColors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: SBColors.tealAccent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: SBColors.teal.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const PulseDot(color: SBColors.teal),
                  const SizedBox(width: 8),
                  Text(
                    'NFC ready — waiting for tap',
                    style: TextStyle(
                      fontFamily: SBFonts.dmSans,
                      fontSize: 13,
                      color: SBColors.teal,
                      fontWeight: FontWeight.w500,
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
