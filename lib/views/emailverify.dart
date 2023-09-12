import 'package:firebase_auth/firebase_auth.dart';

void verfiyEmail() async {
  final user = FirebaseAuth.instance.currentUser;
  await user?.sendEmailVerification();
}
