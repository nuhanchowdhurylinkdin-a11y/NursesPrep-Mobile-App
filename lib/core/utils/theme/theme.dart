import 'package:flutter/material.dart';

import 'app_colors_extension.dart';
import 'custom_themes/app_bar_theme.dart';
import 'custom_themes/elevated_button_theme.dart';
import 'custom_themes/text_field_theme.dart';
import 'custom_themes/text_theme.dart';
import '../constants/colors.dart';

class AppTheme {
  AppTheme._();

  static const _primaryBlue = Color(0xFF0F58BD);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: _primaryBlue,
    colorScheme: const ColorScheme.light(
      primary: _primaryBlue,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      surface: Colors.white,
      onSurface: Color(0xFF111418),
      onSurfaceVariant: Color(0xFF6B7280),
      outline: Color(0xFFE5E7EB),
      outlineVariant: Color(0xFFDBE0E6),
      error: AppColors.error,
    ),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: _primaryBlue,
      linearTrackColor: Color(0xFFDBE0E6),
    ),
    textTheme: AppTextTheme.lightTextTheme,
    elevatedButtonTheme: AppElevatedButtonTheme.lightElevatedButtonTheme,
    appBarTheme: App_BarTheme.lightAppBarTheme,
    inputDecorationTheme: AppTextFormFieldTheme.lightInputDecorationTheme,
    extensions: const [AppColorsExtension.light],
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: _primaryBlue,
    colorScheme: const ColorScheme.dark(
      primary: _primaryBlue,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      surface: Color(0xFF1E1E1E),
      onSurface: Color(0xFFE2E8F0),
      onSurfaceVariant: Color(0xFF9CA3AF),
      outline: Color(0xFF374151),
      outlineVariant: Color(0xFF2D3748),
      error: AppColors.error,
    ),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: _primaryBlue,
      linearTrackColor: Color(0xFF374151),
    ),
    textTheme: AppTextTheme.darkTextTheme,
    elevatedButtonTheme: AppElevatedButtonTheme.darkElevatedButtonTheme,
    appBarTheme: App_BarTheme.darkAppBarTheme,
    inputDecorationTheme: AppTextFormFieldTheme.darkInputDecorationTheme,
    extensions: const [AppColorsExtension.dark],
  );
}
