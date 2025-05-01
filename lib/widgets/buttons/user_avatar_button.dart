import 'package:equb_v3_frontend/blocs/user/user_bloc.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UserAvatarButton extends StatefulWidget {
  final User user;
  final NetworkImage? profileImage;
  final double fontSize;
  final String redirectRoute;
  final double radius;

  const UserAvatarButton(
    this.user, {
    super.key,
    this.radius = 25,
    this.profileImage,
    this.fontSize = 12,
    this.redirectRoute = 'user_profile',
  });

  @override
  State<UserAvatarButton> createState() => _UserAvatarButtonState();
}

class _UserAvatarButtonState extends State<UserAvatarButton> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(
        FetchProfilePicture(widget.user.profilePictureUrl, widget.user.id));
  }

  String getUserInitials(User user) {
    String firstInitial = '';
    String lastInitial = '';

    if (user.firstName.isNotEmpty) {
      firstInitial = user.firstName[0].toUpperCase();
    }

    if (user.lastName.isNotEmpty) {
      lastInitial = user.lastName[0].toUpperCase();
    }

    return '$firstInitial.$lastInitial';
  }

  @override
  Widget build(BuildContext context) {
    final userBloc = context.read<UserBloc>();

    Widget userProfilePictureAvatar() {
      return BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          final imageProvider = state.profilePictures[widget.user.id];

          if (state.status != UserStatus.success) {
            return Container(
              height: widget.radius * 2,
              width: widget.radius * 2,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onSecondaryContainer.withOpacity(0.3)
              ),
            );
          }

          return Container(
            height: widget.radius * 2,
            width: widget.radius * 2,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.onPrimary.withOpacity(0.3)),
              image: DecorationImage(
                image: imageProvider ??
                    const AssetImage('assets/images/default_avatar.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      );
    }

    Widget userInitialsAvatar = Container(
      height: widget.radius * 2,
      width: widget.radius * 2,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: Border.all(color: AppColors.onPrimary.withOpacity(0.3)),
      ),
      child: Text(
        getUserInitials(widget.user),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.bold,
              fontSize: widget.fontSize,
            ),
      ),
    );

    return ClipOval(
      child: Material(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: InkWell(
          onTap: () {
            userBloc.add(FetchUserById(widget.user.id));
            GoRouter.of(context).pushNamed(widget.redirectRoute);
          },
          hoverColor: Theme.of(context).colorScheme.tertiaryContainer,
          child: widget.user.profilePictureUrl != null
              ? userProfilePictureAvatar()
              : userInitialsAvatar,
        ),
      ),
    );
  }
}
