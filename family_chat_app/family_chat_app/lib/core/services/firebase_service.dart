import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import '../firebase_options.dart';

/// Central Firebase service configuration and initialization
class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseService get instance => _instance ??= FirebaseService._();
  FirebaseService._();

  // Firebase service instances
  late final FirebaseAuth _auth;
  late final FirebaseFirestore _firestore;
  late final FirebaseStorage _storage;
  late final FirebaseAnalytics _analytics;
  late final FirebaseCrashlytics _crashlytics;
  late final FirebaseMessaging _messaging;
  late final FirebasePerformance _performance;

  // Getters for services
  FirebaseAuth get auth => _auth;
  FirebaseFirestore get firestore => _firestore;
  FirebaseStorage get storage => _storage;
  FirebaseAnalytics get analytics => _analytics;
  FirebaseCrashlytics get crashlytics => _crashlytics;
  FirebaseMessaging get messaging => _messaging;
  FirebasePerformance get performance => _performance;

  /// Initialize Firebase and all services
  Future<void> initialize() async {
    try {
      // Initialize Firebase Core
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Initialize all Firebase services
      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
      _storage = FirebaseStorage.instance;
      _analytics = FirebaseAnalytics.instance;
      _crashlytics = FirebaseCrashlytics.instance;
      _messaging = FirebaseMessaging.instance;
      _performance = FirebasePerformance.instance;

      // Configure services
      await _configureServices();

      print('🔥 Firebase services initialized successfully');
    } catch (e, stackTrace) {
      print('❌ Firebase initialization failed: $e');
      if (!kDebugMode) {
        FirebaseCrashlytics.instance.recordError(e, stackTrace);
      }
      rethrow;
    }
  }

  /// Configure Firebase services with optimal settings
  Future<void> _configureServices() async {
    // Configure Firestore settings
    if (!kIsWeb) {
      _firestore.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
    }

    // Configure Crashlytics
    if (!kDebugMode) {
      await _crashlytics.setCrashlyticsCollectionEnabled(true);
      FlutterError.onError = _crashlytics.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        _crashlytics.recordError(error, stack, fatal: true);
        return true;
      };
    }

    // Configure Analytics
    await _analytics.setAnalyticsCollectionEnabled(!kDebugMode);

    // Configure Messaging (for push notifications)
    if (!kIsWeb) {
      await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
      );

      // Get FCM token for this device
      final token = await _messaging.getToken();
      print('📱 FCM Token: $token');
    }

    // Configure Performance Monitoring
    await _performance.setPerformanceCollectionEnabled(!kDebugMode);
  }

  /// Set user properties for analytics and crashlytics
  Future<void> setUserProperties({
    required String userId,
    String? userRole,
    String? familyId,
  }) async {
    try {
      // Analytics user properties
      await _analytics.setUserId(id: userId);
      if (userRole != null) {
        await _analytics.setUserProperty(name: 'user_role', value: userRole);
      }
      if (familyId != null) {
        await _analytics.setUserProperty(name: 'family_id', value: familyId);
      }

      // Crashlytics user identifier
      await _crashlytics.setUserIdentifier(userId);
      if (userRole != null) {
        await _crashlytics.setCustomKey('user_role', userRole);
      }
      if (familyId != null) {
        await _crashlytics.setCustomKey('family_id', familyId);
      }
    } catch (e) {
      print('❌ Failed to set user properties: $e');
    }
  }

  /// Log custom analytics event
  Future<void> logEvent(String name, [Map<String, Object>? parameters]) async {
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
    } catch (e) {
      print('❌ Failed to log analytics event: $e');
    }
  }

  /// Log error to Crashlytics
  Future<void> logError(dynamic error, StackTrace? stackTrace, {
    bool fatal = false,
    Map<String, dynamic>? context,
  }) async {
    try {
      if (context != null) {
        for (final entry in context.entries) {
          await _crashlytics.setCustomKey(entry.key, entry.value);
        }
      }
      await _crashlytics.recordError(error, stackTrace, fatal: fatal);
    } catch (e) {
      print('❌ Failed to log error to Crashlytics: $e');
    }
  }

  /// Clear user data on logout
  Future<void> clearUserData() async {
    try {
      await _analytics.resetAnalyticsData();
      await _crashlytics.setUserIdentifier('');
    } catch (e) {
      print('❌ Failed to clear user data: $e');
    }
  }
}
