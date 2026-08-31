import 'package:equb_v3_frontend/widgets/sections/vote_tracker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

VoteTracker tracker({
  int approvals = 0,
  int rejections = 0,
  int memberCount = 7,
  int? requiredApprovals = 4,
}) =>
    VoteTracker(
      approvals: approvals,
      rejections: rejections,
      memberCount: memberCount,
      requiredApprovals: requiredApprovals,
    );

Future<List<Container>> pumpBoxes(WidgetTester tester, VoteTracker widget) async {
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(body: SizedBox(width: 300, child: widget)),
  ));
  return tester.widgetList<Container>(find.byType(Container)).toList();
}

Size boxSizeOf(WidgetTester tester) =>
    tester.getSize(find.byType(Container).first);

int borderedCount(List<Container> boxes) => boxes
    .where((b) => (b.decoration as BoxDecoration).border != null)
    .length;

int filledWith(List<Container> boxes, Color color) => boxes
    .where((b) => (b.decoration as BoxDecoration).color == color)
    .length;

void main() {
  group('boxes', () {
    test('there is one box per member', () {
      expect(tracker(approvals: 2, rejections: 1).boxes.length, 7);
    });

    test('counts match the votes cast', () {
      final boxes = tracker(approvals: 2, rejections: 1).boxes;
      expect(boxes.where((b) => b == VoteBox.approved).length, 2);
      expect(boxes.where((b) => b == VoteBox.declined).length, 1);
      expect(boxes.where((b) => b == VoteBox.pending).length, 4);
    });

    test('declines sort last so they stay out of the threshold region', () {
      final boxes = tracker(approvals: 1, rejections: 2).boxes;
      final firstDecline = boxes.indexOf(VoteBox.declined);
      final lastPending = boxes.lastIndexOf(VoteBox.pending);
      expect(firstDecline, greaterThan(lastPending));
    });

    test('an all-declined request still renders one box per member', () {
      expect(tracker(rejections: 7).boxes.length, 7);
    });
  });

  group('rendering', () {
    testWidgets('exactly the required number of boxes are outlined',
        (tester) async {
      final boxes = await pumpBoxes(tester, tracker(approvals: 1));
      expect(boxes.length, 7);
      expect(borderedCount(boxes), 4);
    });

    testWidgets('no box is outlined when only the creator decides',
        (tester) async {
      final boxes =
          await pumpBoxes(tester, tracker(requiredApprovals: null, approvals: 1));
      expect(boxes.length, 7);
      expect(borderedCount(boxes), 0);
    });

    testWidgets('approved and declined boxes carry their own colours',
        (tester) async {
      final boxes =
          await pumpBoxes(tester, tracker(approvals: 2, rejections: 1));
      expect(filledWith(boxes, approvedColor), 2);
      expect(filledWith(boxes, declinedColor), 1);
    });

    testWidgets('twenty members wrap instead of overflowing', (tester) async {
      await pumpBoxes(
        tester,
        tracker(memberCount: 20, requiredApprovals: 11, approvals: 3),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('every box is a fixed square', (tester) async {
      await pumpBoxes(tester, tracker(approvals: 1));
      expect(boxSizeOf(tester),
          const Size(VoteTracker.boxSize, VoteTracker.boxSize));
    });

    test('height grows a row at a time', () {
      const perRow = VoteTracker.boxesPerRow;
      expect(VoteTracker.heightFor(perRow), VoteTracker.boxSize);
      expect(VoteTracker.heightFor(perRow + 1),
          VoteTracker.boxSize * 2 + VoteTracker.boxGap);
      final rows = (20 / perRow).ceil();
      expect(VoteTracker.heightFor(20),
          VoteTracker.boxSize * rows + VoteTracker.boxGap * (rows - 1));
    });
  });
}
