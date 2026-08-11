import 'package:equb_v3_frontend/widgets/cards/equb_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/builders/equb_builder.dart';
import '../support/harness/pump_helpers.dart';

void main() {
  Future<void> pumpOverview(
    WidgetTester tester, {
    double currentAward = 1200,
    double currentHighestBid = 0.025,
    int currentRound = 2,
    int maxMembers = 6,
    String cycle = '7 00:00:00',
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ActiveEqubBriefOverview(
            equbDetail: buildEqubDetail(
              currentAward: currentAward,
              currentHighestBid: currentHighestBid,
              currentRound: currentRound,
              maxMembers: maxMembers,
              cycle: cycle,
            ),
          ),
        ),
      ),
    );
    await pumpFrames(tester, 2);
  }

  testWidgets('renders the award as currency with one decimal', (tester) async {
    await pumpOverview(tester, currentAward: 1200);

    expect(find.text(r'$1,200.0'), findsOneWidget);
  });

  testWidgets('renders the bid as a percentage', (tester) async {
    await pumpOverview(tester, currentHighestBid: 0.025);

    expect(find.text('2.5%'), findsOneWidget);
  });

  testWidgets('renders a zero bid as zero percent', (tester) async {
    await pumpOverview(tester, currentHighestBid: 0);

    expect(find.text('0.0%'), findsOneWidget);
  });

  testWidgets('renders the round out of the member count', (tester) async {
    await pumpOverview(tester, currentRound: 2, maxMembers: 6);

    expect(find.text('2 / 6'), findsOneWidget);
  });

  testWidgets('renders the cycle in its largest unit', (tester) async {
    await pumpOverview(tester, cycle: '7 00:00:00');
    expect(find.text('7 days'), findsOneWidget);

    await pumpOverview(tester, cycle: '00:30:00');
    expect(find.text('30 mins'), findsOneWidget);
  });

  testWidgets('labels every column', (tester) async {
    await pumpOverview(tester);

    for (final label in ['Amount', 'Interest', 'Round', 'Cycle']) {
      expect(find.text(label), findsOneWidget);
    }
  });
}
