import 'package:equb_v3_frontend/widgets/sections/join_requests.dart';
import 'package:equb_v3_frontend/widgets/sections/vote_tracker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/builders/equb_join_request_builder.dart';
import '../../support/builders/user_builder.dart';

Future<void> pumpCard(WidgetTester tester, double width,
    {int trusters = 2}) async {
  final request = buildEqubJoinRequest(
    sender: buildUser(id: 9, firstName: 'Bartholomew', lastName: 'Wintersgill'),
    approvals: 1,
    requiredApprovals: 4,
    trustedBy: List.generate(trusters, (i) => buildUser(id: 100 + i)),
  );
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: SizedBox(width: width, child: JoinRequestCard(request, 1, 7)),
    ),
  ));
}

void main() {
  for (final width in [250.0, joinRequestCardWidth, 400.0]) {
    testWidgets('the card does not overflow at ${width}px', (tester) async {
      await pumpCard(tester, width);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('a long name and many trusters still do not overflow',
      (tester) async {
    await pumpCard(tester, joinRequestCardWidth, trusters: 6);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the card shows the tracker and both actions', (tester) async {
    await pumpCard(tester, joinRequestCardWidth);
    expect(find.byType(VoteTracker), findsOneWidget);
    expect(find.text('Approve'), findsOneWidget);
    expect(find.text('Decline'), findsOneWidget);
    expect(find.text('Trusted by 2 members'), findsOneWidget);
  });

  testWidgets('the chosen option is the filled one', (tester) async {
    final approved = buildEqubJoinRequest(currentUserVote: true, approvals: 1);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SizedBox(
            width: joinRequestCardWidth,
            child: JoinRequestCard(approved, 1, 7)),
      ),
    ));
    expect(find.text('Approved'), findsOneWidget);
    expect(find.text('Decline'), findsOneWidget);
  });
}
