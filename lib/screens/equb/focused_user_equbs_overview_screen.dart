import 'package:equb_v3_frontend/blocs/equb_overview/equbs_overview_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_overview/equbs_overview_state.dart';
import 'package:equb_v3_frontend/blocs/user/user_bloc.dart';
import 'package:equb_v3_frontend/models/equb/equb_detail.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/cards/equb_overview.dart';
import 'package:equb_v3_frontend/widgets/progress/Placeholders.dart';
import 'package:equb_v3_frontend/widgets/tiles/section_title_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FocusedUserEqubsOverviewScreen extends StatefulWidget {
  final int userId;
  const FocusedUserEqubsOverviewScreen(this.userId, {super.key});

  @override
  State<FocusedUserEqubsOverviewScreen> createState() =>
      _FocusedUserEqubsOverviewScreenState();
}

class _FocusedUserEqubsOverviewScreenState
    extends State<FocusedUserEqubsOverviewScreen> {
  bool? _isShared;
  bool? _isOpen;

  @override
  void initState() {
    super.initState();
    _isShared = false;
    _isOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: BlocBuilder<UserBloc, UserState>(
            builder: (context, userState) {
              if (userState.status != UserStatus.success) {
                return const Center(child: CircularProgressIndicator());
              }
              if (userState.focusedUser == null) {
                return const Center(child: Text('No user found'));
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${userState.focusedUser!.firstName} ${userState.focusedUser!.lastName}'s Equbs",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                        ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.all_inclusive_rounded,
                          color: _isShared!
                              ? Theme.of(context).colorScheme.onTertiary
                              : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isShared = !_isShared!;
                          });
                          if (_isShared!) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 2),
                                showCloseIcon: true,
                                content: Text(
                                    'Filtering to Equbs you and ${userState.focusedUser!.firstName} share'),
                              ),
                            );
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.lock_open_outlined,
                          color: _isOpen!
                              ? Theme.of(context).colorScheme.onTertiary
                              : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isOpen = !_isOpen!;
                            if (_isOpen!) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: const Duration(seconds: 1),
                                  showCloseIcon: true,
                                  content: Text('Filtering to open Equbs'),
                                ),
                              );
                            }
                          });
                        },
                      ),
                    ],
                  )
                ],
              );
            },
          ),
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: smallScreenSize),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BlocBuilder<UserBloc, UserState>(
                    builder: (context, userState) {
                      if (userState.status != UserStatus.success) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (userState.focusedUser == null) {
                        return const Center(child: Text('...'));
                      }
                      return BlocBuilder<EqubsOverviewBloc, EqubsOverviewState>(
                        builder: (context, state) {
                          if (state.status == EqubsOverviewStatus.loading) {
                            return const Column(
                              children: [
                                EqubOverviewPlaceholder(
                                    equbType: EqubType.pending),
                                EqubOverviewPlaceholder(
                                    equbType: EqubType.active),
                                EqubOverviewPlaceholder(
                                    equbType: EqubType.past),
                              ],
                            );
                          } else if (state.status ==
                              EqubsOverviewStatus.success) {
                            if (state.focusedUserEqubsOverview.isEmpty) {
                              return Center(
                                child: Text(
                                  'No Equbs found for this user.',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              );
                            }
                            final focusedUserPrivateEqubsCount =
                                userState.focusedUser!.joinedEqubIds.length -
                                    state.focusedUserEqubsOverview.length;

                            return Column(
                              children: [
                                Column(
                                    children:
                                        state.focusedUserEqubsOverview.map(
                                  (EqubDetail equbDetail) {
                                    final EqubType type =
                                        getEqubType(equbDetail);
                                    bool isIncludedInView = true;
                                    if (_isShared! && _isOpen!) {
                                      isIncludedInView =
                                          (equbDetail.currentUserIsMember) &&
                                              (!equbDetail.isActive &&
                                                  !equbDetail.isCompleted);
                                    } else if (_isShared!) {
                                      isIncludedInView =
                                          equbDetail.currentUserIsMember;
                                    } else if (_isOpen!) {
                                      isIncludedInView = !equbDetail.isActive &&
                                          !equbDetail.isCompleted;
                                    }

                                    if (!isIncludedInView) {
                                      return const SizedBox.shrink();
                                    }

                                    if (type == EqubType.active) {
                                      return ActiveEqubOverview(equbDetail);
                                    } else if (type == EqubType.pending) {
                                      return PendingEqubOverview(
                                          equbDetail, PendingEqubType.joined);
                                    } else {
                                      return PastEqubOverview(equbDetail);
                                    }
                                  },
                                ).toList()),
                                if (focusedUserPrivateEqubsCount > 0)
                                  SectionTitleTile(
                                    'Not displaying $focusedUserPrivateEqubsCount private Equb${focusedUserPrivateEqubsCount > 1 ? 's' : ''}',
                                    Icons.visibility_off,
                                    IconButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              showCloseIcon: true,
                                              duration: Duration(seconds: 3),
                                              content: Text(
                                                'Private equbs are only visible to members and those who have been invited.',
                                              )),
                                        );
                                      },
                                      icon: const Icon(Icons.info_outline),
                                    ),
                                  ),
                                const SizedBox(height: 50),
                              ],
                            );
                          } else if (state.status ==
                              EqubsOverviewStatus.failure) {
                            return const Center(
                                child: Text('Failed to load Equbs'));
                          }
                          return Text(
                            'No Equbs found for this user.',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[600]),
                          );
                        },
                      );
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
