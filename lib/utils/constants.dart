import 'package:flutter/material.dart';

class AppSizes {
  static const double smallScreen = 820;
  static const double mediumScreen = 1100;
}

class AppColors {
  // colors
  static const primary = Color.fromARGB(255, 223, 237, 216);
  static const secondary = Color.fromARGB(157, 56, 87, 35);
  static const tertiary = Color.fromARGB(255, 255, 239, 185);
  // containers
  static const primaryContainer = Color.fromARGB(255, 254, 254, 254);
  static const secondaryContainer = Color.fromARGB(223, 223, 237, 216);
  static const tertiaryContainer = Color.fromARGB(255, 211, 206, 193);

  static const onPrimaryContainer = Color.fromARGB(255, 198, 198, 196);
  static const onSecondaryContainer = Color.fromARGB(255, 74, 104, 47);
  static const onTertiaryContainer = Color.fromARGB(255, 166, 193, 233);

  // text
  static const onPrimary = Color.fromARGB(255, 58, 58, 58);
  static const onSecondary = Color.fromARGB(255, 56, 87, 35);
  static const onTertiary = Color.fromARGB(255, 193, 96, 12);
  static const onSurface = Color.fromARGB(255, 72, 72, 72);
  static const onError = Color.fromARGB(255, 140, 92, 92);

  // background
  static const surface = Color.fromARGB(255, 196, 225, 201);
  static const background = Color.fromARGB(255, 243, 244, 243);
  static const error = Color.fromARGB(255, 249, 232, 231);
}

class AppPadding {
  static const EdgeInsets globalPadding = EdgeInsets.all(15);
  static const double cardMargin = 8.0;
  static const double cardBorderRadius = 10.0;
}

class AppMargin {
  static const EdgeInsets globalMargin = EdgeInsets.all(8.0);
}

class FontSizes {
  static const double largeText = 24.0;
  static const double mediumText = 20.0;
  static const double smallText = 14.0;
}

class AppShadows {
  static const List<BoxShadow> cardShadows = [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 8.0,
      offset: Offset(0, 2),
    ),
  ];
}

class AppBorder {
  static const radius = BorderRadius.all(Radius.circular(12));
}

class SecondaryBoxDecor extends BoxDecoration {
  SecondaryBoxDecor()
      : super(
          color: AppColors.secondaryContainer,
          border: Border.all(color: AppColors.onSecondary),
          borderRadius: AppBorder.radius,
          boxShadow: [
            const BoxShadow(
              color: Color.fromARGB(29, 79, 79, 79),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        );
}

class PrimaryBoxDecor extends BoxDecoration {
  PrimaryBoxDecor()
      : super(
          color: AppColors.primaryContainer,
          border: Border.all(color: AppColors.onPrimary.withOpacity(0.3)),
          borderRadius: AppBorder.radius,
          boxShadow: [
            const BoxShadow(
              color: Color.fromARGB(97, 113, 113, 113),
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        );
}
