import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData dark() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.mysticPurple,
        secondary: AppColors.mysticGold,
        surface: AppColors.cosmic800,
      ),
      scaffoldBackgroundColor: Colors.transparent,
    );

    return base.copyWith(
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.mysticPurple,
        selectionColor: AppColors.mysticPurple.withValues(alpha: 0.35),
        selectionHandleColor: AppColors.mysticPurple,
      ),
    );
  }
}
