import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
class PostModel with _$PostModel {
  const factory PostModel({
    required String id,
    required String authorId,
    required String authorName,
    String? authorAvatar,
    required String content,
    required PostType type,
    @Default([]) List<String> imageUrls,
    @Default({}) Map<String, dynamic> metadata,
    @Default([]) List<String> likedBy,
    @Default([]) List<CommentModel> comments,
    required DateTime createdAt,
    DateTime? updatedAt,
    @Default(true) bool isVisible,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);
}

enum PostType {
  @JsonValue('text')
  text,
  @JsonValue('photo')
  photo,
  @JsonValue('event')
  event,
  @JsonValue('poll')
  poll,
  @JsonValue('recipe')
  recipe,
}

@freezed
class CommentModel with _$CommentModel {
  const factory CommentModel({
    required String id,
    required String postId,
    required String authorId,
    required String authorName,
    String? authorAvatar,
    required String content,
    @Default([]) List<String> likedBy,
    required DateTime createdAt,
    String? parentCommentId, // For threaded replies
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) => _$CommentModelFromJson(json);
}

@freezed
class CreatePostData with _$CreatePostData {
  const factory CreatePostData({
    required String content,
    required PostType type,
    @Default([]) List<String> imagePaths,
    @Default({}) Map<String, dynamic> metadata,
  }) = _CreatePostData;
}
