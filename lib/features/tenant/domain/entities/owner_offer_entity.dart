import 'package:equatable/equatable.dart';
import 'property_entity.dart';

enum OwnerOfferStatus { sent, viewed, accepted, rejected }

class OwnerOfferEntity extends Equatable {
  final String id;
  final String ownerId;
  final String? ownerName;
  final String tenantRequestId;
  final String? propertyId;
  final PropertyEntity? property;
  final String pitchMessage;
  final num proposedPrice;
  final OwnerOfferStatus status;
  final DateTime? createdAt;

  const OwnerOfferEntity({
    required this.id,
    required this.ownerId,
    this.ownerName,
    required this.tenantRequestId,
    this.propertyId,
    this.property,
    required this.pitchMessage,
    required this.proposedPrice,
    this.status = OwnerOfferStatus.sent,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        ownerId,
        ownerName,
        tenantRequestId,
        propertyId,
        property,
        pitchMessage,
        proposedPrice,
        status,
        createdAt,
      ];
}
