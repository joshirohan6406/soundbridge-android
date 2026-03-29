import 'package:flutter/material.dart';
import '../core/theme.dart';

class SbCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;

  const SbCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? SBColors.surface2,
      borderRadius: SBRadius.lg,
      child: InkWell(
        onTap: onTap,
        borderRadius: SBRadius.lg,
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: SBRadius.lg,
            border: Border.all(color: SBColors.border1),
          ),
          child: child,
        ),
      ),
    );
  }
}
