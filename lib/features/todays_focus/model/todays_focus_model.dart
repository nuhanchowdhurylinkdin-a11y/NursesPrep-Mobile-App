class TodaysFocusModel {
  final ExamReadiness examReadiness;
  final DailyQuestionGoal dailyQuestionGoal;
  final List<WeakCategoryItem> weakCategories;
  final SmartRecommendation? smartRecommendation;

  TodaysFocusModel({
    required this.examReadiness,
    required this.dailyQuestionGoal,
    required this.weakCategories,
    this.smartRecommendation,
  });

  factory TodaysFocusModel.fromJson(Map<String, dynamic> json) {
    return TodaysFocusModel(
      examReadiness: ExamReadiness.fromJson(json['exam_readiness'] ?? {}),
      dailyQuestionGoal:
          DailyQuestionGoal.fromJson(json['daily_question_goal'] ?? {}),
      weakCategories: (json['weak_categories'] as List?)
              ?.map((e) => WeakCategoryItem.fromJson(e))
              .toList() ??
          [],
      smartRecommendation: json['smart_recommendation'] != null
          ? SmartRecommendation.fromJson(json['smart_recommendation'])
          : null,
    );
  }
}

class ExamReadiness {
  final double percentage;
  final double changePercentage;
  final int basedOnQuestions;

  ExamReadiness({
    required this.percentage,
    required this.changePercentage,
    required this.basedOnQuestions,
  });

  factory ExamReadiness.fromJson(Map<String, dynamic> json) {
    return ExamReadiness(
      percentage: (json['percentage'] ?? 0).toDouble(),
      changePercentage: (json['change_percentage'] ?? 0).toDouble(),
      basedOnQuestions: json['based_on_questions'] ?? 0,
    );
  }
}

class DailyQuestionGoal {
  final int answeredQuestions;
  final int targetQuestions;
  final int completionPercentage;
  final int remainingQuestions;
  final String message;

  DailyQuestionGoal({
    required this.answeredQuestions,
    required this.targetQuestions,
    required this.completionPercentage,
    required this.remainingQuestions,
    required this.message,
  });

  factory DailyQuestionGoal.fromJson(Map<String, dynamic> json) {
    return DailyQuestionGoal(
      answeredQuestions: json['answered_questions'] ?? 0,
      targetQuestions: json['target_questions'] ?? 50,
      completionPercentage: json['completion_percentage'] ?? 0,
      remainingQuestions: json['remaining_questions'] ?? 0,
      message: json['message'] ?? '',
    );
  }
}

class WeakCategoryItem {
  final String categoryId;
  final String categoryName;
  final int facedQuestions;
  final int correctAnswers;
  final String? lastActiveAt;
  final double accuracyRate;
  final String priority;
  final String statusText;
  final int lastActiveDays;

  WeakCategoryItem({
    required this.categoryId,
    required this.categoryName,
    required this.facedQuestions,
    required this.correctAnswers,
    this.lastActiveAt,
    required this.accuracyRate,
    required this.priority,
    required this.statusText,
    required this.lastActiveDays,
  });

  factory WeakCategoryItem.fromJson(Map<String, dynamic> json) {
    return WeakCategoryItem(
      categoryId: json['category_id'] ?? '',
      categoryName: json['category_name'] ?? '',
      facedQuestions: json['faced_questions'] ?? 0,
      correctAnswers: json['correct_answers'] ?? 0,
      lastActiveAt: json['last_active_at'],
      accuracyRate: (json['accuracy_rate'] ?? 0).toDouble(),
      priority: json['priority'] ?? '',
      statusText: json['status_text'] ?? '',
      lastActiveDays: json['last_active_days'] ?? 0,
    );
  }
}

class SmartRecommendation {
  final String title;
  final String description;
  final int questionCount;
  final RecommendationAction? action;

  SmartRecommendation({
    required this.title,
    required this.description,
    required this.questionCount,
    this.action,
  });

  factory SmartRecommendation.fromJson(Map<String, dynamic> json) {
    return SmartRecommendation(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      questionCount: json['question_count'] ?? 20,
      action: json['action'] != null
          ? RecommendationAction.fromJson(json['action'])
          : null,
    );
  }
}

class RecommendationAction {
  final String mode;
  final String? categoryId;
  final String? topicId;
  final int questionCount;
  final bool randomize;

  RecommendationAction({
    required this.mode,
    this.categoryId,
    this.topicId,
    required this.questionCount,
    required this.randomize,
  });

  factory RecommendationAction.fromJson(Map<String, dynamic> json) {
    return RecommendationAction(
      mode: json['mode'] ?? 'practice',
      categoryId: json['category_id'],
      topicId: json['topic_id'],
      questionCount: json['question_count'] ?? 20,
      randomize: json['randomize'] ?? true,
    );
  }
}
