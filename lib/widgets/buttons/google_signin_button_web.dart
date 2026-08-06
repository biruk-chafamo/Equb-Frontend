import 'package:flutter/widgets.dart';
import 'package:google_sign_in_web/web_only.dart' as web;

// .signIn() can't reliably get an idToken on web, so render Google's own button.
Widget googleSignInButton() => web.renderButton();
