import 'package:diaryx/components/mytextfield.dart';
import 'package:diaryx/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
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
        body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/images/retrosupply-jLwVAUtLOAQ-unsplash.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
                child: Column(
              children: [
                const SizedBox(height: 250),
                const Icon(
                  Icons.lock,
                  size: 65,
                  color: Colors.black,
                ),
                const SizedBox(height: 50),
                MyTextField(
                    controller1: email,
                    hinttext: "Enter your Email",
                    obsecuretext: false),
                SizedBox(height: 15),
                MyTextField(
                    controller1: pass,
                    hinttext: "Enter your Password",
                    obsecuretext: true),
                TextButton(
                  onPressed: () async {
                    final e = email.text;
                    final p = pass.text;
                    try {
                      final usercan = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(email: e, password: p);
                      if (kDebugMode) {
                        print(usercan);
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        print("User not found");
                      } else if (e.code == "wrong-password") {
                        print("Wrong password");
                      }
                    }
                  },
                  child: const Text("Login"),
                ),
              ],
            ))));
  }
}
