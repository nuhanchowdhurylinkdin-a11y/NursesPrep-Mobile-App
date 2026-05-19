import 'dart:async';

import 'package:get/get.dart';

import '../../../core/mock/guest_mock_data.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/constants/api_constants.dart';
import '../../../core/utils/helpers/app_helper.dart';
import '../model/exam_history_model.dart';

class ExamHistoryController extends GetxController {
  final _networkCaller = NetworkCaller();

  // Summary
  final isLoadingSummary = true.obs;
  final avgScore = 0.0.obs;
  final totalExams = 0.obs;

  // History list
  final isLoadingHistory = true.obs;
  final exams = <ExamHistoryItem>[].obs;
  final hasNextPage = false.obs;
  final currentPage = 1.obs;
  final totalResults = 0.obs;

  // Search
  final searchQuery = ''.obs;
  Timer? _debounce;

  // Mode filter: 'all', 'exam', 'practice'
  final selectedMode = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSummary();
    fetchHistory();

    searchQuery.listen((_) {
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        fetchHistory();
      });
    });
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }

  void setMode(String mode) {
    if (selectedMode.value == mode) return;
    selectedMode.value = mode;
    fetchHistory();
  }

  // ─── Summary ───────────────────────────────────────────────────

  Future<void> fetchSummary() async {
    if (StorageService.isGuest) {
      avgScore.value = GuestMockData.examSummary.averageScore;
      totalExams.value = GuestMockData.examSummary.totalExams;
      isLoadingSummary.value = false;
      return;
    }

    try {
      isLoadingSummary.value = true;
      final response =
          await _networkCaller.getRequest(ApiConstants.examSummary);

      if (response.isSuccess) {
        final data = response.responseData['data'];
        final summary = ExamSummary.fromJson(data);
        avgScore.value = summary.averageScore;
        totalExams.value = summary.totalExams;
      }
    } catch (e) {
      AppHelperFunctions.showErrorSnackBar('Failed to load exam summary');
    } finally {
      isLoadingSummary.value = false;
    }
  }

  // ─── History ───────────────────────────────────────────────────

  Future<void> fetchHistory({int page = 1}) async {
    if (StorageService.isGuest) {
      exams.value = GuestMockData.examHistory;
      hasNextPage.value = false;
      totalResults.value = exams.length;
      isLoadingHistory.value = false;
      return;
    }

    try {
      isLoadingHistory.value = true;

      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': '10',
      };

      if (selectedMode.value != 'all') {
        queryParams['mode'] = selectedMode.value;
      }

      if (searchQuery.value.isNotEmpty) {
        queryParams['search'] = searchQuery.value;
      }

      final uri = Uri.parse(ApiConstants.examHistory)
          .replace(queryParameters: queryParams);

      final response = await _networkCaller.getRequest(uri.toString());

      if (response.isSuccess) {
        final dataList =
            List<dynamic>.from(response.responseData['data'] ?? []);
        final items = dataList
            .map((e) =>
                ExamHistoryItem.fromJson(e as Map<String, dynamic>))
            .toList();

        if (page == 1) {
          exams.value = items;
        } else {
          exams.addAll(items);
        }

        final meta = response.responseData['meta'];
        if (meta != null) {
          final metaObj = ExamHistoryMeta.fromJson(meta);
          hasNextPage.value = metaObj.hasNextPage;
          totalResults.value = metaObj.total;
          currentPage.value = metaObj.page;
        }
      } else {
        AppHelperFunctions.showErrorSnackBar(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to load exam history',
        );
      }
    } catch (e) {
      AppHelperFunctions.showErrorSnackBar('Failed to load exam history');
    } finally {
      isLoadingHistory.value = false;
    }
  }

  void loadMore() {
    if (hasNextPage.value && !isLoadingHistory.value) {
      fetchHistory(page: currentPage.value + 1);
    }
  }
}
