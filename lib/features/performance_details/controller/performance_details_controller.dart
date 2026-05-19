import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../core/mock/guest_mock_data.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/constants/api_constants.dart';
import '../../../core/utils/helpers/app_helper.dart';
import '../model/performance_details_model.dart';

PerformanceDetailsModel _parsePerformanceDetails(Map<String, dynamic> json) {
  return PerformanceDetailsModel.fromJson(json);
}

class PerformanceDetailsController extends GetxController {
  final _networkCaller = NetworkCaller();

  final isLoading = true.obs;
  final RxInt selectedFilterIndex = 0.obs;

  final List<String> filterOptions = [
    'Last 7 Days',
    'Last Month',
    'Last 3 Months',
    'Yearly',
  ];

  static const _periodValues = ['7d', '1m', '3m', '1y'];

  final Rxn<PerformanceDetailsModel> data = Rxn<PerformanceDetailsModel>();

  // Convenience getters
  double get overallAccuracy => data.value?.overview.overallAccuracy ?? 0;
  double get accuracyChange => data.value?.overview.overallAccuracyChange ?? 0;

  List<double> get weeklyAccuracy =>
      data.value?.chart.points.map((p) => p.accuracy).toList() ?? [];
  List<String> get weekDays =>
      data.value?.chart.points.map((p) => p.label).toList() ?? [];

  String get timePerQuestion {
    final secs = data.value?.overview.timePerQuestionSeconds ?? 0;
    if (secs >= 60) {
      final mins = (secs / 60).floor();
      final remainSecs = (secs % 60).round();
      return remainSecs > 0 ? '${mins}m ${remainSecs}s' : '${mins}m';
    }
    return '${secs.round()}s';
  }

  String get timeImprovement {
    final val = data.value?.overview.timePerQuestionImprovement ?? 0;
    if (val == 0) return 'No change';
    final abs = val.abs();
    String formatted;
    if (abs >= 60) {
      final mins = (abs / 60).floor();
      final secs = (abs % 60).round();
      formatted = secs > 0 ? '${mins}m ${secs}s' : '${mins}m';
    } else {
      formatted = '${abs.toStringAsFixed(1)}s';
    }
    return val < 0 ? '$formatted slower' : '$formatted faster';
  }

  String get studyHours {
    final val = data.value?.overview.studyHours ?? 0;
    return '${val.toStringAsFixed(1)}h';
  }

  String get studyHoursChange {
    final val = data.value?.overview.studyHoursChange ?? 0;
    if (val == 0) return 'No change';
    final prefix = val > 0 ? '+' : '';
    return '$prefix${val.toStringAsFixed(1)}h';
  }

  List<TopicMasteryItem> get topics => data.value?.topicMastery ?? [];

  @override
  void onInit() {
    super.onInit();
    fetchPerformanceDetails();
  }

  void selectFilter(int index) {
    selectedFilterIndex.value = index;
    fetchPerformanceDetails();
  }

  Future<void> fetchPerformanceDetails() async {
    if (StorageService.isGuest) {
      data.value = GuestMockData.performanceDetails;
      isLoading.value = false;
      return;
    }

    try {
      isLoading.value = true;

      final period = _periodValues[selectedFilterIndex.value];
      final url = '${ApiConstants.performanceDetails}?period=$period';

      final response = await _networkCaller.getRequest(url);

      if (response.isSuccess) {
        final responseData = response.responseData['data'];
        if (responseData != null) {
          data.value = await compute(
            _parsePerformanceDetails,
            Map<String, dynamic>.from(responseData),
          );
        }
      } else {
        AppHelperFunctions.showErrorSnackBar(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to load performance details',
        );
      }
    } catch (e) {
      AppHelperFunctions.showErrorSnackBar('Failed to load performance details');
    } finally {
      isLoading.value = false;
    }
  }
}
