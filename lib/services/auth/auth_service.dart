import 'package:diaryx/services/auth/auth_providor.dart';
import 'package:diaryx/services/auth/auth_user.dart';
import 'package:diaryx/services/auth/firebse_auth_provider.dart';

class AuthService implements AuthProvidor {
  final AuthProvidor providor;
  const AuthService(this.providor);

  factory AuthService.firebase() {
    return AuthService(FireBaseAuthProvidor());
  }

  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) {
    return providor.createUser(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => providor.currentUser;

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    return providor.logIn(email: email, password: password);
  }

  @override
  Future<void> logOut() {
    return providor.logOut();
  }

  @override
  Future<void> sendEmailVerification() {
    return providor.sendEmailVerification();
  }

  @override
  Future<void> initializer() {
    return providor.initializer();
  }
}
