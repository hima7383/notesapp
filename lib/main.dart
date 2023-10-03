import 'package:diaryx/constants/routs.dart';
import 'package:diaryx/services/auth/auth_service.dart';
import 'package:diaryx/views/notes/create_update_note_view.dart';
import 'package:diaryx/views/notes/notesview.dart';
import 'package:diaryx/views/login.dart';
import 'package:diaryx/views/register.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
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
    return FutureBuilder(
      future: AuthService.firebase().initializer(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerfied) {
                return const Notesview();
              } else {
                //showError(context, "please verify your Email before loging in");
                return const LoginView();
              }
            } else {
              return const RegisterationView();
            }

          default:
            return const Text("Loading...");
        }
      },
    );
  }
}
