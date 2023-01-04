import 'package:dertly/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../locator.dart';

class AuthViewModel extends ChangeNotifier {
  AuthService get authService => locator<AuthService>();

  Stream<User?> get onAuthStateChanged => authService.auth.authStateChanges();

  Future<void> signIn(String email, String password) async {
    await authService.signIn(email: email, password: password);
  }

  bool isSignedIn() {
    return authService.isSignedIn;
  }

  String getUserID() {
    return authService.getCurrentUser().uid;
  }

  Future<void> signOut() async {
    await authService.signOut();
  }
}