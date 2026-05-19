import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../core/utils/helpers/app_helper.dart';
import '../../profile/controller/profile_controller.dart';

class SubscriptionController extends GetxController {
  final isLoading = true.obs;
  final isActivating = false.obs;
  final checkingOutPlanId = RxnString();
  final packages = <Package>[].obs;

  static const _pollInterval = Duration(seconds: 3);
  static const _pollTimeout = Duration(seconds: 30);

  @override
  void onInit() {
    super.onInit();
    fetchPackages();
  }

  Future<void> fetchPackages() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(milliseconds: 500));
      final offerings = await Purchases.getOfferings();
      packages.value = offerings.current?.availablePackages ?? [];
    } catch (e) {
      AppHelperFunctions.showErrorSnackBar('Failed to load plans');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> purchasePackage(Package package) async {
    try {
      checkingOutPlanId.value = package.identifier;
      final result = await Purchases.purchasePackage(package);
      final isActive = result.customerInfo.entitlements.active.containsKey('pro');

      if (isActive) {
        await _activateAndNavigate();
      }
    } on PurchasesErrorCode catch (e) {
      if (e != PurchasesErrorCode.purchaseCancelledError) {
        AppHelperFunctions.showErrorSnackBar('Purchase failed');
      }
    } catch (e) {
      AppHelperFunctions.showErrorSnackBar('Something went wrong');
    } finally {
      checkingOutPlanId.value = null;
    }
  }

  Future<void> restorePurchase() async {
    try {
      isLoading.value = true;
      final info = await Purchases.restorePurchases();
      final isActive = info.entitlements.active.containsKey('pro');

      if (isActive) {
        await _activateAndNavigate(isRestore: true);
      } else {
        AppHelperFunctions.showErrorSnackBar('No active purchase found');
      }
    } catch (e) {
      AppHelperFunctions.showErrorSnackBar('Restore failed');
    } finally {
      isLoading.value = false;
    }
  }

  /// Polls the backend until the profile reflects a paid subscription,
  /// then navigates back. Gives up after [_pollTimeout] and still navigates.
  Future<void> _activateAndNavigate({bool isRestore = false}) async {
    isActivating.value = true;
    try {
      final activated = await _pollUntilPro();
      if (activated) {
        AppHelperFunctions.showSuccessSnackBar(
          isRestore ? 'Purchase restored successfully.' : 'Subscription activated successfully.',
        );
      } else {
        // Webhook delayed — navigate anyway; user can pull-to-refresh
        AppHelperFunctions.showSuccessSnackBar(
          'Purchase successful! Subscription activating — pull to refresh.',
        );
      }
      Get.back(result: true);
    } finally {
      isActivating.value = false;
    }
  }

  /// Returns true if the backend confirmed a paid plan within [_pollTimeout].
  Future<bool> _pollUntilPro() async {
    final profileController = Get.find<ProfileController>();
    final deadline = DateTime.now().add(_pollTimeout);

    while (DateTime.now().isBefore(deadline)) {
      try {
        await profileController.fetchProfile();
        if (_hasPaidSubscription(profileController)) return true;
      } catch (_) {}
      await Future.delayed(_pollInterval);
    }
    return false;
  }

  bool _hasPaidSubscription(ProfileController profileController) {
    final sub = profileController.activeSubscription;
    if (sub == null) return false;
    final planType = sub.plan.planType.toLowerCase();
    return planType != 'free' && planType != 'trial' && planType.isNotEmpty;
  }
}
