import 'package:diaryx/constants/routs.dart';
import 'package:diaryx/services/auth/auth_service.dart';
import 'package:diaryx/services/auth/bloc/auth_bloc.dart';
import 'package:diaryx/services/auth/bloc/auth_events.dart';
import 'package:diaryx/services/auth/bloc/auth_state.dart';
import 'package:diaryx/services/auth/firebse_auth_provider.dart';
import 'package:diaryx/views/notes/create_update_note_view.dart';
import 'package:diaryx/views/notes/notesview.dart';
import 'package:diaryx/views/login.dart';
import 'package:diaryx/views/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FireBaseAuthProvidor()),
        child: const HomePage(),
      ),
      routes: {
        loginRout: (context) => const LoginView(),
        reigsterRout: (context) => const RegisterationView(),
        notesRout: (context) => const Notesview(),
        createUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventIntailize());
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedin) {
          return const Notesview();
        } else if (state is AuthStateNeedsVerfication) {
          return const LoginView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
