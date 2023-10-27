import 'package:diaryx/services/auth/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

class AuthStateLoginFailuer extends AuthState {
  final Exception exception;
  const AuthStateLoginFailuer(this.exception);
}

class AuthStateLoggedOut extends AuthState {
  const AuthStateLoggedOut();
}

class AuthStateLogOutFailuer extends AuthState {
  final Exception exception;
  const AuthStateLogOutFailuer(this.exception);
}

class AuthStateNeedsVerfication extends AuthState {
  const AuthStateNeedsVerfication();
}
