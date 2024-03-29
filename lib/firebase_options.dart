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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDE0TcV0Uxb9RMHMdSS_SswCWM-d5f3qgA',
    appId: '1:636742482053:web:989e29db1a122f24a911ec',
    messagingSenderId: '636742482053',
    projectId: 'judgebox-58246',
    authDomain: 'judgebox-58246.firebaseapp.com',
    storageBucket: 'judgebox-58246.appspot.com',
    measurementId: 'G-6EM7F1R9EX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDif4SD9SIzfUJ44ePiMqiXhz7KPuBHe04',
    appId: '1:636742482053:android:ca8f83167c9fcfd3a911ec',
    messagingSenderId: '636742482053',
    projectId: 'judgebox-58246',
    storageBucket: 'judgebox-58246.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC2h6wRoh5DfUpeLdc7G9IfAyTTa8aRs4M',
    appId: '1:636742482053:ios:a191688ec9496a28a911ec',
    messagingSenderId: '636742482053',
    projectId: 'judgebox-58246',
    storageBucket: 'judgebox-58246.appspot.com',
    iosClientId: '636742482053-bjd67v24n9o34llss7riqlbf2lc9f9si.apps.googleusercontent.com',
    iosBundleId: 'com.example.judgebox',
  );
}
