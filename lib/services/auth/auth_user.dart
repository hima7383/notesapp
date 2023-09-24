import 'package:firebase_auth/firebase_auth.dart' show User;

class AuthUser {
  final bool isEmailVerfied;
  final String? email;
  const AuthUser({required this.isEmailVerfied, required this.email});
  factory AuthUser.fromfirebase(User user) =>
      AuthUser(isEmailVerfied: user.emailVerified, email: user.email);
}
