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
              Theme.of(context).colorScheme.secondaryContainer,
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: smallScreenSize),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.supervised_user_circle_sharp,
                        size: 100,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer),
                    Text(
                      'Equb Finance',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
                    const SizedBox(height: 40),
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
                          GoRouter.of(context).goNamed("equbs_overview");
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomOutlinedButton(
                              onPressed: () {
                                final username = usernameController.text.trim();
                                final password = passwordController.text.trim();

                                if (username.isEmpty || password.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
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
                              child: const Text('Login'),
                            ),
                            TextButton(
                              onPressed: () {
                                GoRouter.of(context)
                                    .pushNamed('request_password_reset');
                              },
                              child: Text('Forgot password?',
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: () {
                                GoRouter.of(context).goNamed('signup');
                              },
                              child: Text('Sign up',
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
