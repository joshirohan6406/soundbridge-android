import 'package:flutter/material.dart';
import '../core/theme.dart';

class SbButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final bool isDanger;
  final bool isSecondary;

  const SbButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width,
    this.isDanger = false,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDanger
        ? SBColors.red
        : isSecondary
            ? Colors.transparent
            : SBColors.blue;
    final fg = isDanger || !isSecondary ? Colors.white : SBColors.blue;

    return AnimatedOpacity(
      opacity: onPressed == null ? 0.5 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: SizedBox(
        width: width,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: bg,
            foregroundColor: fg,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: SBRadius.md),
            side: isSecondary
                ? const BorderSide(color: SBColors.border2)
                : BorderSide.none,
          ),
          onPressed: onPressed,
          icon: isLoading
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: fg,
                  ),
                )
              : icon != null
                  ? Icon(icon, size: 20)
                  : const SizedBox.shrink(),
          label: Text(
            label,
            style: TextStyle(
              fontFamily: SBFonts.dmSans,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}