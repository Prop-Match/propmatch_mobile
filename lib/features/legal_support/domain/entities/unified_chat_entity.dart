import 'package:equatable/equatable.dart';

enum ChatMode { support, legal }

enum ChatRole { user, assistant }

class UnifiedChatMessage extends Equatable {
  final String id;
  final ChatRole role;
  final String content;
  final bool declined;
  final bool escalated;
  final String? ticketId;
  final List<String> suggestedGuide;
  final String? attachmentUrl;
  final String? attachmentType;
  final String? attachmentName;
  final DateTime createdAt;

  const UnifiedChatMessage({
    required this.id,
    required this.role,
    required this.content,
    this.declined = false,
    this.escalated = false,
    this.ticketId,
    this.suggestedGuide = const [],
    this.attachmentUrl,
    this.attachmentType,
    this.attachmentName,
    required this.createdAt,
  });

  UnifiedChatMessage copyWith({
    String? content,
    bool? declined,
    bool? escalated,
    String? ticketId,
    List<String>? suggestedGuide,
  }) {
    return UnifiedChatMessage(
      id: id,
      role: role,
      content: content ?? this.content,
      declined: declined ?? this.declined,
      escalated: escalated ?? this.escalated,
      ticketId: ticketId ?? this.ticketId,
      suggestedGuide: suggestedGuide ?? this.suggestedGuide,
      attachmentUrl: attachmentUrl,
      attachmentType: attachmentType,
      attachmentName: attachmentName,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [id, role, content, declined, escalated, ticketId, suggestedGuide, createdAt];
}

class TicketSummaryEntity extends Equatable {
  final String id;
  final String subject;
  final String status;
  final String? priority;
  final String? assignedAdminName;
  final String lastMessageAt;
  final String createdAt;

  const TicketSummaryEntity({
    required this.id,
    required this.subject,
    required this.status,
    this.priority,
    this.assignedAdminName,
    required this.lastMessageAt,
    required this.createdAt,
  });

  factory TicketSummaryEntity.fromJson(Map<String, dynamic> json) {
    return TicketSummaryEntity(
      id: json['id'] as String,
      subject: json['subject'] as String? ?? 'تذكرة دعم فني',
      status: json['status'] as String,
      priority: json['priority'] as String?,
      assignedAdminName: json['assignedAdminName'] as String?,
      lastMessageAt: json['lastMessageAt'] as String,
      createdAt: json['createdAt'] as String,
    );
  }

  bool get isOpen => status.toUpperCase() != 'CLOSED';

  @override
  List<Object?> get props => [id, subject, status, lastMessageAt];
}

class TicketDetailEntity extends Equatable {
  final String id;
  final String subject;
  final String status;
  final String? priority;
  final String? assignedAdminName;
  final String? assignedAdminId;
  final String lastMessageAt;
  final String createdAt;
  final List<TicketMessageEntity> messages;

  const TicketDetailEntity({
    required this.id,
    required this.subject,
    required this.status,
    this.priority,
    this.assignedAdminName,
    this.assignedAdminId,
    required this.lastMessageAt,
    required this.createdAt,
    required this.messages,
  });

  factory TicketDetailEntity.fromJson(Map<String, dynamic> json) {
    final msgs = (json['messages'] as List<dynamic>? ?? [])
        .map((e) => TicketMessageEntity.fromJson(e as Map<String, dynamic>))
        .toList();
    return TicketDetailEntity(
      id: json['id'] as String,
      subject: json['subject'] as String? ?? 'تذكرة دعم فني',
      status: json['status'] as String,
      priority: json['priority'] as String?,
      assignedAdminName: json['assignedAdminName'] as String?,
      assignedAdminId: json['assignedAdminId'] as String?,
      lastMessageAt: json['lastMessageAt'] as String,
      createdAt: json['createdAt'] as String,
      messages: msgs,
    );
  }

  @override
  List<Object?> get props => [id, status, messages];
}

class TicketMessageEntity extends Equatable {
  final String id;
  final String authorType;
  final String authorName;
  final String content;
  final bool internal;
  final String? attachmentUrl;
  final String? attachmentType;
  final String? attachmentName;
  final String createdAt;

  const TicketMessageEntity({
    required this.id,
    required this.authorType,
    required this.authorName,
    required this.content,
    this.internal = false,
    this.attachmentUrl,
    this.attachmentType,
    this.attachmentName,
    required this.createdAt,
  });

  factory TicketMessageEntity.fromJson(Map<String, dynamic> json) {
    return TicketMessageEntity(
      id: json['id'] as String,
      authorType: (json['authorType'] ?? json['author'] ?? 'USER').toString(),
      authorName: json['authorName'] as String? ?? '',
      content: json['content'] as String? ?? '',
      internal: json['internal'] as bool? ?? false,
      attachmentUrl: json['attachmentUrl'] as String?,
      attachmentType: json['attachmentType'] as String?,
      attachmentName: json['attachmentName'] as String?,
      createdAt: (json['createdAt'] ?? json['at'] ?? DateTime.now().toIso8601String()) as String,
    );
  }

  bool get isUser => authorType.toLowerCase() == 'user';

  @override
  List<Object?> get props => [id, authorType, content, createdAt];
}

class StreamChunk {
  final String type; // token | done
  final String? value;
  final String? id;
  final bool? declined;
  final bool? escalated;
  final String? ticketId;
  final List<String>? suggestedGuide;

  StreamChunk.token(this.value)
      : type = 'token',
        id = null,
        declined = null,
        escalated = null,
        ticketId = null,
        suggestedGuide = null;

  StreamChunk.done({this.id, this.declined, this.escalated, this.ticketId, this.suggestedGuide})
      : type = 'done',
        value = null;

  factory StreamChunk.fromJson(Map<String, dynamic> json) {
    final t = json['type'] as String;
    if (t == 'token') {
      return StreamChunk.token(json['value'] as String? ?? '');
    }
    return StreamChunk.done(
      id: json['id'] as String?,
      declined: json['declined'] as bool?,
      escalated: json['escalated'] as bool?,
      ticketId: json['ticketId'] as String?,
      suggestedGuide: (json['suggestedGuide'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
    );
  }
}
