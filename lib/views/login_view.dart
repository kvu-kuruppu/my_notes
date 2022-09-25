import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notebook/services/auth/auth_exceptions.dart';
import 'package:my_notebook/services/auth/bloc/auth_bloc.dart';
import 'package:my_notebook/services/auth/bloc/auth_event.dart';
import 'package:my_notebook/services/auth/bloc/auth_state.dart';

import 'package:my_notebook/utils/dialogs/error_dialog.dart';
import 'package:my_notebook/utils/dialogs/loading_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  CloseDialog? _closeDialogHandle;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          final closeDialog = _closeDialogHandle;

          if (!state.isLoading && closeDialog != null) {
            closeDialog();
            _closeDialogHandle = null;
          } else if (state.isLoading && closeDialog == null) {
            _closeDialogHandle = showLoadingDialog(
              context: context,
              text: 'Loading...',
            );
          }

          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, 'User not found');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Wrong credentials');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication error');
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 185, 185, 185),
        body: ListView(
          children: [
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                children: const [
                  Text(
                    'Login',
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Divider(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  // Email
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
                    ),
                    controller: _email,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  // Password
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Enter your password',
                    ),
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  // Login Button
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 132, 255),
                    ),
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                      context.read<AuthBloc>().add(
                            AuthEventLogIn(
                              email,
                              password,
                            ),
                          );
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  const Text('Don\'t have an account?'),

                  const SizedBox(
                    height: 5,
                  ),

                  // Create an account button
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const AuthEventShouldRegister(),
                          );
                    },
                    child: const Text(
                      'Create an account',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
