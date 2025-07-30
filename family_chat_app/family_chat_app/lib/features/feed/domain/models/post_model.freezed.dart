// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PostModel _$PostModelFromJson(Map<String, dynamic> json) {
  return _PostModel.fromJson(json);
}

/// @nodoc
mixin _$PostModel {
  String get id => throw _privateConstructorUsedError;
  String get authorId => throw _privateConstructorUsedError;
  String get authorName => throw _privateConstructorUsedError;
  String? get authorAvatar => throw _privateConstructorUsedError;
  PostType get type => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  List<String> get imageUrls => throw _privateConstructorUsedError;
  List<String> get likedBy => throw _privateConstructorUsedError;
  int get likeCount => throw _privateConstructorUsedError;
  int get commentCount => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PostModelCopyWith<PostModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostModelCopyWith<$Res> {
  factory $PostModelCopyWith(PostModel value, $Res Function(PostModel) then) =
      _$PostModelCopyWithImpl<$Res, PostModel>;
  @useResult
  $Res call(
      {String id,
      String authorId,
      String authorName,
      String? authorAvatar,
      PostType type,
      String content,
      List<String> imageUrls,
      List<String> likedBy,
      int likeCount,
      int commentCount,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$PostModelCopyWithImpl<$Res, $Val extends PostModel>
    implements $PostModelCopyWith<$Res> {
  _$PostModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? authorId = null,
    Object? authorName = null,
    Object? authorAvatar = freezed,
    Object? type = null,
    Object? content = null,
    Object? imageUrls = null,
    Object? likedBy = null,
    Object? likeCount = null,
    Object? commentCount = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      authorAvatar: freezed == authorAvatar
          ? _value.authorAvatar
          : authorAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PostType,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrls: null == imageUrls
          ? _value.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      likedBy: null == likedBy
          ? _value.likedBy
          : likedBy // ignore: cast_nullable_to_non_nullable
              as List<String>,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentCount: null == commentCount
          ? _value.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PostModelImplCopyWith<$Res>
    implements $PostModelCopyWith<$Res> {
  factory _$$PostModelImplCopyWith(
          _$PostModelImpl value, $Res Function(_$PostModelImpl) then) =
      __$$PostModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String authorId,
      String authorName,
      String? authorAvatar,
      PostType type,
      String content,
      List<String> imageUrls,
      List<String> likedBy,
      int likeCount,
      int commentCount,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$PostModelImplCopyWithImpl<$Res>
    extends _$PostModelCopyWithImpl<$Res, _$PostModelImpl>
    implements _$$PostModelImplCopyWith<$Res> {
  __$$PostModelImplCopyWithImpl(
      _$PostModelImpl _value, $Res Function(_$PostModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? authorId = null,
    Object? authorName = null,
    Object? authorAvatar = freezed,
    Object? type = null,
    Object? content = null,
    Object? imageUrls = null,
    Object? likedBy = null,
    Object? likeCount = null,
    Object? commentCount = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$PostModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      authorAvatar: freezed == authorAvatar
          ? _value.authorAvatar
          : authorAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PostType,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrls: null == imageUrls
          ? _value._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      likedBy: null == likedBy
          ? _value._likedBy
          : likedBy // ignore: cast_nullable_to_non_nullable
              as List<String>,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentCount: null == commentCount
          ? _value.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PostModelImpl implements _PostModel {
  const _$PostModelImpl(
      {required this.id,
      required this.authorId,
      required this.authorName,
      this.authorAvatar,
      required this.type,
      required this.content,
      required final List<String> imageUrls,
      required final List<String> likedBy,
      required this.likeCount,
      required this.commentCount,
      required this.createdAt,
      required this.updatedAt})
      : _imageUrls = imageUrls,
        _likedBy = likedBy;

  factory _$PostModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostModelImplFromJson(json);

  @override
  final String id;
  @override
  final String authorId;
  @override
  final String authorName;
  @override
  final String? authorAvatar;
  @override
  final PostType type;
  @override
  final String content;
  final List<String> _imageUrls;
  @override
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  final List<String> _likedBy;
  @override
  List<String> get likedBy {
    if (_likedBy is EqualUnmodifiableListView) return _likedBy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_likedBy);
  }

  @override
  final int likeCount;
  @override
  final int commentCount;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'PostModel(id: $id, authorId: $authorId, authorName: $authorName, authorAvatar: $authorAvatar, type: $type, content: $content, imageUrls: $imageUrls, likedBy: $likedBy, likeCount: $likeCount, commentCount: $commentCount, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.authorAvatar, authorAvatar) ||
                other.authorAvatar == authorAvatar) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            const DeepCollectionEquality().equals(other._likedBy, _likedBy) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      authorId,
      authorName,
      authorAvatar,
      type,
      content,
      const DeepCollectionEquality().hash(_imageUrls),
      const DeepCollectionEquality().hash(_likedBy),
      likeCount,
      commentCount,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PostModelImplCopyWith<_$PostModelImpl> get copyWith =>
      __$$PostModelImplCopyWithImpl<_$PostModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostModelImplToJson(
      this,
    );
  }
}

abstract class _PostModel implements PostModel {
  const factory _PostModel(
      {required final String id,
      required final String authorId,
      required final String authorName,
      final String? authorAvatar,
      required final PostType type,
      required final String content,
      required final List<String> imageUrls,
      required final List<String> likedBy,
      required final int likeCount,
      required final int commentCount,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$PostModelImpl;

  factory _PostModel.fromJson(Map<String, dynamic> json) =
      _$PostModelImpl.fromJson;

  @override
  String get id;
  @override
  String get authorId;
  @override
  String get authorName;
  @override
  String? get authorAvatar;
  @override
  PostType get type;
  @override
  String get content;
  @override
  List<String> get imageUrls;
  @override
  List<String> get likedBy;
  @override
  int get likeCount;
  @override
  int get commentCount;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$PostModelImplCopyWith<_$PostModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) {
  return _CommentModel.fromJson(json);
}

/// @nodoc
mixin _$CommentModel {
  String get id => throw _privateConstructorUsedError;
  String get postId => throw _privateConstructorUsedError;
  String get authorId => throw _privateConstructorUsedError;
  String get authorName => throw _privateConstructorUsedError;
  String? get authorAvatar => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String? get parentCommentId => throw _privateConstructorUsedError;
  int get likeCount => throw _privateConstructorUsedError;
  List<String> get likedBy => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CommentModelCopyWith<CommentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentModelCopyWith<$Res> {
  factory $CommentModelCopyWith(
          CommentModel value, $Res Function(CommentModel) then) =
      _$CommentModelCopyWithImpl<$Res, CommentModel>;
  @useResult
  $Res call(
      {String id,
      String postId,
      String authorId,
      String authorName,
      String? authorAvatar,
      String content,
      String? parentCommentId,
      int likeCount,
      List<String> likedBy,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$CommentModelCopyWithImpl<$Res, $Val extends CommentModel>
    implements $CommentModelCopyWith<$Res> {
  _$CommentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? postId = null,
    Object? authorId = null,
    Object? authorName = null,
    Object? authorAvatar = freezed,
    Object? content = null,
    Object? parentCommentId = freezed,
    Object? likeCount = null,
    Object? likedBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      authorAvatar: freezed == authorAvatar
          ? _value.authorAvatar
          : authorAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      parentCommentId: freezed == parentCommentId
          ? _value.parentCommentId
          : parentCommentId // ignore: cast_nullable_to_non_nullable
              as String?,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      likedBy: null == likedBy
          ? _value.likedBy
          : likedBy // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommentModelImplCopyWith<$Res>
    implements $CommentModelCopyWith<$Res> {
  factory _$$CommentModelImplCopyWith(
          _$CommentModelImpl value, $Res Function(_$CommentModelImpl) then) =
      __$$CommentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String postId,
      String authorId,
      String authorName,
      String? authorAvatar,
      String content,
      String? parentCommentId,
      int likeCount,
      List<String> likedBy,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$CommentModelImplCopyWithImpl<$Res>
    extends _$CommentModelCopyWithImpl<$Res, _$CommentModelImpl>
    implements _$$CommentModelImplCopyWith<$Res> {
  __$$CommentModelImplCopyWithImpl(
      _$CommentModelImpl _value, $Res Function(_$CommentModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? postId = null,
    Object? authorId = null,
    Object? authorName = null,
    Object? authorAvatar = freezed,
    Object? content = null,
    Object? parentCommentId = freezed,
    Object? likeCount = null,
    Object? likedBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$CommentModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      authorAvatar: freezed == authorAvatar
          ? _value.authorAvatar
          : authorAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      parentCommentId: freezed == parentCommentId
          ? _value.parentCommentId
          : parentCommentId // ignore: cast_nullable_to_non_nullable
              as String?,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      likedBy: null == likedBy
          ? _value._likedBy
          : likedBy // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommentModelImpl implements _CommentModel {
  const _$CommentModelImpl(
      {required this.id,
      required this.postId,
      required this.authorId,
      required this.authorName,
      this.authorAvatar,
      required this.content,
      this.parentCommentId,
      required this.likeCount,
      required final List<String> likedBy,
      required this.createdAt,
      required this.updatedAt})
      : _likedBy = likedBy;

  factory _$CommentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentModelImplFromJson(json);

  @override
  final String id;
  @override
  final String postId;
  @override
  final String authorId;
  @override
  final String authorName;
  @override
  final String? authorAvatar;
  @override
  final String content;
  @override
  final String? parentCommentId;
  @override
  final int likeCount;
  final List<String> _likedBy;
  @override
  List<String> get likedBy {
    if (_likedBy is EqualUnmodifiableListView) return _likedBy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_likedBy);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'CommentModel(id: $id, postId: $postId, authorId: $authorId, authorName: $authorName, authorAvatar: $authorAvatar, content: $content, parentCommentId: $parentCommentId, likeCount: $likeCount, likedBy: $likedBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.authorAvatar, authorAvatar) ||
                other.authorAvatar == authorAvatar) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.parentCommentId, parentCommentId) ||
                other.parentCommentId == parentCommentId) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            const DeepCollectionEquality().equals(other._likedBy, _likedBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      postId,
      authorId,
      authorName,
      authorAvatar,
      content,
      parentCommentId,
      likeCount,
      const DeepCollectionEquality().hash(_likedBy),
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentModelImplCopyWith<_$CommentModelImpl> get copyWith =>
      __$$CommentModelImplCopyWithImpl<_$CommentModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentModelImplToJson(
      this,
    );
  }
}

abstract class _CommentModel implements CommentModel {
  const factory _CommentModel(
      {required final String id,
      required final String postId,
      required final String authorId,
      required final String authorName,
      final String? authorAvatar,
      required final String content,
      final String? parentCommentId,
      required final int likeCount,
      required final List<String> likedBy,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$CommentModelImpl;

  factory _CommentModel.fromJson(Map<String, dynamic> json) =
      _$CommentModelImpl.fromJson;

  @override
  String get id;
  @override
  String get postId;
  @override
  String get authorId;
  @override
  String get authorName;
  @override
  String? get authorAvatar;
  @override
  String get content;
  @override
  String? get parentCommentId;
  @override
  int get likeCount;
  @override
  List<String> get likedBy;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$CommentModelImplCopyWith<_$CommentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreatePostData _$CreatePostDataFromJson(Map<String, dynamic> json) {
  return _CreatePostData.fromJson(json);
}

/// @nodoc
mixin _$CreatePostData {
  PostType get type => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  List<File> get imageFiles => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreatePostDataCopyWith<CreatePostData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatePostDataCopyWith<$Res> {
  factory $CreatePostDataCopyWith(
          CreatePostData value, $Res Function(CreatePostData) then) =
      _$CreatePostDataCopyWithImpl<$Res, CreatePostData>;
  @useResult
  $Res call({PostType type, String content, List<File> imageFiles});
}

/// @nodoc
class _$CreatePostDataCopyWithImpl<$Res, $Val extends CreatePostData>
    implements $CreatePostDataCopyWith<$Res> {
  _$CreatePostDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? content = null,
    Object? imageFiles = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PostType,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      imageFiles: null == imageFiles
          ? _value.imageFiles
          : imageFiles // ignore: cast_nullable_to_non_nullable
              as List<File>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreatePostDataImplCopyWith<$Res>
    implements $CreatePostDataCopyWith<$Res> {
  factory _$$CreatePostDataImplCopyWith(_$CreatePostDataImpl value,
          $Res Function(_$CreatePostDataImpl) then) =
      __$$CreatePostDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({PostType type, String content, List<File> imageFiles});
}

/// @nodoc
class __$$CreatePostDataImplCopyWithImpl<$Res>
    extends _$CreatePostDataCopyWithImpl<$Res, _$CreatePostDataImpl>
    implements _$$CreatePostDataImplCopyWith<$Res> {
  __$$CreatePostDataImplCopyWithImpl(
      _$CreatePostDataImpl _value, $Res Function(_$CreatePostDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? content = null,
    Object? imageFiles = null,
  }) {
    return _then(_$CreatePostDataImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_nullable
              as PostType,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      imageFiles: null == imageFiles
          ? _value._imageFiles
          : imageFiles // ignore: cast_nullable_to_non_nullable
              as List<File>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreatePostDataImpl implements _CreatePostData {
  const _$CreatePostDataImpl(
      {required this.type,
      required this.content,
      required final List<File> imageFiles})
      : _imageFiles = imageFiles;

  factory _$CreatePostDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreatePostDataImplFromJson(json);

  @override
  final PostType type;
  @override
  final String content;
  final List<File> _imageFiles;
  @override
  List<File> get imageFiles {
    if (_imageFiles is EqualUnmodifiableListView) return _imageFiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageFiles);
  }

  @override
  String toString() {
    return 'CreatePostData(type: $type, content: $content, imageFiles: $imageFiles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatePostDataImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality()
                .equals(other._imageFiles, _imageFiles));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type, content,
      const DeepCollectionEquality().hash(_imageFiles));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatePostDataImplCopyWith<_$CreatePostDataImpl> get copyWith =>
      __$$CreatePostDataImplCopyWithImpl<_$CreatePostDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreatePostDataImplToJson(
      this,
    );
  }
}

abstract class _CreatePostData implements CreatePostData {
  const factory _CreatePostData(
      {required final PostType type,
      required final String content,
      required final List<File> imageFiles}) = _$CreatePostDataImpl;

  factory _CreatePostData.fromJson(Map<String, dynamic> json) =
      _$CreatePostDataImpl.fromJson;

  @override
  PostType get type;
  @override
  String get content;
  @override
  List<File> get imageFiles;
  @override
  @JsonKey(ignore: true)
  _$$CreatePostDataImplCopyWith<_$CreatePostDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostModelImpl _$$PostModelImplFromJson(Map<String, dynamic> json) =>
    _$PostModelImpl(
      id: json['id'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      authorAvatar: json['authorAvatar'] as String?,
      type: $enumDecode(_$PostTypeEnumMap, json['type']),
      content: json['content'] as String,
      imageUrls: (json['imageUrls'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      likedBy:
          (json['likedBy'] as List<dynamic>).map((e) => e as String).toList(),
      likeCount: json['likeCount'] as int,
      commentCount: json['commentCount'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$PostModelImplToJson(_$PostModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'authorAvatar': instance.authorAvatar,
      'type': _$PostTypeEnumMap[instance.type]!,
      'content': instance.content,
      'imageUrls': instance.imageUrls,
      'likedBy': instance.likedBy,
      'likeCount': instance.likeCount,
      'commentCount': instance.commentCount,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$PostTypeEnumMap = {
  PostType.text: 'text',
  PostType.photo: 'photo',
  PostType.video: 'video',
  PostType.event: 'event',
};

_$CommentModelImpl _$$CommentModelImplFromJson(Map<String, dynamic> json) =>
    _$CommentModelImpl(
      id: json['id'] as String,
      postId: json['postId'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      authorAvatar: json['authorAvatar'] as String?,
      content: json['content'] as String,
      parentCommentId: json['parentCommentId'] as String?,
      likeCount: json['likeCount'] as int,
      likedBy:
          (json['likedBy'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$CommentModelImplToJson(_$CommentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'postId': instance.postId,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'authorAvatar': instance.authorAvatar,
      'content': instance.content,
      'parentCommentId': instance.parentCommentId,
      'likeCount': instance.likeCount,
      'likedBy': instance.likedBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$CreatePostDataImpl _$$CreatePostDataImplFromJson(Map<String, dynamic> json) =>
    _$CreatePostDataImpl(
      type: $enumDecode(_$PostTypeEnumMap, json['type']),
      content: json['content'] as String,
      imageFiles: (json['imageFiles'] as List<dynamic>)
          .map((e) => File(e as String))
          .toList(),
    );

Map<String, dynamic> _$$CreatePostDataImplToJson(
        _$CreatePostDataImpl instance) =>
    <String, dynamic>{
      'type': _$PostTypeEnumMap[instance.type]!,
      'content': instance.content,
      'imageFiles': instance.imageFiles.map((e) => e.path).toList(),
    };
