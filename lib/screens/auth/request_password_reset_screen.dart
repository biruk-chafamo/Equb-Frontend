import 'package:equb_v3_frontend/blocs/authentication/auth_bloc.dart';
import 'package:equb_v3_frontend/blocs/authentication/auth_event.dart';
import 'package:equb_v3_frontend/blocs/authentication/auth_state.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/buttons/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestPasswordResetScreen extends StatefulWidget {
  const RequestPasswordResetScreen({Key? key}) : super(key: key);

  @override
  _RequestPasswordResetScreenState createState() =>
      _RequestPasswordResetScreenState();
}

class _RequestPasswordResetScreenState extends State<RequestPasswordResetScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Request Password Reset",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is AuthPasswordResetRequested) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Password reset email sent")),
              );
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
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Enter your email',
                      hintText: 'you@example.com',
                    ),
                    autocorrect: false,
                  ),
                  const SizedBox(height: 20),
                  CustomOutlinedButton(
                    onPressed: () {
                      final email = _emailController.text.trim();
                      if (email.isNotEmpty) {
                        context.read<AuthBloc>().add(
                              CheckEmailExistsRequested(email: email),
                            );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Enter a valid email")),
                        );
                      }
                    },
                    child: const Text('Request Password Reset'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}