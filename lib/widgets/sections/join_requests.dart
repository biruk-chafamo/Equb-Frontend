import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_event.dart';
import 'package:equb_v3_frontend/blocs/equb_join_request/equb_join_request_bloc.dart';
import 'package:equb_v3_frontend/models/equb/equb_detail.dart';
import 'package:equb_v3_frontend/models/equb_join_request/equb_join_request.dart';
import 'package:equb_v3_frontend/widgets/buttons/custom_elevated_button.dart';
import 'package:equb_v3_frontend/widgets/cards/user_detail.dart';
import 'package:equb_v3_frontend/widgets/progress/placeholders.dart';
import 'package:equb_v3_frontend/widgets/sections/overlapping_avatars.dart';
import 'package:equb_v3_frontend/widgets/buttons/navigation_text_button.dart';
import 'package:equb_v3_frontend/widgets/sections/vote_tracker.dart';
import 'package:equb_v3_frontend/widgets/tiles/boardered_tile.dart';
import 'package:equb_v3_frontend/widgets/tiles/section_title_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

const double joinRequestCardWidth = 290;
const double _actionsHeight = 60;
const double _cardChromeHeight = 114;

/// The strip is a fixed height, so it has to clear the tallest tracker in it.
double joinRequestStripHeight(int memberCount) {
  final tracker = VoteTracker.heightFor(memberCount);
  return _cardChromeHeight +
      (tracker > _actionsHeight ? tracker : _actionsHeight);
}

String approvalPolicyExplanation(String policy) {
  switch (policy) {
    case 'creator_only':
      return 'Only the creator of this equb decides who joins. '
          'Member votes are recorded but do not carry a request.';
    case 'unanimous':
      return 'Someone joins when every member approves, or when the creator '
          'approves. The outlined boxes show the approvals still needed.';
    default:
      return 'Someone joins when most members approve, or when the creator '
          'approves. The outlined boxes show the approvals still needed.';
  }
}

class JoinRequestsSection extends StatefulWidget {
  final EqubDetail equbDetail;

  const JoinRequestsSection(this.equbDetail, {super.key});

  @override
  State<JoinRequestsSection> createState() => _JoinRequestsSectionState();
}

class _JoinRequestsSectionState extends State<JoinRequestsSection> {
  EqubDetail get equbDetail => widget.equbDetail;

  bool get _votable =>
      !equbDetail.isActive &&
      !equbDetail.isCompleted &&
      equbDetail.currentUserIsMember;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  @override
  void didUpdateWidget(JoinRequestsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    final previous = oldWidget.equbDetail;
    if (previous.id != equbDetail.id ||
        previous.members.length != equbDetail.members.length) {
      _fetch();
    }
  }

  void _fetch() {
    if (!_votable) return;
    context
        .read<EqubJoinRequestBloc>()
        .add(FetchJoinRequestsToEqub(equbDetail.id));
  }

  void _explainPolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        showCloseIcon: true,
        duration: const Duration(seconds: 6),
        content: Text(approvalPolicyExplanation(equbDetail.joinApprovalPolicy)),
      ),
    );
  }

  void _seeAll() {
    context.read<EqubBloc>().add(FetchEqubDetail(equbDetail.id));
    context
        .read<EqubJoinRequestBloc>()
        .add(FetchJoinRequestsToEqub(equbDetail.id));
    GoRouter.of(context).pushNamed('join_requests');
  }

  @override
  Widget build(BuildContext context) {
    if (!_votable) {
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
              "Join Requests (${joinRequests.length})",
              Icons.how_to_reg_outlined,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: _explainPolicy,
                    icon: const Icon(Icons.info_outline, size: 20),
                    tooltip: 'How joining is decided',
                  ),
                  NavigationTextButton(data: "See All", onPressed: _seeAll),
                ],
              ),
              includeDivider: false,
            ),
            SizedBox(
              height: joinRequestStripHeight(equbDetail.members.length),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: joinRequests.length,
                itemBuilder: (context, index) => SizedBox(
                  width: joinRequestCardWidth,
                  child: JoinRequestCard(
                    joinRequests[index],
                    equbDetail.id,
                    equbDetail.members.length,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class JoinRequestCard extends StatelessWidget {
  final EqubJoinRequest joinRequest;
  final int equbId;
  final int memberCount;
  final EdgeInsets? margin;

  const JoinRequestCard(
    this.joinRequest,
    this.equbId,
    this.memberCount, {
    this.margin,
    super.key,
  });

  void _vote(BuildContext context, bool approve) {
    context
        .read<EqubJoinRequestBloc>()
        .add(VoteOnJoinRequest(joinRequest.id, approve));
  }

  @override
  Widget build(BuildContext context) {
    final voted = joinRequest.currentUserVote;

    return BoarderedTile(
      UserDetail(joinRequest.sender, detail1: TrustSignal(joinRequest)),
      const SizedBox.shrink(),
      margin: margin,
      bottomWidget: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: VoteTracker(
                approvals: joinRequest.approvals,
                rejections: joinRequest.rejections,
                memberCount: memberCount,
                requiredApprovals: joinRequest.requiredApprovals,
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: CustomOutlinedButton(
                      onPressed: () => _vote(context, true),
                      showBackground: voted == true,
                      child: voted == true ? "Approved" : "Approve",
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.cancel_rounded,
                      color: voted == false
                          ? declinedColor
                          : Theme.of(context).colorScheme.onTertiary,
                    ),
                    iconSize: 30,
                    tooltip: voted == false ? 'Declined' : 'Decline',
                    onPressed: () => _vote(context, false),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrustSignal extends StatelessWidget {
  final EqubJoinRequest joinRequest;

  const TrustSignal(this.joinRequest, {super.key});

  @override
  Widget build(BuildContext context) {
    final count = joinRequest.trustedByCount;
    final label = count == 0
        ? 'No shared trust'
        : 'Trusted by $count member${count == 1 ? '' : 's'}';

    return SizedBox(
      // fixed so cards with and without trust avatars are the same height
      height: 40,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (joinRequest.trustedBy.isNotEmpty) ...[
            OverlappingAvatars(joinRequest.trustedBy, radius: 16, fontSize: 9),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
