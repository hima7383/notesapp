// ignore_for_file: use_build_context_synchronously

import 'package:diaryx/components/mytextfield.dart';
import 'package:diaryx/constants/routs.dart';
import 'package:diaryx/services/auth/auth_exceptions.dart';
import 'package:diaryx/services/auth/auth_service.dart';
import 'package:diaryx/utilites/dialogs/errordialogs.dart';
import 'package:diaryx/utilites/dialogs/noticedialog.dart';
import 'package:diaryx/views/emailverify.dart';
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
      backgroundColor: Colors.grey.shade300,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 90),
            Text("Register",
                style: TextStyle(fontSize: 26, color: Colors.grey[700])),
            const SizedBox(
              height: 110,
            ),
            MyTextField(
                controller1: email,
                hinttext: "Please Enter Your Email",
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
                try {
                  await AuthService.firebase()
                      .createUser(email: e, password: p);
                  verfiyEmail();
                  showWindow(
                      context,
                      "We have sent an Email verfication link check your inbox or spam folder",
                      "registration success");
                } on WeakPasswordAuthException {
                  showError(
                    context,
                    "Weak password",
                  );
                } on EmailAlreadyInUseAuthException {
                  showError(context, 'Email is already in use');
                } on InvalidEmailAuthException {
                  showError(
                    context,
                    'Email is invalid',
                  );
                } on GenericAuthException {
                  showError(
                    context,
                    "Faild to Register",
                  );
                }
              },
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  backgroundColor: Colors.black,
                  fixedSize: const Size(300, 50)),
              child: const Text(
                "Register",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, loginRout, (route) => false);
                },
                child: const Text(
                  "already has an Email",
                  style: TextStyle(color: Colors.black),
                ))
          ],
        ),
      ),
    );
  }
}
