import 'package:equb_v3_frontend/blocs/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Reports the outcome of a profile picture upload once it finishes.
class ProfilePictureUploadFeedback extends StatelessWidget {
  final Widget child;

  const ProfilePictureUploadFeedback({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      // exactly one message per completed upload, not one per state change
      listenWhen: (previous, current) =>
          previous.isUploadingPicture && !current.isUploadingPicture,
      listener: (context, state) {
        final error = state.pictureUploadError;
        final scheme = Theme.of(context).colorScheme;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                error ?? 'Profile picture updated',
                // error is a light surface in this palette, so the text has to
                // be its paired onError rather than the default light-on-dark
                style: error == null ? null : TextStyle(color: scheme.onError),
              ),
              backgroundColor: error == null ? null : scheme.error,
            ),
          );
      },
      child: child,
    );
  }
}
