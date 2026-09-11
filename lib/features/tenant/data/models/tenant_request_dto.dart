import '../../domain/entities/tenant_request_entity.dart';

class TenantRequestDto extends TenantRequestEntity {
  const TenantRequestDto({
    required super.id,
    super.tenantId,
    super.tenantName,
    required super.minBudget,
    required super.maxBudget,
    required super.preferredLocations,
    super.propertyType = 'APARTMENT',
    required super.requiredBedrooms,
    required super.needsFurnished,
    super.flexibilityScore = 5,
    required super.lifestyleRequirements,
    super.status = TenantRequestStatus.pending,
    super.createdAt,
    super.offersCount = 0,
    super.matchScore,
  });

  factory TenantRequestDto.fromJson(Map<String, dynamic> json) {
    TenantRequestStatus status = TenantRequestStatus.pending;
    final statusStr = (json['status'] as String?)?.toUpperCase();
    if (statusStr == 'APPROVED') status = TenantRequestStatus.approved;
    if (statusStr == 'REJECTED') status = TenantRequestStatus.rejected;
    if (statusStr == 'FULFILLED') status = TenantRequestStatus.fulfilled;
    if (statusStr == 'CLOSED') status = TenantRequestStatus.closed;

    String? tenantName;
    if (json['tenant'] is Map<String, dynamic>) {
      tenantName = (json['tenant']['fullName'] ?? json['tenant']['full_name']) as String?;
    }

    int offersCount = 0;
    if (json['ownerOffers'] is List) {
      offersCount = (json['ownerOffers'] as List).length;
    } else if (json['_count'] is Map<String, dynamic> && json['_count']['ownerOffers'] != null) {
      offersCount = json['_count']['ownerOffers'] as int;
    }

    return TenantRequestDto(
      id: json['id'] as String,
      tenantId: (json['tenantId'] ?? json['tenant_id']) as String?,
      tenantName: tenantName,
      minBudget: (json['minBudget'] ?? json['min_budget'] ?? 0) as num,
      maxBudget: (json['maxBudget'] ?? json['max_budget'] ?? 0) as num,
      preferredLocations: (json['preferredLocations'] ?? json['preferred_locations'] ?? '') as String,
      propertyType: (json['propertyType'] ?? json['property_type'] ?? 'APARTMENT') as String,
      requiredBedrooms: (json['requiredBedrooms'] ?? json['required_bedrooms'] ?? 1) as int,
      needsFurnished: (json['needsFurnished'] ?? json['needs_furnished'] ?? false) as bool,
      flexibilityScore: (json['flexibilityScore'] ?? json['flexibility_score'] ?? 5) as int,
      lifestyleRequirements: (json['lifestyleRequirements'] ?? json['lifestyle_requirements'] ?? '') as String,
      status: status,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
      offersCount: offersCount,
      matchScore: json['matchScore'] != null ? (json['matchScore'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minBudget': minBudget,
      'maxBudget': maxBudget,
      'preferredLocations': preferredLocations,
      'propertyType': propertyType,
      'requiredBedrooms': requiredBedrooms,
      'needsFurnished': needsFurnished,
      'flexibilityScore': flexibilityScore,
      'lifestyleRequirements': lifestyleRequirements,
    };
  }
}
