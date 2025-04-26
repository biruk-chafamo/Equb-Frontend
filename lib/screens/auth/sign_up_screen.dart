import 'dart:convert';

import 'package:equb_v3_frontend/blocs/authentication/auth_bloc.dart';
import 'package:equb_v3_frontend/blocs/authentication/auth_event.dart';
import 'package:equb_v3_frontend/blocs/authentication/auth_state.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/buttons/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();

    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController password2Controller = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).goNamed("login");
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: smallScreenSize),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sign up',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          TextField(
                            controller: usernameController,
                            decoration: const InputDecoration(
                              hintText: 'username',
                            ),
                            autocorrect: false,
                          ),
                          ...potentialParamError(state, "username"),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: firstNameController,
                                      decoration: const InputDecoration(
                                        hintText: 'first name',
                                      ),
                                      autocorrect: false,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: lastNameController,
                                      decoration: const InputDecoration(
                                        hintText: 'last name',
                                      ),
                                      autocorrect: false,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    ...potentialParamError(state, "first_name"),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  children: [
                                    ...potentialParamError(state, "last_name"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              hintText: 'email',
                            ),
                            autocorrect: false,
                          ),
                          ...potentialParamError(state, "email"),
                          const SizedBox(height: 20),
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: 'password',
                            ),
                            autocorrect: false,
                          ),
                          ...potentialParamError(state, "password"),
                          const SizedBox(height: 20),
                          TextField(
                            controller: password2Controller,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: 'confirm password',
                            ),
                            autocorrect: false,
                          ),
                          ...potentialParamError(state, "password2"),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  BlocConsumer<AuthBloc, AuthState>(
                    bloc: authBloc,
                    listener: (context, state) {
                      if (state is AuthAuthenticated) {
                        GoRouter.of(context).goNamed("equbs_overview");
                      } else if (state is AuthError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
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
                            child: 'Sign up',
                            onPressed: () {
                              final username = usernameController.text.trim();
                              final password = passwordController.text.trim();
                              final password2 = password2Controller.text.trim();
                              final email = emailController.text.trim();
                              final firstName = firstNameController.text.trim();
                              final lastName = lastNameController.text.trim();

                              authBloc.add(AuthSignUpRequested(
                                user: UserDTO(
                                  username: username,
                                  password: password,
                                  password2: password2,
                                  email: email,
                                  firstName: firstName,
                                  lastName: lastName,
                                ),
                              ));
                            },
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
    );
  }
}

List<Widget> potentialParamError(AuthState state, String userParam) {
  if (state is AuthError && state.parameterErrorJSON[userParam] != null) {
    return state.parameterErrorJSON[userParam]
        .map<Widget>(
          (e) => Align(
            alignment: Alignment.centerLeft,
            child: Text('- ${e.toString()}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.start),
          ),
        )
        .toList();
  }
  return [];
}
