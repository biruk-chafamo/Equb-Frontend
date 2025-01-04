import 'package:equb_v3_frontend/blocs/authentication/auth_bloc.dart';
import 'package:equb_v3_frontend/blocs/authentication/auth_state.dart';
import 'package:equb_v3_frontend/blocs/user/user_bloc.dart';
import 'package:equb_v3_frontend/screens/user/user_profile_screen.dart';
import 'package:equb_v3_frontend/widgets/buttons/user_avatar_button.dart';
import 'package:equb_v3_frontend/widgets/cards/user_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SideNavRail extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool extended;

  const SideNavRail({
    Key? key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.extended = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userAvatarHeader = BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          final user = state.user;
          return Padding(
            padding: EdgeInsets.only(
              right: 30,
              left: 30,
              bottom: !extended ? 0 : 40,
              top: !extended ? 0 : 10,
            ),
            child: !extended
                ? UserAvatarButton(user, radius: 20, fontSize: 14, redirectRoute: "current_user_profile")
                : Column(
                    children: [
                      UserAvatarButton(user, radius: 30, fontSize: 16, redirectRoute: "current_user_profile"),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${user.firstName} ${user.lastName}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                ),
                          ),
                        ],
                      ),
                      Text(
                        '@${user.username}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StarRating(
                            rating: user.score,
                            color: Theme.of(context).colorScheme.onTertiary,
                            starSize: 15,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '(${user.score.toString()})',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );

    return NavigationRail(
      backgroundColor: const Color.fromARGB(26, 147, 143, 143),
      useIndicator: false,
      selectedIndex: selectedIndex,
      leading: userAvatarHeader,
      selectedLabelTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.onTertiary,
            fontWeight: FontWeight.w900,
          ),
      unselectedLabelTextStyle:
          Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
      onDestinationSelected: onDestinationSelected,
      extended: extended,
      selectedIconTheme: IconThemeData(
        color: Theme.of(context).colorScheme.onTertiary,
      ),
      unselectedIconTheme: IconThemeData(
        color: Theme.of(context).colorScheme.onSecondaryContainer,
      ),
      destinations: const [
        NavigationRailDestination(
          icon: const Icon(Icons.pie_chart),
          label: Text('Equbs'),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.group),
          label: Text('Friends'),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.person),
          label: Text('Profile'),
        ),
      ],
    );
  }
}
