import 'package:equb_v3_frontend/widgets/sections/join_requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/builders/equb_join_request_builder.dart';
import '../../support/builders/user_builder.dart';

void main() {
  group('the strip height matches what a card actually needs', () {
    for (final members in [2, 3, 4, 7, 12, 20]) {
      for (final trusters in [0, 1, 4]) {
        testWidgets('$members members, $trusters trusters', (tester) async {
          await tester.pumpWidget(MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: SizedBox(
                  width: joinRequestCardWidth,
                  child: JoinRequestCard(
                      buildEqubJoinRequest(
                        approvals: 1,
                        trustedBy: List.generate(
                            trusters, (i) => buildUser(id: 50 + i)),
                      ),
                      1,
                      members),
                ),
              ),
            ),
          ));

          final intrinsic = tester.getSize(find.byType(JoinRequestCard)).height;
          expect(joinRequestStripHeight(members), intrinsic,
              reason: 'a $members member card would be clipped or leave a gap');
        });
      }
    }
  });
}
