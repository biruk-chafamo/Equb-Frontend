import 'package:equb_v3_frontend/blocs/authentication/auth_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_event.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_state.dart';
import 'package:equb_v3_frontend/blocs/equb_invite/equb_invite_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_overview/equbs_overview_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_overview/equbs_overview_event.dart';
import 'package:equb_v3_frontend/blocs/equb_overview/equbs_overview_state.dart';
import 'package:equb_v3_frontend/blocs/user/user_bloc.dart';
import 'package:equb_v3_frontend/screens/equb/equb_detail_screen.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/buttons/user_avatar_button.dart';
import 'package:equb_v3_frontend/widgets/cards/equb_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AdaptiveEqubOverviewScreen extends StatelessWidget {
  const AdaptiveEqubOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      print('update -----> ${constraints.maxWidth}');
      if (constraints.maxWidth > largeScreenSize) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
                flex: 4, child: EqubsOverviewScreen(largeScreen: true)),
            const SizedBox(width: 20),
            Expanded(
                flex: 6,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondaryContainer
                            .withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const EqubDetailScreen(),
                )),
          ],
        );
      } else {
        return const EqubsOverviewScreen();
      }
    });
  }
}

class EqubsOverviewScreen extends StatefulWidget {
  final bool largeScreen;
  const EqubsOverviewScreen({
    super.key,
    this.largeScreen = false,
  });

  @override
  State<EqubsOverviewScreen> createState() => _EqubsOverviewScreenState();
}

class _EqubsOverviewScreenState extends State<EqubsOverviewScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(const FetchCurrentUser());
    context.read<EqubsOverviewBloc>().add(const FetchEqubs(EqubType.active));
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();

    return DefaultTabController(
      length: 4,
      child: Center(
        child: Padding(
          padding: AppPadding.globalPadding,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.surface,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: IconButton(
                    icon: const Icon(Icons.add, size: appBarIconSize),
                    onPressed: () {
                      GoRouter.of(context).pushNamed('create_equb');
                    },
                  ),
                ),
                !widget.largeScreen
                    ? Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: userDetail(authBloc),
                      )
                    : const SizedBox(),
              ],
              title: Container(
                // padding: AppPadding.globalPadding,
                margin: AppMargin.globalMargin,
                child: Text(
                  "Equbs",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                ),
              ),
              centerTitle: false,
              bottom: TabBar(
                tabAlignment: TabAlignment.fill,
                tabs: EqubType.values
                    .take(4)
                    .map((e) => Tab(
                text: e.toString().split('.').last,
              ))
                    .toList(),
                onTap: (tabIdx) {
                  if (EqubType.values[tabIdx] == EqubType.active) {
                    BlocProvider.of<EqubsOverviewBloc>(context)
                        .add(const FetchEqubs(EqubType.active));
                  } else if (EqubType.values[tabIdx] == EqubType.pending) {
                    BlocProvider.of<EqubsOverviewBloc>(context)
                        .add(const FetchEqubs(EqubType.pending));
                  } else if (EqubType.values[tabIdx] == EqubType.past) {
                    BlocProvider.of<EqubsOverviewBloc>(context)
                        .add(const FetchEqubs(EqubType.past));
                  } else if (EqubType.values[tabIdx] == EqubType.invites) {
                    BlocProvider.of<EqubInviteBloc>(context)
                        .add(const FetchReceivedEqubInvites());
                  }
                },
              ),
            ),
            body: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: smallScreenSize),
                child: SafeArea(
                  child: TabBarView(
                    // prevent the tabbarview from scrolling horizontally
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      EqubsOverviewTab(EqubType.active,
                          largeScreen: widget.largeScreen),
                      EqubsOverviewTab(EqubType.pending,
                          largeScreen: widget.largeScreen),
                      InvitedEqubOverview(largeScreen: widget.largeScreen),
                      EqubsOverviewTab(EqubType.past,
                          largeScreen: widget.largeScreen),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EqubsOverviewTab extends StatelessWidget {
  final EqubType type;
  final bool largeScreen;

  const EqubsOverviewTab(
    this.type, {
    this.largeScreen = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EqubsOverviewBloc, EqubsOverviewState>(
      listenWhen: (previous, current) =>
          current.status == EqubsOverviewStatus.success &&
          type == EqubType.active,
      listener: (context, state) {
        if (state.equbsOverview.isNotEmpty) {
          final equbBloc = context.read<EqubBloc>();
          if (equbBloc.state.status != EqubDetailStatus.success) {
            equbBloc.add(FetchEqubDetail(state.equbsOverview.first.id));
          }
        }
      },
      builder: (context, state) {
        if (state.status != EqubsOverviewStatus.success) {
          return const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }
        final equbsOverview = state.equbsOverview;
        if (equbsOverview.isEmpty) {
          return Align(
            alignment: Alignment.center,
            child: Text(
              "No equbs available",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
            ),
          );
        }
        if (equbsOverview.isEmpty) {
          return Align(
            alignment: Alignment.center,
            child: Text(
              "No equbs available",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
            ),
          );
        }
        return BlocBuilder<EqubBloc, EqubDetailState>(
          builder: (context, equbDetailstate) {
            return ListView.builder(
              itemCount: equbsOverview.length,
              itemBuilder: (context, index) {
                final e = state.equbsOverview[index];
                final selected = equbDetailstate.equbDetail?.id == e.id;
                if (type == EqubType.active) {
                  return ActiveEqubOverview(e,
                      largeScreen: largeScreen, selected: selected);
                } else if (type == EqubType.pending) {
                  return PendingEqubOverview(e, PendingEqubType.joined,
                      largeScreen: largeScreen, selected: selected);
                } else {
                  return PastEqubOverview(e,
                      largeScreen: largeScreen, selected: selected);
                }
              },
            );
          },
        );
      },
    );
  }
}

BlocBuilder<UserBloc, UserState> userDetail(authBloc) {
  return BlocBuilder<UserBloc, UserState>(
    builder: (context, state) {
      if (state.status == UserStatus.success) {
        final currentUser = state.currentUser;
        if (currentUser == null) {
          return const SizedBox();
        }
        return UserAvatarButton(
          currentUser,
          redirectRoute: 'current_user_profile',
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    },
  );
}