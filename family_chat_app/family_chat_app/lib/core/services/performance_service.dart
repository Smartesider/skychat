import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class PerformanceService {
  static PerformanceService? _instance;
  static PerformanceService get instance => _instance ??= PerformanceService._();
  PerformanceService._();

  // Analytics & Crash Reporting
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;
  
  // Local Storage
  SharedPreferences? _prefs;
  Database? _localDb;
  
  // Connectivity
  final Connectivity _connectivity = Connectivity();
  bool _isOnline = true;
  
  // Cache Management
  final Map<String, dynamic> _memoryCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  static const int _cacheExpiryMinutes = 30;

  /// Initialize performance service
  Future<void> initialize() async {
    try {
      // Initialize shared preferences
      _prefs = await SharedPreferences.getInstance();
      
      // Initialize local database
      await _initializeLocalDatabase();
      
      // Set up connectivity monitoring
      _connectivity.onConnectivityChanged.listen(_onConnectivityChanged);
      
      // Initialize crash reporting
      await _initializeCrashReporting();
      
      // Log initialization
      await logEvent('performance_service_initialized');
      
    } catch (e) {
      await logError('Failed to initialize PerformanceService', e);
    }
  }

  /// Initialize local SQLite database for offline storage
  Future<void> _initializeLocalDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/family_chat_cache.db';
    
    _localDb = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create tables for offline caching
        await db.execute('''
          CREATE TABLE messages (
            id TEXT PRIMARY KEY,
            chat_room_id TEXT,
            sender_id TEXT,
            content TEXT,
            type TEXT,
            timestamp INTEGER,
            is_sent INTEGER,
            data TEXT
          )
        ''');
        
        await db.execute('''
          CREATE TABLE media_cache (
            id TEXT PRIMARY KEY,
            url TEXT,
            local_path TEXT,
            file_size INTEGER,
            mime_type TEXT,
            created_at INTEGER,
            last_accessed INTEGER
          )
        ''');
        
        await db.execute('''
          CREATE TABLE sync_queue (
            id TEXT PRIMARY KEY,
            operation_type TEXT,
            data TEXT,
            retry_count INTEGER,
            created_at INTEGER
          )
        ''');
      },
    );
  }

  /// Initialize crash reporting with user context
  Future<void> _initializeCrashReporting() async {
    await _crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);
    
    // Set custom keys for better crash debugging
    await _crashlytics.setCustomKey('app_version', '1.0.0');
    await _crashlytics.setCustomKey('build_number', '1');
  }

  /// Handle connectivity changes
  void _onConnectivityChanged(ConnectivityResult result) {
    final wasOnline = _isOnline;
    _isOnline = result != ConnectivityResult.none;
    
    if (!wasOnline && _isOnline) {
      // Back online - sync pending operations
      _syncPendingOperations();
    }
    
    logEvent('connectivity_changed', parameters: {
      'connection_type': result.name,
      'is_online': _isOnline,
    });
  }

  /// Cache management methods
  void setCacheItem(String key, dynamic value) {
    _memoryCache[key] = value;
    _cacheTimestamps[key] = DateTime.now();
  }

  T? getCacheItem<T>(String key) {
    final timestamp = _cacheTimestamps[key];
    if (timestamp == null) return null;
    
    final age = DateTime.now().difference(timestamp).inMinutes;
    if (age > _cacheExpiryMinutes) {
      _memoryCache.remove(key);
      _cacheTimestamps.remove(key);
      return null;
    }
    
    return _memoryCache[key] as T?;
  }

  void clearCache() {
    _memoryCache.clear();
    _cacheTimestamps.clear();
  }

  /// Offline storage methods
  Future<void> saveMessageOffline(Map<String, dynamic> message) async {
    if (_localDb == null) return;
    
    try {
      await _localDb!.insert(
        'messages',
        {
          'id': message['id'],
          'chat_room_id': message['chatRoomId'],
          'sender_id': message['senderId'],
          'content': message['content'],
          'type': message['type'],
          'timestamp': message['timestamp']?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
          'is_sent': _isOnline ? 1 : 0,
          'data': jsonEncode(message),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      await logError('Failed to save message offline', e);
    }
  }

  Future<List<Map<String, dynamic>>> getOfflineMessages(String chatRoomId) async {
    if (_localDb == null) return [];
    
    try {
      final result = await _localDb!.query(
        'messages',
        where: 'chat_room_id = ?',
        whereArgs: [chatRoomId],
        orderBy: 'timestamp ASC',
      );
      
      return result.map((row) {
        final data = jsonDecode(row['data'] as String) as Map<String, dynamic>;
        data['isOffline'] = row['is_sent'] == 0;
        return data;
      }).toList();
    } catch (e) {
      await logError('Failed to get offline messages', e);
      return [];
    }
  }

  /// Sync pending operations when back online
  Future<void> _syncPendingOperations() async {
    if (_localDb == null || !_isOnline) return;
    
    try {
      final pendingOps = await _localDb!.query('sync_queue', orderBy: 'created_at ASC');
      
      for (final op in pendingOps) {
        try {
          final data = jsonDecode(op['data'] as String) as Map<String, dynamic>;
          final operationType = op['operation_type'] as String;
          
          // Process based on operation type
          switch (operationType) {
            case 'send_message':
              await _syncMessage(data);
              break;
            case 'upload_media':
              await _syncMediaUpload(data);
              break;
            // Add more sync operations as needed
          }
          
          // Remove from queue after successful sync
          await _localDb!.delete('sync_queue', where: 'id = ?', whereArgs: [op['id']]);
          
        } catch (e) {
          // Increment retry count
          final retryCount = (op['retry_count'] as int) + 1;
          if (retryCount > 3) {
            // Max retries reached, remove from queue
            await _localDb!.delete('sync_queue', where: 'id = ?', whereArgs: [op['id']]);
          } else {
            await _localDb!.update(
              'sync_queue',
              {'retry_count': retryCount},
              where: 'id = ?',
              whereArgs: [op['id']],
            );
          }
        }
      }
    } catch (e) {
      await logError('Failed to sync pending operations', e);
    }
  }

  Future<void> _syncMessage(Map<String, dynamic> data) async {
    // Implementation for syncing messages
  }

  Future<void> _syncMediaUpload(Map<String, dynamic> data) async {
    // Implementation for syncing media uploads
  }

  /// Analytics methods
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
    } catch (e) {
      if (kDebugMode) {
        print('Analytics error: $e');
      }
    }
  }

  Future<void> setUserProperty(String name, String value) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
    } catch (e) {
      if (kDebugMode) {
        print('Analytics error: $e');
      }
    }
  }

  Future<void> logScreen(String screenName, {String? screenClass}) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Analytics error: $e');
      }
    }
  }

  /// Error logging and crash reporting
  Future<void> logError(String message, dynamic error, {StackTrace? stackTrace}) async {
    try {
      // Log to crashlytics
      await _crashlytics.recordError(
        error,
        stackTrace,
        reason: message,
        fatal: false,
      );
      
      // Log to analytics
      await logEvent('error_occurred', parameters: {
        'error_message': message,
        'error_type': error.runtimeType.toString(),
      });
      
      if (kDebugMode) {
        print('Error: $message - $error');
        if (stackTrace != null) {
          print('Stack trace: $stackTrace');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to log error: $e');
      }
    }
  }

  Future<void> logCrash(dynamic error, StackTrace stackTrace, {String? reason}) async {
    try {
      await _crashlytics.recordError(
        error,
        stackTrace,
        reason: reason,
        fatal: true,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Failed to log crash: $e');
      }
    }
  }

  /// Performance monitoring
  Future<void> startTrace(String traceName) async {
    try {
      final trace = _analytics.startTrace(traceName);
      // Store trace reference for later stopping
    } catch (e) {
      if (kDebugMode) {
        print('Failed to start trace: $e');
      }
    }
  }

  /// Accessibility helpers
  Map<String, String> getAccessibilityLabels() {
    return {
      'send_message': 'Send meddelelse',
      'attach_file': 'Legg ved fil',
      'record_voice': 'Ta opp stemmemelding',
      'take_photo': 'Ta bilde',
      'open_gallery': 'Åpne galleri',
      'back_button': 'Gå tilbake',
      'menu_button': 'Meny',
      'settings_button': 'Innstillinger',
      'search_button': 'Søk',
      'profile_button': 'Profil',
    };
  }

  /// Memory optimization
  void optimizeMemory() {
    // Clear old cache entries
    final now = DateTime.now();
    final expiredKeys = <String>[];
    
    for (final entry in _cacheTimestamps.entries) {
      if (now.difference(entry.value).inMinutes > _cacheExpiryMinutes) {
        expiredKeys.add(entry.key);
      }
    }
    
    for (final key in expiredKeys) {
      _memoryCache.remove(key);
      _cacheTimestamps.remove(key);
    }
    
    // Force garbage collection in debug mode
    if (kDebugMode) {
      // System.gc() equivalent not available in Dart
    }
  }

  /// App lifecycle management
  void onAppPaused() {
    optimizeMemory();
    logEvent('app_paused');
  }

  void onAppResumed() {
    // Check connectivity
    _connectivity.checkConnectivity().then(_onConnectivityChanged);
    logEvent('app_resumed');
  }

  /// Cleanup resources
  Future<void> dispose() async {
    await _localDb?.close();
    clearCache();
  }
}

// Helper function for JSON encoding/decoding
import 'dart:convert';

extension MapExtensions on Map<String, dynamic> {
  String toJsonString() => jsonEncode(this);
}

extension StringExtensions on String {
  Map<String, dynamic> fromJsonString() => jsonDecode(this);
}
