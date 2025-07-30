import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_models.freezed.dart';
part 'media_models.g.dart';

enum MediaType {
  photo,
  video,
  document,
}

enum AlbumType {
  family,
  event,
  trip,
  holiday,
  milestone,
}

@freezed
class MediaItemModel with _$MediaItemModel {
  const factory MediaItemModel({
    required String id,
    required String uploadedBy,
    required String uploaderName,
    String? uploaderAvatarUrl,
    required String fileName,
    required String fileUrl,
    String? thumbnailUrl,
    required MediaType type,
    required int fileSize,
    required DateTime uploadedAt,
    DateTime? takenAt,
    String? caption,
    String? location,
    double? latitude,
    double? longitude,
    @Default([]) List<String> taggedUsers,
    @Default({}) Map<String, String> metadata, // EXIF data, etc.
    int? width,
    int? height,
    int? duration, // for videos in seconds
    @Default([]) List<String> albumIds,
    @Default(0) int likesCount,
    @Default([]) List<String> likedBy,
    @Default([]) List<CommentModel> comments,
  }) = _MediaItemModel;

  factory MediaItemModel.fromJson(Map<String, dynamic> json) =>
      _$MediaItemModelFromJson(json);
}

@freezed
class AlbumModel with _$AlbumModel {
  const factory AlbumModel({
    required String id,
    required String name,
    String? description,
    required String createdBy,
    required String creatorName,
    required DateTime createdAt,
    DateTime? updatedAt,
    required AlbumType type,
    @Default([]) List<String> collaborators,
    @Default([]) List<String> mediaItems,
    String? coverPhotoUrl,
    String? coverPhotoId,
    @Default(true) bool isCollaborative,
    @Default(true) bool isVisible,
    @Default({}) Map<String, dynamic> settings,
    DateTime? startDate, // for event albums
    DateTime? endDate,
    String? location,
    @Default([]) List<String> tags,
  }) = _AlbumModel;

  factory AlbumModel.fromJson(Map<String, dynamic> json) =>
      _$AlbumModelFromJson(json);
}

@freezed
class TimelineEventModel with _$TimelineEventModel {
  const factory TimelineEventModel({
    required String id,
    required String title,
    String? description,
    required DateTime date,
    required String createdBy,
    required String creatorName,
    @Default([]) List<String> mediaItems,
    @Default([]) List<String> participants,
    String? location,
    String? coverPhotoUrl,
    @Default([]) List<String> tags,
    @Default({}) Map<String, dynamic> metadata,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _TimelineEventModel;

  factory TimelineEventModel.fromJson(Map<String, dynamic> json) =>
      _$TimelineEventModelFromJson(json);
}

@freezed
class CommentModel with _$CommentModel {
  const factory CommentModel({
    required String id,
    required String authorId,
    required String authorName,
    String? authorAvatarUrl,
    required String content,
    required DateTime createdAt,
    DateTime? updatedAt,
    @Default([]) List<String> likes,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);
}

@freezed
class MediaUploadProgress with _$MediaUploadProgress {
  const factory MediaUploadProgress({
    required String fileName,
    required double progress, // 0.0 to 1.0
    required int uploadedBytes,
    required int totalBytes,
    String? error,
    bool isCompleted = false,
  }) = _MediaUploadProgress;

  factory MediaUploadProgress.fromJson(Map<String, dynamic> json) =>
      _$MediaUploadProgressFromJson(json);
}
