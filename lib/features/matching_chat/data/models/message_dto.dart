import 'package:propmatch_mobile/features/matching_chat/domain/entities/message_entity.dart';

class MessageDto extends MessageEntity {
  const MessageDto({
    required super.id,
    required super.matchConnectionId,
    required super.senderId,
    super.senderName,
    required super.body,
    super.attachmentUrl,
    super.type = MessageType.text,
    required super.createdAt,
  });

  factory MessageDto.fromJson(Map<String, dynamic> json) {
    MessageType type = MessageType.text;
    final typeStr = (json['attachmentType'] ?? json['attachment_type'] ?? '') as String;
    if (typeStr.toUpperCase() == 'IMAGE') type = MessageType.image;
    if (typeStr.toUpperCase() == 'AUDIO') type = MessageType.audio;

    String? senderName;
    if (json['sender'] is Map<String, dynamic>) {
      senderName = (json['sender']['fullName'] ?? json['sender']['full_name']) as String?;
    }

    return MessageDto(
      id: json['id'] as String,
      matchConnectionId: (json['matchConnectionId'] ?? json['match_connection_id']) as String,
      senderId: (json['senderId'] ?? json['sender_id']) as String,
      senderName: senderName,
      body: (json['body'] ?? '') as String,
      attachmentUrl: (json['attachmentUrl'] ?? json['attachment_url']) as String?,
      type: type,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matchConnectionId': matchConnectionId,
      'senderId': senderId,
      'body': body,
      'attachmentUrl': attachmentUrl,
    };
  }
}

class MatchConnectionDto extends MatchConnectionEntity {
  const MatchConnectionDto({
    required super.id,
    required super.tenantId,
    super.tenantName,
    required super.ownerId,
    super.ownerName,
    super.ownerPhone,
    required super.propertyId,
    super.propertyTitle,
    required super.matchScore,
    super.status = ConnectionStatus.interested,
    super.lastMessage,
    super.updatedAt,
  });

  factory MatchConnectionDto.fromJson(Map<String, dynamic> json) {
    ConnectionStatus status = ConnectionStatus.interested;
    final statusStr = (json['status'] ?? json['connectionStatus'] as String?)?.toString().toUpperCase();
    if (statusStr == 'CONNECTED') status = ConnectionStatus.connected;
    if (statusStr == 'REJECTED') status = ConnectionStatus.rejected;

    final id = (json['id'] ?? json['matchConnectionId'] ?? '').toString();
    final otherParticipant = json['otherParticipantName'] as String?;

    String? tenantName = otherParticipant;
    if (json['tenant'] is Map<String, dynamic>) {
      tenantName = (json['tenant']['fullName'] ?? json['tenant']['full_name']) as String?;
    }

    String? ownerName = otherParticipant;
    String? ownerPhone;
    if (json['owner'] is Map<String, dynamic>) {
      ownerName = (json['owner']['fullName'] ?? json['owner']['full_name']) as String?;
      ownerPhone = (json['owner']['phoneNumber'] ?? json['owner']['phone_number']) as String?;
    }

    String? propTitle = (json['propertyTitle'] ?? json['title']) as String?;
    if (json['property'] is Map<String, dynamic>) {
      propTitle = json['property']['title'] as String?;
    }

    MessageDto? lastMsg;
    if (json['messages'] is List && (json['messages'] as List).isNotEmpty) {
      lastMsg = MessageDto.fromJson((json['messages'] as List).first as Map<String, dynamic>);
    } else if (json['lastMessagePreview'] != null) {
      lastMsg = MessageDto(
        id: '',
        matchConnectionId: id,
        senderId: '',
        body: json['lastMessagePreview'].toString(),
        createdAt: json['lastMessageAt'] != null
            ? DateTime.tryParse(json['lastMessageAt'].toString()) ?? DateTime.now()
            : DateTime.now(),
      );
    }

    return MatchConnectionDto(
      id: id,
      tenantId: (json['tenantId'] ?? json['tenant_id'] ?? '').toString(),
      tenantName: tenantName,
      ownerId: (json['ownerId'] ?? json['owner_id'] ?? '').toString(),
      ownerName: ownerName,
      ownerPhone: ownerPhone,
      propertyId: (json['propertyId'] ?? json['property_id'] ?? '').toString(),
      propertyTitle: propTitle,
      matchScore: (json['matchScore'] ?? json['match_score'] ?? 0) as num,
      status: status,
      lastMessage: lastMsg,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : (json['lastMessageAt'] != null
              ? DateTime.tryParse(json['lastMessageAt'].toString())
              : null),
    );
  }
}
