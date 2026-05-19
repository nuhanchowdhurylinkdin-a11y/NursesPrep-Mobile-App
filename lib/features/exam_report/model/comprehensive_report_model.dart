class ComprehensiveReportModel {
  final String sessionId;
  final double scorePercentage;
  final String nclexStatus;
  final String nclexMessage;
  final String timeSpentLabel;
  final int questionsCount;
  final String? focusCategory;
  final ReportTabs tabs;
  final List<DetailedAnalysisItem> detailedAnalysis;

  ComprehensiveReportModel({
    required this.sessionId,
    required this.scorePercentage,
    required this.nclexStatus,
    required this.nclexMessage,
    required this.timeSpentLabel,
    required this.questionsCount,
    this.focusCategory,
    required this.tabs,
    required this.detailedAnalysis,
  });

  bool get passed => nclexStatus == 'PASS';

  factory ComprehensiveReportModel.fromJson(Map<String, dynamic> json) {
    return ComprehensiveReportModel(
      sessionId: json['session_id'] as String,
      scorePercentage:
          (json['score_percentage'] as num?)?.toDouble() ?? 0.0,
      nclexStatus: json['nclex_status'] as String? ?? 'FAIL',
      nclexMessage: json['nclex_message'] as String? ?? '',
      timeSpentLabel: json['time_spent_label'] as String? ?? '0m',
      questionsCount: json['questions_count'] as int? ?? 0,
      focusCategory: json['focus_category'] as String?,
      tabs: ReportTabs.fromJson(
          json['tabs'] as Map<String, dynamic>? ?? {}),
      detailedAnalysis: (json['detailed_analysis'] as List<dynamic>?)
              ?.map((e) =>
                  DetailedAnalysisItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class ReportTabs {
  final int all;
  final int correct;
  final int incorrect;

  ReportTabs({
    required this.all,
    required this.correct,
    required this.incorrect,
  });

  factory ReportTabs.fromJson(Map<String, dynamic> json) {
    return ReportTabs(
      all: json['all'] as int? ?? 0,
      correct: json['correct'] as int? ?? 0,
      incorrect: json['incorrect'] as int? ?? 0,
    );
  }
}

class DetailedAnalysisItem {
  final int index;
  final String sessionQuestionId;
  final String questionId;
  final String status;
  final bool isCorrect;
  final String categoryLabel;
  final String topicLabel;
  final String questionText;
  final Map<String, String> rationales;

  DetailedAnalysisItem({
    required this.index,
    required this.sessionQuestionId,
    required this.questionId,
    required this.status,
    required this.isCorrect,
    required this.categoryLabel,
    required this.topicLabel,
    required this.questionText,
    required this.rationales,
  });

  factory DetailedAnalysisItem.fromJson(Map<String, dynamic> json) {
    final rawRationales =
        json['rationales'] as Map<String, dynamic>? ?? {};
    final rationales = rawRationales
        .map((key, value) => MapEntry(key, value?.toString() ?? ''));

    return DetailedAnalysisItem(
      index: json['index'] as int? ?? 0,
      sessionQuestionId: json['session_question_id'] as String? ?? '',
      questionId: json['question_id'] as String? ?? '',
      status: json['status'] as String? ?? '',
      isCorrect: json['is_correct'] as bool? ?? false,
      categoryLabel: json['category_label'] as String? ?? '',
      topicLabel: json['topic_label'] as String? ?? '',
      questionText: json['question_text'] as String? ?? '',
      rationales: rationales,
    );
  }
}
