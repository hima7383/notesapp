import 'package:firebase_auth/firebase_auth.dart' show User;

class AuthUser {
  final bool isEmailVerfied;
  const AuthUser(this.isEmailVerfied);
  factory AuthUser.fromfirebase(User user) => AuthUser(user.emailVerified);
}
