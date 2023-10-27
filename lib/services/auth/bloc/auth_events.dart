import 'package:flutter/material.dart';

@immutable
abstract class AuthEvents {
  const AuthEvents();
}

class AuthEventIntailize extends AuthEvents {
  const AuthEventIntailize();
}

class AuthEventLogIn extends AuthEvents {
  final String email, password;
  const AuthEventLogIn(this.email, this.password);
}

class AuthEventsLogOut extends AuthEvents {
  const AuthEventsLogOut();
}
