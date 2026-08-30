import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// WCAG relative luminance.
double _luminance(Color c) => c.computeLuminance();

double _contrast(Color a, Color b) {
  final l1 = _luminance(a), l2 = _luminance(b);
  final lighter = l1 > l2 ? l1 : l2;
  final darker = l1 > l2 ? l2 : l1;
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  group('error colours', () {
    test('error is a light surface and onError is the text on it', () {
      // this palette inverts the usual Material meaning: error is the light
      // background, onError the dark foreground. Text drawn in the default
      // light-on-dark SnackBar style is invisible against it.
      expect(_luminance(AppColors.error), greaterThan(_luminance(AppColors.onError)));
    });

    test('the pair is readable', () {
      expect(_contrast(AppColors.error, AppColors.onError), greaterThan(3.0));
    });

    test('white text on the error surface would not be readable', () {
      // the bug this guards: SnackBar's default content colour on error
      expect(_contrast(AppColors.error, Colors.white), lessThan(3.0));
    });

    test('the theme exposes the same pair', () {
      final scheme = AppTheme.lightTheme.colorScheme;

      expect(scheme.error, AppColors.error);
      expect(scheme.onError, AppColors.onError);
    });
  });
}
