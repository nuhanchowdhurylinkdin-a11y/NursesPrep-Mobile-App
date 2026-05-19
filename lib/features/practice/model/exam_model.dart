import 'practice_session_model.dart';

class ExamListResponse {
  final List<ExamModel> exams;

  ExamListResponse({required this.exams});

  factory ExamListResponse.fromJson(List<dynamic> json) {
    return ExamListResponse(
      exams: json.map((e) => ExamModel.fromJson(e)).toList(),
    );
  }
}

class ExamModel {
  final String id;
  final String title;
  final String description;
  final String licenseType;
  final ExamCategory category;
  final ExamTopic topic;
  final int totalQuestions;
  final int timeLimit;
  final int passingScore;
  final List<ExamQuestion> questions;

  ExamModel({
    required this.id,
    required this.title,
    required this.description,
    required this.licenseType,
    required this.category,
    required this.topic,
    required this.totalQuestions,
    required this.timeLimit,
    required this.passingScore,
    required this.questions,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      licenseType: json['license_type'] ?? '',
      category: ExamCategory.fromJson(json['category']),
      topic: ExamTopic.fromJson(json['topic']),
      totalQuestions: json['total_questions'] ?? 0,
      timeLimit: json['time_limit'] ?? 0,
      passingScore: json['passing_score'] ?? 0,
      questions: (json['questions'] as List)
          .map((q) => ExamQuestion.fromJson(q))
          .toList(),
    );
  }

  /// Convert to PracticeSessionModel so QuizScreen can reuse it
  PracticeSessionModel toSessionModel() {
    return PracticeSessionModel(
      id: id,
      mode: 'exam',
      status: 'in_progress',
      licenseType: licenseType,
      startedAt: DateTime.now(),
      totalQuestions: totalQuestions,
      answeredQuestions: 0,
      correctCount: 0,
      incorrectCount: 0,
      scorePercentage: 0,
      timeLimitMinutes: timeLimit,
      filters: SessionFilters(
        licenseType: licenseType,
        category: FilterItem(id: category.id, name: category.categoryName),
        topic: FilterItem(id: topic.id, name: topic.topicName),
        difficulty: FilterItem(id: '', name: ''),
      ),
      questions: questions.asMap().entries.map((entry) {
        final i = entry.key;
        final q = entry.value;
        return SessionQuestion(
          sessionQuestionId: q.id,
          questionId: q.questionId,
          questionNumber: i + 1,
          questionPrompt: q.questionText,
          questionType: q.questionType,
          category: FilterItem(id: category.id, name: category.categoryName),
          topic: FilterItem(id: topic.id, name: topic.topicName),
          difficulty: FilterItem(
            id: q.difficulty.id,
            name: q.difficulty.levelName,
          ),
          options: [
            QuestionOption(key: 'A', text: q.optionA),
            QuestionOption(key: 'B', text: q.optionB),
            QuestionOption(key: 'C', text: q.optionC),
            QuestionOption(key: 'D', text: q.optionD),
          ],
          explanationMain: q.explanationMain,
          rationales: {
            'option_a': q.rationaleA,
            'option_b': q.rationaleB,
            'option_c': q.rationaleC,
            'option_d': q.rationaleD,
          },
          selectedAnswers: [],
        );
      }).toList(),
    );
  }
}

class ExamCategory {
  final String id;
  final String categoryName;

  ExamCategory({required this.id, required this.categoryName});

  factory ExamCategory.fromJson(Map<String, dynamic> json) {
    return ExamCategory(
      id: json['id'] ?? '',
      categoryName: json['category_name'] ?? '',
    );
  }
}

class ExamTopic {
  final String id;
  final String topicName;

  ExamTopic({required this.id, required this.topicName});

  factory ExamTopic.fromJson(Map<String, dynamic> json) {
    return ExamTopic(
      id: json['id'] ?? '',
      topicName: json['topic_name'] ?? '',
    );
  }
}

class ExamQuestion {
  final String id;
  final String questionId;
  final ExamDifficulty difficulty;
  final String questionText;
  final String questionType;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final List<String> correctAnswers;
  final String explanationMain;
  final String rationaleA;
  final String rationaleB;
  final String rationaleC;
  final String rationaleD;

  ExamQuestion({
    required this.id,
    required this.questionId,
    required this.difficulty,
    required this.questionText,
    required this.questionType,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctAnswers,
    required this.explanationMain,
    required this.rationaleA,
    required this.rationaleB,
    required this.rationaleC,
    required this.rationaleD,
  });

  factory ExamQuestion.fromJson(Map<String, dynamic> json) {
    return ExamQuestion(
      id: json['id'] ?? '',
      questionId: json['question_id'] ?? '',
      difficulty: ExamDifficulty.fromJson(json['difficulty']),
      questionText: json['question_text'] ?? '',
      questionType: json['question_type'] ?? 'single_choice',
      optionA: json['option_a'] ?? '',
      optionB: json['option_b'] ?? '',
      optionC: json['option_c'] ?? '',
      optionD: json['option_d'] ?? '',
      correctAnswers: List<String>.from(json['correct_answers'] ?? []),
      explanationMain: json['explanation_main'] ?? '',
      rationaleA: json['rationale_a'] ?? '',
      rationaleB: json['rationale_b'] ?? '',
      rationaleC: json['rationale_c'] ?? '',
      rationaleD: json['rationale_d'] ?? '',
    );
  }
}

class ExamDifficulty {
  final String id;
  final String levelName;

  ExamDifficulty({required this.id, required this.levelName});

  factory ExamDifficulty.fromJson(Map<String, dynamic> json) {
    return ExamDifficulty(
      id: json['id'] ?? '',
      levelName: json['level_name'] ?? '',
    );
  }
}
