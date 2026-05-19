import 'package:get/get.dart';

import '../../../core/common/widgets/license_required_dialog.dart';

class MainNavController extends GetxController {
  final RxInt currentIndex = 0.obs;
  final RxSet<int> visitedTabs = <int>{0}.obs;

  static const _licenseRequiredIndices = {1, 2, 3};

  void changePage(int index) {
    if (_licenseRequiredIndices.contains(index)) {
      if (!LicenseRequiredDialog.checkAndProceed()) return;
    }
    visitedTabs.add(index);
    currentIndex.value = index;
  }
}
