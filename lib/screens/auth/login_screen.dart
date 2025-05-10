import 'package:equb_v3_frontend/blocs/authentication/auth_bloc.dart';
import 'package:equb_v3_frontend/blocs/authentication/auth_event.dart';
import 'package:equb_v3_frontend/blocs/authentication/auth_state.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/buttons/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();

    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: SingleChildScrollView(
              child: Wrap(
                runAlignment: WrapAlignment.center,
                alignment: WrapAlignment.center,
                runSpacing: 150,
                spacing: 100,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/equb_logo.png',
                        width: 50,
                        height: 50,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Equb Finance',
                        style: TextStyle(
                          fontFamily: 'Dangrek',
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Save and borrow with friends!',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ConstrainedBox(
                        constraints:
                            const BoxConstraints(maxWidth: smallScreenSize),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            TextField(
                              controller: usernameController,
                              decoration: const InputDecoration(
                                hintText: 'username',
                              ),
                              autocorrect: false,
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: 'password',
                              ),
                              autocorrect: false,
                            ),
                            const SizedBox(height: 40),
                            BlocConsumer<AuthBloc, AuthState>(
                              bloc: authBloc,
                              listener: (context, state) {
                                if (state is AuthAuthenticated) {
                                  GoRouter.of(context)
                                      .goNamed("equbs_overview");
                                } else if (state is AuthError) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Password or username is incorrect. Please try again."),
                                    ),
                                  );
                                }
                              },
                              builder: (context, state) {
                                if (state is AuthLoading) {
                                  return const CircularProgressIndicator();
                                }
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    CustomOutlinedButton(
                                      onPressed: () {
                                        final username =
                                            usernameController.text.trim();
                                        final password =
                                            passwordController.text.trim();
                        
                                        if (username.isEmpty ||
                                            password.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Username and Password cannot be empty'),
                                            ),
                                          );
                                          return;
                                        }
                                        authBloc.add(AuthLoginRequested(
                                          username: username,
                                          password: password,
                                        ));
                                      },
                                      child: 'Log in',
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                GoRouter.of(context)
                                    .goNamed('request_password_reset');
                              },
                              child: Text('Forgot password?',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomOutlinedButton(
                                  onPressed: () {
                                    GoRouter.of(context).goNamed('signup');
                                  },
                                  showBackground: false,
                                  child: 'Sign up',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
