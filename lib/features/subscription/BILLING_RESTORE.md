# Billing & Payment UI - Restore Guide

These sections were removed from `subscription_screen.dart` to pass Apple/Google app store review. Add them back when ready to enable billing UI.

---

## 1. Add Import

```dart
import '../../../../routes/app_routes.dart';
```

## 2. Add Variables (inside the `Obx` builder, after `final plan = sub.plan;`)

```dart
final expiryFormatted = DateFormat('MMM dd, yyyy').format(sub.expiryDate);
final priceDisplay = '\$${plan.price}/${plan.planType == 'yearly' ? 'year' : 'month'}';
```

## 3. Change Plan Button (was inside the Current Plan card, after the plan name)

Add this after the `'${plan.name} - ${plan.description}'` Text widget:

```dart
SizedBox(height: 12.h),
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text(
      'Next billing: $expiryFormatted',
      style: getTextStyle(
        fontSize: 14,
        color: c.textSecondary,
      ),
    ),
    GestureDetector(
      onTap: () => Get.toNamed(AppRoute.getChangePlanScreen()),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: const Color(0xFF0F58BD),
          borderRadius: BorderRadius.circular(8.r),
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
```

## 4. Billing Details Section (add after the Plan Benefits section)

```dart
SizedBox(height: 24.h),

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
      _BillingRow(label: 'Renewal Date', value: expiryFullFormatted, isBold: true),
      Divider(height: 1, color: c.tagBg),
      _BillingRow(label: 'Renewal Amount', value: priceDisplay, isBold: true),
      Divider(height: 1, color: c.tagBg),
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
```

## 5. Payment Method Section

```dart
SizedBox(height: 24.h),

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
        child: Icon(Iconsax.card, size: 24.sp, color: c.textPrimary),
      ),
      SizedBox(width: 12.w),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Stripe', style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: c.textPrimary)),
            Text('Managed by Stripe', style: getTextStyle(fontSize: 12, color: c.textSecondary)),
          ],
        ),
      ),
      Text('Manage', style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: c.textHint)),
    ],
  ),
),
```

## 6. Action Buttons (Billing History & Billing Support)

```dart
SizedBox(height: 24.h),

_ActionTile(
  icon: Iconsax.receipt_text,
  title: 'View Billing History',
  onTap: () => Get.toNamed(AppRoute.getBillingHistoryScreen()),
),
SizedBox(height: 8.h),
_ActionTile(
  icon: Iconsax.message_question,
  title: 'Contact Billing Support',
  onTap: () => launchUrl(
    Uri.parse('https://www.nursesprep.com/contact'),
    mode: LaunchMode.externalApplication,
  ),
),
```

## 7. Cancel Subscription

```dart
SizedBox(height: 32.h),

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
    style: getTextStyle(fontSize: 10, color: c.textHint),
    textAlign: TextAlign.center,
  ),
),
```

## 8. _BillingRow Widget (add at bottom of file, before closing)

```dart
class _BillingRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _BillingRow({required this.label, required this.value, required this.isBold});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: c.textSecondary)),
          Text(value, style: getTextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.w700 : FontWeight.w400, color: c.textPrimary)),
        ],
      ),
    );
  }
}
```

## Existing Files (already in codebase)

- `lib/features/subscription/views/screens/change_plan_screen.dart`
- `lib/features/subscription/views/screens/billing_history_screen.dart`
- Routes already registered in `lib/routes/app_routes.dart`
