import 'package:freezed_annotation/freezed_annotation.dart';

part 'security_models.freezed.dart';
part 'security_models.g.dart';

enum AuthFactorType {
  sms,
  email,
  authenticatorApp,
  biometric,
  hardware,
}

enum ContentFilterLevel {
  none,
  basic,
  moderate,
  strict,
  custom,
}

enum PrivacyLevel {
  public,
  family,
  parents,
  private,
}

enum AuditActionType {
  login,
  logout,
  messageCreate,
  messageDelete,
  mediaUpload,
  mediaDelete,
  documentAccess,
  settingsChange,
  userAdd,
  userRemove,
  dataExport,
  accountRecovery,
}

enum DataExportFormat {
  json,
  csv,
  pdf,
  html,
}

enum BackupStatus {
  pending,
  inProgress,
  completed,
  failed,
  expired,
}

@freezed
class TwoFactorAuthModel with _$TwoFactorAuthModel {
  const factory TwoFactorAuthModel({
    required String userId,
    required bool isEnabled,
    required List<AuthFactorType> enabledMethods,
    @Default({}) Map<String, String> methodConfigs,
    @Default([]) List<String> backupCodes,
    @Default([]) List<String> usedBackupCodes,
    required DateTime lastUsedAt,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _TwoFactorAuthModel;

  factory TwoFactorAuthModel.fromJson(Map<String, dynamic> json) =>
      _$TwoFactorAuthModelFromJson(json);
}

@freezed
class ContentModerationModel with _$ContentModerationModel {
  const factory ContentModerationModel({
    required String id,
    required String contentId,
    required String contentType, // 'message', 'media', 'comment'
    required String content,
    required String reportedBy,
    required String reporterName,
    required String reason,
    @Default(false) bool isReviewed,
    @Default(false) bool isViolation,
    @Default(false) bool isRemoved,
    String? reviewedBy,
    String? reviewerName,
    String? moderatorNotes,
    @Default([]) List<String> flaggedWords,
    @Default(0.0) double toxicityScore,
    @Default({}) Map<String, dynamic> analysisResults,
    required DateTime reportedAt,
    DateTime? reviewedAt,
    DateTime? removedAt,
  }) = _ContentModerationModel;

  factory ContentModerationModel.fromJson(Map<String, dynamic> json) =>
      _$ContentModerationModelFromJson(json);
}

@freezed
class PrivacySettingsModel with _$PrivacySettingsModel {
  const factory PrivacySettingsModel({
    required String userId,
    required PrivacyLevel defaultPrivacy,
    @Default(true) bool allowLocationSharing,
    @Default(true) bool allowMessageHistory,
    @Default(true) bool allowMediaSharing,
    @Default(false) bool allowDataCollection,
    @Default(true) bool allowNotifications,
    @Default({}) Map<String, PrivacyLevel> contentPrivacy,
    @Default([]) List<String> blockedUsers,
    @Default([]) List<String> restrictedFeatures,
    @Default({}) Map<String, bool> permissionSettings,
    required DateTime updatedAt,
  }) = _PrivacySettingsModel;

  factory PrivacySettingsModel.fromJson(Map<String, dynamic> json) =>
      _$PrivacySettingsModelFromJson(json);
}

@freezed
class AuditLogModel with _$AuditLogModel {
  const factory AuditLogModel({
    required String id,
    required String userId,
    required String userName,
    required String familyId,
    required AuditActionType action,
    required String description,
    String? targetUserId,
    String? targetUserName,
    String? resourceId,
    String? resourceType,
    @Default({}) Map<String, dynamic> metadata,
    required String ipAddress,
    required String userAgent,
    String? location,
    required DateTime timestamp,
  }) = _AuditLogModel;

  factory AuditLogModel.fromJson(Map<String, dynamic> json) =>
      _$AuditLogModelFromJson(json);
}

@freezed
class DataExportRequestModel with _$DataExportRequestModel {
  const factory DataExportRequestModel({
    required String id,
    required String userId,
    required String userName,
    required String familyId,
    required DataExportFormat format,
    @Default([]) List<String> includedDataTypes,
    @Default(false) bool includeMedia,
    @Default(false) bool includeDeleted,
    DateTime? dateFrom,
    DateTime? dateTo,
    @Default(BackupStatus.pending) BackupStatus status,
    String? downloadUrl,
    String? fileName,
    int? fileSize,
    String? errorMessage,
    DateTime? completedAt,
    DateTime? expiresAt,
    required DateTime requestedAt,
  }) = _DataExportRequestModel;

  factory DataExportRequestModel.fromJson(Map<String, dynamic> json) =>
      _$DataExportRequestModelFromJson(json);
}

@freezed
class EmergencyAccessModel with _$EmergencyAccessModel {
  const factory EmergencyAccessModel({
    required String id,
    required String userId,
    required String userName,
    required String emergencyContactId,
    required String emergencyContactName,
    required String emergencyContactEmail,
    @Default(false) bool isActive,
    @Default(7) int waitingPeriodDays,
    @Default([]) List<String> accessibleData,
    DateTime? requestedAt,
    DateTime? grantedAt,
    DateTime? deniedAt,
    DateTime? expiresAt,
    String? reason,
    @Default({}) Map<String, dynamic> metadata,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _EmergencyAccessModel;

  factory EmergencyAccessModel.fromJson(Map<String, dynamic> json) =>
      _$EmergencyAccessModelFromJson(json);
}

@freezed
class SecurityAlertModel with _$SecurityAlertModel {
  const factory SecurityAlertModel({
    required String id,
    required String userId,
    required String alertType,
    required String title,
    required String description,
    required String severity, // 'low', 'medium', 'high', 'critical'
    @Default(false) bool isResolved,
    @Default(false) bool isRead,
    String? resolvedBy,
    DateTime? resolvedAt,
    @Default({}) Map<String, dynamic> metadata,
    required DateTime createdAt,
  }) = _SecurityAlertModel;

  factory SecurityAlertModel.fromJson(Map<String, dynamic> json) =>
      _$SecurityAlertModelFromJson(json);
}

@freezed
class ParentalControlModel with _$ParentalControlModel {
  const factory ParentalControlModel({
    required String childUserId,
    required String parentUserId,
    required ContentFilterLevel filterLevel,
    @Default(true) bool requireApprovalForContacts,
    @Default(true) bool monitorMessages,
    @Default(false) bool restrictTimeUsage,
    @Default({}) Map<String, String> timeRestrictions, // day -> "startTime-endTime"
    @Default([]) List<String> allowedContacts,
    @Default([]) List<String> blockedWords,
    @Default([]) List<String> allowedDomains,
    @Default(true) bool enableLocationTracking,
    @Default(60) int maxDailyMinutes,
    @Default({}) Map<String, bool> featurePermissions,
    required DateTime updatedAt,
  }) = _ParentalControlModel;

  factory ParentalControlModel.fromJson(Map<String, dynamic> json) =>
      _$ParentalControlModelFromJson(json);
}

@freezed
class DeviceSessionModel with _$DeviceSessionModel {
  const factory DeviceSessionModel({
    required String id,
    required String userId,
    required String deviceId,
    required String deviceName,
    required String deviceType,
    required String platform,
    required String appVersion,
    required String ipAddress,
    String? location,
    required bool isActive,
    required DateTime lastActiveAt,
    required DateTime createdAt,
    DateTime? expiredAt,
  }) = _DeviceSessionModel;

  factory DeviceSessionModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceSessionModelFromJson(json);
}

@freezed
class EncryptionKeyModel with _$EncryptionKeyModel {
  const factory EncryptionKeyModel({
    required String id,
    required String userId,
    required String keyType, // 'messaging', 'media', 'document'
    required String publicKey,
    required String encryptedPrivateKey,
    required String algorithm,
    required int keySize,
    @Default(true) bool isActive,
    required DateTime createdAt,
    DateTime? expiredAt,
    DateTime? revokedAt,
  }) = _EncryptionKeyModel;

  factory EncryptionKeyModel.fromJson(Map<String, dynamic> json) =>
      _$EncryptionKeyModelFromJson(json);
}
