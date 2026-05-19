import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/api_constants.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../../../routes/app_routes.dart';
import '../../../profile/controller/profile_controller.dart';

class SubscriptionScreen extends GetView<ProfileController> {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back_ios,
                size: 24.sp, color: const Color(0xFF0F58BD)),
          ),
          centerTitle: true,
          title: Text(
            'Manage Subscription',
            style: getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
          actions: [
            Obx(() => controller.isLoading.value
                ? Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF0F58BD),
                      ),
                    ),
                  )
                : IconButton(
                    onPressed: controller.fetchProfile,
                    icon: Icon(Iconsax.refresh,
                        size: 22.sp, color: const Color(0xFF0F58BD)),
                  )),
          ],
        ),
        body: Obx(() {
          final sub = controller.activeSubscription;

          if (sub == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.card_slash,
                      size: 60.sp, color: c.textHint),
                  SizedBox(height: 16.h),
                  Text(
                    'No active subscription',
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: c.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Upgrade to unlock all features',
                    style: getTextStyle(
                      fontSize: 14,
                      color: c.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          final plan = sub.plan;
          final expiryFormatted =
              DateFormat('MMM dd, yyyy').format(sub.expiryDate);
          final expiryFullFormatted =
              DateFormat('MMMM dd, yyyy').format(sub.expiryDate);
          final priceDisplay =
              '\$${plan.price}/${plan.planType == 'yearly' ? 'year' : 'month'}';

          return RefreshIndicator(
            onRefresh: controller.fetchProfile,
            color: const Color(0xFF0F58BD),
            child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Plan card
                Container(
                  decoration: BoxDecoration(
                    color: c.cardBg,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: c.border),
                  ),
                  child: Column(
                    children: [
                      // Banner
                      Container(
                        height: 144.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12.r)),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0F58BD), Color(0xFF1E7AE8)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: 20.w,
                              top: 20.h,
                              child: Icon(Iconsax.crown_1,
                                  size: 80.sp,
                                  color: Colors.white
                                      .withValues(alpha: 0.15)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(20.w),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.w, vertical: 4.h),
                                    decoration: BoxDecoration(
                                      color: Colors.white
                                          .withValues(alpha: 0.2),
                                      borderRadius:
                                          BorderRadius.circular(4.r),
                                    ),
                                    child: Text(
                                      sub.status.toUpperCase(),
                                      style: getTextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    plan.name,
                                    style: getTextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Plan details
                      Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CURRENT PLAN',
                              style: getTextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F58BD),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '${plan.name} - ${plan.description}',
                              style: getTextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: c.textPrimary,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Next billing: $expiryFormatted',
                                  style: getTextStyle(
                                    fontSize: 14,
                                    color: c.textSecondary,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Get.toNamed(
                                      AppRoute.getChangePlanScreen()),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.w, vertical: 8.h),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0F58BD),
                                      borderRadius:
                                          BorderRadius.circular(8.r),
                                    ),
                                    child: Text(
                                      'Change Plan',
                                      style: getTextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // Billing Details
                Text(
                  'Billing Details',
                  style: getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  decoration: BoxDecoration(
                    color: c.cardBg,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: c.border),
                  ),
                  child: Column(
                    children: [
                      _BillingRow(
                        label: 'Renewal Date',
                        value: expiryFullFormatted,
                        isBold: true,
                      ),
                      Divider(
                          height: 1, color: c.tagBg),
                      _BillingRow(
                        label: 'Renewal Amount',
                        value: priceDisplay,
                        isBold: true,
                      ),
                      Divider(
                          height: 1, color: c.tagBg),
                      _BillingRow(
                        label: 'Subscription ID',
                        value: sub.id.length > 12
                            ? sub.id.substring(0, 12).toUpperCase()
                            : sub.id.toUpperCase(),
                        isBold: false,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // Payment Method
                Text(
                  'Payment Method',
                  style: getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: c.cardBg,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: c.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: c.tagBg,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        alignment: Alignment.center,
                        child: Icon(Iconsax.card,
                            size: 24.sp,
                            color: c.textPrimary),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Apple',
                              style: getTextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: c.textPrimary,
                              ),
                            ),
                            Text(
                              'Managed by Apple In-App-Purches',
                              style: getTextStyle(
                                fontSize: 12,
                                color: c.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Text(
                      //   'Manage',
                      //   style: getTextStyle(
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w700,
                      //     color: c.textHint,
                      //   ),
                      // ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // Action buttons
                _ActionTile(
                  icon: Iconsax.receipt_text,
                  title: 'View Billing History',
                  onTap: () =>
                      Get.toNamed(AppRoute.getBillingHistoryScreen()),
                ),
                SizedBox(height: 8.h),
                _ActionTile(
                  icon: Iconsax.message_question,
                  title: 'Contact Billing Support',
                  onTap: () => launchUrl(
                    Uri.parse(ApiConstants.contactUrl),
                    mode: LaunchMode.externalApplication,
                  ),
                ),

                SizedBox(height: 32.h),

                // Cancel Subscription
                Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Cancel Subscription',
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFEF4444),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    'Canceling your subscription will take effect at the end of your current billing period. You will retain access until then.',
                    style: getTextStyle(
                      fontSize: 10,
                      color: c.textHint,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
          );
        }),
      ),
    );
  }
}

class _BillingRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _BillingRow({
    required this.label,
    required this.value,
    required this.isBold,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: c.textSecondary,
            ),
          ),
          Text(
            value,
            style: getTextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
              color: c.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 17.h),
        decoration: BoxDecoration(
          color: c.cardBg,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: c.border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24.sp, color: c.textSecondary),
            SizedBox(width: 9.w),
            Expanded(
              child: Text(
                title,
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                ),
              ),
            ),
            Icon(Iconsax.arrow_right_3,
                size: 24.sp, color: c.textHint),
          ],
        ),
      ),
    );
  }
}
