import '../../domain/entities/owner_offer_entity.dart';
import 'property_dto.dart';

class OwnerOfferDto extends OwnerOfferEntity {
  const OwnerOfferDto({
    required super.id,
    required super.ownerId,
    super.ownerName,
    required super.tenantRequestId,
    super.propertyId,
    super.property,
    required super.pitchMessage,
    required super.proposedPrice,
    super.status = OwnerOfferStatus.sent,
    super.createdAt,
  });

  factory OwnerOfferDto.fromJson(Map<String, dynamic> json) {
    OwnerOfferStatus status = OwnerOfferStatus.sent;
    final statusStr = (json['status'] as String?)?.toUpperCase();
    if (statusStr == 'VIEWED') status = OwnerOfferStatus.viewed;
    if (statusStr == 'ACCEPTED') status = OwnerOfferStatus.accepted;
    if (statusStr == 'REJECTED') status = OwnerOfferStatus.rejected;

    PropertyDto? property;
    if (json['property'] is Map<String, dynamic>) {
      property = PropertyDto.fromJson(json['property'] as Map<String, dynamic>);
    }

    String? ownerName;
    if (json['owner'] is Map<String, dynamic>) {
      ownerName = (json['owner']['fullName'] ?? json['owner']['full_name']) as String?;
    }

    return OwnerOfferDto(
      id: json['id'] as String,
      ownerId: (json['ownerId'] ?? json['owner_id']) as String,
      ownerName: ownerName,
      tenantRequestId: (json['tenantRequestId'] ?? json['tenant_request_id']) as String,
      propertyId: (json['propertyId'] ?? json['property_id']) as String?,
      property: property,
      pitchMessage: (json['pitchMessage'] ?? json['pitch_message'] ?? '') as String,
      proposedPrice: (json['proposedPrice'] ?? json['proposed_price'] ?? 0) as num,
      status: status,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
    );
  }
}
