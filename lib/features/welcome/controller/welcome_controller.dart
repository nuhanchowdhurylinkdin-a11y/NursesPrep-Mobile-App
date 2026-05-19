import 'package:get/get.dart';

import '../../../core/services/storage_service.dart';
import '../../../routes/app_routes.dart';

class WelcomeController extends GetxController {
  Future<void> onViewAsGuest() async {
    await StorageService.enterGuestMode();
    Get.offAllNamed(AppRoute.getHomeScreen());
  }

  void onCreateAccount() {
    Get.toNamed(AppRoute.getSignUpScreen());
  }

  void onLogin() {
    Get.toNamed(AppRoute.getLoginScreen());
  }
}
