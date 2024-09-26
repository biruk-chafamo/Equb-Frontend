import 'package:equb_v3_frontend/main.dart';
import 'package:equb_v3_frontend/screens/auth/login_screen.dart';
import 'package:equb_v3_frontend/screens/auth/request_password_reset_screen.dart';
import 'package:equb_v3_frontend/screens/auth/reset_password_screen.dart';
import 'package:equb_v3_frontend/screens/auth/sign_up_screen.dart';
import 'package:equb_v3_frontend/screens/payment_method/create_payment_method_screen.dart';
import 'package:equb_v3_frontend/screens/user/current_user_profile_screen.dart';
import 'package:equb_v3_frontend/screens/equb/equb_creation_screen.dart';
import 'package:equb_v3_frontend/screens/equb_invite/equb_invite_screen.dart';
import 'package:equb_v3_frontend/screens/friendship/friend_requests_screen.dart';
import 'package:equb_v3_frontend/screens/friendship/friends_screen.dart';
import 'package:equb_v3_frontend/screens/friendship/friends_search_screen.dart';
import 'package:equb_v3_frontend/screens/equb/equb_members_screen.dart';
import 'package:equb_v3_frontend/screens/payment_confirmation/payment_notice_screen.dart';
import 'package:equb_v3_frontend/screens/payment_confirmation/payment_status_screen.dart';
import 'package:equb_v3_frontend/screens/equb/equb_detail_screen.dart';
import 'package:equb_v3_frontend/screens/equb/equbs_overview_screen.dart';
import 'package:equb_v3_frontend/screens/user/current_user_settings_screen.dart';
import 'package:equb_v3_frontend/screens/user/user_profile_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter loginRouter = GoRouter(
  routes: [
    GoRoute(
      name: "login",
      path: '/',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      name: "signup",
      path: '/signup',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      name: "main",
      path: '/main',
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      name: "request_password_reset",
      path: '/request_password_reset',
      builder: (context, state) => const RequestPasswordResetScreen(),
    )
  ],
);

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      name: "equbs_overview",
      path: '/',
      builder: (context, state) => const AdaptiveEqubOverviewScreen(),
    ),
    GoRoute(
      name: "equb_detail",
      path: '/equb_detail',
      builder: (context, state) {
        return const EqubDetailScreen();
      },
    ),
    GoRoute(
      name: "create_equb",
      path: '/create_equb',
      builder: (context, state) {
        return const EqubCreationScreen();
      },
    ),
    GoRoute(
      name: "confirmations",
      path: '/confirmations',
      builder: (context, state) => const PaymentStatusScreen(),
    ),
    GoRoute(
      name: "members",
      path: '/members',
      builder: (context, state) => const EqubMembersScreen(),
    ),
    GoRoute(
      name: "equb_invite",
      path: '/equb_invite/:equbId',
      builder: (context, GoRouterState state) {
        final equbId = int.parse(state.pathParameters['equbId']!);
        return EqubInviteScreen(equbId);
      },
    ),
    GoRoute(
      name: "payment_notice",
      path: '/payment_notice',
      builder: (context, state) => const PaymentNoticeScreen(),
    ),
    GoRoute(
      name: "friends",
      path: '/friends',
      builder: (context, state) => const FriendsScreen(),
    ),
    GoRoute(
      name: "friends_search",
      path: '/friends/search',
      builder: (context, state) => const FriendsSearch(),
    ),
    GoRoute(
      name: "friend_requests",
      path: '/friends/requests',
      builder: (context, state) => const FriendRequestsScreen(),
    ),
    GoRoute(
        name: "user_profile",
        path: '/user_profile',
        builder: (context, state) => const UserProfileScreen()),
    GoRoute(
      name: "current_user_profile",
      path: '/current_user_profile',
      builder: (context, state) => const CurrentUserProfileScreen(),
    ),
    GoRoute(
      name: "current_user_settings",
      path: '/current_user_settings',
      builder: (context, state) => const CurrentUserSettingsScreen(),
    ),
    GoRoute(
      name: "create_payment_method",
      path: '/create_payment_method',
      builder: (context, state) => const CreatePaymentMethodScreen(),
    ),
  ],
);
