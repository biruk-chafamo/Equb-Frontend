import 'package:flutter/widgets.dart';
import 'package:google_sign_in_web/web_only.dart' as web;

// .signIn() can't reliably get an idToken on web, so render Google's own button.
//
// Google's brand guidelines only allow a fixed set of themes (outline,
// filledBlue, filledBlack) - none can be recolored to match the app's
// palette, so `outline` (white/bordered) is the closest available match.
// Shape and size are still configurable, so those are set to align as
// closely as possible with the rest of the login screen's buttons.
Widget googleSignInButton({double? minimumWidth}) => web.renderButton(
      configuration: web.GSIButtonConfiguration(
        minimumWidth: minimumWidth,
        shape: web.GSIButtonShape.rectangular,
        theme: web.GSIButtonTheme.outline,
        size: web.GSIButtonSize.large,
        text: web.GSIButtonText.signinWith,
      ),
    );
