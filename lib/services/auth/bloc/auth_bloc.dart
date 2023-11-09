import 'package:bloc/bloc.dart';
import 'package:diaryx/services/auth/auth_providor.dart';
import 'package:diaryx/services/auth/bloc/auth_events.dart';
import 'package:diaryx/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvents, AuthState> {
  AuthBloc(AuthProvidor providor) : super(const AuthStateLoading()) {
    // intailize firebase
    on<AuthEventIntailize>((event, emit) async {
      await providor.initializer();
      final user = providor.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(null));
      } else if (!user.isEmailVerfied) {
        emit(const AuthStateNeedsVerfication());
      } else {
        emit(AuthStateLoggedin(user));
      }
    });
    // handling logging in
    on<AuthEventLogIn>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        final user = await providor.logIn(
          email: email,
          password: password,
        );
        emit(AuthStateLoggedin(user));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(e));
      }
    });
    // handling logout
    on<AuthEventsLogOut>((event, emit) async {
      emit(const AuthStateLoading());
      try {
        await providor.logOut();
        emit(const AuthStateLoggedOut(null));
      } on Exception catch (e) {
        emit(AuthStateLogOutFailuer(e));
      }
    });
  }
}
