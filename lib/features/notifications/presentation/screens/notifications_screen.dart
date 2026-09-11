import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:propmatch_mobile/core/constants/app_constants.dart';
import 'package:propmatch_mobile/core/di/injection_container.dart';
import 'package:propmatch_mobile/core/theme/app_colors.dart';
import 'package:propmatch_mobile/features/notifications/domain/entities/notification_entity.dart';
import 'package:propmatch_mobile/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:propmatch_mobile/features/notifications/presentation/cubit/notifications_cubit.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          NotificationsCubit(repository: sl<NotificationsRepository>())..fetchNotifications(),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  IconData _getIconForType(String type) {
    switch (type) {
      case 'MATCH_FOUND':
      case 'MATCH':
        return LucideIcons.sparkles;
      case 'OFFER_RECEIVED':
      case 'OFFER':
        return LucideIcons.badge_percent;
      case 'CONTRACT_UPDATED':
      case 'CONTRACT':
        return LucideIcons.file_text;
      case 'VERIFICATION':
        return LucideIcons.shield_check;
      default:
        return LucideIcons.bell;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 60) {
      return diff.inMinutes <= 1 ? 'الآن' : 'منذ ${diff.inMinutes} دقيقة';
    } else if (diff.inHours < 24) {
      return 'منذ ${diff.inHours} ساعة';
    } else if (diff.inDays < 7) {
      return 'منذ ${diff.inDays} يوم';
    } else {
      return DateFormat('yyyy/MM/dd').format(date);
    }
  }

  void _handleNotificationTap(BuildContext context, NotificationEntity notification) {
    context.read<NotificationsCubit>().markRead(notification.id);

    if (notification.link != null && notification.link!.isNotEmpty) {
      final link = notification.link!;
      if (link.startsWith('/')) {
        context.push(link);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مركز الإشعارات'),
        actions: [
          BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, state) {
              final unread = state is NotificationsLoaded ? state.unreadCount : 0;
              if (unread == 0) return const SizedBox.shrink();
              return TextButton.icon(
                icon: const Icon(LucideIcons.check_check, size: 18),
                label: const Text('تحديد الكل كمقروء'),
                onPressed: () {
                  context.read<NotificationsCubit>().markAllRead();
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingLg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.circle_alert, size: 48, color: AppColors.error),
                    const SizedBox(height: AppConstants.paddingMd),
                    const Text('تعذر تحميل الإشعارات'),
                    const SizedBox(height: AppConstants.paddingMd),
                    ElevatedButton(
                      onPressed: () => context.read<NotificationsCubit>().fetchNotifications(),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is NotificationsLoaded) {
            if (state.notifications.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingLg),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.primaryTint,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(LucideIcons.bell_off, size: 48, color: AppColors.primary),
                      ),
                      const SizedBox(height: AppConstants.paddingLg),
                      const Text(
                        'لا توجد إشعارات حالياً',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'ستظهر هنا جميع الإشعارات المتعلقة بالمطابقات والعروض والعقود.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<NotificationsCubit>().fetchNotifications(),
              child: ListView.separated(
                padding: const EdgeInsets.all(AppConstants.paddingMd),
                itemCount: state.notifications.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = state.notifications[index];
                  final isRead = item.isRead;

                  return Card(
                    elevation: 0,
                    color: isRead ? Colors.white : AppColors.primaryTint.withValues(alpha: 0.35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                      side: BorderSide(
                        color: isRead ? AppColors.border : AppColors.primary.withValues(alpha: 0.3),
                        width: isRead ? 1 : 1.5,
                      ),
                    ),
                    child: InkWell(
                      onTap: () => _handleNotificationTap(context, item),
                      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                      child: Padding(
                        padding: const EdgeInsets.all(AppConstants.paddingMd),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: isRead
                                  ? AppColors.background
                                  : AppColors.primaryTint,
                              child: Icon(
                                _getIconForType(item.type),
                                color: isRead ? AppColors.textMuted : AppColors.primary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
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
                                          style: TextStyle(
                                            fontWeight: isRead ? FontWeight.w600 : FontWeight.bold,
                                            fontSize: 14,
                                            color: isRead ? AppColors.textPrimary : AppColors.primaryDark,
                                          ),
                                        ),
                                      ),
                                      if (!isRead)
                                        Container(
                                          width: 8,
                                          height: 8,
                                          margin: const EdgeInsets.only(right: 6),
                                          decoration: const BoxDecoration(
                                            color: AppColors.primary,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.message,
                                    style: TextStyle(
                                      color: isRead ? AppColors.textSecondary : AppColors.textPrimary,
                                      fontSize: 12,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    _formatDate(item.createdAt),
                                    style: const TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 11,
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
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
