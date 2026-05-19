import 'package:get/get.dart';
import 'package:hayzee152_app/features/splash/screen/views/splash_screen.dart';

import '../features/auth/views/screens/change_password_screen.dart';
import '../features/auth/views/screens/login_screen.dart';
import '../features/auth/views/screens/otp_screen.dart';
import '../features/auth/views/screens/reset_password_screen.dart';
import '../features/auth/views/screens/set_new_password_screen.dart';
import '../features/auth/views/screens/sign_up_screen.dart';
import '../features/main_nav/views/screens/main_nav_screen.dart';
import '../features/performance_details/views/screens/performance_details_screen.dart';
import '../features/daily_progress/views/screens/daily_progress_screen.dart';
import '../features/todays_focus/views/screens/todays_focus_screen.dart';
import '../features/exam_report/views/screens/exam_report_screen.dart';
import '../features/library/views/screens/book_screen.dart';
import '../features/library/views/screens/pdf_viewer_screen.dart';
import '../features/library/views/screens/library_search_screen.dart';
import '../features/profile/views/screens/delete_account_screen.dart';
import '../features/profile/views/screens/edit_profile_screen.dart';
import '../features/practice/views/screens/practice_screen.dart';
import '../features/practice/views/screens/question_review_screen.dart';
import '../features/practice/views/screens/quiz_screen.dart';
import '../features/practice/views/screens/exam_selection_screen.dart';
import '../features/practice/views/screens/session_result_screen.dart';
import '../features/practice/views/screens/topic_selection_screen.dart';
import '../features/subscription/views/screens/billing_history_screen.dart';

import '../features/subscription/views/screens/change_plan_screen.dart';
import '../features/subscription/views/screens/subscription_screen.dart';
import '../features/profile/views/screens/profile_screen.dart';
import '../features/library/views/screens/saved_topics_screen.dart';
import '../features/progress_trend/views/screens/progress_trend_screen.dart';
import '../features/notifications/views/screens/notifications_screen.dart';
import '../features/onboarding/views/screens/onboarding_screen.dart';
import '../features/welcome/views/screens/welcome_screen.dart';

class AppRoute {
  static String splashScreen = "/splashScreen";
  static String onboardingScreen = "/onboardingScreen";
  static String welcomeScreen = "/welcomeScreen";
  static String loginScreen = "/loginScreen";
  static String signUpScreen = "/signUpScreen";
  static String resetPasswordScreen = "/resetPasswordScreen";
  static String otpScreen = "/otpScreen";
  static String changePasswordScreen = "/changePasswordScreen";
  static String setNewPasswordScreen = "/setNewPasswordScreen";
  static String homeScreen = "/homeScreen";
  static String performanceDetailsScreen = "/performanceDetailsScreen";
  static String todaysFocusScreen = "/todaysFocusScreen";
  static String dailyProgressScreen = "/dailyProgressScreen";
  static String notificationsScreen = "/notificationsScreen";
  static String examReportScreen = "/examReportScreen";
  static String progressTrendScreen = "/progressTrendScreen";
  static String bookScreen = "/bookScreen";
  static String savedTopicsScreen = "/savedTopicsScreen";
  static String librarySearchScreen = "/librarySearchScreen";
  static String profileScreen = "/profileScreen";
  static String editProfileScreen = "/editProfileScreen";
  static String subscriptionScreen = "/subscriptionScreen";
  static String changePlanScreen = "/changePlanScreen";
  static String billingHistoryScreen = "/billingHistoryScreen";
  static String practiceSetupScreen = "/practiceSetupScreen";
  static String topicSelectionScreen = "/topicSelectionScreen";
  static String deleteAccountScreen = "/deleteAccountScreen";
  static String quizScreen = "/quizScreen";
  static String sessionResultScreen = "/sessionResultScreen";
  static String examSelectionScreen = "/examSelectionScreen";
  static String pdfViewerScreen = "/pdfViewerScreen";
  static String questionReviewScreen = "/questionReviewScreen";

  static String getSplashScreen() => splashScreen;
  static String getOnboardingScreen() => onboardingScreen;
  static String getWelcomeScreen() => welcomeScreen;
  static String getLoginScreen() => loginScreen;
  static String getSignUpScreen() => signUpScreen;
  static String getResetPasswordScreen() => resetPasswordScreen;
  static String getOtpScreen() => otpScreen;
  static String getChangePasswordScreen() => changePasswordScreen;
  static String getSetNewPasswordScreen() => setNewPasswordScreen;
  static String getHomeScreen() => homeScreen;
  static String getPerformanceDetailsScreen() => performanceDetailsScreen;
  static String getTodaysFocusScreen() => todaysFocusScreen;
  static String getDailyProgressScreen() => dailyProgressScreen;
  static String getNotificationsScreen() => notificationsScreen;
  static String getExamReportScreen() => examReportScreen;
  static String getProgressTrendScreen() => progressTrendScreen;
  static String getBookScreen() => bookScreen;
  static String getSavedTopicsScreen() => savedTopicsScreen;
  static String getLibrarySearchScreen() => librarySearchScreen;
  static String getProfileScreen() => profileScreen;
  static String getEditProfileScreen() => editProfileScreen;
  static String getSubscriptionScreen() => subscriptionScreen;
  static String getChangePlanScreen() => changePlanScreen;
  static String getBillingHistoryScreen() => billingHistoryScreen;
  static String getPracticeSetupScreen() => practiceSetupScreen;
  static String getTopicSelectionScreen() => topicSelectionScreen;
  static String getDeleteAccountScreen() => deleteAccountScreen;
  static String getQuizScreen() => quizScreen;
  static String getSessionResultScreen() => sessionResultScreen;
  static String getExamSelectionScreen() => examSelectionScreen;
  static String getPdfViewerScreen() => pdfViewerScreen;
  static String getQuestionReviewScreen() => questionReviewScreen;

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: onboardingScreen, page: () => const OnboardingScreen()),
    GetPage(name: welcomeScreen, page: () => const WelcomeScreen()),
    GetPage(name: loginScreen, page: () => const LoginScreen()),
    GetPage(name: signUpScreen, page: () => const SignUpScreen()),
    GetPage(name: resetPasswordScreen, page: () => const ResetPasswordScreen()),
    GetPage(name: otpScreen, page: () => const OtpScreen()),
    GetPage(name: changePasswordScreen, page: () => const ChangePasswordScreen()),
    GetPage(name: setNewPasswordScreen, page: () => const SetNewPasswordScreen()),
    GetPage(name: homeScreen, page: () => const MainNavScreen()),
    GetPage(name: performanceDetailsScreen, page: () => const PerformanceDetailsScreen()),
    GetPage(name: todaysFocusScreen, page: () => const TodaysFocusScreen()),
    GetPage(name: dailyProgressScreen, page: () => const DailyProgressScreen()),
    GetPage(name: notificationsScreen, page: () => const NotificationsScreen()),
    GetPage(name: examReportScreen, page: () => const ExamReportScreen()),
    GetPage(name: progressTrendScreen, page: () => const ProgressTrendScreen()),
    GetPage(name: bookScreen, page: () => const BookScreen()),
    GetPage(name: savedTopicsScreen, page: () => const SavedTopicsScreen()),
    GetPage(name: librarySearchScreen, page: () => const LibrarySearchScreen()),
    GetPage(name: profileScreen, page: () => const ProfileScreen()),
    GetPage(name: editProfileScreen, page: () => const EditProfileScreen()),
    GetPage(name: subscriptionScreen, page: () => const SubscriptionScreen()),
    GetPage(name: changePlanScreen, page: () => const ChangePlanScreen()),
    GetPage(name: billingHistoryScreen, page: () => const BillingHistoryScreen()),
    GetPage(name: practiceSetupScreen, page: () => const PracticeScreen()),
    GetPage(name: topicSelectionScreen, page: () => const TopicSelectionScreen()),
    GetPage(name: deleteAccountScreen, page: () => const DeleteAccountScreen()),
    GetPage(name: quizScreen, page: () => const QuizScreen()),
    GetPage(name: sessionResultScreen, page: () => SessionResultScreen()),
    GetPage(name: examSelectionScreen, page: () => const ExamSelectionScreen()),
    GetPage(name: pdfViewerScreen, page: () => const PdfViewerScreen()),
    GetPage(name: questionReviewScreen, page: () => const QuestionReviewScreen()),
  ];
}
