class PracticeSessionModel {
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
  final bool? passed;
  final int? timeLimitMinutes;
  final int? timeTakenSeconds;
  final dynamic exam;
  final SessionFilters filters;
  final List<SessionQuestion> questions;

  PracticeSessionModel({
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
    this.passed,
    this.timeLimitMinutes,
    this.timeTakenSeconds,
    this.exam,
    required this.filters,
    required this.questions,
  });

  factory PracticeSessionModel.fromJson(Map<String, dynamic> json) {
    return PracticeSessionModel(
      id: json['id'] ?? '',
      mode: json['mode'] ?? '',
      status: json['status'] ?? '',
      licenseType: json['license_type'] ?? '',
      startedAt: DateTime.parse(json['started_at']),
      submittedAt: json['submitted_at'],
      totalQuestions: json['total_questions'] ?? 0,
      answeredQuestions: json['answered_questions'] ?? 0,
      correctCount: json['correct_count'] ?? 0,
      incorrectCount: json['incorrect_count'] ?? 0,
      scorePercentage: json['score_percentage'] ?? 0,
      passed: json['passed'],
      timeLimitMinutes: json['time_limit_minutes'],
      timeTakenSeconds: json['time_taken_seconds'],
      exam: json['exam'],
      filters: SessionFilters.fromJson(json['filters']),
      questions: (json['questions'] as List)
          .map((q) => SessionQuestion.fromJson(q))
          .toList(),
    );
  }
}

class SessionFilters {
  final String licenseType;
  final FilterItem category;
  final FilterItem topic;
  final FilterItem difficulty;

  SessionFilters({
    required this.licenseType,
    required this.category,
    required this.topic,
    required this.difficulty,
  });

  factory SessionFilters.fromJson(Map<String, dynamic> json) {
    return SessionFilters(
      licenseType: json['license_type'] ?? '',
      category: json['category'] != null
          ? FilterItem.fromJson(json['category'])
          : FilterItem(id: '', name: ''),
      topic: json['topic'] != null
          ? FilterItem.fromJson(json['topic'])
          : FilterItem(id: '', name: ''),
      difficulty: json['difficulty'] != null
          ? FilterItem.fromJson(json['difficulty'])
          : FilterItem(id: '', name: ''),
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

class SessionQuestion {
  final String sessionQuestionId;
  final String questionId;
  final int questionNumber;
  final String questionPrompt;
  final String questionType;
  final FilterItem category;
  final FilterItem topic;
  final FilterItem difficulty;
  final List<QuestionOption> options;
  final String? explanationMain;
  final Map<String, String> rationales;
  final List<String> selectedAnswers;
  final bool? isCorrect;

  SessionQuestion({
    required this.sessionQuestionId,
    required this.questionId,
    required this.questionNumber,
    required this.questionPrompt,
    required this.questionType,
    required this.category,
    required this.topic,
    required this.difficulty,
    required this.options,
    this.explanationMain,
    required this.rationales,
    required this.selectedAnswers,
    this.isCorrect,
  });

  bool get isMultipleChoice => questionType == 'multiple_choice';

  /// Get rationale for a specific option key (A, B, C, D)
  String? getRationale(String key) {
    return rationales['option_${key.toLowerCase()}'];
  }

  factory SessionQuestion.fromJson(Map<String, dynamic> json) {
    return SessionQuestion(
      sessionQuestionId: json['session_question_id'] ?? '',
      questionId: json['question_id'] ?? '',
      questionNumber: json['question_number'] ?? 0,
      questionPrompt: json['question_prompt'] ?? '',
      questionType: json['question_type'] ?? 'single_choice',
      category: FilterItem.fromJson(json['category']),
      topic: FilterItem.fromJson(json['topic']),
      difficulty: FilterItem.fromJson(json['difficulty']),
      options: (json['options'] as List)
          .map((o) => QuestionOption.fromJson(o))
          .toList(),
      explanationMain: json['explanation_main'],
      rationales: json['rationales'] != null
          ? Map<String, String>.from(json['rationales'])
          : {},
      selectedAnswers: List<String>.from(
          json['selected_answers']?.map((x) => x.toString()) ?? []),
      isCorrect: json['is_correct'],
    );
  }
}

class QuestionOption {
  final String key;
  final String text;

  QuestionOption({required this.key, required this.text});

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      key: json['key'] ?? '',
      text: json['text'] ?? '',
    );
  }
}
