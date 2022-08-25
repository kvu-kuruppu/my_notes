import 'package:flutter/material.dart';
import 'package:my_notebook/constants/routes.dart';
import 'package:my_notebook/services/auth/auth_exceptions.dart';
import 'package:my_notebook/services/auth/auth_service.dart';
import 'package:my_notebook/utils/show_error_dialog.dart';
import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
    return Scaffold(
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
                TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 132, 255),
                    ),
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                      try {
                        final userCredential =
                            await AuthService.firebase().logIn(
                          email: email,
                          password: password,
                        );
                        final user = AuthService.firebase().currentUser;
                        if (user?.isEmailVerified ?? false) {
                          // user email verified
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            notesRoute,
                            (route) => false,
                          );
                        } else {
                          // user email not verified
                          Navigator.of(context).pushNamed(
                            verifyEmailRoute,
                            // (route) => false,
                          );
                        }
                        devtools.log(userCredential.toString());
                      } on UserNotFoundAuthException {
                        await showErrorDialog(
                          context,
                          'User not found',
                        );
                      } on WrongPasswordAuthException {
                        await showErrorDialog(
                          context,
                          'Wrong password',
                        );
                      } on GenericAuthException {
                        await showErrorDialog(
                          context,
                          'Authentication Error',
                        );
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                const Text('Don\'t have an account?'),
                const SizedBox(
                  height: 5,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      registerRoute,
                      (route) => false,
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
    );
  }
}
