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
    apiKey: 'AIzaSyB2JTOILTJ0OX0gJv1vTn6g4fV3fMVm1NA',
    appId: '1:950519412879:web:6677e9c56c35121ff798fa',
    messagingSenderId: '950519412879',
    projectId: 'point-of-sale-app-flutter',
    authDomain: 'point-of-sale-app-flutter.firebaseapp.com',
    storageBucket: 'point-of-sale-app-flutter.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB2JTOILTJ0OX0gJv1vTn6g4fV3fMVm1NA',
    appId: '1:950519412879:android:6677e9c56c35121ff798fa',
    messagingSenderId: '950519412879',
    projectId: 'point-of-sale-app-flutter',
    storageBucket: 'point-of-sale-app-flutter.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB2JTOILTJ0OX0gJv1vTn6g4fV3fMVm1NA',
    appId: '1:950519412879:ios:6677e9c56c35121ff798fa',
    messagingSenderId: '950519412879',
    projectId: 'point-of-sale-app-flutter',
    storageBucket: 'point-of-sale-app-flutter.firebasestorage.app',
    iosBundleId: 'com.fachrinfl.easysell',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB2JTOILTJ0OX0gJv1vTn6g4fV3fMVm1NA',
    appId: '1:950519412879:ios:6677e9c56c35121ff798fa',
    messagingSenderId: '950519412879',
    projectId: 'point-of-sale-app-flutter',
    storageBucket: 'point-of-sale-app-flutter.firebasestorage.app',
    iosBundleId: 'com.fachrinfl.easysell',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB2JTOILTJ0OX0gJv1vTn6g4fV3fMVm1NA',
    appId: '1:950519412879:web:6677e9c56c35121ff798fa',
    messagingSenderId: '950519412879',
    projectId: 'point-of-sale-app-flutter',
    authDomain: 'point-of-sale-app-flutter.firebaseapp.com',
    storageBucket: 'point-of-sale-app-flutter.firebasestorage.app',
  );
}
