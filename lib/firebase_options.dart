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
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDdd-eSVhKM4-ym3O0dNLELJGW7OEPzsps',
    appId: '1:25412054847:web:13de8a302a4a8ca6dd6d8a',
    messagingSenderId: '25412054847',
    projectId: 'qro-gen',
    authDomain: 'qro-gen.firebaseapp.com',
    storageBucket: 'qro-gen.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBI-I0wKQLs4m3h4_AnBHLy34RZfMBrZBQ',
    appId: '1:25412054847:android:1aa6d63700bc7c94dd6d8a',
    messagingSenderId: '25412054847',
    projectId: 'qro-gen',
    storageBucket: 'qro-gen.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDJGvXV8x-un_8qc1oxOt03IiN-60zxhYo',
    appId: '1:25412054847:ios:3c432f218be529d3dd6d8a',
    messagingSenderId: '25412054847',
    projectId: 'qro-gen',
    storageBucket: 'qro-gen.appspot.com',
    iosBundleId: 'com.mvmcj.qro',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDJGvXV8x-un_8qc1oxOt03IiN-60zxhYo',
    appId: '1:25412054847:ios:ce9f5d9b48f40c55dd6d8a',
    messagingSenderId: '25412054847',
    projectId: 'qro-gen',
    storageBucket: 'qro-gen.appspot.com',
    iosBundleId: 'com.example.qrCode',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDdd-eSVhKM4-ym3O0dNLELJGW7OEPzsps',
    appId: '1:25412054847:web:ed3cff448f2f313fdd6d8a',
    messagingSenderId: '25412054847',
    projectId: 'qro-gen',
    authDomain: 'qro-gen.firebaseapp.com',
    storageBucket: 'qro-gen.appspot.com',
  );
}
