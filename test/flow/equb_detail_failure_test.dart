import 'package:equb_v3_frontend/models/equb/equb_detail.dart';
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

  EqubDetail sunrise() => buildEqubDetail(
      id: 7, name: 'Sunrise', members: [alice], isActive: true);

  setUp(() {
    deps = TestDependencies();
    deps.auth.currentUserProfile = alice;
    deps.user.currentUser = alice;
    deps.equb.equbsResult = [sunrise()];
    deps.equb.equbDetailResult = (_) => sunrise();
  });

  Future<void> openWithFailure(WidgetTester tester) async {
    await pumpApp(tester, deps, at: '/equbs_overview');
    await pumpUntilFound(tester, find.text('Sunrise'));

    deps.equb.nextError = Exception('boom');
    await tester.tap(find.text('Sunrise').first);
    await pumpFrames(tester, 20);
  }

  testWidgets('a detail that fails to load says so instead of spinning',
      (tester) async {
    await openWithFailure(tester);

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('retrying refetches the equb', (tester) async {
    await openWithFailure(tester);

    final before = deps.equb.calls.where((c) => c == 'getEqubDetail(7)').length;
    await tester.tap(find.text('Try again'));
    await pumpFrames(tester, 20);

    final after = deps.equb.calls.where((c) => c == 'getEqubDetail(7)').length;
    expect(after, greaterThan(before));
    expect(find.text('Try again'), findsNothing);
  });
}
