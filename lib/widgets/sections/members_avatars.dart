import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_event.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_state.dart';
import 'package:equb_v3_frontend/blocs/equb_invite/equb_invite_bloc.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/models/equb/equb_detail.dart';
import 'package:equb_v3_frontend/screens/equb/equb_members_screen.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/buttons/custom_elevated_button.dart';
import 'package:equb_v3_frontend/widgets/buttons/user_avatar_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

const int maxUsersToShow = 3;

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
            if (state.status == EqubDetailStatus.success) {
              final equbDetail = state.equbDetail;
              if (equbDetail == null) {
                return const Center(child: Text('No equb found'));
              }
              const double size = 15;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    ...equbDetail.members
                        .sublist(
                            0,
                            equbDetail.members.length > maxUsersToShow
                                ? maxUsersToShow
                                : equbDetail.members.length)
                        .map((user) => Align(
                              widthFactor: 0.8,
                              child: UserAvatarButton(user),
                            )),
                    equbDetail.members.length > maxUsersToShow
                        ? InkWell(
                            onTap: () {
                              context
                                  .read<EqubBloc>()
                                  .add(FetchEqubDetail(equbDetail.id));
                              context.pushNamed("members");
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                border: Border.all(
                                    color:
                                        AppColors.onPrimary.withOpacity(0.3)),
                              ),
                              child: Text(
                                '+${equbDetail.members.length - maxUsersToShow}',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer,
                                      fontWeight: FontWeight.bold,
                                      fontSize: size,
                                    ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ]),
                  const SizedBox(
                    width: 30,
                  ),
                  BlocBuilder<EqubBloc, EqubDetailState>(
                    builder: (context, state) {
                      if (state.status == EqubDetailStatus.success) {
                        return !showRequestButtonIfPending
                            ? const SizedBox()
                            : EqubRequestButton(equbDetail, context);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
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
            child: Row(
              children: [
                ...equbDetail.members
                    .sublist(
                        0,
                        equbDetail.members.length > maxUsersToShow
                            ? maxUsersToShow
                            : equbDetail.members.length)
                    .map((user) => Align(
                          widthFactor: 0.8,
                          child: UserAvatarButton(user),
                        )),
                equbDetail.members.length > maxUsersToShow
                    ? InkWell(
                        onTap: () {
                          context
                              .read<EqubBloc>()
                              .add(FetchEqubDetail(equbDetail.id));
                          context.pushNamed("members");
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            border: Border.all(
                                color: AppColors.onPrimary.withOpacity(0.3)),
                          ),
                          child: Text(
                            '+${equbDetail.members.length - maxUsersToShow}',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          EqubRequestButton(equbDetail, context),
        ],
      ),
    );
  }
}
