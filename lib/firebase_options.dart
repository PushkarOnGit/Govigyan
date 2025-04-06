// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: '<YOUR_WEB_API_KEY>',
    authDomain: '<YOUR_PROJECT>.firebaseapp.com',
    projectId: 'flutter_billing_app',
    storageBucket: '<YOUR_PROJECT>.appspot.com',
    messagingSenderId: '<SENDER_ID>',
    appId: '<WEB_APP_ID>',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: '<YOUR_ANDROID_API_KEY>',
    appId: '<ANDROID_APP_ID>',
    messagingSenderId: '<SENDER_ID>',
    projectId: 'flutter_billing_app',
    storageBucket: '<YOUR_PROJECT>.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: '<YOUR_IOS_API_KEY>',
    appId: '<IOS_APP_ID>',
    messagingSenderId: '<SENDER_ID>',
    projectId: 'flutter_billing_app',
    storageBucket: '<YOUR_PROJECT>.appspot.com',
    iosBundleId: 'com.example.flutterBillingApp',
  );
}