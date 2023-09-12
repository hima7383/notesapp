// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:diaryx/components/mytextfield.dart';
import 'package:diaryx/constants/routs.dart';
import 'package:diaryx/services/auth/auth_exceptions.dart';
import 'package:diaryx/services/auth/auth_service.dart';
import 'package:diaryx/utilites/errordialogs.dart';
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
        body: /* Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/images/retrosupply-jLwVAUtLOAQ-unsplash.jpg"),
                fit: BoxFit.cover,
              ),
            ),*/
            SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 90),
              Text(
                "Welcome Back!",
                style: TextStyle(fontSize: 25, color: Colors.grey[700]),
              ),
              const SizedBox(height: 110),
              MyTextField(
                  controller1: email,
                  hinttext: "Enter your Email",
                  obsecuretext: false),
              const SizedBox(height: 15),
              MyTextField(
                  controller1: pass,
                  hinttext: "Enter your Password",
                  obsecuretext: true),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final e = email.text.trim();
                  final p = pass.text.trim();
                  log(e);
                  try {
                    await AuthService.firebase().logIn(email: e, password: p);
                    final user = AuthService.firebase().currentUser;
                    if (user != null) {
                      if (user.isEmailVerfied) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          notesRout,
                          (route) => false,
                        );
                      } else {
                        showError(context, "please verify your email first");
                      }
                    }
                  } on UserNotFoundAuthException {
                    await showError(
                      context,
                      "User not found",
                    );
                  } on WrongPasswordAuthException {
                    await showError(
                      context,
                      "Wrong password",
                    );
                  } on GenericAuthException {
                    await showError(context, "Authentication Eror");
                  }
                },
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    backgroundColor: Colors.black,
                    fixedSize: const Size(300, 50)),
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, reigsterRout, (_) => false);
                },
                child: const Text(
                  "Register an Email",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ));
  }
}
