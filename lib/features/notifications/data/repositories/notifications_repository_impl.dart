import 'package:propmatch_mobile/features/notifications/data/datasources/notifications_remote_datasource.dart';
import 'package:propmatch_mobile/features/notifications/domain/entities/notification_entity.dart';
import 'package:propmatch_mobile/features/notifications/domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;

  NotificationsRepositoryImpl(this.remoteDataSource);

  @override
  Future<NotificationsListResult> getNotifications() {
    return remoteDataSource.getNotifications();
  }

  @override
  Future<void> markRead(String id) {
    return remoteDataSource.markRead(id);
  }

  @override
  Future<void> markAllRead() {
    return remoteDataSource.markAllRead();
  }
}
