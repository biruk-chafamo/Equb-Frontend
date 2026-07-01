import 'package:equb_v3_frontend/blocs/equb_invite/invite_status.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/builders/equb_invite_builder.dart';
import '../../support/builders/user_builder.dart';

void main() {
  final alice = buildUser(id: 1, firstName: 'Alice');
  final bob = buildUser(id: 2, firstName: 'Bob');
  final carol = buildUser(id: 3, firstName: 'Carol');

  InviteStatus statusOf(List<UserWithInviteStatus> results, int userId) =>
      results.firstWhere((r) => r.user.id == userId).inviteStatus;

  test('a user already in the equb is a member', () {
    final result = deriveInviteStatuses(
      users: [alice],
      members: [alice],
      equbInvites: const [],
    );

    expect(statusOf(result, alice.id), InviteStatus.member);
  });

  test('a user with an outstanding invite is invited', () {
    final result = deriveInviteStatuses(
      users: [bob],
      members: const [],
      equbInvites: [buildEqubInvite(receiver: bob)],
    );

    expect(statusOf(result, bob.id), InviteStatus.invited);
  });

  test('an unrelated user has no invite status', () {
    final result = deriveInviteStatuses(
      users: [carol],
      members: const [],
      equbInvites: const [],
    );

    expect(statusOf(result, carol.id), InviteStatus.none);
  });

  test('membership outranks an outstanding invite', () {
    final result = deriveInviteStatuses(
      users: [alice],
      members: [alice],
      equbInvites: [buildEqubInvite(receiver: alice)],
    );

    expect(statusOf(result, alice.id), InviteStatus.member);
  });

  test('an invite addressed to someone else does not leak', () {
    final result = deriveInviteStatuses(
      users: [bob, carol],
      members: const [],
      equbInvites: [buildEqubInvite(receiver: bob)],
    );

    expect(statusOf(result, bob.id), InviteStatus.invited);
    expect(statusOf(result, carol.id), InviteStatus.none);
  });

  test('classifies every user and preserves their order', () {
    final result = deriveInviteStatuses(
      users: [alice, bob, carol],
      members: [alice],
      equbInvites: [buildEqubInvite(receiver: bob)],
    );

    expect(result.map((r) => r.user.id), [1, 2, 3]);
    expect(result.map((r) => r.inviteStatus), [
      InviteStatus.member,
      InviteStatus.invited,
      InviteStatus.none,
    ]);
  });

  test('an empty user list yields an empty result', () {
    final result = deriveInviteStatuses(
      users: const [],
      members: [alice],
      equbInvites: const [],
    );

    expect(result, isEmpty);
  });
}
