import 'package:bloc_test/bloc_test.dart';
import 'package:equb_v3_frontend/blocs/equb_join_request/equb_join_request_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/builders/equb_join_request_builder.dart';
import '../support/fakes/fake_equb_join_request_repository.dart';

void main() {
  late FakeEqubJoinRequestRepository repository;

  setUp(() {
    repository = FakeEqubJoinRequestRepository();
  });

  EqubJoinRequestBloc build() =>
      EqubJoinRequestBloc(equbJoinRequestRepository: repository);

  group('fetching', () {
    blocTest<EqubJoinRequestBloc, EqubJoinRequestState>(
      'lists the undecided requests for one equb',
      build: () {
        repository.joinRequestsToEqubResult = [
          buildEqubJoinRequest(id: 7, equbId: 3, approvals: 1),
        ];
        return build();
      },
      act: (bloc) => bloc.add(const FetchJoinRequestsToEqub(3)),
      expect: () => [
        isA<EqubJoinRequestState>()
            .having((s) => s.status, 'status', EqubJoinRequestStatus.loading),
        isA<EqubJoinRequestState>()
            .having((s) => s.status, 'status', EqubJoinRequestStatus.success)
            .having((s) => s.joinRequests.single.id, 'id', 7)
            .having((s) => s.equbId, 'equbId', 3),
      ],
      verify: (_) => expect(repository.calls, ['getJoinRequestsToEqub(3)']),
    );

    blocTest<EqubJoinRequestBloc, EqubJoinRequestState>(
      'reports a failure rather than going quiet',
      build: () {
        repository.nextError = Exception('boom');
        return build();
      },
      act: (bloc) => bloc.add(const FetchJoinRequestsToEqub(3)),
      expect: () => [
        isA<EqubJoinRequestState>()
            .having((s) => s.status, 'status', EqubJoinRequestStatus.loading),
        isA<EqubJoinRequestState>()
            .having((s) => s.status, 'status', EqubJoinRequestStatus.failure)
            .having((s) => s.error, 'error', isNotNull),
      ],
    );
  });

  group('voting', () {
    blocTest<EqubJoinRequestBloc, EqubJoinRequestState>(
      'keeps an undecided request in the list with the new tally',
      build: () {
        repository.voteResult = buildEqubJoinRequest(
          id: 7,
          equbId: 3,
          approvals: 1,
          currentUserVote: true,
        );
        return build();
      },
      seed: () => EqubJoinRequestState(
        status: EqubJoinRequestStatus.success,
        joinRequests: [buildEqubJoinRequest(id: 7, equbId: 3)],
      ),
      act: (bloc) => bloc.add(const VoteOnJoinRequest(7, true)),
      expect: () => [
        isA<EqubJoinRequestState>()
            .having((s) => s.status, 'status', EqubJoinRequestStatus.loading),
        isA<EqubJoinRequestState>()
            .having((s) => s.joinRequests.single.approvals, 'approvals', 1)
            .having((s) => s.joinRequests.single.currentUserVote, 'vote', true),
      ],
      verify: (_) => expect(repository.calls, ['voteOnJoinRequest(7, true)']),
    );

    blocTest<EqubJoinRequestBloc, EqubJoinRequestState>(
      'drops a request the vote decided',
      build: () {
        repository.voteResult =
            buildEqubJoinRequest(id: 7, equbId: 3, isAccepted: true);
        return build();
      },
      seed: () => EqubJoinRequestState(
        status: EqubJoinRequestStatus.success,
        joinRequests: [
          buildEqubJoinRequest(id: 7, equbId: 3),
          buildEqubJoinRequest(id: 8, equbId: 3),
        ],
      ),
      act: (bloc) => bloc.add(const VoteOnJoinRequest(7, true)),
      expect: () => [
        isA<EqubJoinRequestState>()
            .having((s) => s.status, 'status', EqubJoinRequestStatus.loading),
        isA<EqubJoinRequestState>()
            .having((s) => s.joinRequests.map((r) => r.id), 'ids', [8]),
      ],
    );
  });

  group('sending', () {
    blocTest<EqubJoinRequestBloc, EqubJoinRequestState>(
      'records the request the outsider just sent',
      build: build,
      act: (bloc) => bloc.add(const SendJoinRequest(3)),
      expect: () => [
        isA<EqubJoinRequestState>()
            .having((s) => s.status, 'status', EqubJoinRequestStatus.loading),
        isA<EqubJoinRequestState>()
            .having((s) => s.joinRequests.single.equbId, 'equbId', 3),
      ],
      verify: (_) => expect(repository.calls, ['createJoinRequest(3)']),
    );
  });
}
