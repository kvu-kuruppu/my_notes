import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:my_notebook/constants/routes.dart';

class VerificationView extends StatefulWidget {
  const VerificationView({Key? key}) : super(key: key);

  @override
  State<VerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 185, 185, 185),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: ListView(children: [
          Column(
            children: [
              Row(
                children: const [
                  Text(
                    'Check your email for verification',
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'If you didn\'t receive an email please click the button below',
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                      onPressed: () async {
                        final user = FirebaseAuth.instance.currentUser;
                        await user?.sendEmailVerification();
                        devtools.log('object');
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                      ),
                      child: const Text(
                        'Click me',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        registerRoute,
                        (route) => false,
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_circle_left,
                      size: 50,
                      color: Colors.red,
                    ),
                  ),
                ],
              )
            ],
          ),
        ]),
      ),
    );
  }
}
