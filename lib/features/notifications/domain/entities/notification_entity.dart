import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String type;
  final String title;
  final String message;
  final String? link;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.link,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationEntity.fromJson(Map<String, dynamic> json) {
    return NotificationEntity(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? 'GENERAL',
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      link: json['link'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  NotificationEntity copyWith({
    String? id,
    String? type,
    String? title,
    String? message,
    String? link,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      link: link ?? this.link,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, type, title, message, link, isRead, createdAt];
}

class NotificationsListResult extends Equatable {
  final List<NotificationEntity> items;
  final int unread;

  const NotificationsListResult({
    required this.items,
    required this.unread,
  });

  factory NotificationsListResult.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    return NotificationsListResult(
      items: rawItems
          .map((i) => NotificationEntity.fromJson(i as Map<String, dynamic>))
          .toList(),
      unread: json['unread'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [items, unread];
}
