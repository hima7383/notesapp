import 'package:diaryx/services/auth/auth_user.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateLoggedin extends AuthState {
  final AuthUser user;
  const AuthStateLoggedin(this.user);
}

class AuthStateLoggedOut extends AuthState {
  final Exception? exception;
  const AuthStateLoggedOut(this.exception);
}

class AuthStateLogOutFailuer extends AuthState {
  final Exception exception;
  const AuthStateLogOutFailuer(this.exception);
}

class AuthStateNeedsVerfication extends AuthState {
  const AuthStateNeedsVerfication();
}
