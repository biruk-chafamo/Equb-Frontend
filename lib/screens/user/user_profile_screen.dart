import 'package:equb_v3_frontend/blocs/authentication/auth_bloc.dart';
import 'package:equb_v3_frontend/blocs/authentication/auth_state.dart';
import 'package:equb_v3_frontend/blocs/equb_overview/equbs_overview_bloc.dart';
import 'package:equb_v3_frontend/blocs/equb_overview/equbs_overview_event.dart';
import 'package:equb_v3_frontend/blocs/friendships/friendships_bloc.dart';
import 'package:equb_v3_frontend/blocs/payment_method/payment_method_bloc.dart';
import 'package:equb_v3_frontend/blocs/user/user_bloc.dart';
import 'package:equb_v3_frontend/models/payment_method/payment_method.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/buttons/custom_elevated_button.dart';
import 'package:equb_v3_frontend/widgets/buttons/user_avatar_button.dart';
import 'package:equb_v3_frontend/widgets/cards/user_detail.dart';
import 'package:equb_v3_frontend/widgets/progress/placeholders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state.status == UserStatus.success) {
                final user = state.focusedUser;
                if (user == null) {
                  return const Center(child: Text('No user found'));
                }
                return UserDetailsSection(user);
              } else {
                return const UserDetailsSectionPlaceholder();
              }
            },
          ),
        ),
      ),
    );
  }
}

class UserDetailsSection extends StatefulWidget {
  final User user;
  final bool isCurrentUser;
  const UserDetailsSection(this.user, {this.isCurrentUser = false, super.key});

  @override
  State<UserDetailsSection> createState() => _UserDetailsSectionState();
}

class _UserDetailsSectionState extends State<UserDetailsSection> {
  @override
  void initState() {
    super.initState();
    if (widget.isCurrentUser) {
      context.read<FriendshipsBloc>().add(FetchSentFriendRequests());
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = context.read<UserBloc>();

    Future<void> showProfilePictureModal(User user) async {
      final imageProvider =
          context.read<UserBloc>().state.profilePictures[user.id];
      if (user.profilePictureUrl == null || imageProvider == null) {
        return;
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(20),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black87,
                    // borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          UserAvatarButton(widget.user,
              radius: 50,
              fontSize: 25,
              redirectRoute: "",
              onTap: () => showProfilePictureModal(widget.user)),
          !widget.isCurrentUser
              ? const SizedBox()
              : TextButton(
                  onPressed: () async {
                    final pickedImage = await pickProfileImage();
                    if (pickedImage != null) {
                      try {
                        userBloc.add(
                          UpdateProfilePicture(pickedImage),
                        );
                      } catch (e) {
                        debugPrint('Error updating profile picture: $e');
                      }
                    } else {
                      debugPrint('No image selected');
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: smallIconSize,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                      Text("edit picture",
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                  )),
                    ],
                  ),
                ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${widget.user.firstName} ${widget.user.lastName}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 30,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
              ),
            ],
          ),
          Text(
            '@${widget.user.username}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StarRating(
                rating: widget.user.score,
                color: Theme.of(context).colorScheme.onTertiary,
                starSize: 30,
              ),
              SizedBox(width: 10),
              Text(
                '(${widget.user.score.toString()})',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                final currentUser = state.user;

                if (currentUser.id == widget.user.id) {
                  return const SizedBox();
                }
                return widget.user.friends.contains(currentUser.id)
                    ? OutlinedButton(
                        onPressed: () {},
                        style: getCustomButtonStyle(context, true, false),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Trusted',
                            ),
                          ],
                        ),
                      )
                    : BlocBuilder<FriendshipsBloc, FriendshipsState>(
                        builder: (context, friendshipsState) {
                          if (friendshipsState.status !=
                              FriendshipsStatus.success) {
                            return const FriendshipsStatusButtonPlaceholder();
                          } else {
                            if (friendshipsState.sentFriendRequests
                                .map((friendshipRequest) =>
                                    friendshipRequest.receiver.id)
                                .contains(widget.user.id)) {
                              return CustomOutlinedButton(
                                showBackground: false,
                                onPressed: () {},
                                child: 'Trust request sent',
                              );
                            } else if (friendshipsState.receivedFriendRequests
                                .map((friendshipRequest) =>
                                    friendshipRequest.sender.id)
                                .contains(widget.user.id)) {
                              final receivedFriendRequestId =
                                  friendshipsState.receivedFriendRequests
                                      .firstWhere(
                                        (request) =>
                                            request.sender.id == widget.user.id,
                                      )
                                      .id;
                              return CustomOutlinedButton(
                                showBackground: true,
                                onPressed: () {
                                  context
                                      .read<FriendshipsBloc>()
                                      .add(AcceptFriendRequest(
                                        receivedFriendRequestId,
                                      ));
                                },
                                child: 'Accept trust request',
                              );
                            } else {
                              return CustomOutlinedButton(
                                child: 'Send trust request',
                                onPressed: () {
                                  context
                                      .read<FriendshipsBloc>()
                                      .add(SendFriendRequest(widget.user.id));
                                },
                              );
                            }
                          }
                        },
                      );
              } else {
                return const FriendshipsStatusButtonPlaceholder();
              }
            },
          ),
          const SizedBox(height: 20),
          Padding(
            padding: AppPadding.globalPadding,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: smallScreenSize),
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is! AuthAuthenticated) {
                    return const UserJoineEqubsAndTrustedByPlaceholder();
                  }
                  final currentUser = state.user;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (widget.user.id != currentUser.id) {
                            context
                                .read<EqubsOverviewBloc>()
                                .add(FetchFocusedUserEqubs(widget.user.id));
                            GoRouter.of(context).pushNamed(
                              'focused_user_equbs_overview',
                              pathParameters: {
                                'userId': widget.user.id.toString()
                              },
                            );
                          } else {
                            GoRouter.of(context).pushNamed('equbs_overview');
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.groups_2_outlined,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onTertiary,
                                  ),
                                ),
                                Text(
                                  widget.user.joinedEqubIds.length.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer,
                                      ),
                                ),
                              ],
                            ),
                            Text(
                              'Joined Equbs',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer
                                        .withOpacity(0.5),
                                  ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      SizedBox(
                        height: 50,
                        child: VerticalDivider(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                          thickness: 1,
                        ),
                      ),
                      SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          if (widget.user.id != currentUser.id) {
                            context
                                .read<FriendshipsBloc>()
                                .add(FetchFocusedUserFriends(widget.user.id));
                            GoRouter.of(context).pushNamed(
                                'focused_user_friends',
                                pathParameters: {
                                  'userId': widget.user.id.toString()
                                });
                          } else {
                            GoRouter.of(context).pushNamed('friends');
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.group,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onTertiary,
                                  ),
                                ),
                                Text(
                                  widget.user.friends.length.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer,
                                      ),
                                ),
                              ],
                            ),
                            Text(
                              'Trusted by',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer
                                        .withOpacity(0.5),
                                  ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: BlocBuilder<PaymentMethodBloc, PaymentMethodState>(
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          if (state is AuthAuthenticated) {
                            final currentUser = state.user;
                            if (currentUser.id != widget.user.id) {
                              return const SizedBox();
                            } else {
                              return const PaymentMethodAddBox();
                            }
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                      ...widget.user.paymentMethods.map((paymentMethod) {
                        return PaymentMethodBox(paymentMethod);
                      })
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentMethodAddBox extends StatelessWidget {
  const PaymentMethodAddBox({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<PaymentMethodBloc>().add(const FetchAvailableServices());
        GoRouter.of(context).pushNamed('create_payment_method');
      },
      child: Container(
        width: 150,
        height: 230,
        alignment: Alignment.center,
        margin: AppMargin.globalMargin,
        decoration: BoxDecoration(
          borderRadius: AppBorder.radius,
          border: Border.all(
            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
          ),
        ),
        // column with add icon and text that is centered
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 50,
            ),
            const SizedBox(height: 10),
            Container(
              child: Text(
                'Add payment method',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodBox extends StatelessWidget {
  final PaymentMethod paymentMethod;
  const PaymentMethodBox(this.paymentMethod, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 230,
      margin: AppMargin.globalMargin,
      decoration: PrimaryBoxDecor(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: AppBorder.radius
                  .copyWith(bottomLeft: Radius.zero, bottomRight: Radius.zero),
              child: SizedBox(
                height: 150,
                width: double.infinity,
                child: Image.asset(
                  paymentMethodLogoPaths[paymentMethod.service] ??
                      paymentMethodLogoPaths['custom_payment_method']!,
                  fit: BoxFit.cover,
                ),
              )),
          Padding(
            padding: AppPadding.globalPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${paymentMethod.service} ',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  paymentMethod.detail == '' ? '' : '${paymentMethod.detail}',
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
