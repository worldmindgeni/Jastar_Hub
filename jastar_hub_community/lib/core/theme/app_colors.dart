import 'package:flutter/material.dart';

/// Premium color palette for Jastar Hub Community.
/// Uses Electric Violet as primary, Turquoise as secondary, Pink as accent.
class AppColors {
  AppColors._();

  // ─── Primary ────────────────────────────────────────────────
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryLight = Color(0xFFA29BFE);
  static const Color primaryDark = Color(0xFF5A4BD1);

  // ─── Secondary ──────────────────────────────────────────────
  static const Color secondary = Color(0xFF00CEC9);
  static const Color secondaryLight = Color(0xFF81ECEC);
  static const Color secondaryDark = Color(0xFF00A8A3);

  // ─── Accent ─────────────────────────────────────────────────
  static const Color accent = Color(0xFFFD79A8);
  static const Color accentLight = Color(0xFFFF9CC2);
  static const Color accentDark = Color(0xFFE84393);

  // ─── Backgrounds — Light ────────────────────────────────────
  static const Color backgroundLight = Color(0xFFF8F9FE);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);

  // ─── Backgrounds — Dark ─────────────────────────────────────
  static const Color backgroundDark = Color(0xFF0D1117);
  static const Color surfaceDark = Color(0xFF161B22);
  static const Color cardDark = Color(0xFF21262D);
  static const Color cardDarkElevated = Color(0xFF2D333B);

  // ─── Text — Light ───────────────────────────────────────────
  static const Color textPrimaryLight = Color(0xFF1A1D29);
  static const Color textSecondaryLight = Color(0xFF636E72);
  static const Color textTertiaryLight = Color(0xFFB0B8C1);

  // ─── Text — Dark ────────────────────────────────────────────
  static const Color textPrimaryDark = Color(0xFFF0F0F0);
  static const Color textSecondaryDark = Color(0xFF8B949E);
  static const Color textTertiaryDark = Color(0xFF484F58);

  // ─── Status ─────────────────────────────────────────────────
  static const Color error = Color(0xFFE17055);
  static const Color errorLight = Color(0xFFFF8A76);
  static const Color success = Color(0xFF00B894);
  static const Color successLight = Color(0xFF55EFC4);
  static const Color warning = Color(0xFFFDCB6E);
  static const Color warningLight = Color(0xFFFEE9A0);
  static const Color info = Color(0xFF74B9FF);
  static const Color infoLight = Color(0xFFA3D8FF);

  // ─── Dividers & Borders ─────────────────────────────────────
  static const Color dividerLight = Color(0xFFE8ECF0);
  static const Color dividerDark = Color(0xFF30363D);
  static const Color borderLight = Color(0xFFDDE1E6);
  static const Color borderDark = Color(0xFF3D444D);

  // ─── Shimmer ────────────────────────────────────────────────
  static const Color shimmerBaseLight = Color(0xFFE8ECF0);
  static const Color shimmerHighlightLight = Color(0xFFF5F7FA);
  static const Color shimmerBaseDark = Color(0xFF21262D);
  static const Color shimmerHighlightDark = Color(0xFF2D333B);

  // ─── Gradients ──────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF00CEC9), Color(0xFF81ECEC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFFD79A8), Color(0xFFE84393)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF0D1117), Color(0xFF161B22)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFF0D1117), Color(0xFF1A1040), Color(0xFF2D1B69)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient onboardingGradient1 = LinearGradient(
    colors: [Color(0xFF6C5CE7), Color(0xFF3D2C8D)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient onboardingGradient2 = LinearGradient(
    colors: [Color(0xFF00CEC9), Color(0xFF007F7A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient onboardingGradient3 = LinearGradient(
    colors: [Color(0xFFFD79A8), Color(0xFFB83B5E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ─── Category Colors ────────────────────────────────────────
  static const Color categoryTech = Color(0xFF6C5CE7);
  static const Color categorySports = Color(0xFF00B894);
  static const Color categoryMusic = Color(0xFFFD79A8);
  static const Color categoryArt = Color(0xFFE17055);
  static const Color categoryFood = Color(0xFFFDCB6E);
  static const Color categoryEducation = Color(0xFF74B9FF);
  static const Color categoryBusiness = Color(0xFF636E72);
  static const Color categoryCulture = Color(0xFFA29BFE);
  static const Color categoryWellness = Color(0xFF55EFC4);
  static const Color categoryEntertainment = Color(0xFFFF7675);
}
