import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../../profile/controller/profile_controller.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onCenterTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onCenterTap,
  });

  static const _activeColor = Color(0xFF0F58BD);
  static const _inactiveColor = Color(0xFF9DB2CE);

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    return SizedBox(
      height: 90.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Bar background
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 70.h,
              decoration: BoxDecoration(
                color: c.navBarBg,
                boxShadow: [
                  BoxShadow(
                    color: c.shadow,
                    blurRadius: 10.r,
                    offset: Offset(0, -2.h),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Left items
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _NavItem(
                          activeIcon: Iconsax.home_1,
                          inactiveIcon: Iconsax.home,
                          label: 'Home',
                          isActive: currentIndex == 0,
                          onTap: () => onTap(0),
                        ),
                        _NavItem(
                          activeIcon: Iconsax.book,
                          inactiveIcon: Iconsax.book,
                          label: 'Library',
                          isActive: currentIndex == 1,
                          onTap: () => onTap(1),
                        ),
                      ],
                    ),
                  ),
                  // Center spacer
                  SizedBox(width: 72.w),
                  // Right items
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _NavItem(
                          activeIcon: Iconsax.document_text,
                          inactiveIcon: Iconsax.document_text,
                          label: 'History',
                          isActive: currentIndex == 3,
                          onTap: () => onTap(3),
                        ),
                        _ProfileNavItem(
                          isActive: currentIndex == 4,
                          onTap: () => onTap(4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Center FAB
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: onCenterTap,
                child: Container(
                  width: 72.w,
                  height: 72.w,
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFA9C0FF),
                      width: 2.w,
                    ),
                    color: Color(0xFFA9C0FF),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF0F58BD),
                    ),
                    child: Icon(
                      Iconsax.send_1,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        isActive ? CustomBottomNavBar._activeColor : CustomBottomNavBar._inactiveColor;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : inactiveIcon,
              color: color,
              size: 24.sp,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: getTextStyle(
                fontSize: 12,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileNavItem extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;

  const _ProfileNavItem({required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color =
        isActive ? CustomBottomNavBar._activeColor : CustomBottomNavBar._inactiveColor;
    final profileController = Get.find<ProfileController>();

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() {
              final url = profileController.avatarUrl;
              return Container(
                width: 24.sp,
                height: 24.sp,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: isActive
                      ? Border.all(color: CustomBottomNavBar._activeColor, width: 1.5.w)
                      : null,
                ),
                child: CircleAvatar(
                  radius: 12.sp,
                  backgroundColor: context.appColors.border,
                  backgroundImage:
                      url.isNotEmpty ? NetworkImage(url) : null,
                  child: url.isEmpty
                      ? Icon(Iconsax.user,
                          size: 14.sp, color: context.appColors.textHint)
                      : null,
                ),
              );
            }),
            SizedBox(height: 4.h),
            Text(
              'Profile',
              style: getTextStyle(
                fontSize: 12,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
