import 'package:equb_v3_frontend/blocs/user/user_bloc.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UserAvatarButton extends StatelessWidget {
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

    Widget userProfilePictureAvatar(String imagePath) {
      return Container(
        height: radius * 2,
        width: radius * 2,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(color: AppColors.onPrimary.withOpacity(0.3)),
          image: DecorationImage(
            image: NetworkImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    Widget userInitialsAvatar = Container(
      height: radius * 2,
      width: radius * 2,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: Border.all(color: AppColors.onPrimary.withOpacity(0.3)),
      ),
      child: Text(
        getUserInitials(user),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
      ),
    );
    return ClipOval(
      child: Material(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: InkWell(
          onTap: () {
            userBloc.add(FetchUserById(user.id));
            GoRouter.of(context).pushNamed(redirectRoute);
          },
          hoverColor: Theme.of(context).colorScheme.tertiaryContainer,
          child: user.profilePicture != null
              ? userProfilePictureAvatar(user.profilePicture!)
              : userInitialsAvatar,
        ),
      ),
    );
  }
}
