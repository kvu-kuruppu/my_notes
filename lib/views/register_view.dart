import 'package:flutter/material.dart';
import 'package:my_notebook/constants/routes.dart';
import 'package:my_notebook/services/auth/auth_exceptions.dart';
import 'package:my_notebook/services/auth/auth_service.dart';
import 'package:my_notebook/utils/show_error_dialog.dart';

import 'dart:developer' as devtools show log;

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
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 132, 255),
                  ),
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    try {
                      final userCredential =
                          await AuthService.firebase().register(
                        email: email,
                        password: password,
                      );
                      AuthService.firebase().sendEmailVerification();
                      Navigator.of(context).pushNamed(verifyEmailRoute);
                      devtools.log(userCredential.toString());
                    } on InvalidEmailAuthException {
                      await showErrorDialog(
                        context,
                        'Invalid email',
                      );
                    } on WeakPasswordAuthException {
                      await showErrorDialog(
                        context,
                        'Weak password',
                      );
                    } on EmailAlreadyUsedAuthException {
                      await showErrorDialog(
                        context,
                        'Email already in use',
                      );
                    } on GenericAuthException {
                      await showErrorDialog(
                        context,
                        'Failed to register',
                      );
                    }
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
                TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (route) => false,
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
    );
  }
}
