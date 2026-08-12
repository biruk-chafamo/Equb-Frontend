import 'package:equb_v3_frontend/models/equb_invite/equb_invite.dart';
import 'package:equb_v3_frontend/models/friendship/friend_request.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fixtures/fixture_reader.dart';
import 'fixture_paths.dart';

void main() {
  group('friend requests', () {
    test('parse with both parties nested', () {
      final requests = jsonListFixture(friendRequestsReceived)
          .cast<Map<String, dynamic>>()
          .map(FriendRequest.fromJson)
          .toList();

      expect(requests, isNotEmpty);
      for (final request in requests) {
        expect(request.sender.username, isNotEmpty);
        expect(request.receiver.username, isNotEmpty);
        expect(request.sender.id, isNot(request.receiver.id));
      }
    });

    test('sender and receiver are objects, not hyperlinks', () {
      final json =
          jsonListFixture(friendRequestsReceived).first as Map<String, dynamic>;

      expect(json['sender'], isA<Map<String, dynamic>>());
      expect(json['receiver'], isA<Map<String, dynamic>>());
    });

    test('a received request is not yet accepted', () {
      final requests = jsonListFixture(friendRequestsReceived)
          .cast<Map<String, dynamic>>()
          .map(FriendRequest.fromJson);

      expect(requests.every((r) => r.isAccepted), isFalse);
    });

    test('creation_date parses as a real timestamp', () {
      final json =
          jsonListFixture(friendRequestsReceived).first as Map<String, dynamic>;

      expect(json['creation_date'], isA<String>());
      expect(DateTime.tryParse(json['creation_date'] as String), isNotNull);
    });
  });

  group('equb invites', () {
    test('nest a whole equb payload under equb', () {
      final invites = jsonListFixture(equbInvitesReceived)
          .cast<Map<String, dynamic>>()
          .map(EqubInvite.fromJson)
          .toList();

      expect(invites, isNotEmpty);
      for (final invite in invites) {
        expect(invite.equbDetail.name, isNotEmpty);
        expect(invite.equbDetail.maxMembers, greaterThan(1));
        expect(invite.receiver.username, isNotEmpty);
      }
    });

    test('the nested equb carries the full detail contract', () {
      final json =
          jsonListFixture(equbInvitesReceived).first as Map<String, dynamic>;
      final equb = json['equb'] as Map<String, dynamic>;

      expect(equb['amount'], isA<String>());
      expect(equb['current_award'], isA<num>());
      expect(equb['time_left_till_next_round'], isA<Map<String, dynamic>>());
      expect(equb['user_payment_status'], isA<String>());
    });

    test('invites to one equb all point at that equb', () {
      final invites = jsonListFixture(equbInvitesByEqub)
          .cast<Map<String, dynamic>>()
          .map(EqubInvite.fromJson)
          .toList();

      expect(invites, isNotEmpty);
      expect(invites.map((i) => i.equbDetail.id).toSet(), hasLength(1));
    });

    test('a pending invite is neither accepted nor rejected', () {
      final invites = jsonListFixture(equbInvitesByEqub)
          .cast<Map<String, dynamic>>()
          .map(EqubInvite.fromJson);

      expect(invites.every((i) => !i.isAccepted && !i.isRejected), isTrue);
    });
  });
}
