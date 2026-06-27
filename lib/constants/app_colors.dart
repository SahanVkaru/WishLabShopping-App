import 'package:flutter/material.dart';

class AppColors {
  // ─── Primary Brand Colors (Requested Light Purple) ───
  static const Color primary = Color(0xFFB39CE4);        // Requested Color
  static const Color primaryLight = Color(0xFFD4C4EF);    // Lighter shade
  static const Color primaryDark = Color(0xFF8B73D0);     // Darker shade
  static const Color primarySoft = Color(0xFFF3EDFA);     // Soft tint
  static const Color primaryDarkTheme = Color(0xFFBB86FC); // Requested Dark Mode Main Color
  static const Color button = Color(0xFF8961E6);          // Requested Button Color

  // ─── Secondary / Accent (Plum + Light Gold) ───
  static const Color secondary = Color(0xFF880E4F);       // Plum
  static const Color secondaryLight = Color(0xFFC2185B);  // Light Plum
  static const Color accent = Color(0xFFD4AF37);          // Light Gold
  static const Color accentLight = Color(0xFFF5E6B8);     // Soft Gold

  // ─── Light Theme Surface Colors ───
  static const Color backgroundLight = Color(0xFFFAF8F5);   // Warm Ivory
  static const Color surfaceLight = Colors.white;
  static const Color surfaceVariantLight = Color(0xFFF5F0EB); // Warm Grey
  static const Color textPrimaryLight = Color(0xFF1A1A2E);   // Deep Navy-Black
  static const Color textSecondaryLight = Color(0xFF8E8E9A); // Muted Lavender Grey
  static const Color textTertiaryLight = Color(0xFFB0B0BC);  // Light Grey
  static const Color dividerLight = Color(0xFFEDE8E3);       // Subtle warm divider

  // ─── Dark Theme Surface Colors ───
  static const Color backgroundDark = Color(0xFF0D0D1A);    // Deep Space
  static const Color surfaceDark = Color(0xFF1A1A2E);        // Dark Navy
  static const Color surfaceVariantDark = Color(0xFF252540); // Elevated Dark
  static const Color textPrimaryDark = Color(0xFFF5F0EB);    // Warm White
  static const Color textSecondaryDark = Color(0xFF9E9EB0);  // Muted Lavender
  static const Color textTertiaryDark = Color(0xFF6B6B80);   // Dim Grey
  static const Color dividerDark = Color(0xFF2E2E45);        // Subtle dark divider

  // ─── Semantic / Status Colors ───
  static const Color success = Color(0xFF2ECC71);     // Emerald Green
  static const Color successLight = Color(0xFFD5F5E3);
  static const Color error = Color(0xFFE74C3C);       // Coral Red
  static const Color errorLight = Color(0xFFFDEDEB);
  static const Color warning = Color(0xFFF39C12);     // Amber Gold
  static const Color warningLight = Color(0xFFFEF9E7);
  static const Color info = Color(0xFF3498DB);         // Sky Blue
  static const Color infoLight = Color(0xFFD6EAF8);

  // ─── Special ───
  static const Color starRating = Color(0xFFFFB400);          // Golden Star
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  static const Color shimmerBaseDark = Color(0xFF2A2A40);
  static const Color shimmerHighlightDark = Color(0xFF3A3A55);

  // ─── Shadow Colors ───
  static const Color shadowLight = Color(0x1A000000);         // 10% black
  static const Color shadowPrimary = Color(0x40B39CE4);       // 25% primary glow
  static const Color shadowDark = Color(0x40000000);          // 25% black

  // ─── Gradient Definitions ───
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryDark, primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [secondary, Color(0xFFC2185B), primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF0D0D1A), Color(0xFF1A1A2E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient goldShimmerGradient = LinearGradient(
    colors: [accent, Color(0xFFE8C547), accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFF8B73D0), Color(0xFFB39CE4), Color(0xFFD4C4EF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
