import 'package:equb_v3_frontend/blocs/friendships/friendships_bloc.dart';
import 'package:equb_v3_frontend/blocs/user/user_bloc.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/progress/placeholders.dart';
import 'package:equb_v3_frontend/widgets/sections/list_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class FriendsScreen extends StatefulWidget {
  final int? userId;
  const FriendsScreen({this.userId, super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.userId == null
          ? getCurrentUserFriendsScreenAppBar(context)
          : AppBar(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: smallScreenSize),
          child: SafeArea(
            child: BlocBuilder<FriendshipsBloc, FriendshipsState>(
              builder: (context, state) {
                if (state.status == FriendshipsStatus.loading) {
                  return const UsersListPlaceholder();
                } else if (state.status == FriendshipsStatus.success) {
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.only(left: 30, bottom: 10),
                          child: BlocBuilder<UserBloc, UserState>(
                            builder: (context, userState) {
                              if (userState.status != UserStatus.success) {
                                return const Text('----');
                              }
                              String headerText = widget.userId == null
                                  ? 'You have ${state.friends.length.toString()} trusted friend${state.friends.length != 1 ? 's' : ''}'
                                  : '${userState.focusedUser!.firstName} ${userState.focusedUser!.lastName} has ${state.focusedUserFriends.length.toString()} trusted friend${state.focusedUserFriends.length != 1 ? 's' : ''}';
                              return Text(
                                headerText,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer,
                                    ),
                              );
                            },
                          ),
                        ),
                      ),
                      ListMembers(widget.userId == null
                          ? state.friends
                          : state.focusedUserFriends),
                    ],
                  );
                } else {
                  return const Center(
                    child: Text('Send a Trust Request'),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

AppBar getCurrentUserFriendsScreenAppBar(BuildContext context) {
  return AppBar(
    actions: [
      GestureDetector(
        onTap: () {
          GoRouter.of(context).pushNamed('friend_requests');
        },
        child: BlocBuilder<FriendshipsBloc, FriendshipsState>(
          builder: (context, state) {
            if (state.status == FriendshipsStatus.success) {
              if (state.receivedFriendRequests.isEmpty) {
                return IconButton(
                  onPressed: () =>
                      GoRouter.of(context).pushNamed('friend_requests'),
                  icon: const Icon(
                    Icons.notifications_active_outlined,
                    size: appBarIconSize,
                  ),
                );
              } else {
                return Badge(
                  alignment: Alignment.topRight,
                  backgroundColor: Theme.of(context).colorScheme.onTertiary,
                  label: Text(
                    '${state.receivedFriendRequests.length}',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: Colors.white),
                  ),
                  child: const Icon(
                    Icons.notifications_active_outlined,
                    size: appBarIconSize,
                  ),
                );
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
      SizedBox(width: 20),
      Padding(
        padding: const EdgeInsets.only(right: 20),
        child: IconButton(
          icon: const Icon(Icons.add, size: appBarIconSize),
          onPressed: () {
            GoRouter.of(context).pushNamed('friends_search');
          },
        ),
      )
    ],
  );
}
