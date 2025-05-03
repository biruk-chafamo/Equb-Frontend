import 'package:equb_v3_frontend/blocs/friendships/friendships_bloc.dart'
    as friendships;
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/sections/list_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FriendsSearch extends StatelessWidget {
  const FriendsSearch({super.key});
  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              "Send Trust Request",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.onSecondaryContainer),
            )
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: smallScreenSize),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  margin: AppMargin.globalMargin,
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context)
                          .colorScheme
                          .onTertiary
                          .withOpacity(0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .onTertiary
                                .withOpacity(0.4)),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onTertiary
                                  .withOpacity(0.8))),
                      hintText: 'search users to trust',
                      // ignore: prefer_const_constructors
                      prefixIcon: Icon(Icons.search,
                          size: appBarIconSize), // Add the search icon here
                    ),
                    autocorrect: false,
                    onChanged: (text) {
                      final name = searchController.text.trim();
                      if (name == '') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a name'),
                          ),
                        );
                      }
                      context
                          .read<friendships.FriendshipsBloc>()
                          .add(friendships.FetchUsersByName(name));
                    },
                  ),
                ),
                BlocBuilder<friendships.FriendshipsBloc,
                    friendships.FriendshipsState>(
                  builder: (context, state) {
                    if (state.status == friendships.FriendshipsStatus.initial) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                          ),
                          Container(
                            margin: AppMargin.globalMargin,
                            child: Text(
                              'search for users by typing their name',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ],
                      );
                    } else if (state.status ==
                        friendships.FriendshipsStatus.success) {
                      if (state.searchedUsers.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                            ),
                            Text(
                              'No users found',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        );
                      } else {
                        return ListUsersForFriendRequest(state.searchedUsers);
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
