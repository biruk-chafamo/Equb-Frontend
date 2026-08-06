import 'package:flutter/widgets.dart';

// Non-web platforms use .signIn() instead, no rendered button needed.
Widget googleSignInButton({double? minimumWidth}) => const SizedBox.shrink();
