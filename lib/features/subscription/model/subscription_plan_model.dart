class SubscriptionPlanData {
  final String id;
  final String name;
  final String price;
  final String planType;
  final int durationDays;
  final bool unlimitedPracticeQuestions;
  final bool mockExamsSimulator;
  final bool fullStudyLibraryAccess;
  final bool performanceAnalytics;
  final String description;
  final String discountBadgeText;
  final String stripePriceId;
  final bool isActive;

  SubscriptionPlanData({
    required this.id,
    required this.name,
    required this.price,
    required this.planType,
    required this.durationDays,
    required this.unlimitedPracticeQuestions,
    required this.mockExamsSimulator,
    required this.fullStudyLibraryAccess,
    required this.performanceAnalytics,
    required this.description,
    required this.discountBadgeText,
    required this.stripePriceId,
    required this.isActive,
  });

  factory SubscriptionPlanData.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanData(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? '0.00',
      planType: json['plan_type'] ?? '',
      durationDays: json['duration_days'] ?? 0,
      unlimitedPracticeQuestions: json['unlimited_practice_questions'] ?? false,
      mockExamsSimulator: json['mock_exams_simulator'] ?? false,
      fullStudyLibraryAccess: json['full_study_library_access'] ?? false,
      performanceAnalytics: json['performance_analytics'] ?? false,
      description: json['description'] ?? '',
      discountBadgeText: json['discount_badge_text'] ?? '',
      stripePriceId: json['stripe_price_id'] ?? '',
      isActive: json['is_active'] ?? false,
    );
  }

  String get displayPrice {
    if (planType == 'free') return 'Free';
    return '\$$price';
  }

  String get billingPeriod {
    if (planType == 'free') return 'Forever';
    if (planType == 'quarterly') return '/month';
    if (planType == 'yearly') return '/year';
    return '/$planType';
  }

  List<PlanFeature> get features => [
        PlanFeature('Unlimited Practice Questions', unlimitedPracticeQuestions),
        PlanFeature('Mock Exams Simulator', mockExamsSimulator),
        PlanFeature('Full Study Library Access', fullStudyLibraryAccess),
        PlanFeature('Performance Analytics', performanceAnalytics),
      ];
}

class PlanFeature {
  final String name;
  final bool enabled;
  PlanFeature(this.name, this.enabled);
}
