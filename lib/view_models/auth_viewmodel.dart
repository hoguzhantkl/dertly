import 'package:dertly/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import '../locator.dart';

import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel({required this.authRepository});

  final AuthRepository authRepository;

  AuthService get authService => locator<AuthService>();

  Stream<User?> get onAuthStateChanged => authService.auth.authStateChanges();

  late UserModel userModel;

  Future<void> fetchUserData() async {
    await authRepository.fetchUserData();
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async{
    await authService.signIn(email: email, password: password);
  }

  Future<void> signOut() async{
    await authService.signOut();
  }

}