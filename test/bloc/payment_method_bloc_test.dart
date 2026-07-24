import 'package:bloc_test/bloc_test.dart';
import 'package:equb_v3_frontend/blocs/payment_method/payment_method_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/builders/user_builder.dart';
import '../support/fakes/fake_payment_method_repository.dart';

void main() {
  late FakePaymentMethodRepository repository;

  setUp(() => repository = FakePaymentMethodRepository());

  PaymentMethodBloc build() =>
      PaymentMethodBloc(paymentMethodRepository: repository);

  group('fetch payment methods', () {
    final cash = buildPaymentMethod(id: 1, service: 'Cash');
    final venmo = buildPaymentMethod(id: 2, service: 'Venmo');

    blocTest<PaymentMethodBloc, PaymentMethodState>(
      'loads then succeeds with the fetched methods',
      build: build,
      act: (bloc) {
        repository.paymentMethodsResult = [cash, venmo];
        bloc.add(const FetchPaymentMethods());
      },
      expect: () => [
        isA<PaymentMethodState>()
            .having((s) => s.status, 'status', PaymentMethodStatus.loading),
        isA<PaymentMethodState>()
            .having((s) => s.status, 'status', PaymentMethodStatus.success)
            .having((s) => s.paymentMethods, 'paymentMethods', [cash, venmo]),
      ],
      verify: (_) =>
          expect(repository.calls, contains('getPaymentMethods()')),
    );
  });

  group('fetch available services', () {
    blocTest<PaymentMethodBloc, PaymentMethodState>(
      'succeeds with the service list',
      build: build,
      act: (bloc) {
        repository.servicesResult = ['Cash', 'Zelle'];
        bloc.add(const FetchAvailableServices());
      },
      expect: () => [
        isA<PaymentMethodState>()
            .having((s) => s.status, 'status', PaymentMethodStatus.loading),
        isA<PaymentMethodState>()
            .having((s) => s.status, 'status', PaymentMethodStatus.success)
            .having((s) => s.services, 'services', ['Cash', 'Zelle']),
      ],
    );
  });

  group('create payment method', () {
    final created = buildPaymentMethod(id: 9, service: 'Zelle');

    blocTest<PaymentMethodBloc, PaymentMethodState>(
      'appends the new method exactly once',
      build: build,
      act: (bloc) {
        repository.createResult = created;
        bloc.add(const CreatePaymentMethod(service: 'Zelle', detail: 'a@b.c'));
      },
      verify: (bloc) {
        expect(bloc.state.paymentMethods, [created]);
        expect(bloc.state.selectedPaymentMethod, created);
      },
    );

    blocTest<PaymentMethodBloc, PaymentMethodState>(
      'appends once even when methods were already loaded',
      build: build,
      seed: () => PaymentMethodState(
        status: PaymentMethodStatus.success,
        paymentMethods: [buildPaymentMethod(id: 1, service: 'Cash')],
      ),
      act: (bloc) {
        repository.createResult = created;
        bloc.add(const CreatePaymentMethod(service: 'Zelle', detail: 'a@b.c'));
      },
      verify: (bloc) => expect(bloc.state.paymentMethods.length, 2),
    );

    blocTest<PaymentMethodBloc, PaymentMethodState>(
      'passes through newMethodCreated so the form can react, then settles',
      build: build,
      act: (bloc) {
        repository.createResult = created;
        bloc.add(const CreatePaymentMethod(service: 'Zelle', detail: 'a@b.c'));
      },
      expect: () => [
        isA<PaymentMethodState>()
            .having((s) => s.status, 'status', PaymentMethodStatus.loading),
        isA<PaymentMethodState>().having(
            (s) => s.status, 'status', PaymentMethodStatus.newMethodCreated),
        isA<PaymentMethodState>()
            .having((s) => s.status, 'status', PaymentMethodStatus.success),
      ],
    );
  });

  group('fetch payment methods by user', () {
    final theirs = buildPaymentMethod(id: 4, service: 'Venmo');

    blocTest<PaymentMethodBloc, PaymentMethodState>(
      'is handled rather than throwing on dispatch',
      build: build,
      act: (bloc) {
        repository.paymentMethodsByUserResult = [theirs];
        bloc.add(const FetchPaymentMethodsByUser(userId: 12));
      },
      errors: () => [],
      expect: () => [
        isA<PaymentMethodState>()
            .having((s) => s.status, 'status', PaymentMethodStatus.loading),
        isA<PaymentMethodState>()
            .having((s) => s.status, 'status', PaymentMethodStatus.success)
            .having((s) => s.paymentMethods, 'paymentMethods', [theirs]),
      ],
      verify: (_) =>
          expect(repository.calls, contains('getPaymentMethodsByUser(12)')),
    );
  });
}
