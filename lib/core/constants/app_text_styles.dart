import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Headings
  static TextStyle h1(ColorScheme colorScheme) => TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: colorScheme.onSurface,
  );

  static TextStyle h2(ColorScheme colorScheme) => TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: colorScheme.onSurface,
  );

  static TextStyle h3(ColorScheme colorScheme) => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: colorScheme.onSurface,
  );

  // Body text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // Button text
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
