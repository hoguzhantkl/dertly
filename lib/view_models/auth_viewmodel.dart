import 'package:dertly/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import '../locator.dart';

class AuthViewModel extends ChangeNotifier {
  AuthService get authService => locator<AuthService>();

  Stream<User?> get onAuthStateChanged => authService.auth.authStateChanges();

  Future<void> signIn(String email, String password) async {
    await authService.signIn(email: email, password: password);
  }

  Future<void> signOut() async {
    await authService.signOut();
  }
}