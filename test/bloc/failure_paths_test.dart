import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_event.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_state.dart';
import 'package:equb_v3_frontend/blocs/equb_invite/equb_invite_bloc.dart';
import 'package:equb_v3_frontend/blocs/friendships/friendships_bloc.dart';
import 'package:equb_v3_frontend/blocs/payment_confirmation_request/payment_confirmation_request_bloc.dart';
import 'package:equb_v3_frontend/blocs/payment_confirmation_request/payment_confirmation_request_event.dart';
import 'package:equb_v3_frontend/blocs/payment_confirmation_request/payment_confirmation_request_state.dart';
import 'package:equb_v3_frontend/blocs/payment_method/payment_method_bloc.dart';
import 'package:equb_v3_frontend/blocs/user/user_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fakes/fake_equb_invite_repository.dart';
import '../support/fakes/fake_equb_repository.dart';
import '../support/fakes/fake_friendship_repository.dart';
import '../support/fakes/fake_payment_confirmation_request_repository.dart';
import '../support/fakes/fake_payment_method_repository.dart';
import '../support/fakes/fake_user_repository.dart';

DioException _serverError() => DioException(
      requestOptions: RequestOptions(path: '/x/'),
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: RequestOptions(path: '/x/'),
        statusCode: 500,
      ),
    );

void main() {
  test('every bloc status enum exposes a reachable failure value', () {
    expect(EqubDetailStatus.values, contains(EqubDetailStatus.failure));
    expect(EqubInviteStatus.values, contains(EqubInviteStatus.failure));
    expect(FriendshipsStatus.values, contains(FriendshipsStatus.failure));
    expect(PaymentMethodStatus.values, contains(PaymentMethodStatus.failure));
    expect(UserStatus.values, contains(UserStatus.failure));
  });

  group('friendships', () {
    late FakeFriendshipRepository repository;
    setUp(() => repository = FakeFriendshipRepository());

    blocTest<FriendshipsBloc, FriendshipsState>(
      'a failed friend fetch reports a message',
      build: () => FriendshipsBloc(
        friendshipRepository: repository,
        userRepository: FakeUserRepository(),
      ),
      act: (bloc) {
        repository.nextError = _serverError();
        bloc.add(const FetchFriends());
      },
      expect: () => [
        isA<FriendshipsState>()
            .having((s) => s.status, 'status', FriendshipsStatus.loading),
        isA<FriendshipsState>()
            .having((s) => s.status, 'status', FriendshipsStatus.failure)
            .having((s) => s.error, 'error', contains('server had a problem')),
      ],
      errors: () => [isA<DioException>()],
    );
  });

  group('equb invites', () {
    late FakeEqubInviteRepository repository;
    setUp(() => repository = FakeEqubInviteRepository());

    blocTest<EqubInviteBloc, EqubInviteState>(
      'a failed invite fetch reports a message',
      build: () => EqubInviteBloc(
        equbInviteRepository: repository,
        userRepository: FakeUserRepository(),
        friendshipRepository: FakeFriendshipRepository(),
      ),
      act: (bloc) {
        repository.nextError = _serverError();
        bloc.add(const FetchReceivedEqubInvites());
      },
      expect: () => [
        isA<EqubInviteState>()
            .having((s) => s.status, 'status', EqubInviteStatus.loading),
        isA<EqubInviteState>()
            .having((s) => s.status, 'status', EqubInviteStatus.failure)
            .having((s) => s.error, 'error', isNotNull),
      ],
      errors: () => [isA<DioException>()],
    );
  });

  group('payment methods', () {
    late FakePaymentMethodRepository repository;
    setUp(() => repository = FakePaymentMethodRepository());

    blocTest<PaymentMethodBloc, PaymentMethodState>(
      'a failed create reports a message',
      build: () => PaymentMethodBloc(paymentMethodRepository: repository),
      act: (bloc) {
        repository.nextError = _serverError();
        bloc.add(const CreatePaymentMethod(service: 'Cash', detail: ''));
      },
      expect: () => [
        isA<PaymentMethodState>()
            .having((s) => s.status, 'status', PaymentMethodStatus.loading),
        isA<PaymentMethodState>()
            .having((s) => s.status, 'status', PaymentMethodStatus.failure)
            .having((s) => s.error, 'error', isNotNull),
      ],
      errors: () => [isA<DioException>()],
    );

    blocTest<PaymentMethodBloc, PaymentMethodState>(
      'a failed fetch reports a message',
      build: () => PaymentMethodBloc(paymentMethodRepository: repository),
      act: (bloc) {
        repository.nextError = _serverError();
        bloc.add(const FetchPaymentMethods());
      },
      expect: () => [
        isA<PaymentMethodState>()
            .having((s) => s.status, 'status', PaymentMethodStatus.loading),
        isA<PaymentMethodState>()
            .having((s) => s.status, 'status', PaymentMethodStatus.failure)
            .having((s) => s.error, 'error', isNotNull),
      ],
      errors: () => [isA<DioException>()],
    );
  });

  group('payment confirmation requests', () {
    late FakePaymentConfirmationRequestRepository repository;
    setUp(() => repository = FakePaymentConfirmationRequestRepository());

    blocTest<PaymentConfirmationRequestBloc, PaymentConfirmationRequestState>(
      'a failed fetch reports a message',
      build: () => PaymentConfirmationRequestBloc(
          paymentConfirmationRequestRepository: repository),
      act: (bloc) {
        repository.nextError = _serverError();
        bloc.add(const FetchPaymentConfirmationRequests(7, 1));
      },
      expect: () => [
        isA<PaymentConfirmationRequestState>().having((s) => s.status, 'status',
            PaymentConfirmationRequestStatus.loading),
        isA<PaymentConfirmationRequestState>()
            .having((s) => s.status, 'status',
                PaymentConfirmationRequestStatus.failure)
            .having((s) => s.error, 'error', isNotNull),
      ],
      errors: () => [isA<DioException>()],
    );
  });

  group('user', () {
    late FakeUserRepository repository;

    setUp(() => repository = FakeUserRepository());

    blocTest<UserBloc, UserState>(
      'a failed current-user fetch reports a message',
      build: () => UserBloc(userRepository: repository),
      act: (bloc) {
        repository.nextError = _serverError();
        bloc.add(const FetchCurrentUser());
      },
      expect: () => [
        isA<UserState>().having((s) => s.status, 'status', UserStatus.loading),
        isA<UserState>()
            .having((s) => s.status, 'status', UserStatus.failure)
            .having((s) => s.error, 'error', isNotNull),
      ],
      errors: () => [isA<DioException>()],
    );
  });

  group('equb detail', () {
    late FakeEqubRepository equbRepository;
    late PaymentConfirmationRequestBloc paymentBloc;

    setUp(() {
      equbRepository = FakeEqubRepository();
      paymentBloc = PaymentConfirmationRequestBloc(
        paymentConfirmationRequestRepository:
            FakePaymentConfirmationRequestRepository(),
      );
    });
    tearDown(() => paymentBloc.close());

    blocTest<EqubBloc, EqubDetailState>(
      'a failed bid reports a message rather than hanging on loading',
      build: () =>
          EqubBloc(equbRepository: equbRepository, paymentBloc: paymentBloc),
      act: (bloc) {
        equbRepository.nextError = _serverError();
        bloc.add(const PlaceBid(7, 0.02));
      },
      expect: () => [
        isA<EqubDetailState>()
            .having((s) => s.status, 'status', EqubDetailStatus.loading),
        isA<EqubDetailState>()
            .having((s) => s.status, 'status', EqubDetailStatus.failure)
            .having((s) => s.error, 'error', isNotNull),
      ],
      errors: () => [isA<DioException>()],
    );

    blocTest<EqubBloc, EqubDetailState>(
      'a non-Dio failure during create is caught too',
      build: () =>
          EqubBloc(equbRepository: equbRepository, paymentBloc: paymentBloc),
      act: (bloc) {
        equbRepository.nextError = StateError('unexpected');
        bloc.add(const FetchEqubDetail(7));
      },
      expect: () => [
        isA<EqubDetailState>()
            .having((s) => s.status, 'status', EqubDetailStatus.loading),
        isA<EqubDetailState>()
            .having((s) => s.status, 'status', EqubDetailStatus.failure),
      ],
      errors: () => [isA<StateError>()],
    );
  });
}
