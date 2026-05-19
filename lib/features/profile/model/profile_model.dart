class ProfileData {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final ProfileLicenseType? licenseType;
  final String? avatarUrl;
  final bool is2FaEnabled;
  final DateTime lastActive;
  final String platform;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final bool isEmailVerified;
  final DateTime lastLoginAt;
  final String lastLoginIp;
  final String? fcmToken;
  final int practiceDailyGoal;
  final List<ProfileSubscription> subscriptions;

  ProfileData({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.licenseType,
    this.avatarUrl,
    required this.is2FaEnabled,
    required this.lastActive,
    required this.platform,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.isEmailVerified,
    required this.lastLoginAt,
    required this.lastLoginIp,
    this.fcmToken,
    required this.practiceDailyGoal,
    required this.subscriptions,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        id: json['id'] ?? '',
        fullName: json['fullName'] ?? '',
        email: json['email'] ?? '',
        role: json['role'] ?? '',
        licenseType: json['license_type'] != null
            ? ProfileLicenseType.fromJson(json['license_type'])
            : null,
        avatarUrl: json['avatar_url'],
        is2FaEnabled: json['is_2fa_enabled'] ?? false,
        lastActive: DateTime.parse(json['lastActive']),
        platform: json['platform'] ?? '',
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        deletedAt: json['deleted_at'] != null
            ? DateTime.parse(json['deleted_at'])
            : null,
        isEmailVerified: json['isEmailVerified'] ?? false,
        lastLoginAt: DateTime.parse(json['lastLoginAt']),
        lastLoginIp: json['lastLoginIp'] ?? '',
        fcmToken: json['fcm_token'],
        practiceDailyGoal: json['practice_daily_goal'] ?? 50,
        subscriptions: (json['subscriptions'] as List)
            .map((x) => ProfileSubscription.fromJson(x))
            .toList(),
      );
}

class ProfileLicenseType {
  final String id;
  final String licenseName;
  final DateTime createdAt;

  ProfileLicenseType({
    required this.id,
    required this.licenseName,
    required this.createdAt,
  });

  factory ProfileLicenseType.fromJson(Map<String, dynamic> json) =>
      ProfileLicenseType(
        id: json['id'] ?? '',
        licenseName: json['license_name'] ?? '',
        createdAt: DateTime.parse(json['created_at']),
      );
}

class ProfileSubscription {
  final String id;
  final SubscriptionPlan plan;
  final String status;
  final String amount;
  final DateTime startDate;
  final DateTime expiryDate;
  final bool isActive;
  final String? stripePaymentIntentId;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfileSubscription({
    required this.id,
    required this.plan,
    required this.status,
    required this.amount,
    required this.startDate,
    required this.expiryDate,
    required this.isActive,
    this.stripePaymentIntentId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileSubscription.fromJson(Map<String, dynamic> json) =>
      ProfileSubscription(
        id: json['id'] ?? '',
        plan: SubscriptionPlan.fromJson(json['plan']),
        status: json['status'] ?? '',
        amount: json['amount'] ?? '0',
        startDate: DateTime.parse(json['start_date']),
        expiryDate: DateTime.parse(json['expiry_date']),
        isActive: json['is_active'] ?? false,
        stripePaymentIntentId: json['stripe_payment_intent_id'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );
}

class SubscriptionPlan {
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
  final DateTime createdAt;
  final DateTime updatedAt;

  SubscriptionPlan({
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
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) =>
      SubscriptionPlan(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        price: json['price'] ?? '0',
        planType: json['plan_type'] ?? '',
        durationDays: json['duration_days'] ?? 0,
        unlimitedPracticeQuestions:
            json['unlimited_practice_questions'] ?? false,
        mockExamsSimulator: json['mock_exams_simulator'] ?? false,
        fullStudyLibraryAccess: json['full_study_library_access'] ?? false,
        performanceAnalytics: json['performance_analytics'] ?? false,
        description: json['description'] ?? '',
        discountBadgeText: json['discount_badge_text'] ?? '',
        stripePriceId: json['stripe_price_id'] ?? '',
        isActive: json['is_active'] ?? false,
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );
}
