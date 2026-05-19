import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/login_required_dialog.dart';
import '../../../core/mock/guest_mock_data.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/constants/api_constants.dart';
import '../../../core/utils/helpers/app_helper.dart';
import '../model/library_home_model.dart';
import '../model/library_search_model.dart';
import '../model/material_detail_model.dart';

LibraryHomeModel _parseLibraryHome(Map<String, dynamic> json) {
  return LibraryHomeModel.fromJson(json);
}

List<StudyGuideItem> _parseMaterials(List<dynamic> json) {
  return json.map((e) => StudyGuideItem.fromJson(e)).toList();
}

MaterialDetailModel _parseMaterialDetail(Map<String, dynamic> json) {
  return MaterialDetailModel.fromJson(json);
}

LibrarySearchModel _parseSearch(Map<String, dynamic> json) {
  return LibrarySearchModel.fromJson(json);
}

class LibraryController extends GetxController {
  final _networkCaller = NetworkCaller();

  final isLoading = true.obs;
  final Rxn<LibraryHomeModel> data = Rxn<LibraryHomeModel>();

  // Category drill-down state
  final selectedCategoryIndex = RxnInt(null);
  final selectedTopicFilter = 0.obs;
  final searchQuery = ''.obs;

  // Category materials
  final isLoadingMaterials = false.obs;
  final categoryMaterials = <StudyGuideItem>[].obs;
  final hasNextPage = false.obs;
  final totalMaterialsCount = 0.obs;

  static const _tabValues = ['all', 'saved', 'in_progress', 'unread'];

  // Convenience getters
  int get totalBookmarked => data.value?.savedTopics.totalBookmarked ?? 0;

  List<MedicalCategoryItem> get categories =>
      data.value?.medicalCategories ?? [];

  List<StudyGuideItem> get studyGuides => data.value?.studyGuides ?? [];

  MedicalCategoryItem? get selectedCategory {
    final idx = selectedCategoryIndex.value;
    if (idx == null || idx >= categories.length) return null;
    return categories[idx];
  }

  @override
  void onInit() {
    super.onInit();
    fetchLibraryHome();
  }

  Future<void> fetchLibraryHome() async {
    if (StorageService.isGuest) {
      data.value = GuestMockData.libraryHome;
      isLoading.value = false;
      return;
    }

    try {
      isLoading.value = true;

      final response =
          await _networkCaller.getRequest(ApiConstants.libraryHome);

      if (response.isSuccess) {
        final responseData = response.responseData['data'];
        if (responseData != null) {
          data.value = await compute(
            _parseLibraryHome,
            Map<String, dynamic>.from(responseData),
          );
        }
      } else {
        AppHelperFunctions.showErrorSnackBar(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to load library',
        );
      }
    } catch (e) {
      AppHelperFunctions.showErrorSnackBar('Failed to load library');
    } finally {
      isLoading.value = false;
    }
  }

  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
    selectedTopicFilter.value = 0;
    searchQuery.value = '';
    categoryMaterials.clear();
    fetchCategoryMaterials();
  }

  void goBackToCategories() {
    selectedCategoryIndex.value = null;
    categoryMaterials.clear();
    searchQuery.value = '';
  }

  void selectTopicFilter(int index) {
    selectedTopicFilter.value = index;
    categoryMaterials.clear();
    fetchCategoryMaterials();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    categoryMaterials.clear();
    fetchCategoryMaterials();
  }

  // Material detail state
  final isLoadingDetail = true.obs;
  final Rxn<MaterialDetailModel> materialDetail = Rxn<MaterialDetailModel>();
  final isTogglingBookmark = false.obs;

  Future<void> fetchMaterialDetail(String materialId) async {
    if (StorageService.isGuest) {
      isLoadingDetail.value = false;
      AppHelperFunctions.showErrorSnackBar(
        'Sign in to view full study material content.',
      );
      return;
    }

    try {
      isLoadingDetail.value = true;
      materialDetail.value = null;

      final response = await _networkCaller
          .getRequest('${ApiConstants.libraryMaterials}/$materialId');

      if (response.isSuccess) {
        final responseData = response.responseData['data'];
        if (responseData != null) {
          materialDetail.value = await compute(
            _parseMaterialDetail,
            Map<String, dynamic>.from(responseData),
          );
        }
      } else {
        AppHelperFunctions.showErrorSnackBar(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to load material',
        );
      }
    } catch (e) {
      AppHelperFunctions.showErrorSnackBar('Failed to load material');
    } finally {
      isLoadingDetail.value = false;
    }
  }

  Future<void> toggleBookmark(String materialId) async {
    if (StorageService.isGuest) {
      LoginRequiredDialog.show(
        message:
            'Log in to bookmark study materials and sync them across your devices.',
      );
      return;
    }

    if (isTogglingBookmark.value) return;

    final detail = materialDetail.value;
    if (detail == null) return;

    try {
      isTogglingBookmark.value = true;

      final isSaved = detail.isSaved;
      final url = '${ApiConstants.libraryMaterials}/$materialId/bookmark';

      final response = isSaved
          ? await _networkCaller.patchRequest('$url/remove', body: {})
          : await _networkCaller.postRequest(url, body: {});

      if (response.isSuccess) {
        materialDetail.value = MaterialDetailModel(
          id: detail.id,
          title: detail.title,
          description: detail.description,
          category: detail.category,
          topic: detail.topic,
          isSaved: !isSaved,
          hasViewed: detail.hasViewed,
          readingProgress: detail.readingProgress,
          resource: detail.resource,
          content: detail.content,
          actions: detail.actions,
        );
      } else {
        AppHelperFunctions.showErrorSnackBar(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to update bookmark',
        );
      }
    } catch (e) {
      AppHelperFunctions.showErrorSnackBar('Failed to update bookmark');
    } finally {
      isTogglingBookmark.value = false;
    }
  }

  // Saved materials state
  final isLoadingSaved = false.obs;
  final savedMaterials = <StudyGuideItem>[].obs;
  final savedSearchQuery = ''.obs;
  final savedCategoryId = RxnString(null);
  final savedHasNextPage = false.obs;
  final savedCurrentPage = 1.obs;

  Future<void> fetchSavedMaterials({int page = 1}) async {
    if (StorageService.isGuest) {
      savedMaterials.value = GuestMockData.libraryHome.studyGuides
          .where((g) => g.isSaved)
          .toList();
      savedHasNextPage.value = false;
      isLoadingSaved.value = false;
      return;
    }

    try {
      isLoadingSaved.value = true;

      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': '10',
      };

      if (savedSearchQuery.value.isNotEmpty) {
        queryParams['search'] = savedSearchQuery.value;
      }

      if (savedCategoryId.value != null) {
        queryParams['category_id'] = savedCategoryId.value!;
      }

      final uri = Uri.parse(ApiConstants.librarySavedMaterials)
          .replace(queryParameters: queryParams);

      final response = await _networkCaller.getRequest(uri.toString());

      if (response.isSuccess) {
        final dataList =
            List<dynamic>.from(response.responseData['data'] ?? []);
        final items = await compute(_parseMaterials, dataList);

        if (page == 1) {
          savedMaterials.value = items;
        } else {
          savedMaterials.addAll(items);
        }

        savedCurrentPage.value = page;

        final meta = response.responseData['meta'];
        if (meta != null) {
          savedHasNextPage.value = meta['has_next_page'] ?? false;
        }
      } else {
        AppHelperFunctions.showErrorSnackBar(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to load saved materials',
        );
      }
    } catch (e) {
      AppHelperFunctions.showErrorSnackBar('Failed to load saved materials');
    } finally {
      isLoadingSaved.value = false;
    }
  }

  void onSavedSearchChanged(String query) {
    savedSearchQuery.value = query;
    savedMaterials.clear();
    fetchSavedMaterials();
  }

  void onSavedCategoryChanged(String? categoryId) {
    savedCategoryId.value = categoryId;
    savedMaterials.clear();
    fetchSavedMaterials();
  }

  void loadMoreSaved() {
    if (savedHasNextPage.value && !isLoadingSaved.value) {
      fetchSavedMaterials(page: savedCurrentPage.value + 1);
    }
  }

  Future<void> fetchCategoryMaterials({int page = 1}) async {
    final cat = selectedCategory;
    if (cat == null) return;

    if (StorageService.isGuest) {
      categoryMaterials.value = GuestMockData.libraryHome.studyGuides;
      hasNextPage.value = false;
      totalMaterialsCount.value = categoryMaterials.length;
      isLoadingMaterials.value = false;
      return;
    }

    try {
      isLoadingMaterials.value = true;

      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': '10',
      };

      final tabValue = _tabValues[selectedTopicFilter.value];
      if (tabValue != 'all') {
        queryParams['tab'] = tabValue;
      }

      if (searchQuery.value.isNotEmpty) {
        queryParams['search'] = searchQuery.value;
      }

      final uri = Uri.parse(
              '${ApiConstants.libraryCategories}/${cat.id}/materials')
          .replace(queryParameters: queryParams);

      final response = await _networkCaller.getRequest(uri.toString());

      if (response.isSuccess) {
        final dataList =
            List<dynamic>.from(response.responseData['data'] ?? []);
        final items = await compute(_parseMaterials, dataList);

        if (page == 1) {
          categoryMaterials.value = items;
        } else {
          categoryMaterials.addAll(items);
        }

        final meta = response.responseData['meta'];
        if (meta != null) {
          hasNextPage.value = meta['has_next_page'] ?? false;
          totalMaterialsCount.value = meta['total'] ?? 0;
        }
      } else {
        AppHelperFunctions.showErrorSnackBar(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to load materials',
        );
      }
    } catch (e) {
      AppHelperFunctions.showErrorSnackBar('Failed to load materials');
    } finally {
      isLoadingMaterials.value = false;
    }
  }

  // Library search state
  final isLoadingSearch = false.obs;
  final Rxn<LibrarySearchModel> searchData = Rxn<LibrarySearchModel>();
  final librarySearchQuery = ''.obs;

  Future<void> fetchSearchResults({String? query}) async {
    if (StorageService.isGuest) {
      searchData.value = null;
      isLoadingSearch.value = false;
      return;
    }

    try {
      isLoadingSearch.value = true;

      final q = query ?? librarySearchQuery.value;

      final queryParams = <String, String>{
        'page': '1',
        'limit': '10',
      };

      if (q.isNotEmpty) {
        queryParams['query'] = q;
      }

      final uri = Uri.parse(ApiConstants.librarySearch)
          .replace(queryParameters: queryParams);

      final response = await _networkCaller.getRequest(uri.toString());

      if (response.isSuccess) {
        final responseData = response.responseData['data'];
        if (responseData != null) {
          searchData.value = await compute(
            _parseSearch,
            Map<String, dynamic>.from(responseData),
          );
        }
      } else {
        AppHelperFunctions.showErrorSnackBar(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to search library',
        );
      }
    } catch (e) {
      AppHelperFunctions.showErrorSnackBar('Failed to search library');
    } finally {
      isLoadingSearch.value = false;
    }
  }

  void onLibrarySearchChanged(String query) {
    librarySearchQuery.value = query;
    fetchSearchResults(query: query);
  }

  void initSearch() {
    librarySearchQuery.value = '';
    searchData.value = null;
    fetchSearchResults();
  }
}
