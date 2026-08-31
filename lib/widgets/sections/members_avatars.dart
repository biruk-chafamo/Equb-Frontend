import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_event.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_state.dart';
import 'package:equb_v3_frontend/models/equb/equb_detail.dart';
import 'package:equb_v3_frontend/screens/equb/equb_members_screen.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/sections/overlapping_avatars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MembersAvatars extends StatelessWidget {
  final bool showRequestButtonIfPending;
  const MembersAvatars({this.showRequestButtonIfPending = true, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        margin: AppMargin.globalMargin,
        child: BlocBuilder<EqubBloc, EqubDetailState>(
          builder: (context, state) {
            if (state.status != EqubDetailStatus.success) {
              return const Center(child: CircularProgressIndicator());
            }
            final equbDetail = state.equbDetail;
            if (equbDetail == null) {
              return const Center(child: Text('No equb found'));
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OverlappingAvatars(
                  equbDetail.members,
                  onOverflowTap: () => _seeAllMembers(context, equbDetail),
                ),
                const SizedBox(width: 30),
                showRequestButtonIfPending
                    ? equbRequestButton(equbDetail, context)
                    : const SizedBox(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class PendingEqubMembersAvatars extends StatelessWidget {
  final EqubDetail equbDetail;
  const PendingEqubMembersAvatars(this.equbDetail, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: AppMargin.globalMargin,
            child: OverlappingAvatars(
              equbDetail.members,
              onOverflowTap: () => _seeAllMembers(context, equbDetail),
            ),
          ),
          equbRequestButton(equbDetail, context),
        ],
      ),
    );
  }
}

void _seeAllMembers(BuildContext context, EqubDetail equbDetail) {
  context.read<EqubBloc>().add(FetchEqubDetail(equbDetail.id));
  context.pushNamed("members");
}
