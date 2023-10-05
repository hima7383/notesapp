import 'package:firebase_auth/firebase_auth.dart' show User;

class AuthUser {
  final String id;
  final bool isEmailVerfied;
  final String email;
  const AuthUser({
    required this.isEmailVerfied,
    required this.email,
    required this.id,
  });
  factory AuthUser.fromfirebase(User user) => AuthUser(
      isEmailVerfied: user.emailVerified, email: user.email!, id: user.uid);
}
