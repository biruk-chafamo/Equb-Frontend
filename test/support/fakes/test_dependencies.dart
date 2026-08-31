import 'package:equb_v3_frontend/app_dependencies.dart';
import 'package:equb_v3_frontend/blocs/authentication/auth_bloc.dart';

import 'fake_auth_repository.dart';
import 'fake_equb_invite_repository.dart';
import 'fake_equb_join_request_repository.dart';
import 'fake_equb_repository.dart';
import 'fake_friendship_repository.dart';
import 'fake_payment_confirmation_request_repository.dart';
import 'fake_payment_method_repository.dart';
import 'fake_user_repository.dart';

class TestDependencies {
  final auth = FakeAuthRepository();
  final equb = FakeEqubRepository();
  final invite = FakeEqubInviteRepository();
  final joinRequest = FakeEqubJoinRequestRepository();
  final user = FakeUserRepository();
  final friendship = FakeFriendshipRepository();
  final paymentMethod = FakePaymentMethodRepository();
  final paymentRequest = FakePaymentConfirmationRequestRepository();

  AppDependencies build() => AppDependencies(
        authBloc: AuthBloc(authRepository: auth),
        authRepository: auth,
        equbRepository: equb,
        equbInviteRepository: invite,
        equbJoinRequestRepository: joinRequest,
        userRepository: user,
        friendshipRepository: friendship,
        paymentMethodRepository: paymentMethod,
        paymentConfirmationRequestRepository: paymentRequest,
      );
}
