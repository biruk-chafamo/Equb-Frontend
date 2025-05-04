import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_event.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_state.dart';
import 'package:equb_v3_frontend/blocs/equb_invite/equb_invite_bloc.dart';
import 'package:equb_v3_frontend/models/equb/equb_detail.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/buttons/custom_elevated_button.dart';
import 'package:equb_v3_frontend/widgets/sections/list_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EqubMembersScreen extends StatelessWidget {
  const EqubMembersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Text(
                "Members",
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
            child: BlocBuilder<EqubBloc, EqubDetailState>(
              builder: (context, state) {
                if (state.status == EqubDetailStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.status == EqubDetailStatus.success) {
                  final equbDetail = state.equbDetail;
                  if (equbDetail == null) {
                    return const Center(child: Text("No equb found"));
                  }
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TitleSubtitlePair(
                            leading: "${equbDetail.members.length} ",
                            title: '/ ${equbDetail.maxMembers}',
                            subtitle: 'spots filled',
                          ),
                          EqubRequestButton(equbDetail, context),
                        ],
                      ),
                      ListMembers(equbDetail.members),
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class TitleSubtitlePair extends StatelessWidget {
  const TitleSubtitlePair({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
  });

  final String leading;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.globalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                leading,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
          Text(subtitle)
        ],
      ),
    );
  }
}

Widget EqubRequestButton(EqubDetail equbDetail, BuildContext context) {
  if (equbDetail.isActive || equbDetail.isCompleted) {
    return const SizedBox();
  } else if (equbDetail.currentUserIsMember) {
    return CustomOutlinedButton(
      onPressed: () {
        context.read<EqubBloc>().add(FetchEqubDetail(equbDetail.id));
        context.read<EqubInviteBloc>().add(FetchEqubInvitesToEqub(equbDetail));
        GoRouter.of(context).pushNamed(
          'equb_invite',
          pathParameters: {'equbId': equbDetail.id.toString()},
        );
      },
      showBackground: false,
      child: "Invite others",
    );
  } else if (!equbDetail.currentUserIsMember) {
    return CustomOutlinedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Feature is in progress :('),
          ),
        );
        // TODO: Implement the request to join functionality
        // context.read<EqubBloc>().add(FetchEqubDetail(equbDetail.id));
        // context.read<EqubInviteBloc>().add(FetchEqubJoinRequestsToEqub(equbDetail));
      },
      child: "Request to join",
    );
  }
  return const SizedBox();
}
