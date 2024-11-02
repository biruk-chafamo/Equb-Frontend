import 'package:equb_v3_frontend/blocs/authentication/auth_bloc.dart';
import 'package:equb_v3_frontend/blocs/authentication/auth_state.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_state.dart';
import 'package:equb_v3_frontend/blocs/payment_confirmation_request/payment_confirmation_request_bloc.dart';
import 'package:equb_v3_frontend/blocs/payment_confirmation_request/payment_confirmation_request_event.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/models/equb/equb_detail.dart';
import 'package:equb_v3_frontend/screens/equb/equbs_overview_screen.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/buttons/custom_elevated_button.dart';
import 'package:equb_v3_frontend/widgets/buttons/navigation_text_button.dart';
import 'package:equb_v3_frontend/widgets/cards/equb_detail_summary.dart';
import 'package:equb_v3_frontend/widgets/cards/equb_overview.dart';
import 'package:equb_v3_frontend/widgets/sections/interest_rate_chart.dart';
import 'package:equb_v3_frontend/widgets/sections/members_avatars.dart';
import 'package:equb_v3_frontend/widgets/sections/payment_status_management.dart';
import 'package:equb_v3_frontend/widgets/sections/upcoming_round_calander.dart';
import 'package:equb_v3_frontend/widgets/tiles/section_title_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EqubDetailScreen extends StatelessWidget {
  const EqubDetailScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final equbBloc = context.read<EqubBloc>();
    return Center(
      child: BlocBuilder<EqubBloc, EqubDetailState>(
        builder: (context, state) {
          return state.status == EqubDetailStatus.initial
              ? Scaffold(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  appBar: AppBar(
                    // toolbarHeight: 100,
                  ),
                  body: Center(
                    child: Text('No equb selected',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            )),
                  ),
                )
              : Scaffold(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  appBar: AppBar(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    title: Container(
                      padding: const EdgeInsets.only(left: 20),
                      margin: AppMargin.globalMargin,
                      child: equbStatus(equbBloc),
                    ),
                  ),
                  body: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(maxWidth: smallScreenSize),
                      child: SafeArea(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              const UpcomingRoundCalander(),
                              BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, state) {
                                  if (state is AuthAuthenticated) {
                                    return (BlocBuilder<EqubBloc,
                                        EqubDetailState>(
                                      builder: (context, equbDetailState) {
                                        if (equbDetailState.status ==
                                            EqubDetailStatus.success) {
                                          final equbDetail =
                                              equbDetailState.equbDetail;
                                          if (equbDetail == null) {
                                            return const CircularProgressIndicator();
                                          }

                                          return equbDetail.isCompleted ||
                                                  !equbDetail.isActive
                                              ? Container()
                                              : Column(
                                                  children: [
                                                    const SectionTitleTile(
                                                      "Payment Status",
                                                      Icons.payment_outlined,
                                                      Text(''),
                                                    ),
                                                    PaymentStatusManagement(
                                                        equbDetail: equbDetail,
                                                        currentUser:
                                                            state.user),
                                                  ],
                                                );
                                        } else {
                                          return const CircularProgressIndicator();
                                        }
                                      },
                                    ));
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                },
                              ),
                              const SizedBox(height: 20),
                              const SectionTitleTile(
                                "Summary",
                                Icons.stacked_bar_chart,
                                Text(''),
                                includeDivider: false,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer
                                      .withOpacity(0.3),
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer
                                        .withOpacity(0.1),
                                  ),
                                ),
                                child: IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const EqubAmount(),
                                      VerticalDivider(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer
                                            .withOpacity(0.1),
                                      ),
                                      const EqubRound(),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const SectionTitleTile(
                                "Bidding",
                                Icons.trending_up_sharp,
                                Text(""),
                                includeDivider: false,
                              ),
                              const Bidding(),
                              const SizedBox(height: 20),
                              SectionTitleTile(
                                "Members",
                                Icons.group_sharp,
                                NavigationTextButton(
                                  data: "See All",
                                  onPressed: () => context.pushNamed("members"),
                                ),
                                includeDivider: false,
                              ),
                              const MembersAvatars(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}

BlocBuilder<EqubBloc, EqubDetailState> equbStatus(EqubBloc equbBloc) {
  return BlocBuilder<EqubBloc, EqubDetailState>(
    builder: (context, state) {
      if (state.status == EqubDetailStatus.loading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state.status == EqubDetailStatus.success) {
        final equbDetail = state.equbDetail;
        if (equbDetail == null) {
          return const CircularProgressIndicator();
        }
        final String equbStage;
        final Color equbStageColor;
        if (equbDetail.isCompleted) {
          equbStage = "Completed ";
          equbStageColor = AppColors.onPrimary.withOpacity(0.3);
        } else if (!equbDetail.isActive) {
          equbStage = "Pending ";
          equbStageColor = const Color.fromARGB(255, 236, 200, 21);
        } else if (equbDetail.isInPaymentStage) {
          equbStage = "Payment ";
          equbStageColor = const Color.fromARGB(255, 197, 21, 18);
        } else {
          equbStage = "Bidding ";
          equbStageColor = Colors.green.shade400;
        }

        return Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  equbDetail.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Stage:  ",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withOpacity(0.7),
                      ),
                ),
                Text(
                  equbStage,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                Icon(Icons.circle, color: equbStageColor, size: 12),
              ],
            ),
          ],
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    },
  );
}

class EqubRound extends StatelessWidget {
  const EqubRound({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EqubBloc, EqubDetailState>(builder: (context, state) {
      if (state.status == EqubDetailStatus.loading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state.status == EqubDetailStatus.success) {
        final equbDetail = state.equbDetail;
        if (equbDetail == null) {
          return const CircularProgressIndicator();
        }
        return EqubDetailSummary(
          title: "Round",
          value: Row(
            children: [
              Text(
                "${equbDetail.currentRound}",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              Text(
                " / ${equbDetail.maxMembers}",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.5),
                    ),
              )
            ],
          ),
          topRightVisual: Transform.scale(
            scale: 0.8,
            child: CircularProgressIndicator(
              value: equbDetail.percentCompleted / 100,
              backgroundColor: AppColors.onSecondaryContainer.withOpacity(0.1),
              strokeWidth: 10,
              color: Theme.of(context).colorScheme.onTertiary,
            ),
          ),
          additionalContentTitle: "Cycle",
          additionalContentValue: equbDetail.formattedCycle(),
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }
}

class EqubAmount extends StatelessWidget {
  const EqubAmount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EqubBloc, EqubDetailState>(builder: (context, state) {
      if (state.status == EqubDetailStatus.loading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state.status == EqubDetailStatus.success) {
        final equbDetail = state.equbDetail;
        if (equbDetail == null) {
          return const CircularProgressIndicator();
        }
        return EqubDetailSummary(
          title: "Contribution",
          value: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                equbAmountNumberFormat.format(
                  equbDetail.currentAward / (equbDetail.maxMembers),
                ),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              Text(
                'per person',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.5),
                    ),
              )
            ],
          ),
          topRightVisual: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_drop_down,
                  size: 20,
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
                Text(
                  "${(equbDetail.currentHighestBid * 100).toStringAsFixed(1)}%",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSecondaryContainer,
                      ),
                ),
              ],
            ),
          ),
          additionalContentTitle: "Amount",
          additionalContentValue:
              equbAmountNumberFormat.format(equbDetail.currentAward),
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }
}
