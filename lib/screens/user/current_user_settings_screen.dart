// user setting screen with options for update username, log out

import 'package:equb_v3_frontend/blocs/authentication/auth_bloc.dart';
import 'package:equb_v3_frontend/blocs/authentication/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CurrentUserSettingsScreen extends StatelessWidget {
  const CurrentUserSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              title: const Text('About'),
              onTap: () {
                GoRouter.of(context).pushNamed('about');
              },
            ),
            ListTile(
              title: const Text('Currency'),
              onTap: () {
                GoRouter.of(context).pushNamed('currency');
              },
            ),
            ListTile(
              title: const Text('Account Settings'),
              onTap: () {
                GoRouter.of(context).pushNamed('account_settings');
              },
            ),
            ListTile(
              title: const Text('Log Out'),
              onTap: () {
                context.read<AuthBloc>().add(const AuthLogoutRequested());
              },
            ),
          ],
        ),
      ),
    );
  }
}
