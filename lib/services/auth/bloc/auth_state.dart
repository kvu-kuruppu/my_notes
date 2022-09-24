import 'package:flutter/foundation.dart' show immutable;
import 'package:my_notebook/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;

  const AuthStateLoggedIn(this.user);
}

class AuthStateLoginFaliure extends AuthState {
  final Exception exception;

  const AuthStateLoginFaliure(this.exception);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}

class AuthStateLoggedOut extends AuthState {
  const AuthStateLoggedOut();
}

class AuthStateLogoutFaliure extends AuthState {
  final Exception exception;

  const AuthStateLogoutFaliure(this.exception);
}
