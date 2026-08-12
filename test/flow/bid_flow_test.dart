import 'dart:convert';

import 'package:equb_v3_frontend/models/equb/equb_detail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/builders/equb_builder.dart';
import '../support/builders/user_builder.dart';
import '../support/fakes/test_dependencies.dart';
import '../support/harness/pump_app.dart';
import '../support/harness/pump_helpers.dart';

void main() {
  late TestDependencies deps;
  final alice = buildUser(id: 1, firstName: 'Alice');

  EqubDetail sunrise({double highestBid = 0.02}) => buildEqubDetail(
        id: 7,
        name: 'Sunrise',
        currentAward: 1200,
        maxMembers: 6,
        currentRound: 2,
        currentHighestBid: highestBid,
        members: [alice],
        currentUserIsMember: true,
        isActive: true,
      );

  setUp(() {
    deps = TestDependencies();
    deps.auth.currentUserProfile = alice;
    deps.user.currentUser = alice;
    deps.equb.equbsResult = [sunrise()];
    deps.equb.equbDetailResult = (_) => sunrise();
  });

  testWidgets('the overview lists the active equb with its derived values',
      (tester) async {
    await pumpApp(tester, deps, at: '/equbs_overview');
    await pumpUntilFound(tester, find.text('Sunrise'));

    expect(find.text('Sunrise'), findsWidgets);
    expect(find.text(r'$1,200.0'), findsWidgets);
    expect(find.text('2.0%'), findsWidgets);
    expect(find.text('2 / 6'), findsWidgets);
    expect(find.text('7 days'), findsWidgets);
  });

  testWidgets('opening an equb fetches its detail', (tester) async {
    await pumpApp(tester, deps, at: '/equbs_overview');
    await pumpUntilFound(tester, find.text('Sunrise'));

    await tester.tap(find.text('Sunrise').first);
    await pumpFrames(tester, 10);

    expect(deps.equb.calls, contains('getEqubDetail(7)'));
  });

  testWidgets('the equb list survives a live update pushed over the socket',
      (tester) async {
    await pumpApp(tester, deps, at: '/equbs_overview');
    await pumpUntilFound(tester, find.text('Sunrise'));

    await tester.tap(find.text('Sunrise').first);
    await pumpFrames(tester, 10);

    final before =
        deps.equb.calls.where((c) => c == 'getEqubDetail(7)').length;

    deps.equb.equbDetailResult = (_) => sunrise(highestBid: 0.035);
    deps.equb.wsChannel.emitServer(jsonEncode({'equb_id': 7}));
    await pumpFrames(tester, 10);

    expect(
      deps.equb.calls.where((c) => c == 'getEqubDetail(7)').length,
      greaterThan(before),
    );
  });

  testWidgets('the socket is opened once no matter how often we refetch',
      (tester) async {
    await pumpApp(tester, deps, at: '/equbs_overview');
    await pumpUntilFound(tester, find.text('Sunrise'));

    await tester.tap(find.text('Sunrise').first);
    await pumpFrames(tester, 10);
    deps.equb.wsChannel.emitServer(jsonEncode({'equb_id': 7}));
    await pumpFrames(tester, 10);
    deps.equb.wsChannel.emitServer(jsonEncode({'equb_id': 7}));
    await pumpFrames(tester, 10);

    expect(
      deps.equb.calls.where((c) => c == 'startEqubWsChannel()').length,
      1,
    );
  });

  testWidgets('a failed equb fetch does not leave the app blank',
      (tester) async {
    deps.equb.nextError = Exception('500');

    await pumpApp(tester, deps, at: '/equbs_overview');
    await pumpFrames(tester, 15);

    expect(tester.takeException(), isNull);
  });
}
