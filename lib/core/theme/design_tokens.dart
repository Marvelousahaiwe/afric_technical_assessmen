import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFF0F0F1E);
  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFF00D2FF);
  static const Color surface = Color(0xFF1E1E2E);
  static const Color accent = Color(0xFFFF4B2B);
  static const Color success = Color(0xFF00C853);
  static const Color error = Color(0xFFFF1744);

  static Color glassBackground = Colors.white.withValues(alpha: 0.1);
  static Color glassBorder = Colors.white.withValues(alpha: 0.2);
  static const Color textBody = Colors.white70;
  static const Color textHeadline = Colors.white;
}

class AppTextStyles {
  static TextStyle headlineLarge = GoogleFonts.outfit(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textHeadline,
  );

  static TextStyle headlineMedium = GoogleFonts.outfit(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textHeadline,
  );

  static TextStyle bodyLarge = GoogleFonts.outfit(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textBody,
  );

  static TextStyle bodyMedium = GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textBody,
  );

  static TextStyle button = GoogleFonts.outfit(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

class AppSizes {
  static const double p4 = 4.0;
  static const double p8 = 8.0;
  static const double p12 = 12.0;
  static const double p16 = 16.0;
  static const double p20 = 20.0;
  static const double p24 = 24.0;
  static const double p32 = 32.0;
  static const double p48 = 48.0;
  static const double radius = 24.0;
}
