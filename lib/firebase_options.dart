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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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
        return windows;
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCib2vNdSgSB4pM4YcSY0DvHE1jYpiV2qM',
    appId: '1:374837170876:android:e0dc6f5b799e74a827b6b9',
    messagingSenderId: '374837170876',
    projectId: 'citysos-api',
    storageBucket: 'citysos-api.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDIx49xHKMii4FIbsGHwSefGo_57IwMEQY',
    appId: '1:374837170876:ios:dd6bca6d2e2e894b27b6b9',
    messagingSenderId: '374837170876',
    projectId: 'citysos-api',
    storageBucket: 'citysos-api.appspot.com',
    iosBundleId: 'com.cityup.citysosCitizen',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBh3J7EL5WtPU13k_j6O78e9VpUdxGYAd8',
    appId: '1:374837170876:web:3f89197770c2c12f27b6b9',
    messagingSenderId: '374837170876',
    projectId: 'citysos-api',
    authDomain: 'citysos-api.firebaseapp.com',
    storageBucket: 'citysos-api.appspot.com',
    measurementId: 'G-5KJ706CEPE',
  );
}
