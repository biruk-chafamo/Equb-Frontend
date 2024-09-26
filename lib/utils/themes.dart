import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scrollbarTheme: ScrollbarThemeData(
        thickness: WidgetStateProperty.all(0),
      ),
      tabBarTheme: TabBarTheme(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        tabAlignment: TabAlignment.center,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.onTertiary.withOpacity(0.9)),
        dividerColor: Colors.transparent,
        unselectedLabelColor: AppColors.onPrimary,
        labelColor: AppColors.surface,
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: AppColors.onSecondaryContainer,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.onSecondaryContainer,
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.onTertiary,
        selectionColor: AppColors.secondaryContainer,
        selectionHandleColor: AppColors.onTertiary,
      ),
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
      inputDecorationTheme: const InputDecorationTheme(
        errorStyle: TextStyle(
          color: Colors.red,
        ),
        labelStyle: TextStyle(
          color: AppColors.onSecondaryContainer,
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.onSecondaryContainer,
          ),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.onSecondaryContainer,
          ),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
