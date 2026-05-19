class SessionResultModel {
  final String id;
  final String mode;
  final String status;
  final String licenseType;
  final DateTime startedAt;
  final String? submittedAt;
  final int totalQuestions;
  final int answeredQuestions;
  final int correctCount;
  final int incorrectCount;
  final int scorePercentage;
  final bool passed;
  final int? timeLimitMinutes;
  final int? timeTakenSeconds;
  final ResultSummary summary;
  final PerformanceBreakdown performanceBreakdown;

  SessionResultModel({
    required this.id,
    required this.mode,
    required this.status,
    required this.licenseType,
    required this.startedAt,
    this.submittedAt,
    required this.totalQuestions,
    required this.answeredQuestions,
    required this.correctCount,
    required this.incorrectCount,
    required this.scorePercentage,
    required this.passed,
    this.timeLimitMinutes,
    this.timeTakenSeconds,
    required this.summary,
    required this.performanceBreakdown,
  });

  factory SessionResultModel.fromJson(Map<String, dynamic> json) {
    return SessionResultModel(
      id: json['id'] ?? '',
      mode: json['mode'] ?? '',
      status: json['status'] ?? '',
      licenseType: json['license_type'] ?? '',
      startedAt: DateTime.parse(json['started_at']),
      submittedAt: json['submitted_at'],
      totalQuestions: (json['total_questions'] ?? 0).toInt(),
      answeredQuestions: (json['answered_questions'] ?? 0).toInt(),
      correctCount: (json['correct_count'] ?? 0).toInt(),
      incorrectCount: (json['incorrect_count'] ?? 0).toInt(),
      scorePercentage: (json['score_percentage'] ?? 0).toInt(),
      passed: json['passed'] ?? false,
      timeLimitMinutes: json['time_limit_minutes'] != null ? (json['time_limit_minutes']).toInt() : null,
      timeTakenSeconds: json['time_taken_seconds'] != null ? (json['time_taken_seconds']).toInt() : null,
      summary: ResultSummary.fromJson(json['summary']),
      performanceBreakdown:
          PerformanceBreakdown.fromJson(json['performance_breakdown']),
    );
  }
}

class ResultSummary {
  final int totalQuestions;
  final int answeredQuestions;
  final int correctCount;
  final int incorrectCount;
  final int scorePercentage;
  final bool passed;
  final String? nclexStatus;
  final int? timeTakenSeconds;
  final int? timeLimitMinutes;

  ResultSummary({
    required this.totalQuestions,
    required this.answeredQuestions,
    required this.correctCount,
    required this.incorrectCount,
    required this.scorePercentage,
    required this.passed,
    this.nclexStatus,
    this.timeTakenSeconds,
    this.timeLimitMinutes,
  });

  factory ResultSummary.fromJson(Map<String, dynamic> json) {
    return ResultSummary(
      totalQuestions: (json['total_questions'] ?? 0).toInt(),
      answeredQuestions: (json['answered_questions'] ?? 0).toInt(),
      correctCount: (json['correct_count'] ?? 0).toInt(),
      incorrectCount: (json['incorrect_count'] ?? 0).toInt(),
      scorePercentage: (json['score_percentage'] ?? 0).toInt(),
      passed: json['passed'] ?? false,
      nclexStatus: json['nclex_status'],
      timeTakenSeconds: json['time_taken_seconds'] != null ? (json['time_taken_seconds']).toInt() : null,
      timeLimitMinutes: json['time_limit_minutes'] != null ? (json['time_limit_minutes']).toInt() : null,
    );
  }
}

class PerformanceBreakdown {
  final String title;
  final String subtitle;
  final BreakdownTabs tabs;
  final List<ReviewItem> reviewItems;
  final List<CategorySummaryItem> categorySummary;

  PerformanceBreakdown({
    required this.title,
    required this.subtitle,
    required this.tabs,
    required this.reviewItems,
    required this.categorySummary,
  });

  factory PerformanceBreakdown.fromJson(Map<String, dynamic> json) {
    return PerformanceBreakdown(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      tabs: BreakdownTabs.fromJson(json['tabs'] ?? {}),
      reviewItems: (json['review_items'] as List? ?? [])
          .map((e) => ReviewItem.fromJson(e))
          .toList(),
      categorySummary: (json['category_summary'] as List? ?? [])
          .map((e) => CategorySummaryItem.fromJson(e))
          .toList(),
    );
  }
}

class BreakdownTabs {
  final String defaultTab;
  final TabInfo all;
  final TabInfo correct;
  final TabInfo incorrect;

  BreakdownTabs({
    required this.defaultTab,
    required this.all,
    required this.correct,
    required this.incorrect,
  });

  factory BreakdownTabs.fromJson(Map<String, dynamic> json) {
    return BreakdownTabs(
      defaultTab: json['default'] ?? 'all',
      all: TabInfo.fromJson(json['all'] ?? {}),
      correct: TabInfo.fromJson(json['correct'] ?? {}),
      incorrect: TabInfo.fromJson(json['incorrect'] ?? {}),
    );
  }
}

class TabInfo {
  final String label;
  final String value;
  final int count;

  TabInfo({required this.label, required this.value, required this.count});

  factory TabInfo.fromJson(Map<String, dynamic> json) {
    return TabInfo(
      label: json['label'] ?? '',
      value: json['value'] ?? '',
      count: (json['count'] ?? 0).toInt(),
    );
  }
}

class ReviewItem {
  final String sessionQuestionId;
  final String questionId;
  final int questionNumber;
  final String cardTitle;
  final String categoryLabel;
  final String topicLabel;
  final String reviewStatus;
  final bool isCorrect;
  final bool isExpandable;
  final String questionPrompt;
  final AnswerReview answerReview;

  ReviewItem({
    required this.sessionQuestionId,
    required this.questionId,
    required this.questionNumber,
    required this.cardTitle,
    required this.categoryLabel,
    required this.topicLabel,
    required this.reviewStatus,
    required this.isCorrect,
    required this.isExpandable,
    required this.questionPrompt,
    required this.answerReview,
  });

  factory ReviewItem.fromJson(Map<String, dynamic> json) {
    return ReviewItem(
      sessionQuestionId: json['session_question_id'] ?? '',
      questionId: json['question_id'] ?? '',
      questionNumber: (json['question_number'] ?? 0).toInt(),
      cardTitle: json['card_title'] ?? '',
      categoryLabel: json['category_label'] ?? '',
      topicLabel: json['topic_label'] ?? '',
      reviewStatus: json['review_status'] ?? '',
      isCorrect: json['is_correct'] ?? false,
      isExpandable: json['is_expandable'] ?? false,
      questionPrompt: json['question_prompt'] ?? '',
      answerReview: AnswerReview.fromJson(json['answer_review'] ?? {}),
    );
  }
}

class AnswerReview {
  final AnswerSelection yourSelection;
  final AnswerSelection correctAnswer;
  final AnswerRationale rationale;

  AnswerReview({
    required this.yourSelection,
    required this.correctAnswer,
    required this.rationale,
  });

  factory AnswerReview.fromJson(Map<String, dynamic> json) {
    return AnswerReview(
      yourSelection:
          AnswerSelection.fromJson(json['your_selection'] ?? {}),
      correctAnswer:
          AnswerSelection.fromJson(json['correct_answer'] ?? {}),
      rationale: AnswerRationale.fromJson(json['rationale'] ?? {}),
    );
  }
}

class AnswerSelection {
  final String title;
  final bool isAnswered;
  final String state;
  final List<AnswerOption> options;
  final String text;

  AnswerSelection({
    required this.title,
    this.isAnswered = true,
    required this.state,
    required this.options,
    required this.text,
  });

  factory AnswerSelection.fromJson(Map<String, dynamic> json) {
    return AnswerSelection(
      title: json['title'] ?? '',
      isAnswered: json['is_answered'] ?? true,
      state: json['state'] ?? '',
      options: (json['options'] as List? ?? [])
          .map((e) => AnswerOption.fromJson(e))
          .toList(),
      text: json['text'] ?? '',
    );
  }
}

class AnswerOption {
  final String optionKey;
  final String optionText;

  AnswerOption({required this.optionKey, required this.optionText});

  factory AnswerOption.fromJson(Map<String, dynamic> json) {
    return AnswerOption(
      optionKey: json['option_key'] ?? '',
      optionText: json['option_text'] ?? '',
    );
  }
}

class AnswerRationale {
  final String title;
  final String text;

  AnswerRationale({required this.title, required this.text});

  factory AnswerRationale.fromJson(Map<String, dynamic> json) {
    return AnswerRationale(
      title: json['title'] ?? '',
      text: json['text'] ?? '',
    );
  }
}

class CategorySummaryItem {
  final String categoryId;
  final String categoryName;
  final int totalQuestions;
  final int correctAnswers;
  final int accuracy;

  CategorySummaryItem({
    required this.categoryId,
    required this.categoryName,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.accuracy,
  });

  factory CategorySummaryItem.fromJson(Map<String, dynamic> json) {
    return CategorySummaryItem(
      categoryId: json['category_id'] ?? '',
      categoryName: json['category_name'] ?? '',
      totalQuestions: (json['total_questions'] ?? 0).toInt(),
      correctAnswers: (json['correct_answers'] ?? 0).toInt(),
      accuracy: (json['accuracy'] ?? 0).toInt(),
    );
  }
}
