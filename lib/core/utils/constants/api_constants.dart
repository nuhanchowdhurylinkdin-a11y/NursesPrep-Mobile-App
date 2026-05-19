import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  ApiConstants._();

  static const String webBaseUrl = 'https://nursesprep.com';

  // Web pages
  static const String termsUrl = '$webBaseUrl/terms-and-condition';
  static const String privacyUrl = '$webBaseUrl/privacy-policy';
  static const String helpCenterUrl = '$webBaseUrl/help-center';
  static const String aboutUrl = '$webBaseUrl/about';
  static const String contactUrl = '$webBaseUrl/contact';

  static String get baseUrl {
    final url = dotenv.env['BASE_URL'];
    assert(url != null && url.isNotEmpty, 'BASE_URL is not set in .env');
    return url!;
  }

  // Auth
  static String get signup => '$baseUrl/auth/signup';
  static String get login => '$baseUrl/auth/login';
  static String get verifyOtp => '$baseUrl/auth/verify-otp';
  static String get resendOtp => '$baseUrl/auth/resend-otp';
  static String get forgotPassword => '$baseUrl/auth/forgot-password';
  static String get verifyForgotOtp => '$baseUrl/auth/verify-forgot-otp';
  static String get resetPassword => '$baseUrl/auth/reset-password';
  static String get refreshToken => '$baseUrl/auth/refresh';
  static String get changePassword => '$baseUrl/auth/change-password';
  static String get googleLogin => '$baseUrl/auth/google';
  static String get appleLogin => '$baseUrl/auth/apple';

  // Google OAuth
  static String get googleServerClientId {
    final id = dotenv.env['GOOGLE_SERVER_CLIENT_ID'];
    assert(id != null && id.isNotEmpty, 'GOOGLE_SERVER_CLIENT_ID is not set in .env');
    return id!;
  }
  static String get deleteAccount => '$baseUrl/users/me';

  // Users
  static String get usersMe => '$baseUrl/users/me';
  static String get updateProfile => '$baseUrl/users/update-profile';
  static String get fcmToken => '$baseUrl/users/fcm-token';

  // Questions
  static String get categoriesAndTopics =>
      '$baseUrl/questions/categories-and-topics';

  // Subscription
  static String get activePlans => '$baseUrl/subscription/active-plans';
  static String get createCheckoutSession =>
      '$baseUrl/subscription/create-checkout-session';

  // Practice
  static String get dashboard => '$baseUrl/practice/dashboard';
  static String get practiceSessions => '$baseUrl/practice/sessions';

  // Performance
  static String get performanceDetails =>
      '$baseUrl/practice/performance-details';
  static String get todaysFocus => '$baseUrl/practice/todays-focus';
  static String get dailyProgress => '$baseUrl/practice/daily-progress';
  static String get resumeSession => '$baseUrl/practice/resume-session';
  static String get dailyGoal => '$baseUrl/practice/daily-goal';
  static String get practiceTrends => '$baseUrl/practice/trends';

  // Library
  static String get libraryHome => '$baseUrl/library/user/home';
  static String get libraryCategories => '$baseUrl/library/user/categories';
  static String get libraryMaterials => '$baseUrl/library/user/materials';
  static String get librarySavedMaterials =>
      '$baseUrl/library/user/saved-materials';
  static String get librarySearch => '$baseUrl/library/user/search';

  // Exam
  static String get examAll => '$baseUrl/exam/all';
  static String get examSummary => '$baseUrl/practice/exam-summary';
  static String get examHistory => '$baseUrl/practice/ui/exam-history';
  static String get comprehensiveReport =>
      '$baseUrl/practice/ui/comprehensive-report';

  // Notifications
  static String get notifications => '$baseUrl/notifications/my';
  static String get notificationsUnreadCount =>
      '$baseUrl/notifications/my/unread-count';
  static String get notificationsReadAll =>
      '$baseUrl/notifications/my/read-all';
  static String get notificationsDeleteAll => '$baseUrl/notifications/my/all';
  static String notificationRead(String id) =>
      '$baseUrl/notifications/$id/read';
  static String notificationDelete(String id) => '$baseUrl/notifications/$id';
}
