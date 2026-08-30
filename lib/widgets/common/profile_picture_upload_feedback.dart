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
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(error ?? 'Profile picture updated'),
              backgroundColor: error == null
                  ? null
                  : Theme.of(context).colorScheme.error,
            ),
          );
      },
      child: child,
    );
  }
}
