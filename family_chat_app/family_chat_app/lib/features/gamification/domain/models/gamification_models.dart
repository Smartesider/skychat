import 'package:freezed_annotation/freezed_annotation.dart';

part 'gamification_models.freezed.dart';
part 'gamification_models.g.dart';

enum ChallengeType {
  individual,
  family,
  pairwise,
  generational,
}

enum ChallengeStatus {
  active,
  completed,
  expired,
  cancelled,
}

enum ChallengeDifficulty {
  easy,
  medium,
  hard,
  expert,
}

enum AchievementCategory {
  communication,
  organization,
  media,
  family,
  creativity,
  learning,
}

enum BadgeType {
  bronze,
  silver,
  gold,
  platinum,
  diamond,
}

enum QuizType {
  multipleChoice,
  trueFalse,
  openEnded,
  pictureGuess,
  timeline,
}

@freezed
class ChallengeModel with _$ChallengeModel {
  const factory ChallengeModel({
    required String id,
    required String title,
    required String description,
    required ChallengeType type,
    required ChallengeStatus status,
    required ChallengeDifficulty difficulty,
    required String createdBy,
    required String creatorName,
    required List<String> participants,
    @Default({}) Map<String, dynamic> rules,
    @Default({}) Map<String, int> progress,
    @Default({}) Map<String, bool> completions,
    required int targetValue,
    required int rewardPoints,
    String? badgeId,
    required DateTime startDate,
    required DateTime endDate,
    @Default([]) List<String> tags,
    @Default({}) Map<String, dynamic> metadata,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _ChallengeModel;

  factory ChallengeModel.fromJson(Map<String, dynamic> json) =>
      _$ChallengeModelFromJson(json);
}

@freezed
class AchievementModel with _$AchievementModel {
  const factory AchievementModel({
    required String id,
    required String title,
    required String description,
    required AchievementCategory category,
    required BadgeType badgeType,
    required String iconUrl,
    required int pointsRequired,
    required int rewardPoints,
    @Default([]) List<String> requirements,
    @Default(false) bool isSecret,
    @Default(false) bool isTimeLimited,
    DateTime? expiresAt,
    @Default({}) Map<String, dynamic> metadata,
    required DateTime createdAt,
  }) = _AchievementModel;

  factory AchievementModel.fromJson(Map<String, dynamic> json) =>
      _$AchievementModelFromJson(json);
}

@freezed
class UserAchievementModel with _$UserAchievementModel {
  const factory UserAchievementModel({
    required String id,
    required String userId,
    required String userName,
    required String achievementId,
    required String achievementTitle,
    required String achievementDescription,
    required AchievementCategory category,
    required BadgeType badgeType,
    required String iconUrl,
    required int pointsEarned,
    required int currentProgress,
    required int totalRequired,
    @Default(false) bool isCompleted,
    DateTime? completedAt,
    @Default({}) Map<String, dynamic> metadata,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _UserAchievementModel;

  factory UserAchievementModel.fromJson(Map<String, dynamic> json) =>
      _$UserAchievementModelFromJson(json);
}

@freezed
class MemoryQuizModel with _$MemoryQuizModel {
  const factory MemoryQuizModel({
    required String id,
    required String title,
    required String description,
    required QuizType type,
    required String createdBy,
    required String creatorName,
    @Default([]) List<QuizQuestionModel> questions,
    @Default([]) List<String> participants,
    @Default({}) Map<String, QuizAttemptModel> attempts,
    required int passingScore,
    required int rewardPoints,
    @Default(true) bool isActive,
    @Default(false) bool isTimeLimited,
    int? timeLimitMinutes,
    @Default([]) List<String> tags,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _MemoryQuizModel;

  factory MemoryQuizModel.fromJson(Map<String, dynamic> json) =>
      _$MemoryQuizModelFromJson(json);
}

@freezed
class QuizQuestionModel with _$QuizQuestionModel {
  const factory QuizQuestionModel({
    required String id,
    required String question,
    required QuizType type,
    @Default([]) List<String> options,
    required String correctAnswer,
    String? imageUrl,
    String? explanation,
    required int points,
    @Default({}) Map<String, dynamic> metadata,
  }) = _QuizQuestionModel;

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionModelFromJson(json);
}

@freezed
class QuizAttemptModel with _$QuizAttemptModel {
  const factory QuizAttemptModel({
    required String id,
    required String userId,
    required String userName,
    required String quizId,
    @Default({}) Map<String, String> answers,
    required int score,
    required int totalPossibleScore,
    required bool isPassed,
    required int timeSpentSeconds,
    @Default({}) Map<String, dynamic> metadata,
    required DateTime completedAt,
  }) = _QuizAttemptModel;

  factory QuizAttemptModel.fromJson(Map<String, dynamic> json) =>
      _$QuizAttemptModelFromJson(json);
}

@freezed
class FamilyStatsModel with _$FamilyStatsModel {
  const factory FamilyStatsModel({
    required String familyId,
    @Default(0) int totalMessages,
    @Default(0) int totalPhotos,
    @Default(0) int totalVideos,
    @Default(0) int totalEvents,
    @Default(0) int totalTasks,
    @Default(0) int completedTasks,
    @Default(0) int totalPoints,
    @Default({}) Map<String, int> memberPoints,
    @Default({}) Map<String, int> memberMessages,
    @Default({}) Map<String, int> memberPhotos,
    @Default({}) Map<String, int> memberAchievements,
    @Default([]) List<String> recentAchievements,
    @Default([]) List<String> activeChallenges,
    DateTime? lastActivityAt,
    required DateTime lastUpdated,
  }) = _FamilyStatsModel;

  factory FamilyStatsModel.fromJson(Map<String, dynamic> json) =>
      _$FamilyStatsModelFromJson(json);
}

@freezed
class GrowthRecordModel with _$GrowthRecordModel {
  const factory GrowthRecordModel({
    required String id,
    required String childId,
    required String childName,
    required String recordedBy,
    required String recorderName,
    double? height,
    double? weight,
    String? milestone,
    String? notes,
    @Default([]) List<String> photoUrls,
    @Default({}) Map<String, dynamic> customMetrics,
    required DateTime recordedAt,
    DateTime? updatedAt,
  }) = _GrowthRecordModel;

  factory GrowthRecordModel.fromJson(Map<String, dynamic> json) =>
      _$GrowthRecordModelFromJson(json);
}

@freezed
class AnniversaryModel with _$AnniversaryModel {
  const factory AnniversaryModel({
    required String id,
    required String title,
    required String description,
    required DateTime originalDate,
    required String createdBy,
    required String creatorName,
    @Default([]) List<String> participants,
    @Default(true) bool isRecurring,
    @Default(true) bool sendReminders,
    @Default([1, 7, 30]) List<int> reminderDays,
    String? imageUrl,
    @Default({}) Map<String, dynamic> customData,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _AnniversaryModel;

  factory AnniversaryModel.fromJson(Map<String, dynamic> json) =>
      _$AnniversaryModelFromJson(json);
}

@freezed
class FamilyGoalModel with _$FamilyGoalModel {
  const factory FamilyGoalModel({
    required String id,
    required String title,
    required String description,
    required String createdBy,
    required String creatorName,
    @Default([]) List<String> participants,
    required int targetValue,
    @Default(0) int currentValue,
    required String unit,
    required DateTime targetDate,
    @Default(false) bool isCompleted,
    DateTime? completedAt,
    required int rewardPoints,
    @Default([]) List<String> milestones,
    @Default({}) Map<String, bool> milestonesCompleted,
    @Default({}) Map<String, dynamic> metadata,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _FamilyGoalModel;

  factory FamilyGoalModel.fromJson(Map<String, dynamic> json) =>
      _$FamilyGoalModelFromJson(json);
}

@freezed
class EngagementInsightModel with _$EngagementInsightModel {
  const factory EngagementInsightModel({
    required String familyId,
    required String period, // 'daily', 'weekly', 'monthly'
    @Default(0) int totalInteractions,
    @Default(0) int messagesPerDay,
    @Default(0) int photosPerWeek,
    @Default(0) int tasksCompletedRate,
    @Default(0) double engagementScore,
    @Default({}) Map<String, double> memberEngagement,
    @Default([]) List<String> recommendations,
    @Default({}) Map<String, dynamic> insights,
    required DateTime periodStart,
    required DateTime periodEnd,
    required DateTime generatedAt,
  }) = _EngagementInsightModel;

  factory EngagementInsightModel.fromJson(Map<String, dynamic> json) =>
      _$EngagementInsightModelFromJson(json);
}
