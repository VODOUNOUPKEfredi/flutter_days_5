// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyAZc8g5iZTEDdpEHQOUIPAkhB_M9GB4g-w',
    appId: '1:508280862192:web:fd97e330a3f9f3f0a15935',
    messagingSenderId: '508280862192',
    projectId: 'houeffa-houeto-dclic',
    authDomain: 'houeffa-houeto-dclic.firebaseapp.com',
    storageBucket: 'houeffa-houeto-dclic.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBKWmgkJ3XKGlHtKDmHomFp6bXymEuisGA',
    appId: '1:508280862192:android:8aad949956263825a15935',
    messagingSenderId: '508280862192',
    projectId: 'houeffa-houeto-dclic',
    storageBucket: 'houeffa-houeto-dclic.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBg2N__64-Y8hiVmv0DsbExCSzqv3oUVn4',
    appId: '1:508280862192:ios:b8d06f21f1315cafa15935',
    messagingSenderId: '508280862192',
    projectId: 'houeffa-houeto-dclic',
    storageBucket: 'houeffa-houeto-dclic.firebasestorage.app',
    iosClientId: '508280862192-7olmis1o9geapoerr4e8l6u12procg2u.apps.googleusercontent.com',
    iosBundleId: 'com.example.houeffa',
  );

}