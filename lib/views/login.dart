// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:diaryx/components/mytextfield.dart';
import 'package:diaryx/constants/routs.dart';
import 'package:diaryx/services/auth/auth_exceptions.dart';

import 'package:diaryx/services/auth/bloc/auth_bloc.dart';
import 'package:diaryx/services/auth/bloc/auth_events.dart';
import 'package:diaryx/utilites/dialogs/errordialogs.dart';
import 'package:diaryx/utilites/dialogs/noticedialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                    context.read<AuthBloc>().add(AuthEventLogIn(e, p));
                    // i used to send emeil verfy if usr cicks on login button and he isn't logged in
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
