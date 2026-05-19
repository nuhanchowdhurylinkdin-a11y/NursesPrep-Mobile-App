import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../home/views/screens/home_screen.dart';
import '../../../exam_history/views/screens/exam_history_screen.dart';
import '../../../library/views/screens/library_screen.dart';
import '../../../practice/views/screens/mode_selection_screen.dart';
import '../../../profile/views/screens/profile_screen.dart';
import '../../controller/main_nav_controller.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class MainNavScreen extends GetView<MainNavController> {
  const MainNavScreen({super.key});

  static const _screens = <int, Widget>{
    0: HomeScreen(),
    1: LibraryScreen(),
    2: ModeSelectionScreen(),
    3: ExamHistoryScreen(),
    4: ProfileScreen(),
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        body: Obx(
          () => IndexedStack(
            index: controller.currentIndex.value,
            children: List.generate(5, (i) {
              if (controller.visitedTabs.contains(i)) {
                return _screens[i]!;
              }
              return const SizedBox.shrink();
            }),
          ),
        ),
        bottomNavigationBar: Obx(
          () => CustomBottomNavBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changePage,
            onCenterTap: () => controller.changePage(2),
          ),
        ),
      ),
    );
  }
}
