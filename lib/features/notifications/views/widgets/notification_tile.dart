import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/services/notifications/notification_router.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../controller/notifications_controller.dart';
import '../../model/notification_model.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel item;
  final NotificationsController controller;

  const NotificationTile({
    super.key,
    required this.item,
    required this.controller,
  });

  IconData _iconForType(String type) {
    switch (type) {
      case 'payment_success':
      case 'payment_failed':
        return Iconsax.card;
      case 'refund_processed':
        return Iconsax.money_recive;
      case 'trial_ending':
        return Iconsax.alarm;
      case 'promotion':
        return Iconsax.gift;
      case 'feature_update':
        return Iconsax.star;
      default:
        return Iconsax.notification;
    }
  }

  Color _colorForType(String type) {
    switch (type) {
      case 'payment_success':
        return const Color(0xFF16A34A);
      case 'payment_failed':
        return const Color(0xFFDC2626);
      case 'refund_processed':
        return const Color(0xFFEA580C);
      case 'trial_ending':
        return const Color(0xFFCA8A04);
      case 'promotion':
        return const Color(0xFF9333EA);
      case 'feature_update':
      default:
        return const Color(0xFF0F58BD);
    }
  }

  String _timeAgo(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final color = _colorForType(item.type);
    final bg = color.withValues(alpha: 0.12);
    final unread = !item.isRead;

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: const Color(0xFFDC2626),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => controller.deleteOne(item.id),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: () {
          controller.markAsRead(item.id);
          NotificationRouter.route({
            'type': item.type,
            ...item.data,
          });
        },
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: c.cardBg,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: c.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      _iconForType(item.type),
                      size: 24.sp,
                      color: color,
                    ),
                  ),
                  if (unread)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F58BD),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: getTextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: c.textPrimary,
                            ),
                          ),
                        ),
                        Text(
                          _timeAgo(item.createdAt),
                          style: getTextStyle(
                            fontSize: 12,
                            color: c.textHint,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      item.body,
                      style: getTextStyle(
                        fontSize: 12,
                        color: c.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
