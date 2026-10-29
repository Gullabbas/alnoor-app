import 'package:flutter/material.dart';

/// Al Noor Diagnostic Centre - Design System Colors
class AppColors {
  AppColors._();

  // Primary Brand Tokens
  static const Color brandRed = Color(0xFFC81820);
  static const Color brandRedBright = Color(0xFFD0232A);
  static const Color brandRose = Color(0xFFEF5A78);
  static const Color brandCopper = Color(0xFFE5A274);
  static const Color brandGold = Color(0xFFD4AF37);
  static const Color brandPeach = Color(0xFFF6D9C3);

  // Neutral Tokens - Light Mode
  static const Color ink = Color(0xFF111114);
  static const Color inkSoft = Color(0xFF5B5B66);
  static const Color inkLighter = Color(0xFF8E8E9A);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF3ECE6);
  static const Color canvas = Color(0xFFFBF6F2);
  static const Color border = Color(0xFFEADBCE);
  static const Color divider = Color(0xFFF0E5DC);

  // Neutral Tokens - Dark Mode
  static const Color darkCanvas = Color(0xFF0E0B0C);
  static const Color darkSurface = Color(0xFF1A1516);
  static const Color darkSurfaceElevated = Color(0xFF261F20);
  static const Color darkText = Color(0xFFF4EEEA);
  static const Color darkTextSoft = Color(0xFF9E9895);
  static const Color darkBorder = Color(0xFF332729);

  // Feedback Tokens
  static const Color success = Color(0xFF1E9E6A);
  static const Color successLight = Color(0xFFE6F7F0);
  static const Color warning = Color(0xFFF2A33A);
  static const Color warningLight = Color(0xFFFEF5E7);
  static const Color danger = Color(0xFFB3261E);
  static const Color dangerLight = Color(0xFFFCEBEA);
  static const Color info = Color(0xFF2E6BD6);
  static const Color infoLight = Color(0xFFEAF1FC);

  // Signature Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      brandCopper,
      brandRedBright,
      brandRed,
    ],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFFAF3EE),
    ],
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF221A1C),
      Color(0xFF181314),
    ],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment(-0.8, -1.0),
    end: Alignment(1.0, 1.0),
    colors: [
      Color(0xFFD63138),
      Color(0xFFBA141C),
      Color(0xFF8F0D13),
    ],
  );

  static const LinearGradient goldCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFDF7A),
      Color(0xFFD49E35),
      Color(0xFF9E6D15),
    ],
  );

  static const LinearGradient silverCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFECEFF1),
      Color(0xFFB0BEC5),
      Color(0xFF78909C),
    ],
  );

  static const LinearGradient blueCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF42A5F5),
      Color(0xFF1E88E5),
      Color(0xFF0D47A1),
    ],
  );
}
