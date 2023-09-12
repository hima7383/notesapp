import 'package:diaryx/services/auth/auth_service.dart';

void verfiyEmail() async {
  return AuthService.firebase().sendEmailVerification();
}
