class DashboardModel {
  final WelcomeData welcome;
  final PerformanceSummary performanceSummary;
  final DailyProgress dailyProgress;

  DashboardModel({
    required this.welcome,
    required this.performanceSummary,
    required this.dailyProgress,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      welcome: WelcomeData.fromJson(json['welcome']),
      performanceSummary:
          PerformanceSummary.fromJson(json['performance_summary']),
      dailyProgress: DailyProgress.fromJson(json['daily_progress']),
    );
  }
}

class WelcomeData {
  final String fullName;
  final String licenseType;

  WelcomeData({
    required this.fullName,
    required this.licenseType,
  });

  factory WelcomeData.fromJson(Map<String, dynamic> json) {
    return WelcomeData(
      fullName: json['full_name'] ?? '',
      licenseType: json['license_type'] ?? '',
    );
  }
}

class LicenseType {
  final String id;
  final String licenseName;
  final String createdAt;

  LicenseType({
    required this.id,
    required this.licenseName,
    required this.createdAt,
  });

  factory LicenseType.fromJson(Map<String, dynamic> json) {
    return LicenseType(
      id: json['id'] ?? '',
      licenseName: json['license_name'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}

class PerformanceSummary {
  final double accuracy;
  final int examsTotal;
  final FocusNeeded? focusNeeded;

  PerformanceSummary({
    required this.accuracy,
    required this.examsTotal,
    this.focusNeeded,
  });

  factory PerformanceSummary.fromJson(Map<String, dynamic> json) {
    return PerformanceSummary(
      accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0.0,
      examsTotal: (json['exams_total'] as num?)?.toInt() ?? 0,
      focusNeeded: json['focus_needed'] != null
          ? FocusNeeded.fromJson(json['focus_needed'])
          : null,
    );
  }
}

class FocusNeeded {
  final String title;
  final int averageScore;

  FocusNeeded({
    required this.title,
    required this.averageScore,
  });

  factory FocusNeeded.fromJson(Map<String, dynamic> json) {
    return FocusNeeded(
      title: json['title'] ?? '',
      averageScore: (json['average_score'] as num?)?.toInt() ?? 0,
    );
  }
}

class DailyProgress {
  final int answeredQuestions;
  final int targetQuestions;
  final int completionPercentage;

  DailyProgress({
    required this.answeredQuestions,
    required this.targetQuestions,
    required this.completionPercentage,
  });

  factory DailyProgress.fromJson(Map<String, dynamic> json) {
    return DailyProgress(
      answeredQuestions: (json['answered_questions'] as num?)?.toInt() ?? 0,
      targetQuestions: (json['target_questions'] as num?)?.toInt() ?? 50,
      completionPercentage: (json['completion_percentage'] as num?)?.round() ?? 0,
    );
  }
}
