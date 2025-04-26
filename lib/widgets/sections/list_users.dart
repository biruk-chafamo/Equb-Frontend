import 'package:equb_v3_frontend/blocs/authentication/auth_bloc.dart';
import 'package:equb_v3_frontend/blocs/authentication/auth_state.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_event.dart';
import 'package:equb_v3_frontend/blocs/equb_detail/equb_detail_state.dart';
import 'package:equb_v3_frontend/blocs/equb_invite/equb_invite_bloc.dart';
import 'package:equb_v3_frontend/blocs/friendships/friendships_bloc.dart';
import 'package:equb_v3_frontend/blocs/payment_confirmation_request/payment_confirmation_request_bloc.dart';
import 'package:equb_v3_frontend/blocs/payment_confirmation_request/payment_confirmation_request_event.dart';
import 'package:equb_v3_frontend/blocs/payment_confirmation_request/payment_confirmation_request_state.dart';
import 'package:equb_v3_frontend/blocs/user/user_bloc.dart';
import 'package:equb_v3_frontend/models/friendship/friend_request.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/models/payment_confirmation_request/payment_confirmation_request.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/buttons/custom_elevated_button.dart';
import 'package:equb_v3_frontend/widgets/cards/user_detail.dart';
import 'package:equb_v3_frontend/widgets/tiles/boardered_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ListUnconfirmedPayers extends StatelessWidget {
  final List<PaymentConfirmationRequest> unconfirmedPaymentConfirmationRequests;
  final int maxCount;
  const ListUnconfirmedPayers(
      this.unconfirmedPaymentConfirmationRequests, this.maxCount,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final paymentConfirmationRequestBloc =
        context.read<PaymentConfirmationRequestBloc>();

    final users =
        unconfirmedPaymentConfirmationRequests.map((e) => e.sender).toList();
    return BlocBuilder<PaymentConfirmationRequestBloc,
        PaymentConfirmationRequestState>(builder: (context, requestState) {
      return BlocBuilder<EqubBloc, EqubDetailState>(builder: (context, state) {
        return BlocBuilder<AuthBloc, AuthState>(builder: (context, authState) {
          if (authState is AuthAuthenticated) {
            final latestWinner = state.equbDetail?.latestWinner;
            if (latestWinner == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: maxCount,
              itemBuilder: (context, idx) {
                User? user = users[idx];

                final buttonOrStatus = latestWinner.username ==
                        authState.user.username
                    ? CustomOutlinedButton(
                        child: "Confirm",
                        onPressed: () {
                          paymentConfirmationRequestBloc.add(
                            AcceptPaymentConfirmationRequest(
                              unconfirmedPaymentConfirmationRequests[idx].id,
                            ),
                          );
                        },
                      )
                    : Text(
                        "unconfirmed",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).colorScheme.onTertiary,
                            ),
                      );
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5, top: 5),
                      child: BoarderedTile(
                        UserDetail(
                          user,
                          detail1: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              '${unconfirmedPaymentConfirmationRequests[idx].paymentMethod.service} - ${unconfirmedPaymentConfirmationRequests[idx].paymentMethod.detail}',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(fontWeight: FontWeight.w400),
                            ),
                          ),
                          detail2: Text(
                            creationDateFormat.format(
                                unconfirmedPaymentConfirmationRequests[idx]
                                    .creationDate),
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(fontWeight: FontWeight.w300),
                          ),
                        ),
                        buttonOrStatus,
                      ),
                    ),
                    latestWinner.username == authState.user.username
                        ? Container(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: Icon(
                                Icons.cancel_rounded,
                                color: Theme.of(context).colorScheme.onTertiary,
                              ),
                              iconSize: 30,
                              onPressed: () {
                                paymentConfirmationRequestBloc.add(
                                  RejectPaymentConfirmationRequest(
                                    unconfirmedPaymentConfirmationRequests[idx]
                                        .id,
                                  ),
                                );
                                // fetch equb detail
                              },
                            ),
                          )
                        : const SizedBox(height: 0)
                  ],
                );
              },
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
      });
    });
  }
}

class ListConfirmedPayers extends StatelessWidget {
  final List<PaymentConfirmationRequest> confirmedPaymentConfirmationRequests;
  final int maxCount;
  const ListConfirmedPayers(
      this.confirmedPaymentConfirmationRequests, this.maxCount,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final users =
        confirmedPaymentConfirmationRequests.map((e) => e.sender).toList();
    return BlocBuilder<EqubBloc, EqubDetailState>(builder: (context, state) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: maxCount,
        itemBuilder: (context, idx) {
          User? user = users[idx];

          return Padding(
            padding: const EdgeInsets.only(right: 5, top: 5),
            child: BoarderedTile(
              UserDetail(
                user,
              ),
              Text(
                "Confirmed",
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Colors.green.shade800),
              ),
            ),
          );
        },
      );
    });
  }
}

class ListUnpaidPayers extends StatelessWidget {
  final List<User> users;
  final int maxCount;
  const ListUnpaidPayers(this.users, this.maxCount, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EqubBloc, EqubDetailState>(builder: (context, state) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: maxCount,
        itemBuilder: (context, idx) {
          User? user = users[idx];

          return Padding(
            padding: const EdgeInsets.only(right: 5, top: 5),
            child: BoarderedTile(
              UserDetail(
                user,
              ),
              Padding(
                padding: AppPadding.globalPadding,
                child: Text(
                  "Unpaid",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: Colors.red.shade800),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}

class ListMembers extends StatelessWidget {
  final List<User> users;
  const ListMembers(this.users, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EqubBloc, EqubDetailState>(builder: (context, state) {
      return Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: users.length,
          itemBuilder: (context, idx) {
            User? user = users[idx];

            return Padding(
              padding: const EdgeInsets.only(right: 5, top: 5),
              child: BoarderedTile(
                UserDetail(
                  user,
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
                onTap: () {
                  context.read<UserBloc>().add(FetchUserById(user.id));
                  GoRouter.of(context).pushNamed('user_profile');
                },
              ),
            );
          },
        ),
      );
    });
  }
}

class ListUsersForInvite extends StatelessWidget {
  final List<UserWithInviteStatus> usersWithInviteStatus;
  final int equbId;
  final bool disableScroll;

  const ListUsersForInvite(this.usersWithInviteStatus, this.equbId,
      {this.disableScroll = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final state = context.watch<EqubBloc>().state;
        final equbInviteState = context.watch<EqubInviteBloc>().state;

        if (state.status == EqubDetailStatus.success &&
            equbInviteState.status == EqubInviteStatus.success) {
          final equbDetail = state.equbDetail;
          if (equbDetail == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Flexible(
            child: ListView.builder(
              physics: disableScroll
                  ? const NeverScrollableScrollPhysics()
                  : const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: usersWithInviteStatus.length,
              itemBuilder: (context, idx) {
                User? user = usersWithInviteStatus[idx].user;
                InviteStatus inviteStatus =
                    usersWithInviteStatus[idx].inviteStatus;

                return Padding(
                  padding: const EdgeInsets.only(right: 5, top: 5),
                  child: BoarderedTile(
                    UserDetail(
                      user,
                    ),
                    inviteStatus == InviteStatus.member
                        ? Padding(
                            padding: AppPadding.globalPadding,
                            child: Text(
                              "Member",
                              style: TextStyle(
                                color: Colors.green.shade800,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : inviteStatus == InviteStatus.invited
                            ? Padding(
                                padding: AppPadding.globalPadding,
                                child: Text(
                                  "Invited",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onTertiary,
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            : CustomOutlinedButton(
                                child: "Invite",
                                onPressed: () {
                                  context.read<EqubInviteBloc>().add(
                                      CreateEqubInvite(user.id, equbDetail));

                                  context
                                      .read<EqubBloc>()
                                      .add(FetchEqubDetail(equbId));
                                },
                              ),
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class ListUsersForFriendRequest extends StatelessWidget {
  final List<UserWithTrustStatus> usersWithTrustStatus;

  const ListUsersForFriendRequest(this.usersWithTrustStatus, {super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendshipsBloc, FriendshipsState>(
      builder: (context, friendshipState) {
        if (friendshipState.status == FriendshipsStatus.success) {
          return Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: usersWithTrustStatus.length,
              itemBuilder: (context, idx) {
                User? user = usersWithTrustStatus[idx].user;
                TrustStatus trustStatus = usersWithTrustStatus[idx].trustStatus;
                return Padding(
                  padding: const EdgeInsets.only(right: 5, top: 5),
                  child: BoarderedTile(
                    UserDetail(
                      user,
                    ),
                    trustStatus == TrustStatus.trusted
                        ? Padding(
                            padding: AppPadding.globalPadding,
                            child: Text(
                              "Trusted",
                              style: TextStyle(
                                color: Colors.green.shade800,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : trustStatus == TrustStatus.requestSent
                            ? Padding(
                                padding: AppPadding.globalPadding,
                                child: Text(
                                  "Requested",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onTertiary,
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            : trustStatus == TrustStatus.requestReceived
                                ? CustomOutlinedButton(
                                    child: "Accept",
                                    onPressed: () {
                                      final friendRequest = friendshipState
                                          .receivedFriendRequests
                                          .firstWhere((request) =>
                                              request.sender.id == user.id);
                                      context.read<FriendshipsBloc>().add(
                                          AcceptFriendRequest(
                                              friendRequest.id));
                                    },
                                  )
                                : CustomOutlinedButton(
                                    child: "Trust",
                                    onPressed: () {
                                      context
                                          .read<FriendshipsBloc>()
                                          .add(SendFriendRequest(user.id));
                                    },
                                  ),
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class ListSentFriendRequest extends StatelessWidget {
  final List<FriendRequest> sentFriendRequests;

  const ListSentFriendRequest(this.sentFriendRequests, {super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendshipsBloc, FriendshipsState>(
      builder: (context, friendshipState) {
        if (friendshipState.status == FriendshipsStatus.success) {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: sentFriendRequests.length,
            itemBuilder: (context, idx) {
              User? user = sentFriendRequests[idx].receiver;
              DateTime creationDate = sentFriendRequests[idx].creationDate;
              return Padding(
                padding: const EdgeInsets.only(right: 5, top: 5),
                child: BoarderedTile(
                  UserDetail(user),
                  Text(
                    creationDateFormat.format(creationDate),
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontWeight: FontWeight.w300),
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class ListRecievedFriendRequest extends StatelessWidget {
  final List<FriendRequest> recievedFriendRequests;

  const ListRecievedFriendRequest(this.recievedFriendRequests, {super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendshipsBloc, FriendshipsState>(
      builder: (context, friendshipState) {
        if (friendshipState.status == FriendshipsStatus.success) {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: recievedFriendRequests.length,
            itemBuilder: (context, idx) {
              return Padding(
                padding: const EdgeInsets.only(right: 5, top: 5),
                child: BoarderedTile(
                  UserDetail(
                    recievedFriendRequests[idx].sender,
                    detail2: Text(
                      creationDateFormat
                          .format(recievedFriendRequests[idx].creationDate),
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(fontWeight: FontWeight.w300),
                    ),
                  ),
                  CustomOutlinedButton(
                    child: "Accept",
                    onPressed: () {
                      context.read<FriendshipsBloc>().add(
                          AcceptFriendRequest(recievedFriendRequests[idx].id));
                    },
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
