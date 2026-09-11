import 'package:propmatch_mobile/features/notifications/domain/entities/notification_entity.dart';

abstract class NotificationsRepository {
  Future<NotificationsListResult> getNotifications();
  Future<void> markRead(String id);
  Future<void> markAllRead();
}
