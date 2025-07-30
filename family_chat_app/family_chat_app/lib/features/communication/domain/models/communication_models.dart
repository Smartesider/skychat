import 'package:freezed_annotation/freezed_annotation.dart';

part 'communication_models.freezed.dart';
part 'communication_models.g.dart';

enum CallType {
  voice,
  video,
  screenShare,
}

enum CallStatus {
  initiating,
  ringing,
  connecting,
  connected,
  ended,
  missed,
  declined,
  failed,
}

enum VoiceQuality {
  low,
  medium,
  high,
  lossless,
}

enum TranslationLanguage {
  norwegian,
  english,
  german,
  french,
  spanish,
  swedish,
  danish,
}

enum EncryptionLevel {
  none,
  basic,
  endToEnd,
  military,
}

@freezed
class VoiceMessageModel with _$VoiceMessageModel {
  const factory VoiceMessageModel({
    required String id,
    required String senderId,
    required String senderName,
    required String audioUrl,
    required String fileName,
    required int duration, // Duration in milliseconds
    required int fileSize,
    required VoiceQuality quality,
    @Default([]) List<double> waveformData,
    @Default(false) bool isTranscribed,
    String? transcription,
    String? transcriptionLanguage,
    @Default({}) Map<String, dynamic> metadata,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _VoiceMessageModel;

  factory VoiceMessageModel.fromJson(Map<String, dynamic> json) =>
      _$VoiceMessageModelFromJson(json);
}

@freezed
class CallModel with _$CallModel {
  const factory CallModel({
    required String id,
    required String callerId,
    required String callerName,
    String? callerAvatarUrl,
    required List<String> participants,
    required CallType type,
    required CallStatus status,
    required String roomId,
    DateTime? startedAt,
    DateTime? endedAt,
    int? duration, // Duration in seconds
    @Default(false) bool isRecorded,
    String? recordingUrl,
    @Default({}) Map<String, dynamic> settings,
    @Default({}) Map<String, dynamic> metadata,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _CallModel;

  factory CallModel.fromJson(Map<String, dynamic> json) =>
      _$CallModelFromJson(json);
}

@freezed
class ScreenShareModel with _$ScreenShareModel {
  const factory ScreenShareModel({
    required String id,
    required String sharerId,
    required String sharerName,
    required String sessionId,
    required List<String> viewers,
    @Default(true) bool isActive,
    @Default(false) bool allowViewerControl,
    @Default([]) List<String> controlPermissions,
    @Default({}) Map<String, dynamic> settings,
    required DateTime startedAt,
    DateTime? endedAt,
  }) = _ScreenShareModel;

  factory ScreenShareModel.fromJson(Map<String, dynamic> json) =>
      _$ScreenShareModelFromJson(json);
}

@freezed
class ScheduledMessageModel with _$ScheduledMessageModel {
  const factory ScheduledMessageModel({
    required String id,
    required String senderId,
    required String senderName,
    required String chatRoomId,
    required String content,
    String? messageType,
    @Default({}) Map<String, dynamic> attachments,
    required DateTime scheduledFor,
    @Default(false) bool isSent,
    DateTime? sentAt,
    @Default(false) bool isCancelled,
    DateTime? cancelledAt,
    @Default({}) Map<String, dynamic> metadata,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _ScheduledMessageModel;

  factory ScheduledMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduledMessageModelFromJson(json);
}

@freezed
class TranslationModel with _$TranslationModel {
  const factory TranslationModel({
    required String id,
    required String originalMessageId,
    required String originalText,
    required TranslationLanguage originalLanguage,
    required TranslationLanguage targetLanguage,
    required String translatedText,
    required double confidence,
    required String translationService,
    @Default({}) Map<String, dynamic> metadata,
    required DateTime createdAt,
  }) = _TranslationModel;

  factory TranslationModel.fromJson(Map<String, dynamic> json) =>
      _$TranslationModelFromJson(json);
}

@freezed
class EncryptedMessageModel with _$EncryptedMessageModel {
  const factory EncryptedMessageModel({
    required String id,
    required String senderId,
    required String chatRoomId,
    required String encryptedContent,
    required EncryptionLevel encryptionLevel,
    required String encryptionKey,
    required String initializationVector,
    required String algorithm,
    @Default({}) Map<String, String> recipients, // userId -> encrypted key
    @Default({}) Map<String, dynamic> metadata,
    required DateTime createdAt,
    DateTime? decryptedAt,
  }) = _EncryptedMessageModel;

  factory EncryptedMessageModel.fromJson(Map<String, dynamic> json) =>
      _$EncryptedMessageModelFromJson(json);
}

@freezed
class CommunicationPreferencesModel with _$CommunicationPreferencesModel {
  const factory CommunicationPreferencesModel({
    required String userId,
    @Default(true) bool allowVoiceCalls,
    @Default(true) bool allowVideoCalls,
    @Default(false) bool allowScreenShare,
    @Default(true) bool allowTranslation,
    @Default(TranslationLanguage.norwegian) TranslationLanguage preferredLanguage,
    @Default(VoiceQuality.high) VoiceQuality voiceQuality,
    @Default(EncryptionLevel.endToEnd) EncryptionLevel encryptionLevel,
    @Default(true) bool enableReadReceipts,
    @Default(true) bool enableTypingIndicators,
    @Default(false) bool enableAutoTranslation,
    @Default({}) Map<String, bool> notificationSettings,
    @Default({}) Map<String, dynamic> privacySettings,
    DateTime? updatedAt,
  }) = _CommunicationPreferencesModel;

  factory CommunicationPreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$CommunicationPreferencesModelFromJson(json);
}

@freezed
class WebRTCConfigModel with _$WebRTCConfigModel {
  const factory WebRTCConfigModel({
    required List<String> iceServers,
    @Default({}) Map<String, dynamic> rtcConfiguration,
    @Default({}) Map<String, dynamic> mediaConstraints,
    @Default(30000) int connectionTimeout,
    @Default(5000) int reconnectDelay,
    @Default(3) int maxReconnectAttempts,
    @Default({}) Map<String, dynamic> codecPreferences,
    @Default({}) Map<String, dynamic> bandwidthSettings,
  }) = _WebRTCConfigModel;

  factory WebRTCConfigModel.fromJson(Map<String, dynamic> json) =>
      _$WebRTCConfigModelFromJson(json);
}

@freezed
class CommunicationStatsModel with _$CommunicationStatsModel {
  const factory CommunicationStatsModel({
    required String userId,
    @Default(0) int totalVoiceMessages,
    @Default(0) int totalVoiceCalls,
    @Default(0) int totalVideoCalls,
    @Default(0) int totalScreenShares,
    @Default(0) int totalTranslations,
    @Default(0) int totalScheduledMessages,
    @Default(0) int totalCallMinutes,
    @Default(0) int totalVoiceMinutes,
    @Default({}) Map<String, int> languageUsage,
    @Default({}) Map<String, int> featureUsage,
    DateTime? lastCallAt,
    DateTime? lastVoiceMessageAt,
    DateTime? lastTranslationAt,
    DateTime? updatedAt,
  }) = _CommunicationStatsModel;

  factory CommunicationStatsModel.fromJson(Map<String, dynamic> json) =>
      _$CommunicationStatsModelFromJson(json);
}
