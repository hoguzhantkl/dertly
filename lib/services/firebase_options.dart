// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDcrmTy7LzpDJcotT9mnVXyHkLFfGzjSHg',
    appId: '1:1040068314281:web:18c48a1ca4fe28b74715b8',
    messagingSenderId: '1040068314281',
    projectId: 'dertly-4dc39',
    authDomain: 'dertly-4dc39.firebaseapp.com',
    storageBucket: 'dertly-4dc39.appspot.com',
    measurementId: 'G-2E12G0J8SK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBOZkusy3eaF7fM_2cvkhU4NZnUU4HGun8',
    appId: '1:1040068314281:android:ceaee4c12081d4004715b8',
    messagingSenderId: '1040068314281',
    projectId: 'dertly-4dc39',
    storageBucket: 'dertly-4dc39.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC_5voGzGSUT2dlZrKSK4LFPGFOcsEzIJw',
    appId: '1:1040068314281:ios:9702fb3d2bdf68df4715b8',
    messagingSenderId: '1040068314281',
    projectId: 'dertly-4dc39',
    storageBucket: 'dertly-4dc39.appspot.com',
    androidClientId: '1040068314281-krek9u0cq7odsk8mnl5pak517iac2u8d.apps.googleusercontent.com',
    iosClientId: '1040068314281-k7mti2efal4apn65vp6rmmhm9ph8rc0o.apps.googleusercontent.com',
    iosBundleId: 'com.insch.dertly',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC_5voGzGSUT2dlZrKSK4LFPGFOcsEzIJw',
    appId: '1:1040068314281:ios:9702fb3d2bdf68df4715b8',
    messagingSenderId: '1040068314281',
    projectId: 'dertly-4dc39',
    storageBucket: 'dertly-4dc39.appspot.com',
    androidClientId: '1040068314281-krek9u0cq7odsk8mnl5pak517iac2u8d.apps.googleusercontent.com',
    iosClientId: '1040068314281-k7mti2efal4apn65vp6rmmhm9ph8rc0o.apps.googleusercontent.com',
    iosBundleId: 'com.insch.dertly',
  );
}
