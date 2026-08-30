import 'package:cached_network_image/cached_network_image.dart';
import 'package:equb_v3_frontend/blocs/user/user_bloc.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UserAvatarButton extends StatelessWidget {
  final UserSummary user;
  final double fontSize;
  final String redirectRoute;
  final double radius;
  final void Function()? onTap;

  const UserAvatarButton(
    this.user, {
    super.key,
    this.radius = 25,
    this.fontSize = 12,
    this.redirectRoute = 'user_profile',
    this.onTap,
  });

  String getUserInitials(UserSummary user) {
    String firstInitial = '';
    String lastInitial = '';

    if (user.firstName.isNotEmpty) {
      firstInitial = user.firstName[0].toUpperCase();
    }
    if (user.lastName.isNotEmpty) {
      lastInitial = user.lastName[0].toUpperCase();
    }
    return '$firstInitial$lastInitial';
  }

  @override
  Widget build(BuildContext context) {
    final size = radius * 2;

    Widget initialsAvatar() => Container(
          height: size,
          width: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            border:
                Border.all(color: AppColors.onPrimary.withValues(alpha: 0.3)),
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

    Widget pictureAvatar(String url) {
      // decode at display size rather than at the size of the stored file
      final pixels = (size * MediaQuery.of(context).devicePixelRatio).round();
      return CachedNetworkImage(
        imageUrl: url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        memCacheWidth: pixels,
        maxWidthDiskCache: pixels,
        fadeInDuration: const Duration(milliseconds: 120),
        placeholder: (context, _) => initialsAvatar(),
        errorWidget: (context, _, __) => initialsAvatar(),
        imageBuilder: (context, imageProvider) => Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border:
                Border.all(color: AppColors.onPrimary.withValues(alpha: 0.3)),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
      );
    }

    final url = user.profilePictureUrl;

    return ClipOval(
      child: Material(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: InkWell(
          onTap: onTap ??
              () {
                if (redirectRoute == "") {
                  return;
                }
                context.read<UserBloc>().add(FetchUserById(user.id));
                GoRouter.of(context).pushNamed(redirectRoute);
              },
          hoverColor: Theme.of(context).colorScheme.tertiaryContainer,
          child: (url == null || url.isEmpty)
              ? initialsAvatar()
              : pictureAvatar(url),
        ),
      ),
    );
  }
}
