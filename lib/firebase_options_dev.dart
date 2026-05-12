import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DevFirebaseOptions {
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
    apiKey: "AIzaSyCAG0Z2datwRcPq0DnSaDwj1fdgjDDnYRA",
    authDomain: "buzme-test.firebaseapp.com",
    projectId: "buzme-test",
    storageBucket: "buzme-test.appspot.com",
    messagingSenderId: "762973347675",
    appId: "1:762973347675:web:496bdd7d6d46544e70c47e",
    measurementId: "G-ZHSLFC6W95",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBAF_4XfxzMYQ6cZ2lOGPwKhWCIbe-tzak',
    appId: '1:762973347675:android:68e1a9b16a28342a70c47e',
    messagingSenderId: '762973347675',
    projectId: 'buzme-test',
    storageBucket: 'buzme-test.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBOzIHwUcMAE4T2RKi9L3mskyEPFMKqTww',
    appId: '1:762973347675:ios:d56983ba7d10e40e70c47e',
    messagingSenderId: '762973347675',
    projectId: 'buzme-test',
    storageBucket: 'buzme-test.appspot.com',
    androidClientId:
        '762973347675-9dr30hsd4p74ag40bob1ldh3il97nf58.apps.googleusercontent.com',
    iosClientId:
        '762973347675-4cqgu90klrje75ih70cq7iir4po41dkh.apps.googleusercontent.com',
    iosBundleId: 'com.dohtechsolutions.buzme.dev',
  );
}
