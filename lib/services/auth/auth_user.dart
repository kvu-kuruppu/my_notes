import 'package:firebase_auth/firebase_auth.dart' as Firebase show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String? email;
  final bool isEmailVerified;

  const AuthUser({
    required this.email,
    required this.isEmailVerified,
  });

  factory AuthUser.fromFirebase(Firebase.User user) => AuthUser(
        email: user.email,
        isEmailVerified: user.emailVerified,
      );
}
