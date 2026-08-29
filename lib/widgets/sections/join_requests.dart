import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_event.dart';
import 'package:equb_v3_frontend/blocs/equb_join_request/equb_join_request_bloc.dart';
import 'package:equb_v3_frontend/models/equb/equb_detail.dart';
import 'package:equb_v3_frontend/models/equb_join_request/equb_join_request.dart';
import 'package:equb_v3_frontend/widgets/buttons/custom_elevated_button.dart';
import 'package:equb_v3_frontend/widgets/cards/user_detail.dart';
import 'package:equb_v3_frontend/widgets/progress/placeholders.dart';
import 'package:equb_v3_frontend/widgets/sections/overlapping_avatars.dart';
import 'package:equb_v3_frontend/widgets/tiles/boardered_tile.dart';
import 'package:equb_v3_frontend/widgets/tiles/section_title_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JoinRequestsSection extends StatelessWidget {
  final EqubDetail equbDetail;

  const JoinRequestsSection(this.equbDetail, {super.key});

  @override
  Widget build(BuildContext context) {
    if (equbDetail.isActive ||
        equbDetail.isCompleted ||
        !equbDetail.currentUserIsMember) {
      return const SizedBox();
    }

    return BlocBuilder<EqubJoinRequestBloc, EqubJoinRequestState>(
      builder: (context, state) {
        if (state.status == EqubJoinRequestStatus.initial ||
            state.status == EqubJoinRequestStatus.loading) {
          return const UsersListPlaceholder();
        }

        final joinRequests = state.forEqub(equbDetail.id);
        if (joinRequests.isEmpty) {
          return const SizedBox();
        }

        return Column(
          children: [
            SectionTitleTile(
              "Join Requests",
              Icons.how_to_reg_outlined,
              Text('${joinRequests.length}',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              includeDivider: false,
            ),
            ...joinRequests.map(
              (joinRequest) => JoinRequestTile(joinRequest, equbDetail.id),
            ),
          ],
        );
      },
    );
  }
}

class JoinRequestTile extends StatelessWidget {
  final EqubJoinRequest joinRequest;
  final int equbId;

  const JoinRequestTile(this.joinRequest, this.equbId, {super.key});

  void _vote(BuildContext context, bool approve) {
    context
        .read<EqubJoinRequestBloc>()
        .add(VoteOnJoinRequest(joinRequest.id, approve));
    context.read<EqubBloc>().add(FetchEqubDetail(equbId));
  }

  @override
  Widget build(BuildContext context) {
    final voted = joinRequest.currentUserVote;

    return BoarderedTile(
      UserDetail(
        joinRequest.sender,
        detail1: TrustSignal(joinRequest),
        detail2: Text(
          joinRequest.requiredApprovals == null
              ? 'awaiting the creator'
              : '${joinRequest.approvals} of ${joinRequest.requiredApprovals} approvals',
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(fontWeight: FontWeight.w300),
        ),
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomOutlinedButton(
            onPressed: () => _vote(context, true),
            showBackground: voted != true,
            child: voted == true ? "Approved" : "Approve",
          ),
          const SizedBox(height: 8),
          CustomOutlinedButton(
            onPressed: () => _vote(context, false),
            showBackground: false,
            child: voted == false ? "Declined" : "Decline",
          ),
        ],
      ),
    );
  }
}

class TrustSignal extends StatelessWidget {
  final EqubJoinRequest joinRequest;

  const TrustSignal(this.joinRequest, {super.key});

  @override
  Widget build(BuildContext context) {
    final label = joinRequest.trustedByCount == 0
        ? 'no shared trust'
        : '${joinRequest.trustedByCount} '
            '${joinRequest.trustedByCount == 1 ? 'member trusts' : 'members trust'} '
            '${joinRequest.sender.firstName}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (joinRequest.trustedBy.isNotEmpty)
            OverlappingAvatars(joinRequest.trustedBy, radius: 10, fontSize: 8),
          if (joinRequest.trustedBy.isNotEmpty) const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(fontWeight: FontWeight.w300),
            ),
          ),
        ],
      ),
    );
  }
}
