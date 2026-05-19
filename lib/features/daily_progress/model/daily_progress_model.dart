class DailyProgressModel {
  final DailyProgressInfo dailyProgress;
  final ActiveSession? activeSession;
  final StreakInfo streak;
  final WeeklyPerformance weeklyPerformance;
  final DailyGoalSettings dailyGoal;

  DailyProgressModel({
    required this.dailyProgress,
    this.activeSession,
    required this.streak,
    required this.weeklyPerformance,
    required this.dailyGoal,
  });

  factory DailyProgressModel.fromJson(Map<String, dynamic> json) {
    return DailyProgressModel(
      dailyProgress:
          DailyProgressInfo.fromJson(json['daily_progress'] ?? {}),
      activeSession: json['active_session'] != null
          ? ActiveSession.fromJson(json['active_session'])
          : null,
      streak: StreakInfo.fromJson(json['streak'] ?? {}),
      weeklyPerformance:
          WeeklyPerformance.fromJson(json['weekly_performance'] ?? {}),
      dailyGoal: DailyGoalSettings.fromJson(json['daily_goal'] ?? {}),
    );
  }
}

class DailyProgressInfo {
  final int answeredQuestions;
  final int targetQuestions;
  final int remainingQuestions;
  final int completionPercentage;
  final String message;

  DailyProgressInfo({
    required this.answeredQuestions,
    required this.targetQuestions,
    required this.remainingQuestions,
    required this.completionPercentage,
    required this.message,
  });

  factory DailyProgressInfo.fromJson(Map<String, dynamic> json) {
    return DailyProgressInfo(
      answeredQuestions: json['answered_questions'] ?? 0,
      targetQuestions: json['target_questions'] ?? 50,
      remainingQuestions: json['remaining_questions'] ?? 0,
      completionPercentage: json['completion_percentage'] ?? 0,
      message: json['message'] ?? '',
    );
  }
}

class ActiveSession {
  final String sessionId;
  final String mode;
  final String status;
  final int answeredQuestions;
  final int totalQuestions;
  final int completionPercentage;
  final String? nextSessionQuestionId;
  final int? nextQuestionNumber;
  final dynamic exam;
  final ActiveSessionFilters? filters;
  final String? startedAt;
  final String? updatedAt;

  ActiveSession({
    required this.sessionId,
    required this.mode,
    required this.status,
    required this.answeredQuestions,
    required this.totalQuestions,
    required this.completionPercentage,
    this.nextSessionQuestionId,
    this.nextQuestionNumber,
    this.exam,
    this.filters,
    this.startedAt,
    this.updatedAt,
  });

  factory ActiveSession.fromJson(Map<String, dynamic> json) {
    return ActiveSession(
      sessionId: json['session_id'] ?? '',
      mode: json['mode'] ?? '',
      status: json['status'] ?? '',
      answeredQuestions: json['answered_questions'] ?? 0,
      totalQuestions: json['total_questions'] ?? 0,
      completionPercentage: json['completion_percentage'] ?? 0,
      nextSessionQuestionId: json['next_session_question_id'],
      nextQuestionNumber: json['next_question_number'],
      exam: json['exam'],
      filters: json['filters'] != null
          ? ActiveSessionFilters.fromJson(json['filters'])
          : null,
      startedAt: json['started_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class ActiveSessionFilters {
  final FilterItem? category;
  final FilterItem? topic;
  final FilterItem? difficulty;

  ActiveSessionFilters({
    this.category,
    this.topic,
    this.difficulty,
  });

  factory ActiveSessionFilters.fromJson(Map<String, dynamic> json) {
    return ActiveSessionFilters(
      category: json['category'] != null
          ? FilterItem.fromJson(json['category'])
          : null,
      topic: json['topic'] != null
          ? FilterItem.fromJson(json['topic'])
          : null,
      difficulty: json['difficulty'] != null
          ? FilterItem.fromJson(json['difficulty'])
          : null,
    );
  }
}

class FilterItem {
  final String id;
  final String name;

  FilterItem({required this.id, required this.name});

  factory FilterItem.fromJson(Map<String, dynamic> json) {
    return FilterItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class StreakInfo {
  final int currentDays;
  final String message;

  StreakInfo({
    required this.currentDays,
    required this.message,
  });

  factory StreakInfo.fromJson(Map<String, dynamic> json) {
    return StreakInfo(
      currentDays: json['current_days'] ?? 0,
      message: json['message'] ?? '',
    );
  }
}

class WeeklyPerformance {
  final int totalAnswered;
  final double changePercentage;
  final List<WeeklySeriesItem> series;

  WeeklyPerformance({
    required this.totalAnswered,
    required this.changePercentage,
    required this.series,
  });

  factory WeeklyPerformance.fromJson(Map<String, dynamic> json) {
    return WeeklyPerformance(
      totalAnswered: json['total_answered'] ?? 0,
      changePercentage: (json['change_percentage'] ?? 0).toDouble(),
      series: (json['series'] as List?)
              ?.map((e) => WeeklySeriesItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class WeeklySeriesItem {
  final String date;
  final String label;
  final int answeredQuestions;

  WeeklySeriesItem({
    required this.date,
    required this.label,
    required this.answeredQuestions,
  });

  factory WeeklySeriesItem.fromJson(Map<String, dynamic> json) {
    return WeeklySeriesItem(
      date: json['date'] ?? '',
      label: json['label'] ?? '',
      answeredQuestions: json['answered_questions'] ?? 0,
    );
  }
}

class DailyGoalSettings {
  final int currentTarget;
  final List<int> allowedOptions;

  DailyGoalSettings({
    required this.currentTarget,
    required this.allowedOptions,
  });

  factory DailyGoalSettings.fromJson(Map<String, dynamic> json) {
    return DailyGoalSettings(
      currentTarget: json['current_target'] ?? 50,
      allowedOptions: (json['allowed_options'] as List?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [10, 25, 50, 100, 150, 200],
    );
  }
}
