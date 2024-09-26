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
    return InkWell(
      onTap: () {
        userBloc.add(FetchUserById(user.id));
        GoRouter.of(context).pushNamed(redirectRoute);
      },
      child: Container(
        height: radius * 2,
        width: radius * 2,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.secondaryContainer,
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
      ),
    );
  }
}
