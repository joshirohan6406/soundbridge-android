import 'package:flutter/material.dart';
import '../core/theme.dart';

class AnimatedLogo extends StatefulWidget {
  final double size;
  const AnimatedLogo({super.key, this.size = 100});

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _scales;
  late final List<Animation<double>> _opacities;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2400),
      ),
    );
    _scales = List.generate(
      3,
      (i) => Tween<double>(begin: 0.75, end: 1.15).animate(
        CurvedAnimation(parent: _controllers[i], curve: Curves.easeInOut),
      ),
    );
    _opacities = List.generate(
      3,
      (i) => Tween<double>(begin: 0.8, end: 0.0).animate(
        CurvedAnimation(parent: _controllers[i], curve: Curves.easeOut),
      ),
    );
    for (int i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: i * 550), () {
        if (mounted) _controllers[i].repeat();
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ...List.generate(
              3,
              (i) => AnimatedBuilder(
                    animation: _controllers[i],
                    builder: (_, __) => Opacity(
                      opacity: _opacities[i].value,
                      child: Transform.scale(
                        scale: _scales[i].value,
                        child: Container(
                          width: widget.size * (0.6 + i * 0.2),
                          height: widget.size * (0.6 + i * 0.2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: i == 1 ? SBColors.teal : SBColors.blue,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
          Container(
            width: widget.size * 0.40,
            height: widget.size * 0.40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: SBColors.blueAccent,
              border: Border.all(color: SBColors.blue, width: 1.5),
            ),
            child: Icon(
              Icons.graphic_eq_rounded,
              color: SBColors.blue,
              size: widget.size * 0.22,
            ),
          ),
        ],
      ),
    );
  }
}
