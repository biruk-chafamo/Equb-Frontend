import 'package:equb_v3_frontend/screens/payment_method/create_payment_method_screen.dart';
import 'package:equb_v3_frontend/screens/user/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/builders/user_builder.dart';
import '../support/fakes/test_dependencies.dart';
import '../support/harness/pump_app.dart';
import '../support/harness/pump_helpers.dart';

void main() {
  late TestDependencies deps;

  final existing = buildPaymentMethod(id: 1, service: 'Cash');
  // never updated, so the list can only be right if it stops reading this
  final alice = buildUser(id: 1, firstName: 'Alice', paymentMethods: [existing]);

  setUp(() {
    deps = TestDependencies();
    deps.auth.currentUserProfile = alice;
    deps.user.currentUser = alice;
    deps.paymentMethod.paymentMethodsResult = [existing];
    deps.paymentMethod.servicesResult = ['Cash', 'Venmo'];
  });

  Future<void> openCreateScreen(WidgetTester tester) async {
    await pumpApp(tester, deps, at: '/current_user_profile');
    await pumpUntilFound(tester, find.byType(PaymentMethodAddBox));

    await tester.tap(find.byType(PaymentMethodAddBox));
    await pumpUntilFound(tester, find.byType(ChoiceChip));
  }

  Future<void> submit(WidgetTester tester) async {
    await tester.tap(find.widgetWithText(ChoiceChip, 'Venmo'));
    await pumpFrames(tester, 5);
    await tester.enterText(find.byType(TextFormField), 'alice-venmo');
    await pumpFrames(tester, 5);

    await tester.tap(find.text('Add a Payment Method'));
    await pumpFrames(tester, 20);
  }

  testWidgets('the very first payment method added shows up on the profile',
      (tester) async {
    await openCreateScreen(tester);
    await submit(tester);

    expect(find.byType(CreatePaymentMethodScreen), findsNothing);
    expect(find.byType(PaymentMethodBox), findsNWidgets(2));
    expect(find.text('Venmo '), findsOneWidget);
  });

  testWidgets('the profile list does not depend on a current-user refetch',
      (tester) async {
    await openCreateScreen(tester);
    deps.user.calls.clear();
    await submit(tester);

    expect(deps.user.calls, isNot(contains('getCurrentUser()')));
    expect(find.byType(PaymentMethodBox), findsNWidgets(2));
  });

  testWidgets('a failed create tells the user instead of going quiet',
      (tester) async {
    await openCreateScreen(tester);
    deps.paymentMethod.nextError = Exception('boom');
    await submit(tester);

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.byType(CreatePaymentMethodScreen), findsOneWidget);
  });
}
