import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/navigation/auth_router.dart';
import 'core/services/firebase_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (e.toString().contains('duplicate-app')) {
      print('Firebase already initialized, continuing...');
    } else {
      rethrow;
    }
  }

  await FirebaseService.initialize();

  runApp(const ProviderScope(child: EasySellPOSApp()));
}

class EasySellPOSApp extends StatelessWidget {
  const EasySellPOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthRouter();
  }
}
