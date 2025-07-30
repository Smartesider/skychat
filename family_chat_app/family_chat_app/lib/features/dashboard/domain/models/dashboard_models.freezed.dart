// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DashboardWidget _$DashboardWidgetFromJson(Map<String, dynamic> json) {
  return _DashboardWidget.fromJson(json);
}

/// @nodoc
mixin _$DashboardWidget {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  WidgetType get type => throw _privateConstructorUsedError;
  Map<String, dynamic> get data => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DashboardWidgetCopyWith<DashboardWidget> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardWidgetCopyWith<$Res> {
  factory $DashboardWidgetCopyWith(
          DashboardWidget value, $Res Function(DashboardWidget) then) =
      _$DashboardWidgetCopyWithImpl<$Res, DashboardWidget>;
  @useResult
  $Res call(
      {String id,
      String title,
      WidgetType type,
      Map<String, dynamic> data,
      DateTime lastUpdated});
}

/// @nodoc
class _$DashboardWidgetCopyWithImpl<$Res, $Val extends DashboardWidget>
    implements $DashboardWidgetCopyWith<$Res> {
  _$DashboardWidgetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? type = null,
    Object? data = null,
    Object? lastUpdated = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as WidgetType,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DashboardWidgetImplCopyWith<$Res>
    implements $DashboardWidgetCopyWith<$Res> {
  factory _$$DashboardWidgetImplCopyWith(_$DashboardWidgetImpl value,
          $Res Function(_$DashboardWidgetImpl) then) =
      __$$DashboardWidgetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      WidgetType type,
      Map<String, dynamic> data,
      DateTime lastUpdated});
}

/// @nodoc
class __$$DashboardWidgetImplCopyWithImpl<$Res>
    extends _$DashboardWidgetCopyWithImpl<$Res, _$DashboardWidgetImpl>
    implements _$$DashboardWidgetImplCopyWith<$Res> {
  __$$DashboardWidgetImplCopyWithImpl(
      _$DashboardWidgetImpl _value, $Res Function(_$DashboardWidgetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? type = null,
    Object? data = null,
    Object? lastUpdated = null,
  }) {
    return _then(_$DashboardWidgetImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as WidgetType,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardWidgetImpl implements _DashboardWidget {
  const _$DashboardWidgetImpl(
      {required this.id,
      required this.title,
      required this.type,
      required final Map<String, dynamic> data,
      required this.lastUpdated})
      : _data = data;

  factory _$DashboardWidgetImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardWidgetImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final WidgetType type;
  final Map<String, dynamic> _data;
  @override
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'DashboardWidget(id: $id, title: $title, type: $type, data: $data, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardWidgetImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, type,
      const DeepCollectionEquality().hash(_data), lastUpdated);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardWidgetImplCopyWith<_$DashboardWidgetImpl> get copyWith =>
      __$$DashboardWidgetImplCopyWithImpl<_$DashboardWidgetImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardWidgetImplToJson(
      this,
    );
  }
}

abstract class _DashboardWidget implements DashboardWidget {
  const factory _DashboardWidget(
      {required final String id,
      required final String title,
      required final WidgetType type,
      required final Map<String, dynamic> data,
      required final DateTime lastUpdated}) = _$DashboardWidgetImpl;

  factory _DashboardWidget.fromJson(Map<String, dynamic> json) =
      _$DashboardWidgetImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  WidgetType get type;
  @override
  Map<String, dynamic> get data;
  @override
  DateTime get lastUpdated;
  @override
  @JsonKey(ignore: true)
  _$$DashboardWidgetImplCopyWith<_$DashboardWidgetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FamilyActivity _$FamilyActivityFromJson(Map<String, dynamic> json) {
  return _FamilyActivity.fromJson(json);
}

/// @nodoc
mixin _$FamilyActivity {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String? get userAvatar => throw _privateConstructorUsedError;
  ActivityType get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FamilyActivityCopyWith<FamilyActivity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FamilyActivityCopyWith<$Res> {
  factory $FamilyActivityCopyWith(
          FamilyActivity value, $Res Function(FamilyActivity) then) =
      _$FamilyActivityCopyWithImpl<$Res, FamilyActivity>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String userName,
      String? userAvatar,
      ActivityType type,
      String title,
      String? description,
      String? imageUrl,
      Map<String, dynamic> metadata,
      DateTime timestamp});
}

/// @nodoc
class _$FamilyActivityCopyWithImpl<$Res, $Val extends FamilyActivity>
    implements $FamilyActivityCopyWith<$Res> {
  _$FamilyActivityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userName = null,
    Object? userAvatar = freezed,
    Object? type = null,
    Object? title = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? metadata = null,
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userAvatar: freezed == userAvatar
          ? _value.userAvatar
          : userAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ActivityType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FamilyActivityImplCopyWith<$Res>
    implements $FamilyActivityCopyWith<$Res> {
  factory _$$FamilyActivityImplCopyWith(_$FamilyActivityImpl value,
          $Res Function(_$FamilyActivityImpl) then) =
      __$$FamilyActivityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String userName,
      String? userAvatar,
      ActivityType type,
      String title,
      String? description,
      String? imageUrl,
      Map<String, dynamic> metadata,
      DateTime timestamp});
}

/// @nodoc
class __$$FamilyActivityImplCopyWithImpl<$Res>
    extends _$FamilyActivityCopyWithImpl<$Res, _$FamilyActivityImpl>
    implements _$$FamilyActivityImplCopyWith<$Res> {
  __$$FamilyActivityImplCopyWithImpl(
      _$FamilyActivityImpl _value, $Res Function(_$FamilyActivityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userName = null,
    Object? userAvatar = freezed,
    Object? type = null,
    Object? title = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? metadata = null,
    Object? timestamp = null,
  }) {
    return _then(_$FamilyActivityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userAvatar: freezed == userAvatar
          ? _value.userAvatar
          : userAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ActivityType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FamilyActivityImpl implements _FamilyActivity {
  const _$FamilyActivityImpl(
      {required this.id,
      required this.userId,
      required this.userName,
      this.userAvatar,
      required this.type,
      required this.title,
      this.description,
      this.imageUrl,
      required final Map<String, dynamic> metadata,
      required this.timestamp})
      : _metadata = metadata;

  factory _$FamilyActivityImpl.fromJson(Map<String, dynamic> json) =>
      _$$FamilyActivityImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String userName;
  @override
  final String? userAvatar;
  @override
  final ActivityType type;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String? imageUrl;
  final Map<String, dynamic> _metadata;
  @override
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'FamilyActivity(id: $id, userId: $userId, userName: $userName, userAvatar: $userAvatar, type: $type, title: $title, description: $description, imageUrl: $imageUrl, metadata: $metadata, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FamilyActivityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userAvatar, userAvatar) ||
                other.userAvatar == userAvatar) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      userName,
      userAvatar,
      type,
      title,
      description,
      imageUrl,
      const DeepCollectionEquality().hash(_metadata),
      timestamp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FamilyActivityImplCopyWith<_$FamilyActivityImpl> get copyWith =>
      __$$FamilyActivityImplCopyWithImpl<_$FamilyActivityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FamilyActivityImplToJson(
      this,
    );
  }
}

abstract class _FamilyActivity implements FamilyActivity {
  const factory _FamilyActivity(
      {required final String id,
      required final String userId,
      required final String userName,
      final String? userAvatar,
      required final ActivityType type,
      required final String title,
      final String? description,
      final String? imageUrl,
      required final Map<String, dynamic> metadata,
      required final DateTime timestamp}) = _$FamilyActivityImpl;

  factory _FamilyActivity.fromJson(Map<String, dynamic> json) =
      _$FamilyActivityImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get userName;
  @override
  String? get userAvatar;
  @override
  ActivityType get type;
  @override
  String get title;
  @override
  String? get description;
  @override
  String? get imageUrl;
  @override
  Map<String, dynamic> get metadata;
  @override
  DateTime get timestamp;
  @override
  @JsonKey(ignore: true)
  _$$FamilyActivityImplCopyWith<_$FamilyActivityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardWidgetImpl _$$DashboardWidgetImplFromJson(
        Map<String, dynamic> json) =>
    _$DashboardWidgetImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      type: $enumDecode(_$WidgetTypeEnumMap, json['type']),
      data: json['data'] as Map<String, dynamic>,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$DashboardWidgetImplToJson(
        _$DashboardWidgetImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': _$WidgetTypeEnumMap[instance.type]!,
      'data': instance.data,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

const _$WidgetTypeEnumMap = {
  WidgetType.quickActions: 'quickActions',
  WidgetType.familyActivity: 'familyActivity',
  WidgetType.upcomingEvents: 'upcomingEvents',
  WidgetType.recentPhotos: 'recentPhotos',
  WidgetType.weatherWidget: 'weatherWidget',
  WidgetType.taskList: 'taskList',
};

_$FamilyActivityImpl _$$FamilyActivityImplFromJson(Map<String, dynamic> json) =>
    _$FamilyActivityImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String?,
      type: $enumDecode(_$ActivityTypeEnumMap, json['type']),
      title: json['title'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$FamilyActivityImplToJson(
        _$FamilyActivityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'userAvatar': instance.userAvatar,
      'type': _$ActivityTypeEnumMap[instance.type]!,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'metadata': instance.metadata,
      'timestamp': instance.timestamp.toIso8601String(),
    };

const _$ActivityTypeEnumMap = {
  ActivityType.post: 'post',
  ActivityType.photo: 'photo',
  ActivityType.comment: 'comment',
  ActivityType.like: 'like',
  ActivityType.event: 'event',
  ActivityType.message: 'message',
  ActivityType.task: 'task',
  ActivityType.achievement: 'achievement',
};
