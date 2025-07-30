// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatRoomModel _$ChatRoomModelFromJson(Map<String, dynamic> json) {
  return _ChatRoomModel.fromJson(json);
}

/// @nodoc
mixin _$ChatRoomModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  ChatRoomType get type => throw _privateConstructorUsedError;
  List<String> get participants => throw _privateConstructorUsedError;
  List<String> get admins => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  MessageModel? get lastMessage => throw _privateConstructorUsedError;
  int get unreadCount => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  Map<String, dynamic> get settings => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatRoomModelCopyWith<ChatRoomModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatRoomModelCopyWith<$Res> {
  factory $ChatRoomModelCopyWith(
          ChatRoomModel value, $Res Function(ChatRoomModel) then) =
      _$ChatRoomModelCopyWithImpl<$Res, ChatRoomModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      ChatRoomType type,
      List<String> participants,
      List<String> admins,
      String createdBy,
      DateTime createdAt,
      DateTime updatedAt,
      MessageModel? lastMessage,
      int unreadCount,
      String? avatarUrl,
      Map<String, dynamic> settings});

  $MessageModelCopyWith<$Res>? get lastMessage;
}

/// @nodoc
class _$ChatRoomModelCopyWithImpl<$Res, $Val extends ChatRoomModel>
    implements $ChatRoomModelCopyWith<$Res> {
  _$ChatRoomModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? type = null,
    Object? participants = null,
    Object? admins = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastMessage = freezed,
    Object? unreadCount = null,
    Object? avatarUrl = freezed,
    Object? settings = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ChatRoomType,
      participants: null == participants
          ? _value.participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<String>,
      admins: null == admins
          ? _value.admins
          : admins // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as MessageModel?,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $MessageModelCopyWith<$Res>? get lastMessage {
    if (_value.lastMessage == null) {
      return null;
    }

    return $MessageModelCopyWith<$Res>(_value.lastMessage!, (value) {
      return _then(_value.copyWith(lastMessage: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChatRoomModelImplCopyWith<$Res>
    implements $ChatRoomModelCopyWith<$Res> {
  factory _$$ChatRoomModelImplCopyWith(
          _$ChatRoomModelImpl value, $Res Function(_$ChatRoomModelImpl) then) =
      __$$ChatRoomModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      ChatRoomType type,
      List<String> participants,
      List<String> admins,
      String createdBy,
      DateTime createdAt,
      DateTime updatedAt,
      MessageModel? lastMessage,
      int unreadCount,
      String? avatarUrl,
      Map<String, dynamic> settings});

  @override
  $MessageModelCopyWith<$Res>? get lastMessage;
}

/// @nodoc
class __$$ChatRoomModelImplCopyWithImpl<$Res>
    extends _$ChatRoomModelCopyWithImpl<$Res, _$ChatRoomModelImpl>
    implements _$$ChatRoomModelImplCopyWith<$Res> {
  __$$ChatRoomModelImplCopyWithImpl(
      _$ChatRoomModelImpl _value, $Res Function(_$ChatRoomModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? type = null,
    Object? participants = null,
    Object? admins = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastMessage = freezed,
    Object? unreadCount = null,
    Object? avatarUrl = freezed,
    Object? settings = null,
  }) {
    return _then(_$ChatRoomModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ChatRoomType,
      participants: null == participants
          ? _value._participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<String>,
      admins: null == admins
          ? _value._admins
          : admins // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as MessageModel?,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      settings: null == settings
          ? _value._settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatRoomModelImpl implements _ChatRoomModel {
  const _$ChatRoomModelImpl(
      {required this.id,
      required this.name,
      this.description,
      required this.type,
      required final List<String> participants,
      required final List<String> admins,
      required this.createdBy,
      required this.createdAt,
      required this.updatedAt,
      this.lastMessage,
      this.unreadCount = 0,
      this.avatarUrl,
      final Map<String, dynamic> settings = const {}})
      : _participants = participants,
        _admins = admins,
        _settings = settings;

  factory _$ChatRoomModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatRoomModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final ChatRoomType type;
  final List<String> _participants;
  @override
  List<String> get participants {
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participants);
  }

  final List<String> _admins;
  @override
  List<String> get admins {
    if (_admins is EqualUnmodifiableListView) return _admins;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_admins);
  }

  @override
  final String createdBy;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final MessageModel? lastMessage;
  @override
  @JsonKey()
  final int unreadCount;
  @override
  final String? avatarUrl;
  final Map<String, dynamic> _settings;
  @override
  @JsonKey()
  Map<String, dynamic> get settings {
    if (_settings is EqualUnmodifiableMapView) return _settings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_settings);
  }

  @override
  String toString() {
    return 'ChatRoomModel(id: $id, name: $name, description: $description, type: $type, participants: $participants, admins: $admins, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, lastMessage: $lastMessage, unreadCount: $unreadCount, avatarUrl: $avatarUrl, settings: $settings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatRoomModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other._participants, _participants) &&
            const DeepCollectionEquality().equals(other._admins, _admins) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            const DeepCollectionEquality().equals(other._settings, _settings));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      type,
      const DeepCollectionEquality().hash(_participants),
      const DeepCollectionEquality().hash(_admins),
      createdBy,
      createdAt,
      updatedAt,
      lastMessage,
      unreadCount,
      avatarUrl,
      const DeepCollectionEquality().hash(_settings));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatRoomModelImplCopyWith<_$ChatRoomModelImpl> get copyWith =>
      __$$ChatRoomModelImplCopyWithImpl<_$ChatRoomModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatRoomModelImplToJson(
      this,
    );
  }
}

abstract class _ChatRoomModel implements ChatRoomModel {
  const factory _ChatRoomModel(
      {required final String id,
      required final String name,
      final String? description,
      required final ChatRoomType type,
      required final List<String> participants,
      required final List<String> admins,
      required final String createdBy,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final Map<String, dynamic> settings}) = _$ChatRoomModelImpl;

  factory _ChatRoomModel.fromJson(Map<String, dynamic> json) =
      _$ChatRoomModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  ChatRoomType get type;
  @override
  List<String> get participants;
  @override
  List<String> get admins;
  @override
  String get createdBy;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  MessageModel? get lastMessage;
  @override
  int get unreadCount;
  @override
  String? get avatarUrl;
  @override
  Map<String, dynamic> get settings;
  @override
  @JsonKey(ignore: true)
  _$$ChatRoomModelImplCopyWith<_$ChatRoomModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) {
  return _MessageModel.fromJson(json);
}

/// @nodoc
mixin _$MessageModel {
  String get id => throw _privateConstructorUsedError;
  String get chatRoomId => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String get senderName => throw _privateConstructorUsedError;
  String? get senderAvatarUrl => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  MessageType get type => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  bool get isEdited => throw _privateConstructorUsedError;
  String? get replyToMessageId => throw _privateConstructorUsedError;
  MessageModel? get replyToMessage => throw _privateConstructorUsedError;
  Map<String, int> get reactions => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get voiceNoteUrl => throw _privateConstructorUsedError;
  int? get voiceNoteDuration => throw _privateConstructorUsedError;
  String? get fileUrl => throw _privateConstructorUsedError;
  String? get fileName => throw _privateConstructorUsedError;
  int? get fileSize => throw _privateConstructorUsedError;
  List<String> get readBy => throw _privateConstructorUsedError;
  Map<String, DateTime> get readReceipts => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessageModelCopyWith<MessageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageModelCopyWith<$Res> {
  factory $MessageModelCopyWith(
          MessageModel value, $Res Function(MessageModel) then) =
      _$MessageModelCopyWithImpl<$Res, MessageModel>;
  @useResult
  $Res call(
      {String id,
      String chatRoomId,
      String senderId,
      String senderName,
      String? senderAvatarUrl,
      String content,
      MessageType type,
      DateTime createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
      bool isEdited,
      String? replyToMessageId,
      MessageModel? replyToMessage,
      Map<String, int> reactions,
      String? imageUrl,
      String? voiceNoteUrl,
      int? voiceNoteDuration,
      String? fileUrl,
      String? fileName,
      int? fileSize,
      List<String> readBy,
      Map<String, DateTime> readReceipts});

  $MessageModelCopyWith<$Res>? get replyToMessage;
}

/// @nodoc
class _$MessageModelCopyWithImpl<$Res, $Val extends MessageModel>
    implements $MessageModelCopyWith<$Res> {
  _$MessageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chatRoomId = null,
    Object? senderId = null,
    Object? senderName = null,
    Object? senderAvatarUrl = freezed,
    Object? content = null,
    Object? type = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? isEdited = null,
    Object? replyToMessageId = freezed,
    Object? replyToMessage = freezed,
    Object? reactions = null,
    Object? imageUrl = freezed,
    Object? voiceNoteUrl = freezed,
    Object? voiceNoteDuration = freezed,
    Object? fileUrl = freezed,
    Object? fileName = freezed,
    Object? fileSize = freezed,
    Object? readBy = null,
    Object? readReceipts = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      chatRoomId: null == chatRoomId
          ? _value.chatRoomId
          : chatRoomId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      senderName: null == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String,
      senderAvatarUrl: freezed == senderAvatarUrl
          ? _value.senderAvatarUrl
          : senderAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MessageType,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isEdited: null == isEdited
          ? _value.isEdited
          : isEdited // ignore: cast_nullable_to_non_nullable
              as bool,
      replyToMessageId: freezed == replyToMessageId
          ? _value.replyToMessageId
          : replyToMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
      replyToMessage: freezed == replyToMessage
          ? _value.replyToMessage
          : replyToMessage // ignore: cast_nullable_to_non_nullable
              as MessageModel?,
      reactions: null == reactions
          ? _value.reactions
          : reactions // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      voiceNoteUrl: freezed == voiceNoteUrl
          ? _value.voiceNoteUrl
          : voiceNoteUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      voiceNoteDuration: freezed == voiceNoteDuration
          ? _value.voiceNoteDuration
          : voiceNoteDuration // ignore: cast_nullable_to_non_nullable
              as int?,
      fileUrl: freezed == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      fileName: freezed == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String?,
      fileSize: freezed == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int?,
      readBy: null == readBy
          ? _value.readBy
          : readBy // ignore: cast_nullable_to_non_nullable
              as List<String>,
      readReceipts: null == readReceipts
          ? _value.readReceipts
          : readReceipts // ignore: cast_nullable_to_non_nullable
              as Map<String, DateTime>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $MessageModelCopyWith<$Res>? get replyToMessage {
    if (_value.replyToMessage == null) {
      return null;
    }

    return $MessageModelCopyWith<$Res>(_value.replyToMessage!, (value) {
      return _then(_value.copyWith(replyToMessage: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MessageModelImplCopyWith<$Res>
    implements $MessageModelCopyWith<$Res> {
  factory _$$MessageModelImplCopyWith(
          _$MessageModelImpl value, $Res Function(_$MessageModelImpl) then) =
      __$$MessageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String chatRoomId,
      String senderId,
      String senderName,
      String? senderAvatarUrl,
      String content,
      MessageType type,
      DateTime createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
      bool isEdited,
      String? replyToMessageId,
      MessageModel? replyToMessage,
      Map<String, int> reactions,
      String? imageUrl,
      String? voiceNoteUrl,
      int? voiceNoteDuration,
      String? fileUrl,
      String? fileName,
      int? fileSize,
      List<String> readBy,
      Map<String, DateTime> readReceipts});

  @override
  $MessageModelCopyWith<$Res>? get replyToMessage;
}

/// @nodoc
class __$$MessageModelImplCopyWithImpl<$Res>
    extends _$MessageModelCopyWithImpl<$Res, _$MessageModelImpl>
    implements _$$MessageModelImplCopyWith<$Res> {
  __$$MessageModelImplCopyWithImpl(
      _$MessageModelImpl _value, $Res Function(_$MessageModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chatRoomId = null,
    Object? senderId = null,
    Object? senderName = null,
    Object? senderAvatarUrl = freezed,
    Object? content = null,
    Object? type = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? isEdited = null,
    Object? replyToMessageId = freezed,
    Object? replyToMessage = freezed,
    Object? reactions = null,
    Object? imageUrl = freezed,
    Object? voiceNoteUrl = freezed,
    Object? voiceNoteDuration = freezed,
    Object? fileUrl = freezed,
    Object? fileName = freezed,
    Object? fileSize = freezed,
    Object? readBy = null,
    Object? readReceipts = null,
  }) {
    return _then(_$MessageModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      chatRoomId: null == chatRoomId
          ? _value.chatRoomId
          : chatRoomId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      senderName: null == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String,
      senderAvatarUrl: freezed == senderAvatarUrl
          ? _value.senderAvatarUrl
          : senderAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MessageType,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isEdited: null == isEdited
          ? _value.isEdited
          : isEdited // ignore: cast_nullable_to_non_nullable
              as bool,
      replyToMessageId: freezed == replyToMessageId
          ? _value.replyToMessageId
          : replyToMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
      replyToMessage: freezed == replyToMessage
          ? _value.replyToMessage
          : replyToMessage // ignore: cast_nullable_to_non_nullable
              as MessageModel?,
      reactions: null == reactions
          ? _value._reactions
          : reactions // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      voiceNoteUrl: freezed == voiceNoteUrl
          ? _value.voiceNoteUrl
          : voiceNoteUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      voiceNoteDuration: freezed == voiceNoteDuration
          ? _value.voiceNoteDuration
          : voiceNoteDuration // ignore: cast_nullable_to_non_nullable
              as int?,
      fileUrl: freezed == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      fileName: freezed == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String?,
      fileSize: freezed == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int?,
      readBy: null == readBy
          ? _value._readBy
          : readBy // ignore: cast_nullable_to_non_nullable
              as List<String>,
      readReceipts: null == readReceipts
          ? _value._readReceipts
          : readReceipts // ignore: cast_nullable_to_non_nullable
              as Map<String, DateTime>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageModelImpl implements _MessageModel {
  const _$MessageModelImpl(
      {required this.id,
      required this.chatRoomId,
      required this.senderId,
      required this.senderName,
      this.senderAvatarUrl,
      required this.content,
      required this.type,
      required this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.isEdited = false,
      this.replyToMessageId,
      this.replyToMessage,
      final Map<String, int> reactions = const {},
      this.imageUrl,
      this.voiceNoteUrl,
      this.voiceNoteDuration,
      this.fileUrl,
      this.fileName,
      this.fileSize,
      final List<String> readBy = const [],
      final Map<String, DateTime> readReceipts = const {}})
      : _reactions = reactions,
        _readBy = readBy,
        _readReceipts = readReceipts;

  factory _$MessageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageModelImplFromJson(json);

  @override
  final String id;
  @override
  final String chatRoomId;
  @override
  final String senderId;
  @override
  final String senderName;
  @override
  final String? senderAvatarUrl;
  @override
  final String content;
  @override
  final MessageType type;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? deletedAt;
  @override
  @JsonKey()
  final bool isEdited;
  @override
  final String? replyToMessageId;
  @override
  final MessageModel? replyToMessage;
  final Map<String, int> _reactions;
  @override
  @JsonKey()
  Map<String, int> get reactions {
    if (_reactions is EqualUnmodifiableMapView) return _reactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_reactions);
  }

  @override
  final String? imageUrl;
  @override
  final String? voiceNoteUrl;
  @override
  final int? voiceNoteDuration;
  @override
  final String? fileUrl;
  @override
  final String? fileName;
  @override
  final int? fileSize;
  final List<String> _readBy;
  @override
  @JsonKey()
  List<String> get readBy {
    if (_readBy is EqualUnmodifiableListView) return _readBy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_readBy);
  }

  final Map<String, DateTime> _readReceipts;
  @override
  @JsonKey()
  Map<String, DateTime> get readReceipts {
    if (_readReceipts is EqualUnmodifiableMapView) return _readReceipts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_readReceipts);
  }

  @override
  String toString() {
    return 'MessageModel(id: $id, chatRoomId: $chatRoomId, senderId: $senderId, senderName: $senderName, senderAvatarUrl: $senderAvatarUrl, content: $content, type: $type, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, isEdited: $isEdited, replyToMessageId: $replyToMessageId, replyToMessage: $replyToMessage, reactions: $reactions, imageUrl: $imageUrl, voiceNoteUrl: $voiceNoteUrl, voiceNoteDuration: $voiceNoteDuration, fileUrl: $fileUrl, fileName: $fileName, fileSize: $fileSize, readBy: $readBy, readReceipts: $readReceipts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.chatRoomId, chatRoomId) ||
                other.chatRoomId == chatRoomId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.senderAvatarUrl, senderAvatarUrl) ||
                other.senderAvatarUrl == senderAvatarUrl) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.isEdited, isEdited) ||
                other.isEdited == isEdited) &&
            (identical(other.replyToMessageId, replyToMessageId) ||
                other.replyToMessageId == replyToMessageId) &&
            (identical(other.replyToMessage, replyToMessage) ||
                other.replyToMessage == replyToMessage) &&
            const DeepCollectionEquality()
                .equals(other._reactions, _reactions) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.voiceNoteUrl, voiceNoteUrl) ||
                other.voiceNoteUrl == voiceNoteUrl) &&
            (identical(other.voiceNoteDuration, voiceNoteDuration) ||
                other.voiceNoteDuration == voiceNoteDuration) &&
            (identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            const DeepCollectionEquality().equals(other._readBy, _readBy) &&
            const DeepCollectionEquality()
                .equals(other._readReceipts, _readReceipts));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      chatRoomId,
      senderId,
      senderName,
      senderAvatarUrl,
      content,
      type,
      createdAt,
      updatedAt,
      deletedAt,
      isEdited,
      replyToMessageId,
      replyToMessage,
      const DeepCollectionEquality().hash(_reactions),
      imageUrl,
      voiceNoteUrl,
      voiceNoteDuration,
      fileUrl,
      fileName,
      fileSize,
      const DeepCollectionEquality().hash(_readBy),
      const DeepCollectionEquality().hash(_readReceipts));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageModelImplCopyWith<_$MessageModelImpl> get copyWith =>
      __$$MessageModelImplCopyWithImpl<_$MessageModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageModelImplToJson(
      this,
    );
  }
}

abstract class _MessageModel implements MessageModel {
  const factory _MessageModel(
      {required final String id,
      required final String chatRoomId,
      required final String senderId,
      required final String senderName,
      required final String content,
      required final MessageType type,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final DateTime? deletedAt,
      final bool isEdited,
      final String? replyToMessageId,
      final MessageModel? replyToMessage,
      final Map<String, int> reactions,
      final String? voiceNoteUrl,
      final int? voiceNoteDuration}) = _$MessageModelImpl;

  factory _MessageModel.fromJson(Map<String, dynamic> json) =
      _$MessageModelImpl.fromJson;

  @override
  String get id;
  @override
  String get chatRoomId;
  @override
  String get senderId;
  @override
  String get senderName;
  @override
  String? get senderAvatarUrl;
  @override
  String get content;
  @override
  MessageType get type;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  DateTime? get deletedAt;
  @override
  bool get isEdited;
  @override
  String? get replyToMessageId;
  @override
  MessageModel? get replyToMessage;
  @override
  Map<String, int> get reactions;
  @override
  String? get imageUrl;
  @override
  String? get voiceNoteUrl;
  @override
  int? get voiceNoteDuration;
  @override
  String? get fileUrl;
  @override
  String? get fileName;
  @override
  int? get fileSize;
  @override
  List<String> get readBy;
  @override
  Map<String, DateTime> get readReceipts;
  @override
  @JsonKey(ignore: true)
  _$$MessageModelImplCopyWith<_$MessageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
