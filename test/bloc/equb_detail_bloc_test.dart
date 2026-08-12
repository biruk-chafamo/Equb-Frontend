import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_event.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_state.dart';
import 'package:equb_v3_frontend/blocs/payment_confirmation_request/payment_confirmation_request_bloc.dart';
import 'package:equb_v3_frontend/blocs/payment_confirmation_request/payment_confirmation_request_event.dart';
import 'package:equb_v3_frontend/models/equb/equb.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/builders/equb_builder.dart';
import '../support/fakes/fake_equb_repository.dart';
import '../support/fakes/fake_payment_confirmation_request_repository.dart';

void main() {
  late FakeEqubRepository equbRepository;
  late FakePaymentConfirmationRequestRepository paymentRepository;
  late PaymentConfirmationRequestBloc paymentBloc;

  setUp(() {
    equbRepository = FakeEqubRepository();
    paymentRepository = FakePaymentConfirmationRequestRepository();
    paymentBloc = PaymentConfirmationRequestBloc(
      paymentConfirmationRequestRepository: paymentRepository,
    );
  });

  tearDown(() => paymentBloc.close());

  EqubBloc build() =>
      EqubBloc(equbRepository: equbRepository, paymentBloc: paymentBloc);

  int wsOpenCount() =>
      equbRepository.calls.where((c) => c == 'startEqubWsChannel()').length;

  group('fetch equb detail', () {
    blocTest<EqubBloc, EqubDetailState>(
      'loads then succeeds with the fetched equb',
      build: build,
      act: (bloc) {
        equbRepository.equbDetailResult = (id) => buildEqubDetail(id: id);
        bloc.add(const FetchEqubDetail(7));
      },
      expect: () => [
        isA<EqubDetailState>()
            .having((s) => s.status, 'status', EqubDetailStatus.loading)
            .having((s) => s.equbWsChannelStarted, 'wsStarted', isFalse),
        isA<EqubDetailState>()
            .having((s) => s.status, 'status', EqubDetailStatus.loading)
            .having((s) => s.equbWsChannelStarted, 'wsStarted', isTrue),
        isA<EqubDetailState>()
            .having((s) => s.status, 'status', EqubDetailStatus.success)
            .having((s) => s.equbDetail?.id, 'equbDetail.id', 7),
      ],
      verify: (_) =>
          expect(equbRepository.calls, contains('getEqubDetail(7)')),
    );

    blocTest<EqubBloc, EqubDetailState>(
      'opens the websocket exactly once across repeated fetches',
      build: build,
      act: (bloc) async {
        bloc.add(const FetchEqubDetail(7));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const FetchEqubDetail(7));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const FetchEqubDetail(8));
      },
      verify: (bloc) {
        expect(wsOpenCount(), 1);
        expect(bloc.state.equbWsChannelStarted, isTrue);
      },
    );

    blocTest<EqubBloc, EqubDetailState>(
      're-subscribes to the equb on every fetch',
      build: build,
      act: (bloc) async {
        bloc.add(const FetchEqubDetail(7));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const FetchEqubDetail(8));
      },
      verify: (_) {
        expect(equbRepository.wsChannel.sent, [
          jsonEncode({'equb_id': 7}),
          jsonEncode({'equb_id': 8}),
        ]);
      },
    );
  });

  group('server pushes', () {
    blocTest<EqubBloc, EqubDetailState>(
      'refetches the equb named in a pushed frame',
      build: build,
      act: (bloc) async {
        bloc.add(const FetchEqubDetail(7));
        await Future<void>.delayed(Duration.zero);
        equbRepository.wsChannel.emitServer(jsonEncode({'equb_id': 7}));
        await Future<void>.delayed(Duration.zero);
      },
      verify: (_) {
        expect(
          equbRepository.calls.where((c) => c == 'getEqubDetail(7)').length,
          greaterThanOrEqualTo(2),
        );
      },
    );

    blocTest<EqubBloc, EqubDetailState>(
      'accepts a string equb id as well as an int',
      build: build,
      act: (bloc) async {
        bloc.add(const FetchEqubDetail(7));
        await Future<void>.delayed(Duration.zero);
        equbRepository.wsChannel.emitServer(jsonEncode({'equb_id': '7'}));
        await Future<void>.delayed(Duration.zero);
      },
      verify: (_) => expect(
        equbRepository.calls.where((c) => c == 'getEqubDetail(7)').length,
        greaterThanOrEqualTo(2),
      ),
    );

    blocTest<EqubBloc, EqubDetailState>(
      'ignores a push for an equb the user is not looking at',
      build: build,
      act: (bloc) async {
        bloc.add(const FetchEqubDetail(7));
        await Future<void>.delayed(Duration.zero);
        equbRepository.wsChannel.emitServer(jsonEncode({'equb_id': 9}));
        await Future<void>.delayed(Duration.zero);
      },
      verify: (bloc) {
        expect(equbRepository.calls, isNot(contains('getEqubDetail(9)')));
        expect(bloc.state.equbDetail?.id, 7);
      },
    );

    blocTest<EqubBloc, EqubDetailState>(
      'an unparseable equb id does not throw',
      build: build,
      act: (bloc) async {
        bloc.add(const FetchEqubDetail(7));
        await Future<void>.delayed(Duration.zero);
        equbRepository.wsChannel.emitServer(jsonEncode({'equb_id': 'nonsense'}));
        await Future<void>.delayed(Duration.zero);
      },
      errors: () => [],
      verify: (bloc) => expect(bloc.state.equbDetail?.id, 7),
    );

    blocTest<EqubBloc, EqubDetailState>(
      'ignores a frame with no equb id',
      build: build,
      act: (bloc) async {
        bloc.add(const FetchEqubDetail(7));
        await Future<void>.delayed(Duration.zero);
        final before =
            equbRepository.calls.where((c) => c.startsWith('getEqubDetail')).length;
        equbRepository.wsChannel.emitServer(jsonEncode({'other': 1}));
        await Future<void>.delayed(Duration.zero);
        expect(
          equbRepository.calls.where((c) => c.startsWith('getEqubDetail')).length,
          before,
        );
      },
    );

    blocTest<EqubBloc, EqubDetailState>(
      'marks the channel closed without emitting after the handler finished',
      build: build,
      act: (bloc) async {
        bloc.add(const FetchEqubDetail(7));
        await Future<void>.delayed(Duration.zero);
        await equbRepository.wsChannel.closeServer();
        await Future<void>.delayed(Duration.zero);
      },
      errors: () => [],
      verify: (bloc) => expect(bloc.state.equbWsChannelStarted, isFalse),
    );
  });

  group('place bid', () {
    blocTest<EqubBloc, EqubDetailState>(
      'succeeds with the equb the backend returns',
      build: build,
      act: (bloc) {
        equbRepository.placeBidResult =
            buildEqubDetail(id: 7, currentHighestBid: 0.025);
        bloc.add(const PlaceBid(7, 0.025));
      },
      expect: () => [
        isA<EqubDetailState>()
            .having((s) => s.status, 'status', EqubDetailStatus.loading),
        isA<EqubDetailState>()
            .having((s) => s.status, 'status', EqubDetailStatus.success)
            .having((s) => s.equbDetail?.currentHighestBid,
                'currentHighestBid', 0.025),
      ],
      verify: (_) =>
          expect(equbRepository.calls, contains('placeBid(7, 0.025)')),
    );
  });

  group('create equb', () {
    final dto = EqubCreationDTO(
      name: 'Sunrise',
      amount: 1200,
      maxMembers: 6,
      cycle: '7 00:00:00',
      isPrivate: false,
    );

    blocTest<EqubBloc, EqubDetailState>(
      'passes through equbCreated so the overview can reload, then settles',
      build: build,
      act: (bloc) => bloc.add(CreateEqub(dto)),
      expect: () => [
        isA<EqubDetailState>()
            .having((s) => s.status, 'status', EqubDetailStatus.loading),
        isA<EqubDetailState>()
            .having((s) => s.status, 'status', EqubDetailStatus.equbCreated),
        isA<EqubDetailState>()
            .having((s) => s.status, 'status', EqubDetailStatus.success),
      ],
    );
  });

  group('payment bloc coupling', () {
    blocTest<EqubBloc, EqubDetailState>(
      'refetches the equb when a payment confirmation succeeds',
      build: build,
      act: (bloc) async {
        paymentBloc.add(const FetchPaymentConfirmationRequests(7, 1));
        await Future<void>.delayed(Duration.zero);
      },
      verify: (_) =>
          expect(equbRepository.calls, contains('getEqubDetail(7)')),
    );
  });
}
