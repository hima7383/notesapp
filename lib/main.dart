import 'package:diaryx/firebase_options.dart';
import 'package:diaryx/views/login.dart';
import 'package:diaryx/views/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: const Text("HomePage"),
        backgroundColor: Colors.grey,
      ),*/
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              /*  if (user?.emailVerified ?? false) {
                print("You are verified");
                return Text("done");
              } else {
                return const Verify_Email_View();
              }*/
              return LoginView();

            default:
              return const Text("Loading...");
          }
        },
      ),
    );
  }
}

class Verify_Email_View extends StatefulWidget {
  const Verify_Email_View({super.key});

  @override
  State<Verify_Email_View> createState() => _Verify_Email_ViewState();
}

class _Verify_Email_ViewState extends State<Verify_Email_View> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("pls verfiy your email"),
        TextButton(
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
          },
          child: const Text("send email verfication"),
        )
      ],
    );
  }
}
