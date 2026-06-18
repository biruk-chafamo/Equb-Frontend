import 'package:equb_v3_frontend/blocs/friendships/trust_status.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/builders/friendship_builder.dart';
import '../../support/builders/user_builder.dart';

void main() {
  final alice = buildUser(id: 1, firstName: 'Alice');
  final bob = buildUser(id: 2, firstName: 'Bob');
  final carol = buildUser(id: 3, firstName: 'Carol');
  final dave = buildUser(id: 4, firstName: 'Dave');

  TrustStatus statusOf(
    List<UserWithTrustStatus> results,
    int userId,
  ) =>
      results.firstWhere((r) => r.user.id == userId).trustStatus;

  test('an unrelated user has no trust status', () {
    final result = deriveTrustStatuses(
      searchedUsers: [dave],
      friends: const [],
      sentRequests: const [],
      receivedRequests: const [],
    );

    expect(statusOf(result, dave.id), TrustStatus.none);
  });

  test('an existing friend is trusted', () {
    final result = deriveTrustStatuses(
      searchedUsers: [alice],
      friends: [alice],
      sentRequests: const [],
      receivedRequests: const [],
    );

    expect(statusOf(result, alice.id), TrustStatus.trusted);
  });

  test('a request we sent is matched on its receiver', () {
    final result = deriveTrustStatuses(
      searchedUsers: [bob],
      friends: const [],
      sentRequests: [buildFriendRequest(sender: alice, receiver: bob)],
      receivedRequests: const [],
    );

    expect(statusOf(result, bob.id), TrustStatus.requestSent);
  });

  test('a request we received is matched on its sender', () {
    final result = deriveTrustStatuses(
      searchedUsers: [carol],
      friends: const [],
      sentRequests: const [],
      receivedRequests: [buildFriendRequest(sender: carol, receiver: alice)],
    );

    expect(statusOf(result, carol.id), TrustStatus.requestReceived);
  });

  test('friendship outranks a pending request in either direction', () {
    final result = deriveTrustStatuses(
      searchedUsers: [bob],
      friends: [bob],
      sentRequests: [buildFriendRequest(sender: alice, receiver: bob)],
      receivedRequests: [buildFriendRequest(sender: bob, receiver: alice)],
    );

    expect(statusOf(result, bob.id), TrustStatus.trusted);
  });

  test('a sent request outranks a received one', () {
    final result = deriveTrustStatuses(
      searchedUsers: [bob],
      friends: const [],
      sentRequests: [buildFriendRequest(sender: alice, receiver: bob)],
      receivedRequests: [buildFriendRequest(sender: bob, receiver: alice)],
    );

    expect(statusOf(result, bob.id), TrustStatus.requestSent);
  });

  test('a request involving someone else does not leak across users', () {
    final result = deriveTrustStatuses(
      searchedUsers: [bob, carol],
      friends: const [],
      sentRequests: [buildFriendRequest(sender: alice, receiver: bob)],
      receivedRequests: const [],
    );

    expect(statusOf(result, bob.id), TrustStatus.requestSent);
    expect(statusOf(result, carol.id), TrustStatus.none);
  });

  test('classifies every searched user and preserves their order', () {
    final result = deriveTrustStatuses(
      searchedUsers: [alice, bob, carol, dave],
      friends: [alice],
      sentRequests: [buildFriendRequest(sender: alice, receiver: bob)],
      receivedRequests: [buildFriendRequest(sender: carol, receiver: alice)],
    );

    expect(result.map((r) => r.user.id), [1, 2, 3, 4]);
    expect(
      result.map((r) => r.trustStatus),
      [
        TrustStatus.trusted,
        TrustStatus.requestSent,
        TrustStatus.requestReceived,
        TrustStatus.none,
      ],
    );
  });

  test('an empty search yields an empty result', () {
    final result = deriveTrustStatuses(
      searchedUsers: const [],
      friends: [alice],
      sentRequests: const [],
      receivedRequests: const [],
    );

    expect(result, isEmpty);
  });
}
