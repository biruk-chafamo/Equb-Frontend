import 'package:equb_v3_frontend/blocs/authentication/auth_bloc.dart';
import 'package:equb_v3_frontend/blocs/authentication/auth_event.dart';
import 'package:equb_v3_frontend/blocs/authentication/auth_state.dart';
import 'package:equb_v3_frontend/screens/auth/sign_up_screen.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/buttons/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PasswordResetScreen extends StatefulWidget {
  final String token; // The email that was used to request the reset

  const PasswordResetScreen({Key? key, required this.token}) : super(key: key);

  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  final bool passwordsMatch = false;
  final bool isAboveMinLength = false;
  final bool isAllNumbers = false;

  List<Widget> potentialParamError(AuthState state, String userParam) {
    if (state is AuthError && state.parameterErrorJSON[userParam] != null) {
      return state.parameterErrorJSON[userParam]
          .map<Widget>(
            (e) => Align(
              alignment: Alignment.centerLeft,
              child: Text('- ${e.toString()}',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onError),
                  textAlign: TextAlign.start),
            ),
          )
          .toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              GoRouter.of(context).pushNamed('login');
            },
            child: Text(
              "Log in",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                fontSize: 16,
              ),
            ),
          ),
        ],
        title: Text(
          "Reset Password",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: smallScreenSize),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                } else if (state is AuthUnauthenticated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Password reset successful")),
                  );
                  GoRouter.of(context).pushNamed('login');
                }
              },
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Enter your new password',
                        ),
                      ),
                      ...potentialParamError(state, "password"),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _password2Controller,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Confirm your new password',
                        ),
                      ),
                      const SizedBox(height: 30),
                      CustomOutlinedButton(
                        onPressed: () {
                          final password = _passwordController.text.trim();
                          final password2 = _password2Controller.text.trim();
                          if (password != password2) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Passwords do not match")),
                            );
                            return;
                          }
                          if (password.isNotEmpty) {
                            context.read<AuthBloc>().add(
                                  AuthPasswordResetRequestedEvent(
                                    token: widget.token,
                                    password: password,
                                  ),
                                );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Enter a valid password")),
                            );
                          }
                        },
                        child: 'Reset Password',
                      ),
                      ...[
                        "At least 8 characters",
                        "Don’t use your name or email",
                        "Avoid common passwords",
                        "Can’t be all numbers"
                      ].map((hint) => Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.check_circle_outlined,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer
                                      .withOpacity(0.7),
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  hint,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer
                                            .withOpacity(0.7),
                                      ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
