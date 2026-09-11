import 'package:equatable/equatable.dart';
import 'message_entity.dart';

enum ConnectionStatus { interested, connected, rejected }

class MatchConnectionEntity extends Equatable {
  final String id;
  final String tenantId;
  final String? tenantName;
  final String ownerId;
  final String? ownerName;
  final String? ownerPhone;
  final String propertyId;
  final String? propertyTitle;
  final num matchScore;
  final ConnectionStatus status;
  final MessageEntity? lastMessage;
  final DateTime? updatedAt;

  const MatchConnectionEntity({
    required this.id,
    required this.tenantId,
    this.tenantName,
    required this.ownerId,
    this.ownerName,
    this.ownerPhone,
    required this.propertyId,
    this.propertyTitle,
    required this.matchScore,
    this.status = ConnectionStatus.interested,
    this.lastMessage,
    this.updatedAt,
  });

  bool get isConnected => status == ConnectionStatus.connected;

  @override
  List<Object?> get props => [
        id,
        tenantId,
        tenantName,
        ownerId,
        ownerName,
        ownerPhone,
        propertyId,
        propertyTitle,
        matchScore,
        status,
        lastMessage,
        updatedAt,
      ];
}
