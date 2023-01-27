import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AuthService extends ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseAuth get auth => _auth;

  bool get isSignedIn => _auth.currentUser != null;

  Future<void> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password)
          .then((value) {debugPrint("Signed in with email: $email");})
          .catchError((onError) {debugPrint("Error while signing in with email: $email, error: $onError");});
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        debugPrint("invalid email");
      } else if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      }else{
        debugPrint("Error: ${e.code}, ${e.message}");
      }
    }
  }

  User getCurrentUser() {
    return _auth.currentUser!;
  }

  String getCurrentUserUID() {
    return _auth.currentUser!.uid;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}