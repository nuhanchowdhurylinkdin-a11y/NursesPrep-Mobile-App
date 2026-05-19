import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/api_constants.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../controller/subscription_controller.dart';

class ChangePlanScreen extends GetView<SubscriptionController> {
  const ChangePlanScreen({super.key});

  static const _features = [
    'Unlimited practice questions',
    'Mock exam simulator',
    'Full study library access',
    'Performance analytics & insights',
    'Priority support',
  ];

  @override
  Widget build(BuildContext context) {
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
            child: Icon(
              Icons.arrow_back_ios,
              size: 24.sp,
              color: const Color(0xFF0F58BD),
            ),
          ),
          centerTitle: true,
          title: Text(
            'Choose a Plan',
            style: getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: context.appColors.textPrimary,
            ),
          ),
        ),
        body: Obx(
          () => controller.isActivating.value
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(color: Color(0xFF0F58BD)),
                      SizedBox(height: 16.h),
                      Text(
                        'Activating your subscription…',
                        style: getTextStyle(
                          fontSize: 14,
                          color: context.appColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              : controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : controller.packages.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline,
                                  size: 60.sp,
                                  color: context.appColors.textHint),
                              SizedBox(height: 16.h),
                              Text(
                                'No plans available',
                                style: getTextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: context.appColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              ElevatedButton(
                                onPressed: controller.fetchPackages,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: controller.fetchPackages,
                          color: const Color(0xFF0F58BD),
                          child: ListView(
                            physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics(),
                            ),
                            padding: EdgeInsets.all(16.w),
                            children: [
                              // What's included
                              Text(
                                "What's included",
                                style: getTextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: context.appColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              ..._features.map(
                                (f) => Padding(
                                  padding: EdgeInsets.only(bottom: 6.h),
                                  child: Row(
                                    children: [
                                      Icon(Iconsax.tick_circle,
                                          size: 18.sp,
                                          color: const Color(0xFF0F58BD)),
                                      SizedBox(width: 8.w),
                                      Text(
                                        f,
                                        style: getTextStyle(
                                          fontSize: 13,
                                          color: context.appColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: 16.h),

                              // Plan cards
                              ...controller.packages.map(
                                (pkg) => _PackageCard(
                                  package: pkg,
                                  controller: controller,
                                ),
                              ),

                              SizedBox(height: 4.h),

                              // Restore Purchase
                              Center(
                                child: TextButton(
                                  onPressed: controller.restorePurchase,
                                  child: Text(
                                    'Restore Purchase',
                                    style: getTextStyle(
                                      fontSize: 13,
                                      color: context.appColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 8.h),

                              // Auto-renewal disclosure (Apple required)
                              Text(
                                'Subscription automatically renews unless cancelled at least 24 hours before the end of the current period. Your account will be charged for renewal within 24 hours prior to the end of the current period. You can manage or cancel your subscription in your App Store account settings.',
                                style: getTextStyle(
                                  fontSize: 11,
                                  color: context.appColors.textHint,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              SizedBox(height: 12.h),

                              // Terms & Privacy links (Apple required)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () => launchUrl(
                                      Uri.parse(ApiConstants.termsUrl),
                                      mode: LaunchMode.externalApplication,
                                    ),
                                    child: Text(
                                      'Terms of Use',
                                      style: getTextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF0F58BD),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '  ·  ',
                                    style: getTextStyle(
                                      fontSize: 12,
                                      color: context.appColors.textHint,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => launchUrl(
                                      Uri.parse(ApiConstants.privacyUrl),
                                      mode: LaunchMode.externalApplication,
                                    ),
                                    child: Text(
                                      'Privacy Policy',
                                      style: getTextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF0F58BD),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 24.h),
                            ],
                          ),
                        ),
        ),
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  final Package package;
  final SubscriptionController controller;

  const _PackageCard({
    required this.package,
    required this.controller,
  });

  String _periodLabel(PackageType type) {
    switch (type) {
      case PackageType.weekly:
        return '/ week';
      case PackageType.monthly:
        return '/ month';
      case PackageType.threeMonth:
        return '/ 3 months';
      case PackageType.sixMonth:
        return '/ 6 months';
      case PackageType.annual:
        return '/ year';
      case PackageType.lifetime:
        return 'one-time';
      default:
        return '';
    }
  }

  String _durationText(PackageType type) {
    switch (type) {
      case PackageType.weekly:
        return '1-week subscription';
      case PackageType.monthly:
        return '1-month subscription';
      case PackageType.threeMonth:
        return '3-month subscription';
      case PackageType.sixMonth:
        return '6-month subscription';
      case PackageType.annual:
        return '1-year subscription';
      case PackageType.lifetime:
        return 'Lifetime access';
      default:
        return 'Subscription';
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final product = package.storeProduct;
    final period = _periodLabel(package.packageType);
    final duration = _durationText(package.packageType);

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: c.border, width: 1.w),
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  duration,
                  style: getTextStyle(
                    fontSize: 13,
                    color: c.textSecondary,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      product.priceString,
                      style: getTextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: c.textPrimary,
                      ),
                    ),
                    if (period.isNotEmpty) ...[
                      SizedBox(width: 4.w),
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: Text(
                          period,
                          style: getTextStyle(
                            fontSize: 14,
                            color: c.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (product.description.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    product.description,
                    style: getTextStyle(fontSize: 13, color: c.textSecondary),
                  ),
                ],
              ],
            ),
          ),

          Divider(height: 1, color: c.tagBg),

          // Subscribe button
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Obx(() {
              final loading =
                  controller.checkingOutPlanId.value == package.identifier;
              final anyLoading = controller.checkingOutPlanId.value != null;

              return GestureDetector(
                onTap: anyLoading
                    ? null
                    : () => controller.purchasePackage(package),
                child: Container(
                  width: double.infinity,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F58BD),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  alignment: Alignment.center,
                  child: loading
                      ? SizedBox(
                          width: 24.w,
                          height: 24.w,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Subscribe',
                          style: getTextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
