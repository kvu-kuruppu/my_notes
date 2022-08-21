import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

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
      backgroundColor: Color.fromARGB(255, 185, 185, 185),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Register',
                            style: TextStyle(
                                fontSize: 50, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          // Email
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter your email',
                            ),
                            controller: _email,
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          // Password
                          TextField(
                            decoration: InputDecoration(
                                hintText: 'Enter your passowrd'),
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
                                      .createUserWithEmailAndPassword(
                                          email: email, password: password);

                                  print(userCredential);
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'invalid-email') {
                                    print('Invalid email');
                                  } else if (e.code == 'weak-password') {
                                    print('Weak password');
                                  } else if (e.code == 'email-already-in-use') {
                                    print('Email already in use');
                                  }
                                }
                              },
                              child: Text(
                                'Register',
                                style: TextStyle(color: Colors.white),
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text('Already have an account?'),
                          const SizedBox(
                            height: 5,
                          ),
                          TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.black),
                              onPressed: () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/login', (route) => false);
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(color: Colors.white),
                              ))
                        ],
                      ),
                    )
                  ],
                );
              default:
                return Center(child: const Text('Loading...'));
            }
          }),
    );
  }
}
