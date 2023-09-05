import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class VerfiyEmail extends StatefulWidget {
  const VerfiyEmail({super.key});

  @override
  State<VerfiyEmail> createState() => _VerfiyEmailState();
}

class _VerfiyEmailState extends State<VerfiyEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
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
    ));
  }
}
