// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatRoomModelImpl _$$ChatRoomModelImplFromJson(Map<String, dynamic> json) =>
    _$ChatRoomModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      type: $enumDecode(_$ChatRoomTypeEnumMap, json['type']),
      participants: (json['participants'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      admins:
          (json['admins'] as List<dynamic>).map((e) => e as String).toList(),
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      lastMessage: json['lastMessage'] == null
          ? null
          : MessageModel.fromJson(json['lastMessage'] as Map<String, dynamic>),
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      avatarUrl: json['avatarUrl'] as String?,
      settings: json['settings'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$ChatRoomModelImplToJson(_$ChatRoomModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'type': _$ChatRoomTypeEnumMap[instance.type]!,
      'participants': instance.participants,
      'admins': instance.admins,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'lastMessage': instance.lastMessage?.toJson(),
      'unreadCount': instance.unreadCount,
      'avatarUrl': instance.avatarUrl,
      'settings': instance.settings,
    };

const _$ChatRoomTypeEnumMap = {
  ChatRoomType.direct: 'direct',
  ChatRoomType.group: 'group',
};

_$MessageModelImpl _$$MessageModelImplFromJson(Map<String, dynamic> json) =>
    _$MessageModelImpl(
      id: json['id'] as String,
      chatRoomId: json['chatRoomId'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      senderAvatarUrl: json['senderAvatarUrl'] as String?,
      content: json['content'] as String,
      type: $enumDecode(_$MessageTypeEnumMap, json['type']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      isEdited: json['isEdited'] as bool? ?? false,
      replyToMessageId: json['replyToMessageId'] as String?,
      replyToMessage: json['replyToMessage'] == null
          ? null
          : MessageModel.fromJson(json['replyToMessage'] as Map<String, dynamic>),
      reactions: (json['reactions'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      imageUrl: json['imageUrl'] as String?,
      voiceNoteUrl: json['voiceNoteUrl'] as String?,
      voiceNoteDuration: (json['voiceNoteDuration'] as num?)?.toInt(),
      fileUrl: json['fileUrl'] as String?,
      fileName: json['fileName'] as String?,
      fileSize: (json['fileSize'] as num?)?.toInt(),
      readBy:
          (json['readBy'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      readReceipts: (json['readReceipts'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, DateTime.parse(e as String)),
          ) ??
          const {},
    );

Map<String, dynamic> _$$MessageModelImplToJson(_$MessageModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chatRoomId': instance.chatRoomId,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'senderAvatarUrl': instance.senderAvatarUrl,
      'content': instance.content,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'isEdited': instance.isEdited,
      'replyToMessageId': instance.replyToMessageId,
      'replyToMessage': instance.replyToMessage?.toJson(),
      'reactions': instance.reactions,
      'imageUrl': instance.imageUrl,
      'voiceNoteUrl': instance.voiceNoteUrl,
      'voiceNoteDuration': instance.voiceNoteDuration,
      'fileUrl': instance.fileUrl,
      'fileName': instance.fileName,
      'fileSize': instance.fileSize,
      'readBy': instance.readBy,
      'readReceipts': instance.readReceipts
          .map((k, e) => MapEntry(k, e.toIso8601String())),
    };

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.image: 'image',
  MessageType.voice: 'voice',
  MessageType.file: 'file',
};
