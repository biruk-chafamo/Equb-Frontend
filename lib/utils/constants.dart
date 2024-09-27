import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// const bool isProd = bool.fromEnvironment('dart.vm.product');

const baseUrl = "https://api.equbfinance.com";
// const baseUrl = isProd ? "https://www.equbfinance.com" : "http://0.0.0.0:8000";

enum EqubType { active, pending, invites, past, recommended }

enum PaymentStatus { winner, confirmed, unconfirmed, rejected, unpaid }

enum TrustStatus { trusted, requestSent, requestReceived, none }

enum InviteStatus { member, invited, none }

const double appBarIconSize = 30;
const double smallIconSize = 15;

const double smallScreenSize = 600;
const double mediumScreenSize = 840;
const double largeScreenSize = 1100;

final equbAmountNumberFormat = NumberFormat.currency(
  symbol: "\$",
  locale: "en_US",
  decimalDigits: 1,
);

final creationDateFormat = DateFormat('dd/MM/yyyy');

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
  static const tertiaryContainer = Color.fromARGB(255, 237, 180, 130);

  static const onPrimaryContainer = Color.fromARGB(255, 198, 198, 196);
  static const onSecondaryContainer = Color.fromARGB(255, 51, 72, 33);
  static const onTertiaryContainer = Color.fromARGB(255, 166, 193, 233);

  // text
  static const onPrimary = Color.fromARGB(255, 58, 58, 58);
  static const onSecondary = Color.fromARGB(255, 56, 87, 35);
  static const onTertiary = Color.fromARGB(255, 193, 96, 12);
  static const onSurface = Color.fromARGB(255, 72, 72, 72);
  static const onError = Color.fromARGB(255, 140, 92, 92);

  // background
  static const surface = Color.fromARGB(255, 243, 244, 243);
  static const background = Color.fromARGB(255, 243, 244, 243);
  static const error = Color.fromARGB(255, 249, 232, 231);
}

class AppPadding {
  static const EdgeInsets globalPadding = EdgeInsets.all(15.0);
  static const double cardMargin = 8.0;
  static const double cardBorderRadius = 10.0;
}

class AppMargin {
  static const EdgeInsets globalMargin = EdgeInsets.all(15.0);
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
          border: Border.all(color: AppColors.onSecondary.withOpacity(0.3)),
          borderRadius: AppBorder.radius,
          boxShadow: [
            const BoxShadow(
              color: Color.fromARGB(29, 79, 79, 79),
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        );
}

class PrimaryBoxDecor extends BoxDecoration {
  PrimaryBoxDecor()
      : super(
          color: AppColors.primaryContainer,
          border: Border.all(color: AppColors.onPrimary.withOpacity(0.2)),
          borderRadius: AppBorder.radius,
          boxShadow: [
            const BoxShadow(
              color: Color.fromARGB(29, 79, 79, 79),
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        );
}
