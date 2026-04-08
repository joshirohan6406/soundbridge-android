import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class VisualizerZone extends StatefulWidget {
  const VisualizerZone({super.key});

  @override
  State<VisualizerZone> createState() => _VisualizerZoneState();
}

class _VisualizerZoneState extends State<VisualizerZone>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  final _rand = Random();
  final List<double> _bars = List.filled(40, 0.3);
  final List<double> _targets = List.filled(40, 0.3);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    )
      ..addListener(_update)
      ..repeat();
  }

  void _update() {
    for (int i = 0; i < _bars.length; i++) {
      _bars[i] += (_targets[i] - _bars[i]) * 0.15;
      if ((_bars[i] - _targets[i]).abs() < 0.02) {
        _targets[i] = 0.1 + _rand.nextDouble() * 0.9;
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: SBColors.surface1,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SBColors.border1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(_bars.length, (i) {
          final h = (_bars[i] * 50).clamp(4.0, 50.0);
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 80),
                  height: h,
                  decoration: BoxDecoration(
                    color: SBColors.blue.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
