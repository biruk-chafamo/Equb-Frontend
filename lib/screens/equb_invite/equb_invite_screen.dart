import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_state.dart';
import 'package:equb_v3_frontend/blocs/equb_invite/equb_invite_bloc.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/sections/list_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EqubInviteScreen extends StatelessWidget {
  const EqubInviteScreen(this.equbdId, {super.key});
  final int equbdId;
  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              "Invite Members",
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
                Padding(
                  padding: AppPadding.globalPadding,
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'search members',
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
                                .withOpacity(0.8)),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        size: appBarIconSize,
                      ),
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
                          .read<EqubInviteBloc>()
                          .add(FetchUsersByName(name));
                    },
                  ),
                ),
                BlocBuilder<EqubBloc, EqubDetailState>(
                  builder: (context, equbDetailState) {
                    if (equbDetailState.status == EqubDetailStatus.success) {
                      return BlocBuilder<EqubInviteBloc, EqubInviteState>(
                        builder: (context, state) {
                          if (state.status == EqubInviteStatus.initial) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                ),
                                Container(
                                  margin: AppMargin.globalMargin,
                                  child: Text(
                                    'Send an invite to people you would like to join this equb',
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                              ],
                            );
                          } else if (state.status == EqubInviteStatus.success) {
                            return Expanded(
                              child: Column(
                                children: [
                                  const SizedBox(height: 30),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 30, bottom: 10),
                                      child: Text(
                                        state.searchedUsers.isEmpty
                                            ? "Recommended Users"
                                            : "Search Results",
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
                                  ListUsersForInvite(
                                    state.searchedUsers.isEmpty
                                        ? state.recommendedUsers
                                        : state.searchedUsers,
                                    equbdId,
                                    // disableScroll: true,
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      );
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
