/// API Keys and Configuration for Advanced Features
/// Norwegian Family Chat App
class ApiKeys {
  // Firebase Configuration (already in firebase_options.dart)
  static const String firebaseProjectId = 'skychat-19b6b';
  static const String firebaseStorageBucket = 'skychat-19b6b.firebasestorage.app';
  
  // Google OAuth Configuration (Trollhagen)
  static const String googleOAuthClientId = '74609337378-lttqsu4bpohj5jkqgvlpjld7e2n32fc6.apps.googleusercontent.com';
  static const String googleOAuthSecret = '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';
  static const String googleApiKey = 'AIzaSyCdu7B2doNwYemNzMX_8LY36YnH0zndcuc';
  static const String googleServiceAccount = '74609337378-compute@developer.gserviceaccount.com';
  
  // Additional API Keys (to be configured later)
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_KEY'; // For location sharing
  static const String googleTranslateApiKey = 'YOUR_TRANSLATE_KEY'; // For message translation
  static const String agoraAppId = 'YOUR_AGORA_APP_ID'; // For video calls (alternative to WebRTC)
  static const String oneSignalAppId = 'YOUR_ONESIGNAL_APP_ID'; // For push notifications (optional)
  
  // Web Push Certificate (from Firebase)
  static const String webPushCertificate = 'BEcQEeXXznP2K3YyhhllHYGTznCLphoUg81KSme1nliLVEI-AiA4iYNAcY15FUTHMXAUfIfLIX1J5aT-kDpMmCQ';
  
  // Environment detection
  static bool get isProduction => const bool.fromEnvironment('dart.vm.product');
  static bool get isDevelopment => !isProduction;
}

/// Norwegian-specific configuration
class NorwegianConfig {
  static const String appName = 'Skychat Familie';
  static const String supportEmail = 'support@skychat.no';
  static const String privacyPolicyUrl = 'https://skychat.no/personvern';
  static const String termsOfServiceUrl = 'https://skychat.no/vilkar';
  
  // Norwegian language settings
  static const String defaultLocale = 'nb_NO';
  static const String timeZone = 'Europe/Oslo';
  static const String currency = 'NOK';
  
  // Family-friendly content settings
  static const int minimumChildAge = 6;
  static const int maximumFamilySize = 50;
  static const int maxDailyMessages = 1000;
}
