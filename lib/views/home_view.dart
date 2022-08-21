import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_notebook/firebase_options.dart';
import 'package:my_notebook/views/login_view.dart';

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
                print('hey $user');
                if (user?.emailVerified ?? false) {
                } else { 
                  // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  //   Navigator.of(context).push(MaterialPageRoute(
                  //       builder: (context) => const VerificationView()));
                  // });
                  return LoginView();
                }
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
                            'Home',
                            style: TextStyle(
                                fontSize: 50, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    const Center(child: Text('Done')),
                  ],
                );
              default:
                return const Center(child: Text('Loading...'));
            }
          }),
    );
  }
}

class VerificationView extends StatefulWidget {
  const VerificationView({Key? key}) : super(key: key);

  @override
  State<VerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('data'),
          TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                print('object');
              },
              child: const Text('Click me'))
        ],
      ),
    );
  }
}
