import 'package:equatable/equatable.dart';

enum TenantRequestStatus { pending, approved, rejected, fulfilled, closed }

class TenantRequestEntity extends Equatable {
  final String id;
  final String? tenantId;
  final String? tenantName;
  final num minBudget;
  final num maxBudget;
  final String preferredLocations;
  final String propertyType;
  final int requiredBedrooms;
  final bool needsFurnished;
  final int flexibilityScore;
  final String lifestyleRequirements;
  final TenantRequestStatus status;
  final DateTime? createdAt;
  final int offersCount;
  final double? matchScore; // Computed when viewed by landlord

  const TenantRequestEntity({
    required this.id,
    this.tenantId,
    this.tenantName,
    required this.minBudget,
    required this.maxBudget,
    required this.preferredLocations,
    this.propertyType = 'APARTMENT',
    required this.requiredBedrooms,
    required this.needsFurnished,
    this.flexibilityScore = 5,
    required this.lifestyleRequirements,
    this.status = TenantRequestStatus.pending,
    this.createdAt,
    this.offersCount = 0,
    this.matchScore,
  });

  @override
  List<Object?> get props => [
        id,
        tenantId,
        tenantName,
        minBudget,
        maxBudget,
        preferredLocations,
        propertyType,
        requiredBedrooms,
        needsFurnished,
        flexibilityScore,
        lifestyleRequirements,
        status,
        createdAt,
        offersCount,
        matchScore,
      ];
}
