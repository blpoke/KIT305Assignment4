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
    apiKey: 'AIzaSyDYCVJlY06Ue14ohj-ojCQ8VDoMsIlz918',
    appId: '1:41711140833:web:8d3258170dd4dd3ab79ca0',
    messagingSenderId: '41711140833',
    projectId: 'assignment2-18514',
    authDomain: 'assignment2-18514.firebaseapp.com',
    storageBucket: 'assignment2-18514.appspot.com',
    measurementId: 'G-01B3RP668T',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDRpOhAUzq9Z1h3xuoYE2EtWMeH6L5N3l4',
    appId: '1:41711140833:android:cd591360bb3ce866b79ca0',
    messagingSenderId: '41711140833',
    projectId: 'assignment2-18514',
    storageBucket: 'assignment2-18514.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAxzZtrLAwzoDMC8cy10qUfsr7Y2Fiy0zc',
    appId: '1:41711140833:ios:8092c5c679bb6586b79ca0',
    messagingSenderId: '41711140833',
    projectId: 'assignment2-18514',
    storageBucket: 'assignment2-18514.appspot.com',
    iosClientId: '41711140833-f1l755st1np9ob9lhla9vnm4l4j1cp01.apps.googleusercontent.com',
    iosBundleId: 'au.utas.edu.blpoke.assignment4.kit305Assignment4',
  );
}
