import 'package:get/get.dart';

import '../../../core/services/network_caller.dart';
import '../../../core/utils/constants/api_constants.dart';
import '../../../core/utils/helpers/app_helper.dart';
import '../model/comprehensive_report_model.dart';

class ExamReportController extends GetxController {
  final _networkCaller = NetworkCaller();

  final isLoading = true.obs;
  final selectedFilter = 0.obs;
  final Rxn<ComprehensiveReportModel> report = Rxn<ComprehensiveReportModel>();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    final sessionId = args?['sessionId'] as String?;
    if (sessionId != null) {
      fetchReport(sessionId);
    }
  }

  Future<void> fetchReport(String sessionId) async {
    try {
      isLoading.value = true;
      final url = '${ApiConstants.comprehensiveReport}/$sessionId';
      final response = await _networkCaller.getRequest(url);

      if (response.isSuccess) {
        final data = response.responseData['data'];
        report.value =
            ComprehensiveReportModel.fromJson(data as Map<String, dynamic>);
      } else {
        AppHelperFunctions.showErrorSnackBar(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to load report',
        );
      }
    } catch (e) {
      AppHelperFunctions.showErrorSnackBar('Failed to load report');
    } finally {
      isLoading.value = false;
    }
  }

  List<DetailedAnalysisItem> get filteredQuestions {
    final r = report.value;
    if (r == null) return [];
    if (selectedFilter.value == 1) {
      return r.detailedAnalysis.where((q) => !q.isCorrect).toList();
    } else if (selectedFilter.value == 2) {
      return r.detailedAnalysis.where((q) => q.isCorrect).toList();
    }
    return r.detailedAnalysis;
  }

  void selectFilter(int index) {
    selectedFilter.value = index;
  }
}
