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
    apiKey: 'AIzaSyBK6aYwcYSbwkc_lzCKFc1DndwWk92hCAA',
    appId: '1:941465184921:web:80d8dce00efe310d412608',
    messagingSenderId: '941465184921',
    projectId: 'yer-lazim',
    authDomain: 'yer-lazim.firebaseapp.com',
    storageBucket: 'yer-lazim.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD90rfDp_T9hXiuqfK7ZYQqq4EBDgYycpw',
    appId: '1:941465184921:android:f77d0206a788c4ae412608',
    messagingSenderId: '941465184921',
    projectId: 'yer-lazim',
    storageBucket: 'yer-lazim.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDZxDlkVA52_o9jon_PtwJS4YQuOmpS32c',
    appId: '1:941465184921:ios:4553faea5b3cd8ca412608',
    messagingSenderId: '941465184921',
    projectId: 'yer-lazim',
    storageBucket: 'yer-lazim.appspot.com',
    iosClientId: '941465184921-kn3fqfnm84o9c7hucuj0o5laubsai5b6.apps.googleusercontent.com',
    iosBundleId: 'com.sokmen.yerlazim.yerlazim',
  );
}
