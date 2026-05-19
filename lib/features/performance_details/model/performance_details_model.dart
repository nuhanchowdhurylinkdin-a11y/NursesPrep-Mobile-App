class PerformanceDetailsModel {
  final String period;
  final PerformanceOverview overview;
  final PerformanceChart chart;
  final List<TopicMasteryItem> topicMastery;

  PerformanceDetailsModel({
    required this.period,
    required this.overview,
    required this.chart,
    required this.topicMastery,
  });

  factory PerformanceDetailsModel.fromJson(Map<String, dynamic> json) {
    return PerformanceDetailsModel(
      period: json['period'] ?? '7d',
      overview: PerformanceOverview.fromJson(json['overview'] ?? {}),
      chart: PerformanceChart.fromJson(json['chart'] ?? {}),
      topicMastery: (json['topic_mastery'] as List?)
              ?.map((e) => TopicMasteryItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class PerformanceOverview {
  final double overallAccuracy;
  final double overallAccuracyChange;
  final double timePerQuestionSeconds;
  final double timePerQuestionImprovement;
  final double studyHours;
  final double studyHoursChange;
  final int facedQuestions;
  final int correctAnswers;

  PerformanceOverview({
    required this.overallAccuracy,
    required this.overallAccuracyChange,
    required this.timePerQuestionSeconds,
    required this.timePerQuestionImprovement,
    required this.studyHours,
    required this.studyHoursChange,
    required this.facedQuestions,
    required this.correctAnswers,
  });

  factory PerformanceOverview.fromJson(Map<String, dynamic> json) {
    return PerformanceOverview(
      overallAccuracy: (json['overall_accuracy'] ?? 0).toDouble(),
      overallAccuracyChange: (json['overall_accuracy_change'] ?? 0).toDouble(),
      timePerQuestionSeconds:
          (json['time_per_question_seconds'] ?? 0).toDouble(),
      timePerQuestionImprovement:
          (json['time_per_question_improvement'] ?? 0).toDouble(),
      studyHours: (json['study_hours'] ?? 0).toDouble(),
      studyHoursChange: (json['study_hours_change'] ?? 0).toDouble(),
      facedQuestions: json['faced_questions'] ?? 0,
      correctAnswers: json['correct_answers'] ?? 0,
    );
  }
}

class PerformanceChart {
  final String granularity;
  final List<ChartPoint> points;

  PerformanceChart({
    required this.granularity,
    required this.points,
  });

  factory PerformanceChart.fromJson(Map<String, dynamic> json) {
    return PerformanceChart(
      granularity: json['granularity'] ?? 'day',
      points: (json['points'] as List?)
              ?.map((e) => ChartPoint.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ChartPoint {
  final String key;
  final String label;
  final int facedQuestions;
  final double accuracy;

  ChartPoint({
    required this.key,
    required this.label,
    required this.facedQuestions,
    required this.accuracy,
  });

  factory ChartPoint.fromJson(Map<String, dynamic> json) {
    return ChartPoint(
      key: json['key'] ?? '',
      label: json['label'] ?? '',
      facedQuestions: json['faced_questions'] ?? 0,
      accuracy: (json['accuracy'] ?? 0).toDouble(),
    );
  }
}

class TopicMasteryItem {
  final String topicId;
  final String topicName;
  final int facedQuestions;
  final int correctAnswers;
  final double accuracyRate;
  final String status;
  final String insight;

  TopicMasteryItem({
    required this.topicId,
    required this.topicName,
    required this.facedQuestions,
    required this.correctAnswers,
    required this.accuracyRate,
    required this.status,
    required this.insight,
  });

  factory TopicMasteryItem.fromJson(Map<String, dynamic> json) {
    return TopicMasteryItem(
      topicId: json['topic_id'] ?? '',
      topicName: json['topic_name'] ?? '',
      facedQuestions: json['faced_questions'] ?? 0,
      correctAnswers: json['correct_answers'] ?? 0,
      accuracyRate: (json['accuracy_rate'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      insight: json['insight'] ?? '',
    );
  }
}
