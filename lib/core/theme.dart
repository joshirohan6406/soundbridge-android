import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SBColors {
  static const Color bg = Color(0xFF060810);
  static const Color surface1 = Color(0xFF0C0F1D);
  static const Color surface2 = Color(0xFF131929);
  static const Color surface3 = Color(0xFF1C2540);
  static const Color blue = Color(0xFF4F8EFF);
  static const Color blueAccent = Color(0x294F8EFF);
  static const Color teal = Color(0xFF00E5B4);
  static const Color tealAccent = Color(0x2300E5B4);
  static const Color pink = Color(0xFFFF4FA3);
  static const Color green = Color(0xFF22C55E);
  static const Color amber = Color(0xFFF59E0B);
  static const Color red = Color(0xFFEF4444);
  static const Color textPrimary = Color(0xFFE2E8F5);
  static const Color textSecondary = Color(0xFF8895B3);
  static const Color textTertiary = Color(0xFF3D4F72);
  static const Color border1 = Color(0x0FFFFFFF);
  static const Color border2 = Color(0x1CFFFFFF);
  static const Color border3 = Color(0x2EFFFFFF);
}

class SBRadius {
  static const BorderRadius sm = BorderRadius.all(Radius.circular(8));
  static const BorderRadius md = BorderRadius.all(Radius.circular(12));
  static const BorderRadius lg = BorderRadius.all(Radius.circular(16));
  static const BorderRadius xl = BorderRadius.all(Radius.circular(20));
  static const BorderRadius full = BorderRadius.all(Radius.circular(999));
}

class SBFonts {
  static String get syne => GoogleFonts.syne().fontFamily!;
  static String get dmSans => GoogleFonts.dmSans().fontFamily!;
  static String get jetbrains => GoogleFonts.jetBrainsMono().fontFamily!;
}

Color latencyColor(int ms) {
  if (ms < 80) return SBColors.green;
  if (ms < 150) return SBColors.amber;
  return SBColors.red;
}

String latencyLabel(int ms) {
  if (ms < 80) return 'Excellent';
  if (ms < 150) return 'Acceptable';
  return 'Poor';
}

ThemeData soundBridgeTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: SBColors.bg,
    colorScheme: const ColorScheme.dark(
      surface: SBColors.bg,
      primary: SBColors.blue,
      secondary: SBColors.teal,
      error: SBColors.red,
    ),
    cardColor: SBColors.surface1,
    dividerColor: SBColors.border1,
    fontFamily: GoogleFonts.dmSans().fontFamily,
    textTheme: GoogleFonts.dmSansTextTheme(
      TextTheme(
        displayLarge: GoogleFonts.syne(
          fontWeight: FontWeight.w700,
          color: SBColors.textPrimary,
        ),
        displayMedium: GoogleFonts.syne(
          fontWeight: FontWeight.w700,
          color: SBColors.textPrimary,
        ),
        headlineLarge: GoogleFonts.syne(
          fontWeight: FontWeight.w700,
          color: SBColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.syne(
          fontWeight: FontWeight.w700,
          color: SBColors.textPrimary,
        ),
        headlineSmall: GoogleFonts.syne(
          fontWeight: FontWeight.w700,
          color: SBColors.textPrimary,
        ),
        titleLarge: GoogleFonts.dmSans(
          fontWeight: FontWeight.w500,
          color: SBColors.textPrimary,
        ),
        titleMedium: GoogleFonts.dmSans(
          fontWeight: FontWeight.w500,
          color: SBColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.dmSans(
          fontWeight: FontWeight.w400,
          color: SBColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.dmSans(
          fontWeight: FontWeight.w400,
          color: SBColors.textSecondary,
        ),
        bodySmall: GoogleFonts.dmSans(
          fontWeight: FontWeight.w400,
          color: SBColors.textTertiary,
        ),
        labelLarge: GoogleFonts.dmSans(
          fontWeight: FontWeight.w500,
          color: SBColors.textPrimary,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: SBColors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: SBRadius.md),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),
  );
}
