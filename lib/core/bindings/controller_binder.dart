import 'package:get/get.dart';

import '../controller/theme_controller.dart';
import '../../features/auth/controller/auth_controller.dart';
import '../../features/home/controller/home_controller.dart';
import '../../features/main_nav/controller/main_nav_controller.dart';
import '../../features/exam_history/controller/exam_history_controller.dart';
import '../../features/exam_report/controller/exam_report_controller.dart';
import '../../features/library/controller/library_controller.dart';
import '../../features/notifications/controller/notifications_controller.dart';
import '../../features/progress_trend/controller/progress_trend_controller.dart';
import '../../features/practice/controller/practice_controller.dart';
import '../../features/profile/controller/profile_controller.dart';
import '../../features/subscription/controller/subscription_controller.dart';
import '../../features/onboarding/controller/onboarding_controller.dart';
import '../../features/performance_details/controller/performance_details_controller.dart';
import '../../features/daily_progress/controller/daily_progress_controller.dart';
import '../../features/todays_focus/controller/todays_focus_controller.dart';
import '../../features/welcome/controller/welcome_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ThemeController>(
      () => ThemeController(),
      fenix: true,
    );
    Get.lazyPut<OnboardingController>(
      () => OnboardingController(),
      fenix: true,
    );
    Get.lazyPut<WelcomeController>(
      () => WelcomeController(),
      fenix: true,
    );
    Get.lazyPut<AuthController>(
      () => AuthController(),
      fenix: true,
    );
    Get.lazyPut<MainNavController>(
      () => MainNavController(),
      fenix: true,
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
      fenix: true,
    );
    Get.lazyPut<PerformanceDetailsController>(
      () => PerformanceDetailsController(),
      fenix: true,
    );
    Get.lazyPut<TodaysFocusController>(
      () => TodaysFocusController(),
      fenix: true,
    );
    Get.lazyPut<DailyProgressController>(
      () => DailyProgressController(),
      fenix: true,
    );
    Get.lazyPut<NotificationsController>(
      () => NotificationsController(),
      fenix: true,
    );
    Get.lazyPut<PracticeController>(
      () => PracticeController(),
      fenix: true,
    );
    Get.lazyPut<ExamHistoryController>(
      () => ExamHistoryController(),
      fenix: true,
    );
    Get.lazyPut<ExamReportController>(
      () => ExamReportController(),
      fenix: true,
    );
    Get.lazyPut<ProgressTrendController>(
      () => ProgressTrendController(),
      fenix: true,
    );
    Get.lazyPut<LibraryController>(
      () => LibraryController(),
      fenix: true,
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
      fenix: true,
    );
    Get.lazyPut<SubscriptionController>(
      () => SubscriptionController(),
      fenix: true,
    );
  }
}
