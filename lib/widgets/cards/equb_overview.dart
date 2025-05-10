import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_event.dart';
import 'package:equb_v3_frontend/blocs/equb_invite/equb_invite_bloc.dart';
import 'package:equb_v3_frontend/models/equb/equb_detail.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/buttons/custom_elevated_button.dart';
import 'package:equb_v3_frontend/widgets/sections/members_avatars.dart';
import 'package:equb_v3_frontend/widgets/tiles/section_title_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slide_countdown/slide_countdown.dart';

class ActiveEqubOverview extends StatelessWidget {
  final EqubDetail equbDetail;
  final bool showSplitScreen;
  final bool selected;

  const ActiveEqubOverview(
    this.equbDetail, {
    this.showSplitScreen = false,
    this.selected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected && showSplitScreen
              ? Theme.of(context).colorScheme.onTertiary
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          if (equbDetail.currentUserIsMember) {
            context.read<EqubBloc>().add(FetchEqubDetail(equbDetail.id));
            if (!showSplitScreen) {
              GoRouter.of(context).pushNamed("equb_detail");
            }
          }
        },
        child: Column(
          children: [
            Container(
              decoration: PrimaryBoxDecor().copyWith(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitleTile(
                    equbDetail.name,
                    Icons.circle,
                    equbDetail.currentUserIsMember
                        ? const Icon(
                            Icons.arrow_forward_ios,
                            size: smallIconSize,
                          )
                        : Icon(
                            Icons.lock,
                            size: smallIconSize * 1.5,
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer
                                .withOpacity(0.7),
                          ),
                    includeDivider: false,
                    iconColor: getPaymentStageColor(equbDetail),
                    iconSize: smallIconSize,
                  ),
                  equbDetail.currentUserIsMember
                      ? TimeLeftUntilCollection(equbDetail: equbDetail)
                      : const SizedBox(
                          height: 20,
                        ),
                ],
              ),
            ),
            ActiveEqubBriefOverview(equbDetail: equbDetail)
          ],
        ),
      ),
    );
  }
}

class ActiveEqubBriefOverview extends StatelessWidget {
  const ActiveEqubBriefOverview({
    super.key,
    required this.equbDetail,
    this.showSplitScreen = false,
    this.selected = false,
  });

  final EqubDetail equbDetail;
  final bool showSplitScreen;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final detailStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSecondaryContainer,
        );
    return Container(
      padding: AppPadding.globalPadding,
      decoration: SecondaryBoxDecor().copyWith(
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            equbOverviewDetail(
              context,
              "Amount",
              Text(
                equbAmountNumberFormat.format(equbDetail.currentAward),
                style: detailStyle,
              ),
            ),
            detailsSeparator,
            equbOverviewDetail(
              context,
              "Interest",
              Text(
                "${(equbDetail.currentHighestBid * 100).toStringAsFixed(1)}%",
                style: detailStyle,
              ),
            ),
            detailsSeparator,
            equbOverviewDetail(
              context,
              "Round",
              Text(
                "${equbDetail.currentRound} / ${equbDetail.maxMembers}",
                style: detailStyle,
              ),
            ),
            detailsSeparator,
            equbOverviewDetail(
              context,
              "Cycle",
              Text(
                equbDetail.formattedCycle(),
                style: detailStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimeLeftUntilCollection extends StatefulWidget {
  const TimeLeftUntilCollection({
    super.key,
    required this.equbDetail,
  });

  final EqubDetail equbDetail;

  @override
  State<TimeLeftUntilCollection> createState() =>
      _TimeLeftUntilCollectionState();
}

class _TimeLeftUntilCollectionState extends State<TimeLeftUntilCollection> {
  String _timeLeftStatusText = "";
  bool _showCounter = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.equbDetail.isInPaymentStage &&
          widget.equbDetail.latestWinner == null) {
        _timeLeftStatusText = "winner is being selected";
        _showCounter = false;
      } else if (widget.equbDetail.isInPaymentStage) {
        _timeLeftStatusText = "payments are in progress...";
        _showCounter = false;
      } else if (widget.equbDetail.timeLeftTillNextRound["days"]! < 0) {
        _timeLeftStatusText = "winner is being selected";
        _showCounter = false;
      } else {
        _timeLeftStatusText = "payment starts in";
        _showCounter = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Round ${widget.equbDetail.currentRound} ',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer),
                    ),
                    TextSpan(
                      text: _timeLeftStatusText,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              _showCounter
                  ? SlideCountdownSeparated(
                      shouldShowSeconds: (duration) {
                        return duration.inMinutes < 1;
                      },
                      showZeroValue: true,
                      duration: Duration(
                        days: widget.equbDetail.timeLeftTillNextRound["days"]!,
                        hours:
                            widget.equbDetail.timeLeftTillNextRound["hours"]!,
                        minutes:
                            widget.equbDetail.timeLeftTillNextRound["minutes"]!,
                        seconds:
                            widget.equbDetail.timeLeftTillNextRound["seconds"]!,
                      ),
                      onDone: () {
                        setState(() {
                          _timeLeftStatusText = "winner is being selected";
                          _showCounter = false;
                        });

                        Future.delayed(const Duration(seconds: 5), () {
                          context
                              .read<EqubBloc>()
                              .add(FetchEqubDetail(widget.equbDetail.id));
                        });
                      },
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }
}

class InvitedEqubOverview extends StatelessWidget {
  final bool showSplitScreen;
  final bool selected;

  const InvitedEqubOverview({
    super.key,
    this.showSplitScreen = false,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return (BlocBuilder<EqubInviteBloc, EqubInviteState>(
      builder: (context, state) {
        if (state.status != EqubInviteStatus.success) {
          return const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        } else {
          final equbInvites = state.equbInvites;
          return equbInvites.isEmpty
              ? Align(
                  alignment: Alignment.center,
                  child: Text(
                    "You have not received any equb invitations",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                        ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: equbInvites.length,
                  itemBuilder: (context, idx) {
                    final equbInvite = equbInvites[idx];
                    final equbDetail = equbInvite.equbDetail;

                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: selected && showSplitScreen
                                  ? Theme.of(context).colorScheme.onTertiary
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Container(
                            decoration: PrimaryBoxDecor(),
                            child: InkWell(
                              onTap: () {
                                context.read<EqubBloc>().add(FetchEqubDetail(
                                    equbInvites.first.equbDetail.id));
                                if (!showSplitScreen) {
                                  GoRouter.of(context).pushNamed("equb_detail");
                                }
                              },
                              child: Column(
                                children: [
                                  SectionTitleTile(
                                    equbDetail.name,
                                    Icons.circle,
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                    ),
                                    includeDivider: false,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  "${equbDetail.maxMembers - equbDetail.members.length} ",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSecondaryContainer,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            TextSpan(
                                              text:
                                                  "/ ${equbDetail.maxMembers} spots remaining",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSecondaryContainer,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: LinearProgressIndicator(
                                      value: equbDetail.percentJoined / 100,
                                      minHeight: 10,
                                      borderRadius: BorderRadius.circular(10),
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer
                                          .withOpacity(0.3),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Theme.of(context)
                                              .colorScheme
                                              .onSecondaryContainer
                                              .withOpacity(0.7)),
                                    ),
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: CustomOutlinedButton(
                                              onPressed: () {
                                                context
                                                    .read<EqubInviteBloc>()
                                                    .add(AcceptEqubInvite(
                                                        equbInvite.id));
                                              },
                                              showBackground: true,
                                              child: "Accept",
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: CustomOutlinedButton(
                                              onPressed: () {
                                                context
                                                    .read<EqubInviteBloc>()
                                                    .add(ExpireEqubInvite(
                                                        equbInvite.id));
                                              },
                                              showBackground: false,
                                              child: "Decline",
                                            ),
                                          ),
                                        ),
                                      ]),
                                  Container(
                                    padding: AppPadding.globalPadding,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiaryContainer
                                          .withOpacity(0.2),
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
                                      border: Border.all(
                                        color: AppColors.onPrimary
                                            .withOpacity(0.3),
                                        width: 0.5,
                                      ),
                                    ),
                                    child: IntrinsicHeight(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          equbOverviewDetail(
                                              context,
                                              "Amount",
                                              Text(equbAmountNumberFormat
                                                  .format(equbDetail.amount))),
                                          detailsSeparator,
                                          equbOverviewDetail(
                                            context,
                                            "Cycle",
                                            Text(
                                              equbDetail.formattedCycle(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
        }
      },
    ));
  }
}

enum PendingEqubType { joined, invited }

class PendingEqubOverview extends StatelessWidget {
  final EqubDetail equbDetail;
  final PendingEqubType type;
  final bool showSplitScreen;
  final bool selected;

  const PendingEqubOverview(
    this.equbDetail,
    this.type, {
    this.showSplitScreen = false,
    this.selected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected && showSplitScreen
              ? Theme.of(context).colorScheme.onTertiary
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: (Container(
        decoration: PrimaryBoxDecor(),
        child: InkWell(
          onTap: () {
            context.read<EqubBloc>().add(FetchEqubDetail(equbDetail.id));
            if (!showSplitScreen) {
              GoRouter.of(context).pushNamed("equb_detail");
            }
          },
          child: Column(
            children: [
              SectionTitleTile(
                equbDetail.name,
                Icons.circle,
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),
                includeDivider: false,
                iconColor: getPaymentStageColor(equbDetail),
                iconSize: smallIconSize,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              "${equbDetail.maxMembers - equbDetail.members.length} ",
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        TextSpan(
                          text: "/ ${equbDetail.maxMembers} spots remaining",
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                    fontWeight: FontWeight.normal,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LinearProgressIndicator(
                  value: equbDetail.percentJoined / 100,
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(10),
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .onPrimaryContainer
                      .withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context)
                      .colorScheme
                      .onSecondaryContainer
                      .withOpacity(0.7)),
                ),
              ),
              PendingEqubMembersAvatars(equbDetail),
              Container(
                padding: AppPadding.globalPadding,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .tertiaryContainer
                      .withOpacity(0.2),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  border: Border.all(
                    color: AppColors.onPrimary.withOpacity(0.3),
                    width: 0.5,
                  ),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          equbOverviewDetail(
                              context,
                              "Amount",
                              Text(equbAmountNumberFormat
                                  .format(equbDetail.amount))),
                          detailsSeparator,
                          equbOverviewDetail(
                            context,
                            "Cycle",
                            Text(
                              equbDetail.formattedCycle(),
                            ),
                          ),
                        ],
                      ),
                      // TODO: drop down menu with option to delete or rename equb
                      // equbDetail.isCreatedByUser
                      //     ? PopupMenuButton(
                      //         itemBuilder: (context) => [
                      //           const PopupMenuItem(
                      //             value: "Delete",
                      //             child: Text("Delete"),
                      //           ),
                      //           const PopupMenuItem(
                      //             value: "Rename",
                      //             child: Text("Rename"),
                      //           ),
                      //         ],
                      //         onSelected: (value) {
                      //           if (value == "Delete") {
                      //             // context
                      //             //     .read<EqubBloc>()
                      //             //     .add(DeleteEqub(equbDetail.id));
                      //           } else {
                      //             // rename equb
                      //           }
                      //         },
                      //       )
                      //     : Container(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}

class PastEqubOverview extends StatelessWidget {
  final EqubDetail equbDetail;
  final bool showSplitScreen;
  final bool selected;

  const PastEqubOverview(
    this.equbDetail, {
    this.showSplitScreen = false,
    this.selected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected && showSplitScreen
              ? Theme.of(context).colorScheme.onTertiary
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: (Container(
        decoration: PrimaryBoxDecor(),
        child: InkWell(
          onTap: () {
            if (equbDetail.currentUserIsMember) {
              context.read<EqubBloc>().add(FetchEqubDetail(equbDetail.id));
              if (!showSplitScreen) {
                GoRouter.of(context).pushNamed("equb_detail");
              }
            }
          },
          child: Column(
            children: [
              SectionTitleTile(
                equbDetail.name,
                Icons.circle,
                equbDetail.currentUserIsMember
                    ? const Icon(
                        Icons.arrow_forward_ios,
                        size: smallIconSize,
                      )
                    : Icon(
                        Icons.lock,
                        size: smallIconSize * 1.5,
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondaryContainer
                            .withOpacity(0.7),
                      ),
                includeDivider: false,
                iconColor: getPaymentStageColor(equbDetail),
                iconSize: smallIconSize,
              ),
            ],
          ),
        ),
      )),
    );
  }
}

Widget equbOverviewDetail(BuildContext context, String title, Widget value) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.bold,
              ),
        ),
        value,
      ],
    ),
  );
}

final detailsSeparator = VerticalDivider(
  width: 1,
  thickness: 1,
  color: AppColors.onSecondaryContainer.withOpacity(0.3),
);

EqubType getEqubType(EqubDetail equbDetail) {
  if (equbDetail.isCompleted) {
    return EqubType.past;
  } else if (equbDetail.isActive) {
    return EqubType.active;
  } else {
    return EqubType.pending;
  }
}

Color getPaymentStageColor(EqubDetail equbDetail) {
  final Color equbStageColor;
  if (equbDetail.isCompleted) {
    equbStageColor = AppColors.onPrimary.withOpacity(0.3);
  } else if (!equbDetail.isActive) {
    equbStageColor = const Color.fromARGB(255, 236, 200, 21);
  } else if (equbDetail.isInPaymentStage) {
    equbStageColor = const Color.fromARGB(255, 197, 21, 18);
  } else {
    equbStageColor = Colors.green.shade400;
  }
  return equbStageColor;
}
