import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_notebook/firebase_options.dart';
import 'package:my_notebook/views/login_view.dart';
import 'package:my_notebook/views/notes_view.dart';
import 'package:my_notebook/views/verify_email_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  if (user.emailVerified) {
                    return const NotesView();
                  } else {
                    return const VerificationView();
                  }
                } else {
                  return const LoginView();
                }
              // print('hey $user');
              // if (user?.emailVerified ?? false) {
              // } else {
              //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              //     Navigator.of(context).push(MaterialPageRoute(
              //         builder: (context) => const VerificationView()));
              //   });
              // }
              default:
                return const Center(child: Text('Loading...'));
            }
          }),
    );
  }
}
