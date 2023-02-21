import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';

class EmulatorService{
  var ip = "10.0.2.2";
  Future<void> configureFirebaseAuth() async {
    String configHost = const String.fromEnvironment("FIREBASE_EMU_URL");
    int configPort = const int.fromEnvironment("AUTH_EMU_PORT");
    // Android emulator must be pointed to 10.0.2.2
    var defaultHost = Platform.isAndroid ? ip : 'localhost';
    var host = configHost.isNotEmpty ? configHost : defaultHost;
    var port = configPort != 0 ? configPort : 9099;
    await FirebaseAuth.instance.useAuthEmulator(host, port);
    debugPrint('Using Firebase Auth emulator on: $host:$port');
  }

  Future<void> configureFirebaseStorage() async {
    String configHost = const String.fromEnvironment("FIREBASE_EMU_URL");
    int configPort = const int.fromEnvironment("STORAGE_EMU_PORT");
    // Android emulator must be pointed to 10.0.2.2
    var defaultHost = Platform.isAndroid ? ip : 'localhost';
    var host = configHost.isNotEmpty ? configHost : defaultHost;
    var port = configPort != 0 ? configPort : 9199;
    await FirebaseStorage.instance.useStorageEmulator(host, port);
    debugPrint('Using Firebase Storage emulator on: $host:$port');
  }

  void configureFirebaseFirestore() {
    String configHost = const String.fromEnvironment("FIREBASE_EMU_URL");
    int configPort = const int.fromEnvironment("DB_EMU_PORT");
    // Android emulator must be pointed to 10.0.2.2
    var defaultHost = Platform.isAndroid ? ip : 'localhost';
    var host = configHost.isNotEmpty ? configHost : defaultHost;
    var port = configPort != 0 ? configPort : 8080;

    FirebaseFirestore.instance.settings = Settings(
      host: '$host:$port',
      sslEnabled: false,
      persistenceEnabled: false,
    );
    debugPrint('Using Firebase Firestore emulator on: $host:$port');
  }

  void configureFirebaseFunctions(){
    String configHost = const String.fromEnvironment("FIREBASE_EMU_URL");
    int configPort = const int.fromEnvironment("FUNCTIONS_EMU_PORT");
    // Android emulator must be pointed to
    var defaultHost = Platform.isAndroid ? ip : 'localhost';
    var host = configHost.isNotEmpty ? configHost : defaultHost;
    var port = configPort != 0 ? configPort : 5001;
    FirebaseFunctions.instanceFor(region: 'europe-west1').useFunctionsEmulator(host, port);
    debugPrint('Using Firebase Functions emulator on: $host:$port');

  }
}