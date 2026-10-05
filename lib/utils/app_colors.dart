import 'package:flutter/material.dart';

/// Neo-Brutalist color tokens and styling utilities for CareerConnect.
/// Characterized by high-contrast black borders, hard unblurred drop shadows,
/// and punchy retro-modern pastel & electric accents.
class AppColors {
  // Neo-Brutal Base
  static const Color neoBlack = Color(0xFF121212); // Deep rich black
  static const Color neoBackground = Color(0xFFFDFBF7); // Warm retro off-white / canvas
  static const Color neoSurface = Colors.white;

  // Punchy Neo-Brutal Accents
  static const Color neoYellow = Color(0xFFFFDE59); // Electric Sun Yellow
  static const Color neoBlue = Color(0xFF3B82F6); // Punchy Royal Blue
  static const Color neoGreen = Color(0xFF00E676); // Mint Electric Green
  static const Color neoPink = Color(0xFFFF66C4); // Retro Bubblegum Pink
  static const Color neoPurple = Color(0xFFA855F7); // Vivid Purple
  static const Color neoOrange = Color(0xFFFF8A00); // Warm Tangerine
  static const Color neoCyan = Color(0xFF00D2FF); // Vivid Cyan

  // Functional Aliases for consistency
  static const Color primary = neoBlue;
  static const Color primaryDark = neoBlack;
  static const Color primaryLight = Color(0xFF60A5FA);
  static const Color primaryTint = Color(0xFFE0E7FF);

  static const Color secondary = neoGreen;
  static const Color secondaryTint = Color(0xFFDCFCE7);

  static const Color background = neoBackground;
  static const Color surface = neoSurface;
  static const Color cardSurface = neoSurface;

  // Typography
  static const Color textPrimary = neoBlack;
  static const Color textSecondary = Color(0xFF374151); // Dark neutral
  static const Color textMuted = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);

  // Status Tints
  static const Color success = Color(0xFF16A34A);
  static const Color successBg = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFD97706);
  static const Color warningBg = Color(0xFFFEF3C7);
  static const Color border = neoBlack; // 100% crisp solid black borders
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFE5E7EB);

  // Neo-Brutalist Hard Drop Shadow (Zero blur, crisp offset)
  static List<BoxShadow> neoShadow({
    double offset = 4.0,
    Color color = neoBlack,
  }) =>
      [
        BoxShadow(
          color: color,
          offset: Offset(offset, offset),
          blurRadius: 0,
        ),
      ];

  static List<BoxShadow> get cardShadow => neoShadow(offset: 4.0);
  static List<BoxShadow> get buttonShadow => neoShadow(offset: 3.0);
  static List<BoxShadow> get chipShadow => neoShadow(offset: 2.0);
  static List<BoxShadow> get headerShadow => neoShadow(offset: 6.0);
}
