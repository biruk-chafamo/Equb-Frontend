import 'package:equb_v3_frontend/blocs/friendships/friendships_bloc.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/sections/list_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class FriendRequestsScreen extends StatefulWidget {
  const FriendRequestsScreen({super.key});

  @override
  State<FriendRequestsScreen> createState() => _FriendRequestsScreenState();
}

class _FriendRequestsScreenState extends State<FriendRequestsScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                icon: const Icon(Icons.search, size: appBarIconSize),
                onPressed: () {
                  GoRouter.of(context).pushNamed('friends_search');
                },
              ),
            ),
          ],
          title: Container(
            margin: AppMargin.globalMargin,
            child: Text(
              "Trust Requests",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
            ),
          ),
          centerTitle: false,
          bottom: const TabBar(
            tabs: [
              Tab(
                child: SizedBox(
                  width: 80,
                  child: Center(
                    child: Text('Received'),
                  ),
                ),
              ),
              Tab(
                child: SizedBox(
                  width: 80,
                  child: Center(
                    child: Text('Sent'),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: smallScreenSize),
            child: SafeArea(
              child: TabBarView(
                children: [
                  BlocBuilder<FriendshipsBloc, FriendshipsState>(
                    builder: (context, state) {
                      if (state.status == FriendshipsStatus.loading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state.status == FriendshipsStatus.success) {
                        if ((state.receivedFriendRequests).isNotEmpty) {
                          return ListRecievedFriendRequest(
                              state.receivedFriendRequests);
                        } else {
                          return const Center(
                              child:
                                  Text('You have no pending trust requests'));
                        }
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                  BlocBuilder<FriendshipsBloc, FriendshipsState>(
                    builder: (context, state) {
                      if (state.status == FriendshipsStatus.loading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state.status == FriendshipsStatus.success) {
                        if (state.sentFriendRequests.isNotEmpty) {
                          return ListSentFriendRequest(
                              state.sentFriendRequests);
                        } else {
                          return const Center(
                              child:
                                  Text('You have no pending trust requests'));
                        }
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}