import 'package:equb_v3_frontend/main.dart';
import 'package:equb_v3_frontend/screens/auth/auto_login_screen.dart';
import 'package:equb_v3_frontend/screens/auth/login_screen.dart';
import 'package:equb_v3_frontend/screens/auth/request_password_reset_screen.dart';
import 'package:equb_v3_frontend/screens/auth/reset_password_screen.dart';
import 'package:equb_v3_frontend/screens/auth/sign_up_screen.dart';
import 'package:equb_v3_frontend/screens/equb/focused_user_equbs_overview_screen.dart';
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
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      name: "auto_login",
      path: '/',
      builder: (context, state) => const AutoLoginScreen(),
    ),
    GoRoute(
      name: "login",
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) =>
          ConstrainedBox(constraints: const BoxConstraints(maxWidth: smallScreenSize), child: child),
      routes: [
        GoRoute(
          name: "signup",
          path: '/signup',
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          name: "request_password_reset",
          path: '/request_password_reset',
          builder: (context, state) => const RequestPasswordResetScreen(),
        ),
        GoRoute(
          name: "password_reset",
          path: '/password_reset/:token',
          builder: (context, GoRouterState state) {
            final token = state.pathParameters['token']!;
            return PasswordResetScreen(token: token);
          },
        ),
      ],
    ),
    ShellRoute(
      builder: (context, state, child) => AppScaffold(child),
      routes: [
        GoRoute(
          name: "equbs_overview",
          path: '/equbs_overview',
          builder: (context, state) =>
              const AdaptiveEqubOverviewScreen(initialIndex: 0),
        ),
        GoRoute(
          name: "pending_equbs_overview",
          path: '/pending_equbs_overview',
          builder: (context, state) =>
              const AdaptiveEqubOverviewScreen(initialIndex: 1),
        ),
        GoRoute(
          name: "past_equbs_overview",
          path: '/past_equbs_overview',
          builder: (context, state) =>
              const AdaptiveEqubOverviewScreen(initialIndex: 3),
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
          name: "focused_user_equbs_overview",
          path: '/focused_user_equbs_overview/:userId',
          builder: (context, GoRouterState state) {
            final userId = int.parse(state.pathParameters['userId']!);
            return FocusedUserEqubsOverviewScreen(userId);
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
          name: "focused_user_friends",
          path: '/focused_user_friends/:userId',
          builder: (context, state) =>
              FriendsScreen(userId: int.parse(state.pathParameters['userId']!)),
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
    )
  ],
);
