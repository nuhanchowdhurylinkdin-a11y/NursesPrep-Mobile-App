import 'package:get/get.dart';

import '../../../core/mock/guest_mock_data.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/constants/api_constants.dart';
import '../../../core/utils/helpers/app_helper.dart';
import '../../profile/controller/profile_controller.dart';
import '../model/dashboard_model.dart';

class HomeController extends GetxController {
  final _networkCaller = NetworkCaller();

  final isLoading = true.obs;

  // Welcome
  final userName = ''.obs;
  final licenseName = ''.obs;

  // Performance Summary
  final accuracy = 0.0.obs;
  final examsTotal = 0.obs;

  // Focus Needed
  final Rxn<FocusNeeded> focusNeeded = Rxn<FocusNeeded>();

  // Daily Progress
  final answeredQuestions = 0.obs;
  final targetQuestions = 50.obs;
  final completionPercentage = 0.obs;

  String get displayName =>
      userName.value.isNotEmpty ? userName.value : (StorageService.fullName ?? 'User');

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    if (StorageService.isGuest) {
      _applyDashboard(GuestMockData.dashboard);
      isLoading.value = false;
      return;
    }

    try {
      isLoading.value = true;
      final response = await _networkCaller.getRequest(ApiConstants.dashboard);

      if (response.isSuccess) {
        final data = response.responseData['data'];
        _applyDashboard(DashboardModel.fromJson(data));
        Get.find<ProfileController>().init();
      }
    } catch (e) {
      AppHelperFunctions.showErrorSnackBar('Failed to load dashboard data');
    } finally {
      isLoading.value = false;
    }
  }

  void _applyDashboard(DashboardModel dashboard) {
    userName.value = dashboard.welcome.fullName;
    licenseName.value = dashboard.welcome.licenseType;

    accuracy.value = dashboard.performanceSummary.accuracy;
    examsTotal.value = dashboard.performanceSummary.examsTotal;
    focusNeeded.value = dashboard.performanceSummary.focusNeeded;

    answeredQuestions.value = dashboard.dailyProgress.answeredQuestions;
    targetQuestions.value = dashboard.dailyProgress.targetQuestions;
    completionPercentage.value = dashboard.dailyProgress.completionPercentage;
  }
}
