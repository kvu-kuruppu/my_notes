import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class VerificationView extends StatefulWidget {
  const VerificationView({Key? key}) : super(key: key);

  @override
  State<VerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          children: [
            const Text('data'),
            TextButton(
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();
                  devtools.log('object');
                },
                child: const Text('Click me'))
          ],
        ),
      ),
    );
  }
}
