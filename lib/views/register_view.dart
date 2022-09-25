import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notebook/services/auth/auth_exceptions.dart';
import 'package:my_notebook/services/auth/bloc/auth_bloc.dart';
import 'package:my_notebook/services/auth/bloc/auth_event.dart';
import 'package:my_notebook/services/auth/bloc/auth_state.dart';
import 'package:my_notebook/utils/dialogs/error_dialog.dart';


class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

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
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'Weak Password');
          } else if (state.exception is EmailAlreadyUsedAuthException) {
            await showErrorDialog(context, 'Email already in use');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Failed to register');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Invalid email');
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
                    'Register',
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

                  // Register button
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 132, 255),
                    ),
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                      context.read<AuthBloc>().add(
                            AuthEventRegister(
                              email,
                              password,
                            ),
                          );
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  const Text('Already have an account?'),

                  const SizedBox(
                    height: 5,
                  ),

                  // Login button
                  TextButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.black),
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const AuthEventLogOut(),
                          );
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
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
