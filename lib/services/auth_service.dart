import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AuthService extends ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseAuth get auth => _auth;

  bool get isSignedIn => _auth.currentUser != null;

  Future<void> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        print("invalid email");
      } else if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  User getCurrentUser() {
    return _auth.currentUser!;
  }

  Future<String> getCurrentUserUID() async {
    return _auth.currentUser!.uid;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}