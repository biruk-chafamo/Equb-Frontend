import 'dart:async';

import 'package:equb_v3_frontend/blocs/authentication/auth_bloc.dart';
import 'package:equb_v3_frontend/blocs/authentication/auth_event.dart';
import 'package:equb_v3_frontend/blocs/authentication/auth_state.dart';
import 'package:equb_v3_frontend/repositories/authentication_repository.dart';
import 'package:equb_v3_frontend/services/authentication_service.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/buttons/custom_elevated_button.dart';
import 'package:equb_v3_frontend/widgets/buttons/google_signin_button.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? rememberedAuthMethod;
  StreamSubscription<GoogleSignInAccount?>? _googleUserSubscription;

  @override
  void initState() {
    super.initState();
    // Listen to email changes to check authentication method
    usernameController.addListener(_checkAuthMethod);

    if (kIsWeb) {
      // Web needs silent sign-in + the rendered Google button instead of
      // the custom button/`.signIn()` flow used on other platforms.
      final authService = context.read<AuthRepository>().authService;
      _googleUserSubscription =
          authService.onGoogleUserChanged.listen((account) {
        if (account != null && mounted) {
          context.read<AuthBloc>().add(AuthGoogleAccountReceived(account));
        }
      });
      authService.trySilentGoogleSignIn();
    }
  }

  @override
  void dispose() {
    usernameController.removeListener(_checkAuthMethod);
    usernameController.dispose();
    passwordController.dispose();
    _googleUserSubscription?.cancel();
    super.dispose();
  }

  void _checkAuthMethod() async {
    final email = usernameController.text.trim();
    if (email.isNotEmpty && email.contains('@')) {
      final authService = AuthService(baseUrl: baseUrl);
      final method = await authService.getAuthMethod(email);
      if (mounted && method != rememberedAuthMethod) {
        setState(() {
          rememberedAuthMethod = method;
        });
      }
    } else if (rememberedAuthMethod != null) {
      setState(() {
        rememberedAuthMethod = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();

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
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Wrap(
                runAlignment: WrapAlignment.center,
                alignment: WrapAlignment.center,
                runSpacing: 100,
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
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
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
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Web needs Google's own rendered button
                                  if (kIsWeb)
                                    SizedBox(
                                      height: 40,
                                      child: googleSignInButton(),
                                    )
                                  else
                                    CustomOutlinedButton(
                                      onPressed: () {
                                        authBloc.add(
                                            const AuthGoogleSignInRequested());
                                      },
                                      showBackground: false,
                                      leading: Image.asset(
                                        'assets/images/login_service_logos/google.png',
                                        width: 24,
                                        height: 24,
                                      ),
                                      backgroundColor: Colors.grey.shade700,
                                      child: 'Continue with Google',
                                    ),
                                ],
                              ),
                              const SizedBox(height: 40),
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary
                                          .withOpacity(0.3),
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    child: Text('OR'),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary
                                          .withOpacity(0.3),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 40),
                              TextField(
                                controller: usernameController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter username',
                                  hintStyle: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                style: const TextStyle(fontSize: 16),
                                autocorrect: false,
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  hintText: 'Enter password',
                                  hintStyle: TextStyle(
                                    fontSize: 16,
                                  ),
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
                                      SnackBar(
                                        content: Text(
                                          state.message,
                                        ),
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
                                      // Account Sign-In Button
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
                                        showBackground: true,
                                        child: 'Sign in with account',
                                      ),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              // Smart password reset / Google sign-in hint
                              if (rememberedAuthMethod == 'google')
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border:
                                        Border.all(color: Colors.blue.shade200),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.info_outline,
                                          color: Colors.blue.shade700,
                                          size: 20),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          'This email uses Google Sign-In. Use "Continue with Google" above.',
                                          style: TextStyle(
                                            color: Colors.blue.shade700,
                                            fontSize: 13,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else if (rememberedAuthMethod != 'google')
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
                      )
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
