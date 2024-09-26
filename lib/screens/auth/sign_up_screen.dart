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
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).goNamed('login');
          },
          icon: const Icon(Icons.arrow_back_ios),
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
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      hintText: 'username',
                    ),
                    autocorrect: false,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: firstNameController,
                          decoration: const InputDecoration(
                            hintText: 'first name',
                          ),
                          autocorrect: false,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextField(
                          controller: lastNameController,
                          decoration: const InputDecoration(
                            hintText: 'last name',
                          ),
                          autocorrect: false,
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
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'password',
                    ),
                    autocorrect: false,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: password2Controller,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'confirm password',
                    ),
                    autocorrect: false,
                  ),
                  const SizedBox(height: 40),
                  BlocConsumer<AuthBloc, AuthState>(
                    bloc: authBloc,
                    listener: (context, state) {
                      if (state is AuthAuthenticated) {
                        GoRouter.of(context).pushNamed("main");
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
                            child: const Text('Sign up'),
                            onPressed: () {
                              final username = usernameController.text.trim();
                              final password = passwordController.text.trim();
                              final password2 = password2Controller.text.trim();
                              final email = emailController.text.trim();
                              final firstName = firstNameController.text.trim();
                              final lastName = lastNameController.text.trim();
                              if (username.isEmpty ||
                                  password.isEmpty ||
                                  password2.isEmpty ||
                                  email.isEmpty ||
                                  firstName.isEmpty ||
                                  lastName.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'All fields are required to sign up'),
                                  ),
                                );
                                return;
                              }
                              if (password != password2) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Passwords do not match'),
                                  ),
                                );
                                return;
                              }
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
