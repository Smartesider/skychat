import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'chat_models.freezed.dart';
part 'chat_models.g.dart';

// Chat Room Model
@freezed
class ChatRoomModel with _$ChatRoomModel {
  const factory ChatRoomModel({
    required String id,
    required String name,
    String? description,
    String? imageUrl,
    required ChatRoomType type,
    required List<String> memberIds,
    required String familyId,
    String? lastMessageId,
    String? lastMessageContent,
    @TimestampConverter() DateTime? lastMessageTime,
    String? lastMessageSenderId,
    required Map<String, int> unreadCounts, // userId -> count
    required bool isActive,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
    String? createdBy,
    Map<String, dynamic>? settings, // Room-specific settings
  }) = _ChatRoomModel;

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomModelFromJson(json);
}

// Message Model
@freezed
class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String id,
    required String chatRoomId,
    required String senderId,
    required String senderName,
    String? senderAvatar,
    required MessageType type,
    required String content,
    List<String>? imageUrls,
    String? voiceNoteUrl,
    int? voiceNoteDuration, // in seconds
    Map<String, dynamic>? metadata, // Additional data for different message types
    String? replyToMessageId,
    MessageModel? replyToMessage, // Populated when fetching
    required Map<String, MessageReaction> reactions, // userId -> reaction
    required MessageStatus status,
    required Map<String, MessageReadStatus> readStatus, // userId -> read info
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() DateTime? updatedAt,
    @TimestampConverter() DateTime? deletedAt,
    bool? isEdited,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}

// Message Read Status
@freezed
class MessageReadStatus with _$MessageReadStatus {
  const factory MessageReadStatus({
    required String userId,
    @TimestampConverter() required DateTime readAt,
    @TimestampConverter() DateTime? deliveredAt,
  }) = _MessageReadStatus;

  factory MessageReadStatus.fromJson(Map<String, dynamic> json) =>
      _$MessageReadStatusFromJson(json);
}

// Message Reaction
@freezed
class MessageReaction with _$MessageReaction {
  const factory MessageReaction({
    required String userId,
    required String emoji,
    @TimestampConverter() required DateTime createdAt,
  }) = _MessageReaction;

  factory MessageReaction.fromJson(Map<String, dynamic> json) =>
      _$MessageReactionFromJson(json);
}

// Typing Indicator
@freezed
class TypingIndicator with _$TypingIndicator {
  const factory TypingIndicator({
    required String userId,
    required String userName,
    required String chatRoomId,
    @TimestampConverter() required DateTime startedAt,
  }) = _TypingIndicator;

  factory TypingIndicator.fromJson(Map<String, dynamic> json) =>
      _$TypingIndicatorFromJson(json);
}

// Create Message Data
@freezed
class CreateMessageData with _$CreateMessageData {
  const factory CreateMessageData({
    required MessageType type,
    required String content,
    List<String>? imageUrls,
    String? voiceNoteUrl,
    int? voiceNoteDuration,
    String? replyToMessageId,
    Map<String, dynamic>? metadata,
  }) = _CreateMessageData;

  factory CreateMessageData.fromJson(Map<String, dynamic> json) =>
      _$CreateMessageDataFromJson(json);
}

// Enums
enum ChatRoomType {
  @JsonValue('family')
  family,
  @JsonValue('private')
  private,
  @JsonValue('group')
  group,
}

enum MessageType {
  @JsonValue('text')
  text,
  @JsonValue('image')
  image,
  @JsonValue('voice')
  voice,
  @JsonValue('system')
  system,
  @JsonValue('emoji')
  emoji,
}

enum MessageStatus {
  @JsonValue('sending')
  sending,
  @JsonValue('sent')
  sent,
  @JsonValue('delivered')
  delivered,
  @JsonValue('read')
  read,
  @JsonValue('failed')
  failed,
}

// Timestamp converter for Firestore
class TimestampConverter implements JsonConverter<DateTime?, dynamic> {
  const TimestampConverter();

  @override
  DateTime? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is Timestamp) return json.toDate();
    if (json is String) return DateTime.parse(json);
    if (json is int) return DateTime.fromMillisecondsSinceEpoch(json);
    return null;
  }

  @override
  dynamic toJson(DateTime? dateTime) {
    if (dateTime == null) return null;
    return Timestamp.fromDate(dateTime);
  }
}
