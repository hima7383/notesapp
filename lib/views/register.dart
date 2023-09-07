import 'dart:developer';

import 'package:diaryx/components/mytextfield.dart';
import 'package:diaryx/constants/routs.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 300),
            MyTextField(
                controller1: email,
                hinttext: "Please Enter Your Email",
                obsecuretext: false),
            MyTextField(
                controller1: pass,
                hinttext: "Enter your Password",
                obsecuretext: true),
            TextButton(
              onPressed: () async {
                final e = email.text.trim();
                final p = pass.text.trim();
                try {
                  final usercan = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(email: e, password: p);
                  log(usercan.toString());
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    log("Weak password");
                  } else if (e.code == 'email-already-in-use') {
                    log("Email already in use");
                  } else if (e.code == 'invalid-email') {
                    log('Email is invalid');
                  }
                }
              },
              child: const Text("Register"),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, loginRout, (route) => false);
                },
                child: const Text("already has an Email"))
          ],
        ),
      ),
    );
  }
}
