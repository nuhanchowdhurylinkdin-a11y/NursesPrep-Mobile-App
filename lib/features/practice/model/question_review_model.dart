class QuestionReviewModel {
  final String sessionQuestionId;
  final String questionId;
  final int questionNumber;
  final String questionPrompt;
  final String questionType;
  final ReviewCategory? category;
  final ReviewTopic? topic;
  final ReviewDifficulty? difficulty;
  final List<ReviewOption> options;
  final String explanationMain;
  final Map<String, String> rationales;
  final List<String> correctAnswers;
  final List<String> selectedAnswers;
  final bool? isCorrect;

  QuestionReviewModel({
    required this.sessionQuestionId,
    required this.questionId,
    required this.questionNumber,
    required this.questionPrompt,
    required this.questionType,
    this.category,
    this.topic,
    this.difficulty,
    required this.options,
    required this.explanationMain,
    required this.rationales,
    required this.correctAnswers,
    required this.selectedAnswers,
    this.isCorrect,
  });

  String? getRationale(String key) {
    return rationales['option_${key.toLowerCase()}'];
  }

  factory QuestionReviewModel.fromJson(Map<String, dynamic> json) {
    final rawRationales = json['rationales'] as Map<String, dynamic>? ?? {};
    final parsedRationales = <String, String>{};
    rawRationales.forEach((key, value) {
      parsedRationales[key] = value?.toString() ?? '';
    });

    return QuestionReviewModel(
      sessionQuestionId: json['session_question_id'] ?? '',
      questionId: json['question_id'] ?? '',
      questionNumber: json['question_number'] ?? 0,
      questionPrompt: json['question_prompt'] ?? '',
      questionType: json['question_type'] ?? '',
      category: json['category'] != null
          ? ReviewCategory.fromJson(json['category'])
          : null,
      topic: json['topic'] != null ? ReviewTopic.fromJson(json['topic']) : null,
      difficulty: json['difficulty'] != null
          ? ReviewDifficulty.fromJson(json['difficulty'])
          : null,
      options: (json['options'] as List?)
              ?.map((e) => ReviewOption.fromJson(e))
              .toList() ??
          [],
      explanationMain: json['explanation_main'] ?? '',
      rationales: parsedRationales,
      correctAnswers: (json['correct_answers'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      selectedAnswers: (json['selected_answers'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isCorrect: json['is_correct'],
    );
  }
}

class ReviewCategory {
  final String id;
  final String name;

  ReviewCategory({required this.id, required this.name});

  factory ReviewCategory.fromJson(Map<String, dynamic> json) {
    return ReviewCategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class ReviewTopic {
  final String id;
  final String name;

  ReviewTopic({required this.id, required this.name});

  factory ReviewTopic.fromJson(Map<String, dynamic> json) {
    return ReviewTopic(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class ReviewDifficulty {
  final String id;
  final String name;

  ReviewDifficulty({required this.id, required this.name});

  factory ReviewDifficulty.fromJson(Map<String, dynamic> json) {
    return ReviewDifficulty(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class ReviewOption {
  final String key;
  final String text;

  ReviewOption({required this.key, required this.text});

  factory ReviewOption.fromJson(Map<String, dynamic> json) {
    return ReviewOption(
      key: json['key'] ?? '',
      text: json['text'] ?? '',
    );
  }
}
