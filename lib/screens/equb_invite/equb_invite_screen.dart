import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_state.dart';
import 'package:equb_v3_frontend/blocs/equb_invite/equb_invite_bloc.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/screens/equb/equb_detail_screen.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/buttons/navigation_text_button.dart';
import 'package:equb_v3_frontend/widgets/progress/Placeholders.dart';
import 'package:equb_v3_frontend/widgets/sections/list_users.dart';
import 'package:equb_v3_frontend/widgets/sections/members_avatars.dart';
import 'package:equb_v3_frontend/widgets/tiles/section_title_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EqubInviteScreen extends StatelessWidget {
  const EqubInviteScreen(this.equbdId, {super.key});
  final int equbdId;
  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Container(
          padding: const EdgeInsets.only(left: 20),
          margin: AppMargin.globalMargin,
          child: equbStatus(context.read<EqubBloc>()),
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: smallScreenSize),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: AppPadding.globalPadding,
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'search users to invite',
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
                            final emptySearchEqubInviteView = Column(
                              children: [
                                SectionTitleTile(
                                  "Members",
                                  Icons.group_sharp,
                                  NavigationTextButton(
                                    data: "See All",
                                    onPressed: () =>
                                        context.pushNamed("members"),
                                  ),
                                  includeDivider: false,
                                ),
                                const MembersAvatars(
                                    showRequestButtonIfPending: false),
                                const SectionTitleTile(
                                  "Recommended users",
                                  Icons.group_sharp,
                                  Text(""),
                                  includeDivider: true,
                                ),
                                ListUsersForInvite(
                                    state.recommendedUsers, equbdId,
                                    disableScroll: true),
                              ],
                            );

                            final nonEmptySearchEqubInviteView = Column(
                              children: [
                                const SectionTitleTile(
                                  "Search results ...",
                                  Icons.search,
                                  Text(""),
                                  includeDivider: false,
                                ),
                                ListUsersForInvite(
                                    state.searchedUsers, equbdId),
                              ],
                            );

                            if (state.status == EqubInviteStatus.success) {
                              return state.searchedUsers.isEmpty
                                  ? emptySearchEqubInviteView
                                  : nonEmptySearchEqubInviteView;
                            } else {
                              return const Center(
                                  child: UsersListPlaceholder());
                            }
                          },
                        );
                      } else {
                        return const UsersListPlaceholder();
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
