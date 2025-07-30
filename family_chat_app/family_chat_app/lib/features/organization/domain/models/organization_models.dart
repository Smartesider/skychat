import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization_models.freezed.dart';
part 'organization_models.g.dart';

enum TaskStatus {
  pending,
  inProgress,
  completed,
  cancelled,
}

enum TaskPriority {
  low,
  medium,
  high,
  urgent,
}

enum EventType {
  family,
  appointment,
  birthday,
  holiday,
  reminder,
  activity,
}

enum AnnouncementPriority {
  info,
  important,
  urgent,
}

enum DocumentType {
  identity,
  medical,
  financial,
  legal,
  educational,
  insurance,
  other,
}

@freezed
class EventModel with _$EventModel {
  const factory EventModel({
    required String id,
    required String title,
    String? description,
    required DateTime startDate,
    DateTime? endDate,
    String? location,
    required EventType type,
    required String createdBy,
    required String creatorName,
    @Default([]) List<String> participants,
    @Default([]) List<String> reminders, // reminder times in minutes before event
    @Default(true) bool isAllDay,
    String? recurrenceRule, // RRULE format for recurring events
    @Default({}) Map<String, dynamic> metadata,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _EventModel;

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);
}

@freezed
class TaskModel with _$TaskModel {
  const factory TaskModel({
    required String id,
    required String title,
    String? description,
    required TaskStatus status,
    required TaskPriority priority,
    required String createdBy,
    required String creatorName,
    String? assignedTo,
    String? assignedToName,
    DateTime? dueDate,
    @Default([]) List<String> tags,
    @Default([]) List<String> checklist,
    @Default([]) List<String> completedChecklist,
    int? estimatedMinutes,
    DateTime? completedAt,
    String? completedBy,
    @Default(0) int points, // Gamification points for completing task
    @Default({}) Map<String, dynamic> metadata,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);
}

@freezed
class ShoppingItemModel with _$ShoppingItemModel {
  const factory ShoppingItemModel({
    required String id,
    required String name,
    String? description,
    int quantity = 1,
    String? category,
    String? brand,
    double? estimatedPrice,
    @Default(false) bool isCompleted,
    required String addedBy,
    required String addedByName,
    String? completedBy,
    String? completedByName,
    DateTime? completedAt,
    String? notes,
    @Default([]) List<String> tags,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _ShoppingItemModel;

  factory ShoppingItemModel.fromJson(Map<String, dynamic> json) =>
      _$ShoppingItemModelFromJson(json);
}

@freezed
class ShoppingListModel with _$ShoppingListModel {
  const factory ShoppingListModel({
    required String id,
    required String name,
    String? description,
    required String createdBy,
    required String creatorName,
    @Default([]) List<String> collaborators,
    @Default([]) List<ShoppingItemModel> items,
    @Default(false) bool isArchived,
    DateTime? archivedAt,
    @Default({}) Map<String, dynamic> settings,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _ShoppingListModel;

  factory ShoppingListModel.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListModelFromJson(json);
}

@freezed
class DocumentModel with _$DocumentModel {
  const factory DocumentModel({
    required String id,
    required String name,
    String? description,
    required String fileUrl,
    required String fileName,
    required int fileSize,
    required DocumentType type,
    required String uploadedBy,
    required String uploaderName,
    @Default([]) List<String> sharedWith,
    @Default([]) List<String> tags,
    DateTime? expiryDate,
    @Default(false) bool isEncrypted,
    String? thumbnailUrl,
    @Default({}) Map<String, String> metadata,
    required DateTime uploadedAt,
    DateTime? updatedAt,
  }) = _DocumentModel;

  factory DocumentModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentModelFromJson(json);
}

@freezed
class AnnouncementModel with _$AnnouncementModel {
  const factory AnnouncementModel({
    required String id,
    required String title,
    required String content,
    required AnnouncementPriority priority,
    required String createdBy,
    required String creatorName,
    @Default([]) List<String> targetUsers, // empty means all family members
    @Default([]) List<String> readBy,
    DateTime? expiresAt,
    @Default(true) bool isActive,
    @Default({}) Map<String, dynamic> metadata,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _AnnouncementModel;

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementModelFromJson(json);
}

@freezed
class LocationShareModel with _$LocationShareModel {
  const factory LocationShareModel({
    required String id,
    required String userId,
    required String userName,
    String? userAvatarUrl,
    required double latitude,
    required double longitude,
    double? accuracy,
    String? address,
    DateTime? expiresAt,
    @Default(true) bool isActive,
    String? message,
    @Default({}) Map<String, dynamic> metadata,
    required DateTime sharedAt,
    DateTime? updatedAt,
  }) = _LocationShareModel;

  factory LocationShareModel.fromJson(Map<String, dynamic> json) =>
      _$LocationShareModelFromJson(json);
}

@freezed
class FamilyStatsModel with _$FamilyStatsModel {
  const factory FamilyStatsModel({
    required String familyId,
    @Default(0) int totalTasks,
    @Default(0) int completedTasks,
    @Default(0) int totalEvents,
    @Default(0) int upcomingEvents,
    @Default(0) int totalShoppingItems,
    @Default(0) int completedShoppingItems,
    @Default(0) int totalDocuments,
    @Default(0) int totalAnnouncements,
    @Default(0) int activeAnnouncements,
    @Default({}) Map<String, int> tasksByUser,
    @Default({}) Map<String, int> completedTasksByUser,
    @Default({}) Map<String, int> pointsByUser,
    DateTime? lastUpdated,
  }) = _FamilyStatsModel;

  factory FamilyStatsModel.fromJson(Map<String, dynamic> json) =>
      _$FamilyStatsModelFromJson(json);
}
