import 'package:equb_v3_frontend/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/builders/equb_builder.dart';
import '../support/builders/user_builder.dart';
import '../support/fakes/test_dependencies.dart';
import '../support/harness/pump_app.dart';
import '../support/harness/pump_helpers.dart';

void main() {
  late TestDependencies deps;
  final alice = buildUser(id: 1, firstName: 'Alice');

  setUp(() {
    deps = TestDependencies();
    deps.auth.currentUserProfile = alice;
    deps.user.currentUser = alice;
  });

  testWidgets('an unauthenticated visitor lands on the login screen',
      (tester) async {
    deps.auth.profileError = Exception('401');

    await pumpApp(tester, deps, at: '/');
    await pumpUntilFound(tester, find.byType(LoginScreen));

    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('the login screen exposes both credential fields',
      (tester) async {
    await pumpApp(tester, deps, at: '/login');
    await pumpUntilFound(tester, find.byKey(const Key('login_username')));

    expect(find.byKey(const Key('login_username')), findsOneWidget);
    expect(find.byKey(const Key('login_password')), findsOneWidget);
  });

  testWidgets('an authenticated visitor is taken past the login screen',
      (tester) async {
    deps.equb.equbsResult = [buildEqubDetail(id: 7, name: 'Sunrise')];

    await pumpApp(tester, deps, at: '/');
    await pumpFrames(tester, 20);

    expect(deps.auth.calls, contains('getCurrentUserProfile()'));
    expect(find.byType(LoginScreen), findsNothing);
  });
}
