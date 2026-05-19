import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/login_required_dialog.dart';
import '../../../../core/common/widgets/staggered_fade_in.dart';
import '../../../../core/controller/theme_controller.dart';
import '../../../../core/services/notifications/fcm_token_sync.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/constants/api_constants.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../../../routes/app_routes.dart';
import '../../../main_nav/controller/main_nav_controller.dart';
import '../../controller/profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Obx(() {
        final navController = Get.find<MainNavController>();
        final isLoading = controller.isLoading.value;
        final animate =
            !isLoading && navController.currentIndex.value == 4;
        return RefreshIndicator(
          onRefresh: controller.fetchProfile,
          color: const Color(0xFF0F58BD),
          child: Skeletonizer(
            enabled: isLoading,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              child: Column(
                children: [
                  // Header (static chrome — not animated)
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding:
                        EdgeInsets.fromLTRB(16.w, 50.h, 16.w, 12.h),
                    child: Row(
                      children: [
                        SizedBox(width: 40.w),
                        Expanded(
                          child: Text(
                            'Profile',
                            style: getTextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: c.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: Icon(Iconsax.setting_2,
                              size: 24.sp,
                              color: c.textBody),
                          onSelected: (value) {
                            if (value == 'change_password') {
                              Get.toNamed(
                                  AppRoute.getChangePasswordScreen());
                            } else if (value == 'delete_account') {
                              Get.toNamed(
                                  AppRoute.getDeleteAccountScreen());
                            }
                          },
                          itemBuilder: (_) => [
                            PopupMenuItem(
                              value: 'change_password',
                              child: Row(
                                children: [
                                  Icon(Iconsax.lock_1,
                                      size: 20.sp,
                                      color: c.textBody),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Change Password',
                                    style: getTextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: c.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete_account',
                              child: Row(
                                children: [
                                  Icon(Iconsax.trash,
                                      size: 20.sp,
                                      color: const Color(0xFFDC2626)),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Delete Account',
                                    style: getTextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFFDC2626),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Profile avatar
                  SizedBox(height: 8.h),
                  StaggeredFadeIn(
                    index: 0,
                    enabled: animate,
                    stagger: const Duration(milliseconds: 70),
                    child: _buildAvatar(context),
                  ),
                  SizedBox(height: 12.h),
                  // Name
                  StaggeredFadeIn(
                    index: 1,
                    enabled: animate,
                    stagger: const Duration(milliseconds: 70),
                    child: Text(
                      controller.fullName.isNotEmpty
                          ? controller.fullName
                          : 'Jane Doe, RN',
                      style: getTextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: c.textPrimary,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  // Email
                  StaggeredFadeIn(
                    index: 2,
                    enabled: animate,
                    stagger: const Duration(milliseconds: 70),
                    child: Text(
                      controller.email.isNotEmpty
                          ? controller.email
                          : 'jane@nurseprep.pro',
                      style: getTextStyle(
                        fontSize: 16,
                        color: c.textSecondary,
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Stats grid
                  StaggeredFadeIn(
                    index: 3,
                    enabled: animate,
                    stagger: const Duration(milliseconds: 70),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        children: [
                          _StatCard(
                            icon: Iconsax.teacher,
                            iconColor: const Color(0xFF0F58BD),
                            label: 'License',
                            value: controller.licenseName.isNotEmpty
                                ? controller.licenseName
                                : 'RN',
                          ),
                          SizedBox(width: 8.w),
                          _StatCard(
                            icon: Iconsax.crown_1,
                            iconColor: const Color(0xFFF59E0B),
                            label: 'Plan',
                            value: controller.planName,
                            valueColor: const Color(0xFF0F58BD),
                          ),
                          SizedBox(width: 8.w),
                          _StatCard(
                            icon: Iconsax.calendar_1,
                            iconColor: const Color(0xFF94A3B8),
                            label: 'Member',
                            value: controller.memberSince.isNotEmpty
                                ? controller.memberSince
                                : "Jan '24",
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Account Management header
                  StaggeredFadeIn(
                    index: 4,
                    enabled: animate,
                    stagger: const Duration(milliseconds: 70),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Account Management',
                          style: getTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: c.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Account Management container
                  StaggeredFadeIn(
                    index: 5,
                    enabled: animate,
                    stagger: const Duration(milliseconds: 70),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Container(
                        decoration: BoxDecoration(
                          color: c.cardBg,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          children: [
                            _MenuTile(
                              icon: Iconsax.user,
                              iconBgColor: const Color(0xFF0F58BD),
                              title: 'Edit Profile',
                              onTap: () {
                                if (StorageService.isGuest) {
                                  LoginRequiredDialog.show(
                                    message:
                                        'Log in to edit your profile and personalize your nursing exam prep.',
                                  );
                                  return;
                                }
                                Get.toNamed(AppRoute.getEditProfileScreen());
                              },
                            ),
                            Divider(
                                height: 1,
                                color: c.tagBg),
                            _MenuTile(
                              icon: Iconsax.card,
                              iconBgColor: const Color(0xFF0F58BD),
                              title: 'Account Details',
                              onTap: () {
                                if (StorageService.isGuest) {
                                  LoginRequiredDialog.show(
                                    message:
                                        'Log in to manage your Account Details',
                                  );
                                  return;
                                }
                                Get.toNamed(AppRoute.getSubscriptionScreen());
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Appearance header
                  StaggeredFadeIn(
                    index: 6,
                    enabled: animate,
                    stagger: const Duration(milliseconds: 70),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Appearance',
                          style: getTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: c.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Theme toggle
                  StaggeredFadeIn(
                    index: 7,
                    enabled: animate,
                    stagger: const Duration(milliseconds: 70),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: GetBuilder<ThemeController>(
                        init: Get.find<ThemeController>(),
                        builder: (tc) => Obx(() {
                          // Access .obs value to trigger rebuild
                          final _ = tc.themeMode;
                          return Container(
                            decoration: BoxDecoration(
                              color: c.cardBg,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: _MenuTile(
                              icon: tc.icon,
                              iconBgColor: const Color(0xFF0F58BD),
                              title: 'Theme: ${tc.label}',
                              onTap: tc.toggle,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Support header
                  StaggeredFadeIn(
                    index: 8,
                    enabled: animate,
                    stagger: const Duration(milliseconds: 70),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Support',
                          style: getTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: c.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Support container
                  StaggeredFadeIn(
                    index: 9,
                    enabled: animate,
                    stagger: const Duration(milliseconds: 70),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Container(
                        decoration: BoxDecoration(
                          color: c.cardBg,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          children: [
                            _MenuTile(
                              icon: Iconsax.message_question,
                              iconBgColor: const Color(0xFF64748B),
                              iconBg: c.tagBg,
                              title: 'Help & Support',
                              onTap: () => launchUrl(
                                Uri.parse(ApiConstants.helpCenterUrl),
                                mode: LaunchMode.externalApplication,
                              ),
                            ),
                            Divider(height: 1, color: c.tagBg),
                            _MenuTile(
                              icon: Iconsax.call,
                              iconBgColor: const Color(0xFF64748B),
                              iconBg: c.tagBg,
                              title: 'Contact & Support',
                              onTap: () => launchUrl(
                                Uri.parse(ApiConstants.contactUrl),
                                mode: LaunchMode.externalApplication,
                              ),
                            ),
                            Divider(height: 1, color: c.tagBg),
                            _MenuTile(
                              icon: Iconsax.info_circle,
                              iconBgColor: const Color(0xFF64748B),
                              iconBg: c.tagBg,
                              title: 'About Us',
                              onTap: () => launchUrl(
                                Uri.parse(ApiConstants.aboutUrl),
                                mode: LaunchMode.externalApplication,
                              ),
                            ),
                            Divider(height: 1, color: c.tagBg),
                            _MenuTile(
                              icon: Iconsax.document_text,
                              iconBgColor: const Color(0xFF64748B),
                              iconBg: c.tagBg,
                              title: 'Terms & Conditions',
                              onTap: () => launchUrl(
                                Uri.parse(ApiConstants.termsUrl),
                                mode: LaunchMode.externalApplication,
                              ),
                            ),
                            Divider(height: 1, color: c.tagBg),
                            _MenuTile(
                              icon: Iconsax.shield_tick,
                              iconBgColor: const Color(0xFF64748B),
                              iconBg: c.tagBg,
                              title: 'Privacy Policy',
                              onTap: () => launchUrl(
                                Uri.parse(ApiConstants.privacyUrl),
                                mode: LaunchMode.externalApplication,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Logout
                  StaggeredFadeIn(
                    index: 10,
                    enabled: animate,
                    stagger: const Duration(milliseconds: 70),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: GestureDetector(
                        onTap: () => _showLogoutDialog(context),
                        child: Container(
                          width: double.infinity,
                          height: 56.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Iconsax.logout,
                                  size: 24.sp,
                                  color: const Color(0xFFDC2626)),
                              SizedBox(width: 8.w),
                              Text(
                                'Logout Account',
                                style: getTextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFDC2626),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // Version text
                  StaggeredFadeIn(
                    index: 9,
                    enabled: animate,
                    stagger: const Duration(milliseconds: 70),
                    child: Text(
                      'NursePrep Pro v2.4.1 (Build 402)',
                      style: getTextStyle(
                        fontSize: 12,
                        color: c.textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final c = context.appColors;
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (_) => Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24.w),
          decoration: BoxDecoration(
            color: c.cardBg,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 32.h),
              // Icon
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F58BD).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(Iconsax.logout,
                    size: 36.sp, color: const Color(0xFF0F58BD)),
              ),
              SizedBox(height: 16.h),
              // Title
              Text(
                'Confirm Logout',
                style: getTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                ),
              ),
              SizedBox(height: 16.h),
              // Description
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  'Are you sure you want to log out of NursePrep Pro? You will need to sign back in to access your nursing exam materials and saved progress.',
                  style: getTextStyle(
                    fontSize: 14,
                    color: c.textBody,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 24.h),
              // Buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await FcmTokenSync.clear();
                        await StorageService.logoutUser();
                        Get.offAllNamed(AppRoute.getWelcomeScreen());
                      },
                      child: Container(
                        width: double.infinity,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F58BD),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Log Out',
                          style: getTextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: double.infinity,
                        height: 48.h,
                        alignment: Alignment.center,
                        child: Text(
                          'Cancel',
                          style: getTextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: c.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4.h),
              // Bottom accent bar
              Container(
                width: double.infinity,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F58BD).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(12.r)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final c = context.appColors;
    final url = controller.avatarUrl;

    return CircleAvatar(
      radius: 56.r,
      backgroundColor: c.border,
      backgroundImage: url.isNotEmpty ? NetworkImage(url) : null,
      child: url.isEmpty
          ? Icon(Iconsax.user, size: 48.sp, color: c.textHint)
          : null,
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color? valueColor;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: c.cardBg,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            Icon(icon, size: 24.sp, color: iconColor),
            SizedBox(height: 8.h),
            Text(
              label,
              style: getTextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: c.textHint,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              value,
              style: getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: valueColor ?? c.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color? iconBg;
  final String title;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.iconBgColor,
    this.iconBg,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: iconBg ?? iconBgColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 20.sp, color: iconBgColor),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: c.textPrimary,
                ),
              ),
            ),
            Icon(Iconsax.arrow_right_3,
                size: 18.sp, color: c.textHint),
          ],
        ),
      ),
    );
  }
}
