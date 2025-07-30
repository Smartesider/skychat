import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_models.freezed.dart';
part 'dashboard_models.g.dart';

@freezed
class DashboardWidget with _$DashboardWidget {
  const factory DashboardWidget({
    required String id,
    required String title,
    required DashboardWidgetType type,
    required Map<String, dynamic> data,
    @Default(true) bool isEnabled,
    @Default(0) int position,
  }) = _DashboardWidget;

  factory DashboardWidget.fromJson(Map<String, dynamic> json) => 
      _$DashboardWidgetFromJson(json);
}

enum DashboardWidgetType {
  @JsonValue('quick_post')
  quickPost,
  @JsonValue('recent_photos')
  recentPhotos,
  @JsonValue('family_activity')
  familyActivity,
  @JsonValue('quick_chat')
  quickChat,
  @JsonValue('upcoming_birthdays')
  upcomingBirthdays,
  @JsonValue('weather')
  weather,
  @JsonValue('countdown')
  countdown,
  @JsonValue('on_this_day')
  onThisDay,
}

@freezed
class QuickAction with _$QuickAction {
  const factory QuickAction({
    required String id,
    required String title,
    required String icon,
    required String color,
    required String route,
    @Default(true) bool isEnabled,
  }) = _QuickAction;

  factory QuickAction.fromJson(Map<String, dynamic> json) => 
      _$QuickActionFromJson(json);
}

@freezed
class FamilyActivity with _$FamilyActivity {
  const factory FamilyActivity({
    required String id,
    required String userId,
    required String userName,
    required String userAvatar,
    required String action,
    required String description,
    required DateTime timestamp,
    String? imageUrl,
  }) = _FamilyActivity;

  factory FamilyActivity.fromJson(Map<String, dynamic> json) => 
      _$FamilyActivityFromJson(json);
}
