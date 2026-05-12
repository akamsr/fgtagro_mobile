import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class ProdFirebaseOptions {
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
    apiKey: 'AIzaSyCsIAkSsDcJnSZUGZTR-SPFsusbQCIG_ck',
    appId: '1:791360931874:web:9f4fb9c756a0929a6ae27b',
    messagingSenderId: '791360931874',
    projectId: 'buzme-46464',
    authDomain: 'buzme-46464.firebaseapp.com',
    storageBucket: 'buzme-46464.appspot.com',
    measurementId: 'G-P0R9BMYVWQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD__cPN5QDzO7jawj76ygqVRN-319DWyig',
    appId: '1:791360931874:android:1adfac6546f586cf6ae27b',
    messagingSenderId: '791360931874',
    projectId: 'buzme-46464',
    storageBucket: 'buzme-46464.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA5jQjKEfycehx-lEwEOsixPu0qtiVJ7Zg',
    appId: '1:791360931874:ios:e91e0049aa1ef5c66ae27b',
    messagingSenderId: '791360931874',
    projectId: 'buzme-46464',
    storageBucket: 'buzme-46464.appspot.com',
    androidClientId:
        '791360931874-3a4u5h9r6hk98fupcevj931rfo8crorp.apps.googleusercontent.com',
    iosClientId:
        '791360931874-ec8idas078mvbp83lpbpv1inqtmglr8p.apps.googleusercontent.com',
    iosBundleId: 'com.dohtechsolutions.buzmemarket',
  );
}
