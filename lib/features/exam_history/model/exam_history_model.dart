class ExamSummary {
  final double averageScore;
  final int totalExams;

  ExamSummary({
    required this.averageScore,
    required this.totalExams,
  });

  factory ExamSummary.fromJson(Map<String, dynamic> json) {
    return ExamSummary(
      averageScore: (json['average_score'] as num?)?.toDouble() ?? 0.0,
      totalExams: json['total_exams'] as int? ?? 0,
    );
  }
}

class ExamHistoryItem {
  final String id;
  final String title;
  final String mode;
  final double scorePercentage;
  final bool passed;
  final String passLabel;
  final int correctCount;
  final int incorrectCount;
  final int totalQuestions;
  final int timeTakenSeconds;
  final String timeSpentLabel;
  final DateTime submittedAt;
  final String? category;
  final String? topic;
  final String examTitle;

  ExamHistoryItem({
    required this.id,
    required this.title,
    required this.mode,
    required this.scorePercentage,
    required this.passed,
    required this.passLabel,
    required this.correctCount,
    required this.incorrectCount,
    required this.totalQuestions,
    required this.timeTakenSeconds,
    required this.timeSpentLabel,
    required this.submittedAt,
    this.category,
    this.topic,
    required this.examTitle,
  });

  factory ExamHistoryItem.fromJson(Map<String, dynamic> json) {
    return ExamHistoryItem(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      mode: json['mode'] as String? ?? '',
      scorePercentage:
          (json['score_percentage'] as num?)?.toDouble() ?? 0.0,
      passed: json['passed'] as bool? ?? false,
      passLabel: json['pass_label'] as String? ?? 'Retake',
      correctCount: json['correct_count'] as int? ?? 0,
      incorrectCount: json['incorrect_count'] as int? ?? 0,
      totalQuestions: json['total_questions'] as int? ?? 0,
      timeTakenSeconds: json['time_taken_seconds'] as int? ?? 0,
      timeSpentLabel: json['time_spent_label'] as String? ?? '0m',
      submittedAt: DateTime.parse(json['submitted_at'] as String),
      category: json['category'] as String?,
      topic: json['topic'] as String?,
      examTitle: json['exam_title'] as String? ?? '',
    );
  }
}

class ExamHistoryMeta {
  final int total;
  final int page;
  final int limit;
  final int lastPage;
  final bool hasNextPage;
  final bool hasPrevPage;

  ExamHistoryMeta({
    required this.total,
    required this.page,
    required this.limit,
    required this.lastPage,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory ExamHistoryMeta.fromJson(Map<String, dynamic> json) {
    return ExamHistoryMeta(
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
      lastPage: json['last_page'] as int? ?? 1,
      hasNextPage: json['has_next_page'] as bool? ?? false,
      hasPrevPage: json['has_prev_page'] as bool? ?? false,
    );
  }
}
