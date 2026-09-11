import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:propmatch_mobile/core/theme/app_colors.dart';
import 'package:propmatch_mobile/core/constants/app_constants.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'title': 'عرض إيجار جديد!',
        'body': 'قدم مالك عقار في حي الجامعة عرضاً بخصوص طلبك السكني بقيمة 7,500 ج.م',
        'time': 'منذ 15 دقيقة',
        'isRead': false,
        'icon': LucideIcons.sparkles,
      },
      {
        'title': 'تم كشف بيانات الاتصال',
        'body': 'تمت الموافقة على المطابقة بنجاح. يمكنك الآن الاتصال بالمالك مباشرة.',
        'time': 'منذ ساعتين',
        'isRead': true,
        'icon': LucideIcons.lock_open,
      },
      {
        'title': 'تحديث مسودة العقد',
        'body': 'قام المالك بتجهيز مسودة عقد الإيجار الإلكتروني وهي بانتظار مراجعتك.',
        'time': 'منذ يوم',
        'isRead': true,
        'icon': LucideIcons.file_text,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('مركز الإشعارات'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppConstants.paddingMd),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final item = notifications[index];
          final isRead = item['isRead'] as bool;

          return Card(
            elevation: 0,
            color: isRead ? Colors.white : AppColors.accent.withValues(alpha: 0.04),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              side: BorderSide(
                color: isRead ? AppColors.border : AppColors.accent.withValues(alpha: 0.3),
              ),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: isRead ? AppColors.background : AppColors.accent.withValues(alpha: 0.1),
                child: Icon(item['icon'] as IconData, color: isRead ? AppColors.textSecondary : AppColors.accent, size: 20),
              ),
              title: Text(
                item['title'] as String,
                style: TextStyle(
                  fontWeight: isRead ? FontWeight.w600 : FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    item['body'] as String,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.4),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['time'] as String,
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
