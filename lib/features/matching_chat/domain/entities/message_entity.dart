import 'package:equatable/equatable.dart';

export 'match_connection_entity.dart';

enum MessageType { text, image, audio }

class MessageEntity extends Equatable {
  final String id;
  final String matchConnectionId;
  final String senderId;
  final String? senderName;
  final String body;
  final String? attachmentUrl;
  final MessageType type;
  final DateTime createdAt;

  const MessageEntity({
    required this.id,
    required this.matchConnectionId,
    required this.senderId,
    this.senderName,
    required this.body,
    this.attachmentUrl,
    this.type = MessageType.text,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        matchConnectionId,
        senderId,
        senderName,
        body,
        attachmentUrl,
        type,
        createdAt,
      ];
}
