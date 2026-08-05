import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_event.dart';
import 'package:equb_v3_frontend/blocs/equb_invite/equb_invite_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_overview/equbs_overview_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_overview/equbs_overview_event.dart';
import 'package:equb_v3_frontend/blocs/equb_overview/equbs_overview_state.dart';
import 'package:equb_v3_frontend/blocs/payment_confirmation_request/payment_confirmation_request_bloc.dart';
import 'package:equb_v3_frontend/models/equb/equb.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/builders/equb_builder.dart';
import '../support/fakes/fake_equb_invite_repository.dart';
import '../support/fakes/fake_equb_repository.dart';
import '../support/fakes/fake_friendship_repository.dart';
import '../support/fakes/fake_payment_confirmation_request_repository.dart';
import '../support/fakes/fake_user_repository.dart';

void main() {
  late FakeEqubRepository equbRepository;
  late EqubBloc equbBloc;
  late EqubInviteBloc equbInviteBloc;
  late PaymentConfirmationRequestBloc paymentBloc;

  setUp(() {
    equbRepository = FakeEqubRepository();
    paymentBloc = PaymentConfirmationRequestBloc(
      paymentConfirmationRequestRepository:
          FakePaymentConfirmationRequestRepository(),
    );
    equbBloc = EqubBloc(equbRepository: equbRepository, paymentBloc: paymentBloc);
    equbInviteBloc = EqubInviteBloc(
      equbInviteRepository: FakeEqubInviteRepository(),
      userRepository: FakeUserRepository(),
      friendshipRepository: FakeFriendshipRepository(),
    );
  });

  tearDown(() async {
    await equbBloc.close();
    await equbInviteBloc.close();
    await paymentBloc.close();
  });

  EqubsOverviewBloc build() => EqubsOverviewBloc(
        equbRepository: equbRepository,
        equbBloc: equbBloc,
        equbInviteBloc: equbInviteBloc,
      );

  group('fetch equbs', () {
    blocTest<EqubsOverviewBloc, EqubsOverviewState>(
      'succeeds with the equbs and remembers the requested type',
      build: build,
      act: (bloc) {
        equbRepository.equbsResult = [buildEqubDetail(id: 1)];
        bloc.add(const FetchEqubs(EqubType.active));
      },
      expect: () => [
        isA<EqubsOverviewState>()
            .having((s) => s.status, 'status', EqubsOverviewStatus.loading)
            .having((s) => s.type, 'type', EqubType.active),
        isA<EqubsOverviewState>()
            .having((s) => s.status, 'status', EqubsOverviewStatus.success)
            .having((s) => s.equbsOverview.length, 'count', 1)
            .having((s) => s.type, 'type', EqubType.active),
      ],
      verify: (_) =>
          expect(equbRepository.calls, contains('getEqubs(EqubType.active)')),
    );

    blocTest<EqubsOverviewBloc, EqubsOverviewState>(
      'keeps another user equbs separate from the main list',
      build: build,
      seed: () => EqubsOverviewState(
        status: EqubsOverviewStatus.success,
        equbsOverview: [buildEqubDetail(id: 1)],
      ),
      act: (bloc) {
        equbRepository.focusedUserEqubsResult = [buildEqubDetail(id: 2)];
        bloc.add(const FetchFocusedUserEqubs(12));
      },
      verify: (bloc) {
        expect(bloc.state.focusedUserEqubsOverview.single.id, 2);
        expect(bloc.state.equbsOverview.single.id, 1);
      },
    );
  });

  group('failure', () {
    blocTest<EqubsOverviewBloc, EqubsOverviewState>(
      'reports a failure state with a message instead of hanging on loading',
      build: build,
      act: (bloc) {
        equbRepository.nextError = DioException(
          requestOptions: RequestOptions(path: '/equbs/'),
          type: DioExceptionType.connectionTimeout,
        );
        bloc.add(const FetchEqubs(EqubType.active));
      },
      expect: () => [
        isA<EqubsOverviewState>()
            .having((s) => s.status, 'status', EqubsOverviewStatus.loading),
        isA<EqubsOverviewState>()
            .having((s) => s.status, 'status', EqubsOverviewStatus.failure)
            .having((s) => s.error, 'error', contains('timed out'))
            .having((s) => s.type, 'type', EqubType.active),
      ],
      errors: () => [isA<DioException>()],
    );

    blocTest<EqubsOverviewBloc, EqubsOverviewState>(
      'clears a previous error once a later fetch succeeds',
      build: build,
      seed: () => const EqubsOverviewState(
        status: EqubsOverviewStatus.failure,
        error: 'earlier failure',
      ),
      act: (bloc) => bloc.add(const FetchEqubs(EqubType.active)),
      verify: (bloc) {
        expect(bloc.state.status, EqubsOverviewStatus.success);
        expect(bloc.state.error, isNull);
      },
    );

    blocTest<EqubsOverviewBloc, EqubsOverviewState>(
      'reports a failure when another user equbs cannot be loaded',
      build: build,
      act: (bloc) {
        equbRepository.nextError = Exception('boom');
        bloc.add(const FetchFocusedUserEqubs(12));
      },
      expect: () => [
        isA<EqubsOverviewState>()
            .having((s) => s.status, 'status', EqubsOverviewStatus.loading),
        isA<EqubsOverviewState>()
            .having((s) => s.status, 'status', EqubsOverviewStatus.failure)
            .having((s) => s.error, 'error', isNotNull),
      ],
      errors: () => [isA<Exception>()],
    );
  });

  group('equb bloc coupling', () {
    blocTest<EqubsOverviewBloc, EqubsOverviewState>(
      'reloads the pending list when an equb is created while viewing it',
      build: build,
      seed: () => const EqubsOverviewState(type: EqubType.pending),
      act: (bloc) async {
        equbBloc.add(CreateEqub(EqubCreationDTO(
          name: 'Sunrise',
          amount: 1200,
          maxMembers: 6,
          cycle: '7 00:00:00',
          isPrivate: false,
        )));
        await Future<void>.delayed(Duration.zero);
      },
      verify: (_) =>
          expect(equbRepository.calls, contains('getEqubs(EqubType.pending)')),
    );

    blocTest<EqubsOverviewBloc, EqubsOverviewState>(
      'does not reload while viewing a different tab',
      build: build,
      seed: () => const EqubsOverviewState(type: EqubType.past),
      act: (bloc) async {
        equbBloc.add(CreateEqub(EqubCreationDTO(
          name: 'Sunrise',
          amount: 1200,
          maxMembers: 6,
          cycle: '7 00:00:00',
          isPrivate: false,
        )));
        await Future<void>.delayed(Duration.zero);
      },
      verify: (_) => expect(
        equbRepository.calls.where((c) => c.startsWith('getEqubs')),
        isEmpty,
      ),
    );
  });
}
