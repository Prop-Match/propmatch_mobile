import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propmatch_mobile/features/notifications/domain/entities/notification_entity.dart';
import 'package:propmatch_mobile/features/notifications/domain/repositories/notifications_repository.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();
  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationEntity> notifications;
  final int unreadCount;

  const NotificationsLoaded({
    required this.notifications,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [notifications, unreadCount];
}

class NotificationsError extends NotificationsState {
  final String message;
  const NotificationsError(this.message);

  @override
  List<Object?> get props => [message];
}

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository repository;

  NotificationsCubit({required this.repository}) : super(NotificationsInitial());

  Future<void> fetchNotifications() async {
    emit(NotificationsLoading());
    try {
      final result = await repository.getNotifications();
      emit(NotificationsLoaded(
        notifications: result.items,
        unreadCount: result.unread,
      ));
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }

  Future<void> markRead(String id) async {
    if (state is! NotificationsLoaded) return;
    final current = state as NotificationsLoaded;

    final updated = current.notifications.map((n) {
      if (n.id == id && !n.isRead) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();

    final newUnread = updated.where((n) => !n.isRead).length;
    emit(NotificationsLoaded(notifications: updated, unreadCount: newUnread));

    try {
      await repository.markRead(id);
    } catch (_) {
      // Best effort sync
    }
  }

  Future<void> markAllRead() async {
    if (state is! NotificationsLoaded) return;
    final current = state as NotificationsLoaded;

    final updated = current.notifications.map((n) => n.copyWith(isRead: true)).toList();
    emit(NotificationsLoaded(notifications: updated, unreadCount: 0));

    try {
      await repository.markAllRead();
    } catch (_) {
      // Best effort sync
    }
  }
}
