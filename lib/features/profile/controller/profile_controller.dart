import 'dart:io';

import 'package:get/get.dart';
import 'package:hayzee152_app/core/utils/logging/logger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/common/widgets/login_required_dialog.dart';
import '../../../core/mock/guest_mock_data.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/constants/api_constants.dart';
import '../../../core/utils/helpers/app_helper.dart';
import '../model/profile_model.dart';
import '../../home/controller/home_controller.dart';

class LicenseOption {
  final String id;
  final String name;

  LicenseOption({required this.id, required this.name});
}

class ProfileController extends GetxController {
  final _networkCaller = NetworkCaller();

  final isLoading = true.obs;
  final isUpdating = false.obs;
  final Rxn<ProfileData> profile = Rxn<ProfileData>();

  // License options from API
  final licenses = <LicenseOption>[].obs;

  // Image picker
  final profileImage = Rxn<File>();
  final _picker = ImagePicker();

  // Computed getters
  String get fullName => profile.value?.fullName ?? '';
  String get email => profile.value?.email ?? '';
  String get licenseName => profile.value?.licenseType?.licenseName ?? '';
  String get licenseId => profile.value?.licenseType?.id ?? '';
  String get avatarUrl => profile.value?.avatarUrl ?? '';

  String get planName {
    final sub = activeSubscription;
    return sub?.plan.name ?? 'Free';
  }

  String get memberSince {
    final date = profile.value?.createdAt;
    if (date == null) return '';
    return DateFormat("MMM ''yy").format(date);
  }

  ProfileSubscription? get activeSubscription {
    final subs = profile.value?.subscriptions;
    if (subs == null || subs.isEmpty) return null;
    try {
      return subs.firstWhere((s) => s.isActive);
    } catch (_) {
      return subs.first;
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (StorageService.isGuest) init();
  }

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    await fetchProfile();
    fetchLicenses();
  }



  Future<void> fetchProfile() async {
    if (StorageService.isGuest) {
      profile.value = GuestMockData.profile;
      isLoading.value = false;
      return;
    }

    try {
      isLoading.value = true;
      final response =
          await _networkCaller.getRequest(ApiConstants.usersMe);

      if (response.isSuccess) {
        final data = response.responseData['data'];
        profile.value = ProfileData.fromJson(data);
        AppLoggerHelper.info("The Id is: ${profile.value!.id}");
      }
    } catch (e) {
      AppHelperFunctions.showErrorSnackBar('Failed to load profile');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchLicenses() async {
    if (StorageService.isGuest) {
      licenses.value = [
        LicenseOption(id: 'mock-license', name: GuestMockData.guestLicense),
      ];
      return;
    }

    try {
      final response = await _networkCaller
          .getRequest(ApiConstants.categoriesAndTopics);

      if (response.isSuccess) {
        final data = response.responseData['data'];
        final list = data['licenses'] as List;
        licenses.value = list
            .map((l) => LicenseOption(
                  id: l['id'],
                  name: l['license_name'],
                ))
            .toList();
      }
    } catch (_) {}
  }

  Future<void> updateProfile({
    String? name,
    String? licenseOptionId,
  }) async {
    if (StorageService.isGuest) {
      LoginRequiredDialog.show(
        message:
            'Log in to save profile changes and personalize your experience.',
      );
      return;
    }

    try {
      isUpdating.value = true;

      final fields = <String, String>{};
      if (name != null && name.isNotEmpty) fields['fullName'] = name;
      if (licenseOptionId != null) fields['licenseId'] = licenseOptionId;

      final response = await _networkCaller.patchMultipart(
        ApiConstants.updateProfile,
        fields: fields.isNotEmpty ? fields : null,
        filePath: profileImage.value?.path,
        fileField: profileImage.value != null ? 'avatar' : null,
      );

      if (response.isSuccess) {
        AppHelperFunctions.showSuccessSnackBar('Profile updated successfully');
        await fetchProfile();
        try { Get.find<HomeController>().fetchDashboard(); } catch (_) {}
      } else {
        AppHelperFunctions.showErrorSnackBar(
            response.errorMessage.isNotEmpty
                ? response.errorMessage
                : 'Failed to update profile');
      }
    } catch (e) {
      AppHelperFunctions.showErrorSnackBar('Failed to update profile');
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );
    if (picked != null) {
      profileImage.value = File(picked.path);
    }
  }
}
