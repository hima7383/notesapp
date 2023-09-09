import 'dart:developer';

import 'package:diaryx/components/mytextfield.dart';
import 'package:diaryx/constants/routs.dart';
import 'package:diaryx/utilites/errordialogs.dart';
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
        backgroundColor: Colors.grey.shade300,
        body: Container(
          /* decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/images/retrosupply-jLwVAUtLOAQ-unsplash.jpg"),
              fit: BoxFit.cover,
            ),
          ),*/
          child: ListView(
            children: [
              const SizedBox(height: 250),
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
                  final e = email.text.trim();
                  final p = pass.text.trim();
                  log(e);
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email.text.trim(),
                      password: p.trim(),
                    );

                    Navigator.of(context).pushNamedAndRemoveUntil(
                      notesRout,
                      (route) => false,
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      await showError(
                        context,
                        "User not found",
                      );
                    } else if (e.code == "wrong-password") {
                      await showError(
                        context,
                        "Wrong password",
                      );
                    } else {
                      await showError(context, "Error :${e.code}");
                    }
                  } catch (e) {
                    await showError(context, e.toString());
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
                      context, reigsterRout, (_) => false);
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
        ));
  }
}
