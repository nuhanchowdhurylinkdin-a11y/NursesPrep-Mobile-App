class ProgressTrendModel {
  final String period;
  final double avgAccuracy;
  final PredictiveScore predictiveScore;
  final List<TrendPoint> trendPoints;
  final ClinicalGrowthInsight clinicalGrowthInsight;
  final List<Milestone> milestones;

  ProgressTrendModel({
    required this.period,
    required this.avgAccuracy,
    required this.predictiveScore,
    required this.trendPoints,
    required this.clinicalGrowthInsight,
    required this.milestones,
  });

  factory ProgressTrendModel.fromJson(Map<String, dynamic> json) {
    return ProgressTrendModel(
      period: json['period']?.toString() ?? '',
      avgAccuracy: (json['avg_accuracy'] as num?)?.toDouble() ?? 0.0,
      predictiveScore: PredictiveScore.fromJson(
        Map<String, dynamic>.from(json['predictive_score'] ?? {}),
      ),
      trendPoints: (json['trend_points'] as List? ?? [])
          .map((e) => TrendPoint.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      clinicalGrowthInsight: ClinicalGrowthInsight.fromJson(
        Map<String, dynamic>.from(json['clinical_growth_insight'] ?? {}),
      ),
      milestones: (json['milestones'] as List? ?? [])
          .map((e) => Milestone.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

class PredictiveScore {
  final String label;
  final String level;

  PredictiveScore({required this.label, required this.level});

  factory PredictiveScore.fromJson(Map<String, dynamic> json) {
    return PredictiveScore(
      label: json['label']?.toString() ?? '',
      level: json['level']?.toString() ?? '',
    );
  }
}

class TrendPoint {
  final String date;
  final double accuracy;
  final String mode;

  TrendPoint({
    required this.date,
    required this.accuracy,
    required this.mode,
  });

  factory TrendPoint.fromJson(Map<String, dynamic> json) {
    return TrendPoint(
      date: json['date']?.toString() ?? '',
      accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0.0,
      mode: json['mode']?.toString() ?? '',
    );
  }
}

class ClinicalGrowthInsight {
  final String strongestArea;
  final String weakestArea;
  final String narrative;

  ClinicalGrowthInsight({
    required this.strongestArea,
    required this.weakestArea,
    required this.narrative,
  });

  factory ClinicalGrowthInsight.fromJson(Map<String, dynamic> json) {
    return ClinicalGrowthInsight(
      strongestArea: json['strongest_area']?.toString() ?? '',
      weakestArea: json['weakest_area']?.toString() ?? '',
      narrative: json['narrative']?.toString() ?? '',
    );
  }
}

class Milestone {
  final String sessionId;
  final String mode;
  final String title;
  final double scorePercentage;
  final DateTime? completedAt;

  Milestone({
    required this.sessionId,
    required this.mode,
    required this.title,
    required this.scorePercentage,
    this.completedAt,
  });

  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      sessionId: json['session_id']?.toString() ?? '',
      mode: json['mode']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      scorePercentage:
          (json['score_percentage'] as num?)?.toDouble() ?? 0.0,
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'].toString())
          : null,
    );
  }
}
