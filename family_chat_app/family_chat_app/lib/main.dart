import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/firebase_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with comprehensive services
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Initialize enhanced Firebase services
    await FirebaseService.instance.initialize();
    
    print('🚀 App initialized successfully with Firebase');
  } catch (e) {
    print('❌ App initialization failed: $e');
    // Continue with app launch even if Firebase fails
  }
  
  runApp(const ProviderScope(child: FamilyChatApp()));
}

class FamilyChatApp extends ConsumerWidget {
  const FamilyChatApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      title: 'Family Chat',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
