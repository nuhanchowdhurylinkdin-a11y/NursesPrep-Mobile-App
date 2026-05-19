import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../../profile/controller/profile_controller.dart';
import '../../../profile/model/profile_model.dart';

class BillingHistoryScreen extends GetView<ProfileController> {
  const BillingHistoryScreen({super.key});

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
            'Billing History',
            style: getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
        ),
        body: Obx(() {
          final subs = controller.profile.value?.subscriptions ?? [];

          if (subs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.receipt_disscount,
                      size: 60.sp, color: c.textHint),
                  SizedBox(height: 16.h),
                  Text(
                    'No billing history',
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: c.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Your past transactions will appear here',
                    style: getTextStyle(
                      fontSize: 14,
                      color: c.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.all(16.w),
            itemCount: subs.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (_, index) => _BillingItem(sub: subs[index]),
          );
        }),
      ),
    );
  }
}

class _BillingItem extends StatelessWidget {
  final ProfileSubscription sub;

  const _BillingItem({required this.sub});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final dateFormatted = DateFormat('MMM dd, yyyy').format(sub.startDate);
    final amount = double.tryParse(sub.amount) ?? 0;
    final amountDisplay = amount == 0 ? 'Free' : '\$${sub.amount}';

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: c.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: sub.isActive
                      ? const Color(0xFF0F58BD).withValues(alpha: 0.1)
                      : c.tagBg,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Iconsax.receipt_text,
                  size: 22.sp,
                  color: sub.isActive
                      ? const Color(0xFF0F58BD)
                      : c.textHint,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sub.plan.name,
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: c.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      dateFormatted,
                      style: getTextStyle(
                        fontSize: 13,
                        color: c.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amountDisplay,
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: c.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  _StatusBadge(status: sub.status, isActive: sub.isActive),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(height: 1, color: c.tagBg),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _DetailItem(
                label: 'Plan Type',
                value: sub.plan.planType == 'free'
                    ? 'Free'
                    : sub.plan.planType[0].toUpperCase() +
                        sub.plan.planType.substring(1),
              ),
              _DetailItem(
                label: 'Duration',
                value: '${sub.plan.durationDays} days',
              ),
              _DetailItem(
                label: 'Expires',
                value: DateFormat('MMM dd, yyyy').format(sub.expiryDate),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  final bool isActive;

  const _StatusBadge({required this.status, required this.isActive});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    if (isActive) {
      bgColor = const Color(0xFF10B981).withValues(alpha: 0.1);
      textColor = const Color(0xFF10B981);
    } else if (status == 'expired') {
      bgColor = const Color(0xFFEF4444).withValues(alpha: 0.1);
      textColor = const Color(0xFFEF4444);
    } else {
      bgColor = const Color(0xFF94A3B8).withValues(alpha: 0.1);
      textColor = const Color(0xFF64748B);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        status[0].toUpperCase() + status.substring(1),
        style: getTextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;

  const _DetailItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Column(
      children: [
        Text(
          label,
          style: getTextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: c.textHint,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: getTextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: c.textPrimary,
          ),
        ),
      ],
    );
  }
}
