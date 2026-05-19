import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../core/mock/guest_mock_data.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/constants/api_constants.dart';
import '../../../core/utils/helpers/app_helper.dart';
import '../model/progress_trend_model.dart';

ProgressTrendModel _parseTrend(Map<String, dynamic> json) {
  return ProgressTrendModel.fromJson(json);
}

class ProgressTrendController extends GetxController {
  final _networkCaller = NetworkCaller();

  final selectedTimeFilter = 0.obs;
  final selectedMode = 'all'.obs;
  final isLoading = true.obs;

  final Rxn<ProgressTrendModel> data = Rxn<ProgressTrendModel>();

  // 0 -> 30d, 1 -> 90d
  static const _periodValues = ['30d', '90d'];
  static const tabLabels = ['Last 30 Days', 'Last 3 Months'];
  static const modeLabels = ['All', 'Exam'];
  static const _modeValues = ['all', 'exam'];

  @override
  void onInit() {
    super.onInit();
    fetchTrends();
  }

  void selectTimeFilter(int index) {
    if (selectedTimeFilter.value == index) return;
    selectedTimeFilter.value = index;
    fetchTrends();
  }

  void selectMode(int index) {
    final mode = _modeValues[index];
    if (selectedMode.value == mode) return;
    selectedMode.value = mode;
    fetchTrends();
  }

  int get selectedModeIndex => _modeValues.indexOf(selectedMode.value);

  Future<void> fetchTrends() async {
    if (StorageService.isGuest) {
      data.value = GuestMockData.progressTrend;
      isLoading.value = false;
      return;
    }

    try {
      isLoading.value = true;

      final period = _periodValues[selectedTimeFilter.value];
      final mode = selectedMode.value;
      final modePath = mode == 'all' ? '' : '/$mode';
      final url = '${ApiConstants.practiceTrends}$modePath?period=$period';

      final response = await _networkCaller.getRequest(url);

      if (response.isSuccess) {
        final responseData = response.responseData['data'];
        if (responseData != null) {
          data.value = await compute(
            _parseTrend,
            Map<String, dynamic>.from(responseData),
          );
        }
      } else {
        AppHelperFunctions.showErrorSnackBar(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to load progress trends',
        );
      }
    } catch (e) {
      AppHelperFunctions.showErrorSnackBar('Failed to load progress trends');
    } finally {
      isLoading.value = false;
    }
  }
}
