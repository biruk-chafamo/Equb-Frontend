import 'package:equb_v3_frontend/models/equb/equb_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/builders/equb_builder.dart';
import '../support/builders/equb_join_request_builder.dart';
import '../support/builders/user_builder.dart';
import '../support/fakes/test_dependencies.dart';
import '../support/harness/pump_app.dart';
import '../support/harness/pump_helpers.dart';

void main() {
  late TestDependencies deps;
  final alice = buildUser(id: 1, firstName: 'Alice');
  final bob = buildUser(id: 2, firstName: 'Bob');
  final erin = buildUser(id: 9, firstName: 'Erin', lastName: 'Endale');

  EqubDetail forming({int pendingJoinRequestCount = 1}) => buildEqubDetail(
        id: 7,
        name: 'Weekly Savers',
        maxMembers: 4,
        members: [alice, bob],
        currentUserIsMember: true,
        isActive: false,
        percentJoined: 50,
        pendingJoinRequestCount: pendingJoinRequestCount,
      );

  setUp(() {
    deps = TestDependencies();
    deps.auth.currentUserProfile = alice;
    deps.user.currentUser = alice;
    deps.equb.equbsResult = [forming()];
    deps.equb.equbDetailResult = (_) => forming();
    deps.joinRequest.joinRequestsToEqubResult = [
      buildEqubJoinRequest(
        id: 12,
        equbId: 7,
        sender: erin,
        approvals: 1,
        requiredApprovals: 2,
        trustedBy: [bob],
      ),
    ];
  });

  testWidgets('a forming equb shows how many people are waiting',
      (tester) async {
    await pumpApp(tester, deps, at: '/pending_equbs_overview');
    await pumpUntilFound(tester, find.text('Weekly Savers'));

    expect(find.text('1 request'), findsWidgets);
  });

  testWidgets('opening the equb lists the request with its trust signal',
      (tester) async {
    await pumpApp(tester, deps, at: '/pending_equbs_overview');
    await pumpUntilFound(tester, find.text('Weekly Savers'));

    await tester.tap(find.text('Weekly Savers').first);
    await pumpUntilFound(tester, find.text('Erin Endale'));

    expect(deps.joinRequest.calls, contains('getJoinRequestsToEqub(7)'));
    expect(find.text('1 member trusts Erin'), findsOneWidget);
    expect(find.text('1 of 2 approvals'), findsOneWidget);
  });

  testWidgets('approving sends the vote and refetches the equb',
      (tester) async {
    await pumpApp(tester, deps, at: '/pending_equbs_overview');
    await pumpUntilFound(tester, find.text('Weekly Savers'));

    await tester.tap(find.text('Weekly Savers').first);
    await pumpUntilFound(tester, find.text('Approve'));

    await tester.ensureVisible(find.text('Approve'));
    await tester.tap(find.text('Approve'));
    await pumpFrames(tester, 10);

    expect(deps.joinRequest.calls, contains('voteOnJoinRequest(12, true)'));
    expect(deps.equb.calls, contains('getEqubDetail(7)'));
  });

  testWidgets('a failed vote tells the user instead of going quiet',
      (tester) async {
    await pumpApp(tester, deps, at: '/pending_equbs_overview');
    await pumpUntilFound(tester, find.text('Weekly Savers'));

    await tester.tap(find.text('Weekly Savers').first);
    await pumpUntilFound(tester, find.text('Approve'));

    deps.joinRequest.nextError = Exception('boom');
    await tester.ensureVisible(find.text('Approve'));
    await tester.tap(find.text('Approve'));
    await pumpFrames(tester, 10);

    expect(find.byType(SnackBar), findsOneWidget);
  });
}
