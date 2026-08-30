import 'package:equb_v3_frontend/widgets/common/profile_picture_upload_feedback.dart';
// user setting screen with options for update username, log out

import 'package:equb_v3_frontend/blocs/authentication/auth_bloc.dart';
import 'package:equb_v3_frontend/blocs/authentication/auth_event.dart';
import 'package:equb_v3_frontend/blocs/user/user_bloc.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentUserSettingsScreen extends StatelessWidget {
  const CurrentUserSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = context.read<UserBloc>();
    return ProfilePictureUploadFeedback(
        child: Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: smallScreenSize),
            child: ListView(
              children: [
                BlocBuilder<UserBloc, UserState>(
                  buildWhen: (previous, current) =>
                      previous.isUploadingPicture != current.isUploadingPicture,
                  builder: (context, state) {
                    final uploading = state.isUploadingPicture;
                    return ListTile(
                      leading: const Icon(Icons.edit_outlined),
                      contentPadding: const EdgeInsets.only(left: 20),
                      title: Text(uploading
                          ? 'Uploading picture...'
                          : 'Edit Profile Picture'),
                      trailing: uploading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : null,
                      enabled: !uploading,
                      onTap: () async {
                        final pickedImage = await pickProfileImage();
                        if (pickedImage == null) return;
                        userBloc.add(UpdateProfilePicture(pickedImage));
                      },
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout_outlined),
                  contentPadding: const EdgeInsets.only(left: 20),
                  title: const Text('Log Out'),
                  onTap: () {
                    context.read<AuthBloc>().add(const AuthLogoutRequested());
                    // show a snackbar or dialog to confirm logout
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('You have been logged out.'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
