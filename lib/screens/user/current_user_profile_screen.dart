import 'package:equb_v3_frontend/blocs/user/user_bloc.dart';
import 'package:equb_v3_frontend/screens/user/user_profile_screen.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CurrentUserProfileScreen extends StatelessWidget {
  const CurrentUserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              icon: const Icon(Icons.settings, size: appBarIconSize),
              onPressed: () {
                GoRouter.of(context).pushNamed('current_user_settings');
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state.status == UserStatus.success) {
              final currentUser = state.currentUser;
              if (currentUser == null) {
                return const Center(child: Text('No user found'));
              }
              return UserDetailsSection(currentUser, isCurrentUser: true);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        )),
      ),
    );
  }
}
