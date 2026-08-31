import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_state.dart';
import 'package:equb_v3_frontend/blocs/equb_join_request/equb_join_request_bloc.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/progress/placeholders.dart';
import 'package:equb_v3_frontend/widgets/sections/join_requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EqubJoinRequestsScreen extends StatelessWidget {
  const EqubJoinRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Join Requests",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
          ),
          actions: [
            BlocBuilder<EqubBloc, EqubDetailState>(
              builder: (context, state) {
                final equbDetail = state.equbDetail;
                if (equbDetail == null) return const SizedBox();
                return IconButton(
                  icon: const Icon(Icons.info_outline),
                  tooltip: 'How joining is decided',
                  onPressed: () =>
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    showCloseIcon: true,
                    duration: const Duration(seconds: 6),
                    content: Text(approvalPolicyExplanation(
                        equbDetail.joinApprovalPolicy)),
                  )),
                );
              },
            ),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: smallScreenSize),
            child: BlocBuilder<EqubBloc, EqubDetailState>(
              builder: (context, equbState) {
                final equbDetail = equbState.equbDetail;
                if (equbDetail == null) {
                  return const UsersListPlaceholder();
                }
                return BlocBuilder<EqubJoinRequestBloc, EqubJoinRequestState>(
                  builder: (context, state) {
                    if (state.status == EqubJoinRequestStatus.initial ||
                        state.status == EqubJoinRequestStatus.loading) {
                      return const UsersListPlaceholder();
                    }
                    final joinRequests = state.forEqub(equbDetail.id);
                    if (joinRequests.isEmpty) {
                      return Center(
                        child: Text(
                          'No one is waiting to join',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: joinRequests.length,
                      itemBuilder: (context, index) => JoinRequestCard(
                        joinRequests[index],
                        equbDetail.id,
                        equbDetail.members.length,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
