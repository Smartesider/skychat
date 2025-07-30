import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    String? profileImageUrl,
    String? phoneNumber,
    DateTime? dateOfBirth,
    @Default(UserRole.member) UserRole role,
    @Default(UserStatus.active) UserStatus status,
    String? familyId,
    @Default([]) List<String> groupIds,
    DateTime? createdAt,
    DateTime? lastSeen,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}

enum UserRole {
  @JsonValue('admin')
  admin,
  @JsonValue('member')
  member,
  @JsonValue('child')
  child,
}

enum UserStatus {
  @JsonValue('active')
  active,
  @JsonValue('memorial')
  memorial,
  @JsonValue('suspended')
  suspended,
}
