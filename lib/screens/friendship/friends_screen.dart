import 'package:equb_v3_frontend/blocs/friendships/friendships_bloc.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/sections/list_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

final TextEditingController searchController = TextEditingController();
bool isReceived = true;

class _FriendsScreenState extends State<FriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              GoRouter.of(context).pushNamed('friend_requests');
            },
            child: Badge(
              alignment: Alignment.topRight,
              backgroundColor: Theme.of(context).colorScheme.onTertiary,
              label: BlocBuilder<FriendshipsBloc, FriendshipsState>(
                builder: (context, state) {
                  if (state.status == FriendshipsStatus.success) {
                    if ((state.receivedFriendRequests).isNotEmpty) {
                      return Text(
                        '${state.receivedFriendRequests.length}',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(color: Colors.white),
                      );
                    } else {
                      return const SizedBox();
                    }
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              child: const Icon(
                Icons.notifications_active_outlined,
                size: appBarIconSize,
              ),
            ),
          ),
          SizedBox(width: 20),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              icon: const Icon(Icons.handshake_outlined, size: appBarIconSize),
              onPressed: () {
                GoRouter.of(context).pushNamed('friends_search');
              },
            ),
          )
        ],
        title: Container(
          // padding: AppPadding.globalPadding,
          margin: AppMargin.globalMargin,
          child: Text(
            "Trusted Friends",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
          ),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: smallScreenSize),
          child: SafeArea(
            child: BlocBuilder<FriendshipsBloc, FriendshipsState>(
              builder: (context, state) {
                if (state.status == FriendshipsStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state.status == FriendshipsStatus.success) {
                  return Column(
                    children: [
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.only(left: 30),
                          child: Text(
                            '${state.friends.length.toString()} Friend${state.friends.length != 1 ? 's' : ''}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                ),
                          ),
                        ),
                      ),
                      ListMembers(state.friends),
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
