import 'package:propmatch_mobile/core/constants/api_endpoints.dart';
import 'package:propmatch_mobile/core/network/dio_client.dart';
import 'package:propmatch_mobile/features/notifications/domain/entities/notification_entity.dart';

abstract class NotificationsRemoteDataSource {
  Future<NotificationsListResult> getNotifications();
  Future<void> markRead(String id);
  Future<void> markAllRead();
}

class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  final DioClient client;

  NotificationsRemoteDataSourceImpl(this.client);

  @override
  Future<NotificationsListResult> getNotifications() async {
    final response = await client.get<Map<String, dynamic>>(
      ApiEndpoints.notifications,
      forceRefresh: true,
    );
    return NotificationsListResult.fromJson(response.data ?? {});
  }

  @override
  Future<void> markRead(String id) async {
    await client.post<Map<String, dynamic>>(
      '${ApiEndpoints.notifications}/$id/read',
    );
  }

  @override
  Future<void> markAllRead() async {
    await client.post<Map<String, dynamic>>(
      '${ApiEndpoints.notifications}/read-all',
    );
  }
}
