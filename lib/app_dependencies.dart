import 'package:equb_v3_frontend/blocs/authentication/auth_bloc.dart';
import 'package:equb_v3_frontend/network/dio_client.dart';
import 'package:equb_v3_frontend/network/interceptors/authentication_interceptor.dart';
import 'package:equb_v3_frontend/network/websocket_client.dart';
import 'package:equb_v3_frontend/repositories/authentication_repository.dart';
import 'package:equb_v3_frontend/repositories/equb_invite_repository.dart';
import 'package:equb_v3_frontend/repositories/equb_join_request_repository.dart';
import 'package:equb_v3_frontend/repositories/equb_repository.dart';
import 'package:equb_v3_frontend/repositories/friendship_respository.dart';
import 'package:equb_v3_frontend/repositories/payment_confirmation_request_repository.dart';
import 'package:equb_v3_frontend/repositories/payment_method_repository.dart';
import 'package:equb_v3_frontend/repositories/user_repository.dart';
import 'package:equb_v3_frontend/services/authentication_service.dart';
import 'package:equb_v3_frontend/services/equb_invite_service.dart';
import 'package:equb_v3_frontend/services/equb_join_request_service.dart';
import 'package:equb_v3_frontend/services/equb_service.dart';
import 'package:equb_v3_frontend/services/friendship_service.dart';
import 'package:equb_v3_frontend/services/payment_confirmation_request_service.dart';
import 'package:equb_v3_frontend/services/payment_method_service.dart';
import 'package:equb_v3_frontend/services/user_service.dart';
import 'package:equb_v3_frontend/utils/constants.dart';

class AppDependencies {
  final AuthBloc authBloc;
  final AuthRepository authRepository;
  final EqubRepository equbRepository;
  final EqubInviteRepository equbInviteRepository;
  final EqubJoinRequestRepository equbJoinRequestRepository;
  final UserRepository userRepository;
  final FriendshipRepository friendshipRepository;
  final PaymentMethodRepository paymentMethodRepository;
  final PaymentConfirmationRequestRepository
      paymentConfirmationRequestRepository;

  const AppDependencies({
    required this.authBloc,
    required this.authRepository,
    required this.equbRepository,
    required this.equbInviteRepository,
    required this.equbJoinRequestRepository,
    required this.userRepository,
    required this.friendshipRepository,
    required this.paymentMethodRepository,
    required this.paymentConfirmationRequestRepository,
  });

  factory AppDependencies.production() {
    final authService = AuthService(baseUrl: baseUrl);
    final authRepository = AuthRepository(authService: authService);
    final authBloc = AuthBloc(authRepository: authRepository);

    DioClient.setupInterceptors(AuthInterceptor(
      authBloc: authBloc,
      authRepository: authRepository,
      baseUrl: baseUrl,
    ));
    final dio = DioClient.instance;

    final webSocketClient =
        WebSocketClient(authBloc: authBloc, authRepository: authRepository);

    return AppDependencies(
      authBloc: authBloc,
      authRepository: authRepository,
      equbRepository: EqubRepository(
        equbService: EqubService(
            baseUrl: baseUrl, dio: dio, webSocketClient: webSocketClient),
      ),
      equbInviteRepository: EqubInviteRepository(
        equbInviteService: EqubInviteService(baseUrl: baseUrl, dio: dio),
      ),
      equbJoinRequestRepository: EqubJoinRequestRepository(
        equbJoinRequestService: EqubJoinRequestService(baseUrl: baseUrl, dio: dio),
      ),
      userRepository: UserRepository(
        userService: UserService(baseUrl: baseUrl, dio: dio),
      ),
      friendshipRepository: FriendshipRepository(
        friendshipService: FriendshipService(baseUrl: baseUrl, dio: dio),
      ),
      paymentMethodRepository: PaymentMethodRepository(
        paymentMethodService: PaymentMethodService(baseUrl: baseUrl, dio: dio),
      ),
      paymentConfirmationRequestRepository:
          PaymentConfirmationRequestRepository(
        paymentConfirmationRequestService:
            PaymentConfirmationRequestService(baseUrl: baseUrl, dio: dio),
      ),
    );
  }
}
