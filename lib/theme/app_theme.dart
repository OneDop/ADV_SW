import 'package:flutter/material.dart';

class AppColors {
  // Teal palette
  static const Color teal900 = Color(0xFF002B38);
  static const Color teal800 = Color(0xFF003547);
  static const Color teal700 = Color(0xFF004253);
  static const Color teal600 = Color(0xFF005B71);
  static const Color teal500 = Color(0xFF006D87);
  static const Color teal100 = Color(0xFFD0E6F3);
  static const Color teal50  = Color(0xFFE8F2F8);
  static const Color aqua    = Color(0xFF8DD0E9);

  // Warm palette
  static const Color warm700 = Color(0xFF622E00);
  static const Color warm600 = Color(0xFF854000);
  static const Color warm300 = Color(0xFFFFDCC6);
  static const Color warm100 = Color(0xFFFFF1E6);

  // Success palette
  static const Color success700 = Color(0xFF1F6B4A);
  static const Color success100 = Color(0xFFD6EDDE);

  // Background / surface
  static const Color bg     = Color(0xFFF8F9FA);
  static const Color bgAlt  = Color(0xFFF2F4F6);
  static const Color card   = Color(0xFFFFFFFF);

  // Ink (text)
  static const Color ink900 = Color(0xFF004253);
  static const Color ink700 = Color(0xFF40484C);
  static const Color ink500 = Color(0xFF70787D);
  static const Color ink400 = Color(0xFF94A3B8);
  static const Color ink300 = Color(0xFFBFC8CC);

  // Borders
  static const Color line     = Color(0xFFE7E8E9);
  static const Color lineSoft = Color(0xFFECEEEF);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.teal700,
      primary: AppColors.teal700,
      surface: AppColors.bg,
    ),
    scaffoldBackgroundColor: AppColors.bg,
    fontFamily: 'Manrope',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bg,
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: AppColors.ink900,
    ),
  );

  // Gradient helpers
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [AppColors.teal700, AppColors.teal500],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadow helpers
  static List<BoxShadow> get shadowSm => [
    BoxShadow(color: const Color(0xFF0F1F29).withValues(alpha: 0.04), blurRadius: 2, offset: const Offset(0, 1)),
    BoxShadow(color: const Color(0xFF0F1F29).withValues(alpha: 0.03), blurRadius: 1, offset: const Offset(0, 1)),
  ];

  static List<BoxShadow> get shadowMd => [
    BoxShadow(color: const Color(0xFF0F1F29).withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4)),
    BoxShadow(color: const Color(0xFF0F1F29).withValues(alpha: 0.03), blurRadius: 2, offset: const Offset(0, 1)),
  ];

  static List<BoxShadow> get shadowLg => [
    BoxShadow(color: const Color(0xFF0F1F29).withValues(alpha: 0.06), blurRadius: 24, offset: const Offset(0, 10)),
    BoxShadow(color: const Color(0xFF0F1F29).withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2)),
  ];
}
