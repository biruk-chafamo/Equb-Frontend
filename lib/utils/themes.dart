import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          tertiary: AppColors.tertiary,
          primaryContainer: AppColors.primaryContainer,
          secondaryContainer: AppColors.secondaryContainer,
          tertiaryContainer: AppColors.tertiaryContainer,
          onPrimaryContainer: AppColors.onPrimaryContainer,
          onSecondaryContainer: AppColors.onSecondaryContainer,
          onTertiaryContainer: AppColors.onTertiaryContainer,
          surface: AppColors.surface,
          error: AppColors.error,
          onPrimary: AppColors.onPrimary,
          onSecondary: AppColors.onSecondary,
          onTertiary: AppColors.onTertiary,
          onSurface: AppColors.onSurface,
          onError: AppColors.onError),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        color: AppColors.primary,
        iconTheme: IconThemeData(color: AppColors.onPrimary),
        toolbarTextStyle: TextStyle(
            color: AppColors.onPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: AppColors.primary,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
