import 'package:diaryx/services/auth/auth_exceptions.dart';
import 'package:diaryx/services/auth/auth_providor.dart';
import 'package:diaryx/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group("Mock Authprovidor", () {
    final providor = MockAuthProvidor();
    test("should not be intailazed", () {
      expect(providor.isintialzed, false);
    });
    test("don't log out without intialzed", () {
      expect(providor.logOut(),
          throwsA(const TypeMatcher<IsNotintailizedExceptoin>()));
    });
    test("we should be intailized", () async {
      await providor.initializer();
    });
    test("user should be null", () {
      expect(providor.currentUser, null);
    });
    test("should be intailezed in z amount of seconds", () async {
      await providor.initializer();
      expect(providor.isintialzed, true);
    }, timeout: const Timeout(Duration(seconds: 2)));
    test("create user should call login function", () async {
      final bademail =
          providor.createUser(email: "010@gmail.com", password: "pas7646");
      expect(bademail, throwsA(const TypeMatcher<UserNotFoundAuthException>()));
      final badpass =
          providor.createUser(email: "123@gmail.com", password: "lolman");
      expect(badpass, throwsA(const TypeMatcher<WrongPasswordAuthException>()));
      final user = await providor.createUser(email: "email", password: "111");
      expect(providor.currentUser, user);
      expect(user.isEmailVerfied, false);
    });
    test("loged in usre should be able to get verifed", () {
      providor.sendEmailVerification();
      final user = providor.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerfied, true);
    });
    test("should be able to logout and login again", () async {
      await providor.logOut();
      await providor.logIn(email: "email", password: "password");
      final user = providor.currentUser;
      expect(user, isNotNull);
    });
  });
}

class IsNotintailizedExceptoin implements Exception {}

class MockAuthProvidor implements AuthProvidor {
  AuthUser? _user;
  var _isintialzed = false;
  bool get isintialzed => _isintialzed;
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isintialzed) throw IsNotintailizedExceptoin();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initializer() async {
    await Future.delayed(const Duration(seconds: 1));
    _isintialzed = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!_isintialzed) throw IsNotintailizedExceptoin();
    if (email == '010@gmail.com') throw UserNotFoundAuthException();
    if (password == 'lolman') throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerfied: false, email: 'hshsdgad@1.com');
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!_isintialzed) throw IsNotintailizedExceptoin();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!_isintialzed) throw IsNotintailizedExceptoin();
    final user = _user;
    if (user == null) {
      throw UserNotFoundAuthException();
    }
    const newuser = AuthUser(isEmailVerfied: true, email: 'gagsagfa@g.com');
    _user = newuser;
  }
}
