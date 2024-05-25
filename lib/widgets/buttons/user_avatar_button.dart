import 'package:equb_v3_frontend/models/authentication/user.dart';
import 'package:flutter/material.dart';

class UserAvatarButton extends StatelessWidget {
  final User user;
  final NetworkImage? profileImage;
  final double radius;

  const UserAvatarButton(
    this.user, {
    super.key,
    this.profileImage,
    this.radius = 30,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TDOD: redirect to user detail if other user, else to current user profile
      },
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        backgroundImage: profileImage,
        child: Text(
            '${user.firstName[0].toUpperCase()}.${user.lastName[0].toUpperCase()}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
