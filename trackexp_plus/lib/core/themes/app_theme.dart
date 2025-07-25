import 'package:flutter/material.dart';
import 'package:trackexp_plus/core/constants/colors.dart';
import 'package:trackexp_plus/core/constants/typography.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.background,
    ),
    textTheme: TextTheme(
      displayLarge: AppTypography.headline1,
      displayMedium: AppTypography.headline2,
      bodyLarge: AppTypography.body1,
      bodyMedium: AppTypography.body2,
      labelLarge: AppTypography.button,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.primary,
        textStyle: AppTypography.button,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.accent,
      foregroundColor: AppColors.primary,
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );

  // Dark theme (placeholder for future implementation)
  static ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: const Color(0xFF121212),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: Color(0xFF121212),
    ),
    textTheme: TextTheme(
      displayLarge: AppTypography.headline1.copyWith(color: Colors.white),
      displayMedium: AppTypography.headline2.copyWith(color: Colors.white),
      bodyLarge: AppTypography.body1.copyWith(color: Colors.white),
      bodyMedium: AppTypography.body2.copyWith(color: Colors.white70),
      labelLarge: AppTypography.button.copyWith(color: AppColors.accent),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.primary,
        textStyle: AppTypography.button,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.accent,
      foregroundColor: AppColors.primary,
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardBackground.withOpacity(0.2),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}
