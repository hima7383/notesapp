import 'package:diaryx/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class RegisterationView extends StatefulWidget {
  const RegisterationView({super.key});

  @override
  State<RegisterationView> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<RegisterationView> {
  late final TextEditingController email;
  late final TextEditingController pass;
  @override
  void initState() {
    email = TextEditingController();
    pass = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: email,
          decoration: const InputDecoration(hintText: "Enter your Email"),
          enableSuggestions: false,
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
        ),
        TextField(
          controller: pass,
          decoration: const InputDecoration(hintText: "Enter password"),
          enableSuggestions: false,
          obscureText: true,
          autocorrect: false,
        ),
        TextButton(
          onPressed: () async {
            final e = email.text;
            final p = pass.text;
            try {
              final usercan = await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(email: e, password: p);
              print(usercan);
            } on FirebaseAuthException catch (e) {
              if (e.code == 'weak-password') {
                print("Weak password");
              } else if (e.code == 'email-already-in-use') {
                print("Email already in use");
              } else if (e.code == 'invalid-email') {
                print('Email is invalid');
              }
            }
          },
          child: const Text("Register"),
        ),
      ],
    );
  }
}
