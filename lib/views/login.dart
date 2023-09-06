import 'package:diaryx/components/mytextfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _HomePageState();
}

class _HomePageState extends State<LoginView> {
  late final TextEditingController email;
  late final TextEditingController pass;
  final String hinttext = "Enter your email";
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
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 50),
          MyTextField(
              controller1: email,
              hinttext: "Enter your Email",
              obsecuretext: false),
          const SizedBox(height: 15),
          MyTextField(
              controller1: pass,
              hinttext: "Enter your Password",
              obsecuretext: true),
          TextButton(
            onPressed: () async {
              final e = email.text;
              final p = pass.text;
              print(e);
              try {
                final usercan = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: email.text.trim(), password: p.trim());

                print(usercan);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  print("User not found");
                } else if (e.code == "wrong-password") {
                  print("Wrong password");
                }
              }
            },
            child: const Text(
              "Login",
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, "/register/", (route) => false);
            },
            style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0))),
            child: const Text(
              "Register an Email",
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}
