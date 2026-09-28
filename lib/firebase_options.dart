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
        return android;
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBPniJNWbD5uxK9_efBdNPMXVrAf8bT-Sc',
    appId: '1:631078233703:android:17d109c1f215d16e7116c2',
    messagingSenderId: '631078233703',
    projectId: 'disaster-7281e',
    storageBucket: 'disaster-7281e.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBPniJNWbD5uxK9_efBdNPMXVrAf8bT-Sc',
    appId: '1:631078233703:web:17d109c1f215d16e7116c2',
    messagingSenderId: '631078233703',
    projectId: 'disaster-7281e',
    storageBucket: 'disaster-7281e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBPniJNWbD5uxK9_efBdNPMXVrAf8bT-Sc',
    appId: '1:631078233703:ios:17d109c1f215d16e7116c2',
    messagingSenderId: '631078233703',
    projectId: 'disaster-7281e',
    storageBucket: 'disaster-7281e.firebasestorage.app',
  );
}
