import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_notebook/views/register_view.dart';
import '../firebase_options.dart';

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
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 185, 185, 185),
      body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return ListView(
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
                            style: TextStyle(
                                fontSize: 50, fontWeight: FontWeight.bold),
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
                                hintText: 'Enter your password'),
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
                                backgroundColor:
                                    const Color.fromARGB(255, 0, 132, 255),
                              ),
                              onPressed: () async {
                                final email = _email.text;
                                final password = _password.text;
                                try {
                                  final userCredential = await FirebaseAuth
                                      .instance
                                      .signInWithEmailAndPassword(
                                          email: email, password: password);

                                  print(userCredential);
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    print('User not found');
                                  } else if (e.code == 'wrong-password') {
                                    print('Wrong password');
                                  }
                                }
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(color: Colors.white),
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
                                  backgroundColor: Colors.black),
                              onPressed: () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/register', (route) => false);
                              },
                              child: const Text(
                                'Create an account',
                                style: TextStyle(color: Colors.white),
                              ))
                        ],
                      ),
                    )
                  ],
                );
              default:
                return const Center(child: Text('Loading...'));
            }
          }),
    );
  }
}
