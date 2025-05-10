import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scrollbarTheme: ScrollbarThemeData(
        thickness: WidgetStateProperty.all(0),
      ),
      tabBarTheme: TabBarTheme(
        indicatorColor: AppColors.onTertiary,
        // overlayColor: WidgetStateProperty.all(Colors.transparent),
        tabAlignment: TabAlignment.center,
        // indicatorSize: TabBarIndicatorSize.tab,
        // indicator: BoxDecoration(
        //     borderRadius: BorderRadius.circular(12),
        //     color: AppColors.onTertiary.withOpacity(0.9)),
        dividerColor: AppColors.onPrimary.withOpacity(0.1),
        unselectedLabelColor: AppColors.onPrimary,
        labelColor: AppColors.onTertiary,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: AppColors.onSecondaryContainer,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
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
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSecondaryContainer,
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
        filled: true,
        fillColor: AppColors.secondaryContainer.withOpacity(0.4),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        labelStyle: const TextStyle(
          color: AppColors.onSecondaryContainer,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: const TextStyle(
          color: AppColors.onSecondaryContainer,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: AppBorder.radius,
          borderSide: BorderSide(
            color: AppColors.onSecondaryContainer.withOpacity(0.4),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppBorder.radius,
          borderSide: BorderSide(
            color: AppColors.onSecondaryContainer.withOpacity(0.4),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppBorder.radius,
          borderSide: BorderSide(
            color: AppColors.onSecondaryContainer.withOpacity(0.4),
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppBorder.radius,
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: AppBorder.radius,
          borderSide: BorderSide(color: Colors.red),
        ),
        errorStyle: const TextStyle(
          color: Colors.red,
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
