import 'package:bloc_test/bloc_test.dart';
import 'package:equb_v3_frontend/blocs/payment_confirmation_request/payment_confirmation_request_bloc.dart';
import 'package:equb_v3_frontend/blocs/payment_confirmation_request/payment_confirmation_request_event.dart';
import 'package:equb_v3_frontend/blocs/payment_confirmation_request/payment_confirmation_request_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/builders/payment_builders.dart';
import '../support/fakes/fake_payment_confirmation_request_repository.dart';

void main() {
  late FakePaymentConfirmationRequestRepository repository;

  setUp(() => repository = FakePaymentConfirmationRequestRepository());

  PaymentConfirmationRequestBloc build() => PaymentConfirmationRequestBloc(
        paymentConfirmationRequestRepository: repository,
      );

  final first = buildPaymentConfirmationRequest(id: 1);
  final second = buildPaymentConfirmationRequest(id: 2);

  group('fetch', () {
    blocTest<PaymentConfirmationRequestBloc, PaymentConfirmationRequestState>(
      'succeeds with the requests and remembers the equb',
      build: build,
      act: (bloc) {
        repository.requestsResult = [first, second];
        bloc.add(const FetchPaymentConfirmationRequests(7, 2));
      },
      expect: () => [
        isA<PaymentConfirmationRequestState>().having((s) => s.status, 'status',
            PaymentConfirmationRequestStatus.loading),
        isA<PaymentConfirmationRequestState>()
            .having((s) => s.status, 'status',
                PaymentConfirmationRequestStatus.success)
            .having((s) => s.paymentConfirmationRequests, 'requests',
                [first, second])
            .having((s) => s.equbId, 'equbId', 7),
      ],
      verify: (_) => expect(repository.calls, contains('get(7, 2)')),
    );
  });

  group('create', () {
    blocTest<PaymentConfirmationRequestBloc, PaymentConfirmationRequestState>(
      'appends the created request to the existing list',
      build: build,
      seed: () => PaymentConfirmationRequestState(
        status: PaymentConfirmationRequestStatus.success,
        paymentConfirmationRequests: [first],
        equbId: 7,
      ),
      act: (bloc) {
        repository.createResult = second;
        bloc.add(const CreatePaymentConfirmationRequest(7, 2, 3, 'sent it'));
      },
      verify: (bloc) {
        expect(bloc.state.paymentConfirmationRequests, [first, second]);
        expect(repository.calls, contains('create(7, 3, 2, sent it)'));
      },
    );
  });

  group('accept', () {
    blocTest<PaymentConfirmationRequestBloc, PaymentConfirmationRequestState>(
      'marks only the accepted request and keeps the rest',
      build: build,
      seed: () => PaymentConfirmationRequestState(
        status: PaymentConfirmationRequestStatus.success,
        paymentConfirmationRequests: [first, second],
        equbId: 7,
      ),
      act: (bloc) => bloc.add(const AcceptPaymentConfirmationRequest(1)),
      verify: (bloc) {
        final requests = bloc.state.paymentConfirmationRequests;
        expect(requests.length, 2);
        expect(requests.firstWhere((r) => r.id == 1).isAccepted, isTrue);
        expect(requests.firstWhere((r) => r.id == 2).isAccepted, isFalse);
      },
    );

    blocTest<PaymentConfirmationRequestBloc, PaymentConfirmationRequestState>(
      'keeps the equb id so the detail screen can refetch',
      build: build,
      seed: () => PaymentConfirmationRequestState(
        status: PaymentConfirmationRequestStatus.success,
        paymentConfirmationRequests: [first],
        equbId: 7,
      ),
      act: (bloc) => bloc.add(const AcceptPaymentConfirmationRequest(1)),
      verify: (bloc) => expect(bloc.state.equbId, 7),
    );
  });

  group('reject', () {
    blocTest<PaymentConfirmationRequestBloc, PaymentConfirmationRequestState>(
      'drops the rejected request from the list',
      build: build,
      seed: () => PaymentConfirmationRequestState(
        status: PaymentConfirmationRequestStatus.success,
        paymentConfirmationRequests: [first, second],
        equbId: 7,
      ),
      act: (bloc) => bloc.add(const RejectPaymentConfirmationRequest(1)),
      verify: (bloc) {
        expect(bloc.state.paymentConfirmationRequests.map((r) => r.id), [2]);
        expect(repository.calls, contains('reject(1)'));
      },
    );

    blocTest<PaymentConfirmationRequestBloc, PaymentConfirmationRequestState>(
      'leaves the list alone when the id is not present',
      build: build,
      seed: () => PaymentConfirmationRequestState(
        status: PaymentConfirmationRequestStatus.success,
        paymentConfirmationRequests: [first, second],
        equbId: 7,
      ),
      act: (bloc) => bloc.add(const RejectPaymentConfirmationRequest(99)),
      verify: (bloc) =>
          expect(bloc.state.paymentConfirmationRequests.length, 2),
    );
  });
}
