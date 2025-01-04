import 'package:dio/dio.dart';
import 'package:equb_v3_frontend/bloc_observer.dart';
import 'package:equb_v3_frontend/blocs/authentication/auth_bloc.dart';
import 'package:equb_v3_frontend/blocs/authentication/auth_state.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_invite/equb_invite_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_overview/equbs_overview_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_overview/equbs_overview_event.dart';
import 'package:equb_v3_frontend/blocs/friendships/friendships_bloc.dart';
import 'package:equb_v3_frontend/blocs/payment_confirmation_request/payment_confirmation_request_bloc.dart';
import 'package:equb_v3_frontend/blocs/payment_method/payment_method_bloc.dart';
import 'package:equb_v3_frontend/blocs/user/user_bloc.dart';
import 'package:equb_v3_frontend/network/dio_client.dart';
import 'package:equb_v3_frontend/network/interceptors/authentication_interceptor.dart';
import 'package:equb_v3_frontend/repositories/authentication_repository.dart';
import 'package:equb_v3_frontend/repositories/equb_invite_repository.dart';
import 'package:equb_v3_frontend/repositories/equb_repository.dart';
import 'package:equb_v3_frontend/repositories/friendship_respository.dart';
import 'package:equb_v3_frontend/repositories/payment_confirmation_request_repository.dart';
import 'package:equb_v3_frontend/repositories/payment_method_repository.dart';
import 'package:equb_v3_frontend/repositories/user_repository.dart';
import 'package:equb_v3_frontend/routing.dart';
import 'package:equb_v3_frontend/services/authentication_service.dart';
import 'package:equb_v3_frontend/services/equb_invite_service.dart';
import 'package:equb_v3_frontend/services/equb_service.dart';
import 'package:equb_v3_frontend/services/friendship_service.dart';
import 'package:equb_v3_frontend/services/payment_confirmation_request_service.dart';
import 'package:equb_v3_frontend/services/payment_method_service.dart';
import 'package:equb_v3_frontend/services/user_service.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/utils/themes.dart';
import 'package:equb_v3_frontend/widgets/sections/bottom_nav_bar.dart';
import 'package:equb_v3_frontend/widgets/sections/side_nav_rail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

void main() async {
  // Bloc.observer = AppBlocObserver();
  runApp(const App()); // Use App directly
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService(baseUrl: baseUrl);
    final authRepo = AuthRepository(authService: authService);
    final authBloc = AuthBloc(authRepository: authRepo);

    final AuthInterceptor authInterceptor = AuthInterceptor(
      authBloc: authBloc,
      authRepository: authRepo,
      baseUrl: baseUrl,
    );
    DioClient.setupInterceptors(authInterceptor);
    final dio = DioClient.instance;

    final userService = UserService(baseUrl: baseUrl, dio: dio);
    final equbService = EqubService(baseUrl: baseUrl, dio: dio);
    final equbInviteService = EqubInviteService(baseUrl: baseUrl, dio: dio);
    final paymentConfirmationRequestService = PaymentConfirmationRequestService(
      baseUrl: baseUrl,
      dio: dio,
    );
    final friendshipService = FriendshipService(
      baseUrl: baseUrl,
      dio: dio,
    );
    final paymentMethodService = PaymentMethodService(
      baseUrl: baseUrl,
      dio: dio,
    );

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => authRepo,
        ),
        RepositoryProvider<EqubRepository>(
          create: (context) => EqubRepository(equbService: equbService),
        ),
        RepositoryProvider<PaymentConfirmationRequestRepository>(
          create: (context) => PaymentConfirmationRequestRepository(
            paymentConfirmationRequestService:
                paymentConfirmationRequestService,
          ),
        ),
        RepositoryProvider<EqubInviteRepository>(
          create: (context) => EqubInviteRepository(
            equbInviteService: equbInviteService,
          ),
        ),
        RepositoryProvider<UserRepository>(
          create: (context) => UserRepository(userService: userService),
        ),
        RepositoryProvider<FriendshipRepository>(
          create: (context) => FriendshipRepository(
            friendshipService: friendshipService,
          ),
        ),
        RepositoryProvider<PaymentMethodRepository>(
          create: (context) => PaymentMethodRepository(
            paymentMethodService: paymentMethodService,
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => authBloc,
          ),
          BlocProvider<PaymentConfirmationRequestBloc>(
            create: (context) => PaymentConfirmationRequestBloc(
              paymentConfirmationRequestRepository:
                  context.read<PaymentConfirmationRequestRepository>(),
            ),
          ),
          BlocProvider<EqubInviteBloc>(
            create: (context) => EqubInviteBloc(
              equbInviteRepository: context.read<EqubInviteRepository>(),
              userRepository: context.read<UserRepository>(),
              friendshipRepository: context.read<FriendshipRepository>(),
            ),
          ),
          BlocProvider<PaymentMethodBloc>(
            create: (context) => PaymentMethodBloc(
              paymentMethodRepository: context.read<PaymentMethodRepository>(),
            ),
          ),
          BlocProvider<UserBloc>(
            create: (context) => UserBloc(
              userRepository: context.read<UserRepository>(),
              paymentMethodBloc: context.read<PaymentMethodBloc>(),
            ),
          ),
          BlocProvider<EqubBloc>(
            create: (context) => EqubBloc(
              equbRepository: context.read<EqubRepository>(),
              paymentBloc: context.read<PaymentConfirmationRequestBloc>(),
            ),
          ),
          BlocProvider<EqubsOverviewBloc>(
            create: (context) => EqubsOverviewBloc(
              equbRepository: context.read<EqubRepository>(),
              equbInviteBloc: context.read<EqubInviteBloc>(),
              equbBloc: context.read<EqubBloc>(),
            ),
          ),
          BlocProvider<FriendshipsBloc>(
            create: (context) => FriendshipsBloc(
              friendshipRepository: context.read<FriendshipRepository>(),
              userRepository: context.read<UserRepository>(),
            ),
          ),
        ],
        // MaterialApp.router is used to handle navigation
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routerConfig: router,
          // builder: (context, child) {
          //   return AppScaffold(child!);
          // }
        ),
      ),
    );
  }
}

class AppScaffold extends StatefulWidget {
  final Widget child;

  const AppScaffold(
    this.child, {
    super.key,
  });

  @override
  AppScaffoldState createState() => AppScaffoldState();
}

class AppScaffoldState extends State<AppScaffold> {
  int _selectedIndex = 0;
  void equbsOverviewSetup() {
    context.read<UserBloc>().add(const FetchCurrentUser());
    context.read<EqubsOverviewBloc>().add(const FetchEqubs(EqubType.active));
  }

  void friendsSetup() {
    context.read<FriendshipsBloc>().add(const FetchFriends());
    context.read<FriendshipsBloc>().add(FetchSentFriendRequests());
    context.read<FriendshipsBloc>().add(FetchReceivedFriendRequests());
  }

  void currentUserProfileSetup() {
    context.read<UserBloc>().add(const FetchCurrentUser());
    context.read<PaymentMethodBloc>().add(const FetchAvailableServices());
  }

  @override
  void initState() {
    super.initState();
    equbsOverviewSetup();
    friendsSetup();
    currentUserProfileSetup();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        equbsOverviewSetup();
        router.goNamed('equbs_overview');
        break;
      case 1:
        friendsSetup();
        router.goNamed('friends');
        break;
      case 2:
        currentUserProfileSetup();
        router.goNamed('current_user_profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          router.goNamed('login');
        }
      },
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > mediumScreenSize) {
              return Scaffold(
                body: Row(
                  children: [
                    SideNavRail(
                      selectedIndex: _selectedIndex,
                      onDestinationSelected: _onItemTapped,
                      extended: true,
                    ),
                    Expanded(
                      child: Center(
                        child: widget.child,
                      ),
                    ),
                  ],
                ),
              );
            } else if (constraints.maxWidth > smallScreenSize) {
              return Scaffold(
                body: Row(
                  children: [
                    SideNavRail(
                      selectedIndex: _selectedIndex,
                      onDestinationSelected: _onItemTapped,
                    ),
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: smallScreenSize,
                          child: widget.child,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Scaffold(
                body: Center(
                  child: widget.child,
                ),
                bottomNavigationBar: BottomNavBar(
                  selectedIndex: _selectedIndex,
                  onItemTapped: _onItemTapped,
                ),
              );
            }
          },
        );
      },
    );
  }
}
