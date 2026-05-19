import 'package:get/get.dart';

import '../../../core/mock/guest_mock_data.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/constants/api_constants.dart';
import '../../../core/utils/helpers/app_helper.dart';
import '../model/practice_data_model.dart';

enum PracticeMode { practice, exam }

class PracticeController extends GetxController {
  final _networkCaller = NetworkCaller();

  // Loading
  final isLoading = true.obs;

  // Mode
  final mode = PracticeMode.practice.obs;

  // API data
  final categories = <CategoryModel>[].obs;
  final topics = <TopicModel>[].obs;
  final difficulties = <DifficultyModel>[].obs;

  // Selections
  final selectedDifficultyIndex = 0.obs;
  final selectedTopicIds = <String>{}.obs;
  final selectedCategoryId = ''.obs;
  final randomize = false.obs;
  final questionCount = 10.obs;
  final searchQuery = ''.obs;

  // Category expansion tracking
  final expandedCategoryIndex = RxnInt(null);

  bool get isPracticeMode => mode.value == PracticeMode.practice;

  List<CategoryModel> get filteredCategories {
    if (searchQuery.value.isEmpty) return categories;
    final q = searchQuery.value.toLowerCase();
    return categories
        .where((c) => c.categoryName.toLowerCase().contains(q))
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    if (StorageService.isGuest) {
      final model = GuestMockData.practiceData;
      categories.value = model.categories;
      topics.value = model.topics;
      difficulties.value = model.difficulties;
      isLoading.value = false;
      return;
    }

    try {
      isLoading.value = true;
      final response =
          await _networkCaller.getRequest(ApiConstants.categoriesAndTopics);

      if (response.isSuccess) {
        final data = response.responseData['data'];
        final model = PracticeDataModel.fromJson(data);

        categories.value = model.categories;
        topics.value = model.topics;
        difficulties.value = model.difficulties;
      } else {
        AppHelperFunctions.showErrorSnackBar('Failed to load practice data');
      }
    } catch (e) {
      AppHelperFunctions.showErrorSnackBar('Failed to load practice data');
    } finally {
      isLoading.value = false;
    }
  }

  void setMode(PracticeMode m) {
    mode.value = m;
  }

  void toggleCategory(int index) {
    if (expandedCategoryIndex.value == index) {
      expandedCategoryIndex.value = null;
    } else {
      expandedCategoryIndex.value = index;
    }
  }

  void selectDifficulty(int index) {
    selectedDifficultyIndex.value = index;
  }

  void toggleTopic(String id) {
    if (selectedTopicIds.contains(id)) {
      selectedTopicIds.remove(id);
    } else {
      selectedTopicIds.add(id);
    }
  }

  void toggleRandomize(bool value) {
    randomize.value = value;
  }

  void selectCategory(String id) {
    selectedCategoryId.value = id;
  }

  String? get selectedDifficultyId {
    if (difficulties.isEmpty) return null;
    return difficulties[selectedDifficultyIndex.value].id;
  }
}
