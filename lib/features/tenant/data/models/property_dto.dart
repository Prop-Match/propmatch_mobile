import '../../domain/entities/property_entity.dart';

class PropertyDto extends PropertyEntity {
  const PropertyDto({
    required super.id,
    required super.title,
    required super.description,
    required super.rentAmount,
    required super.areaM2,
    required super.bedrooms,
    required super.bathrooms,
    required super.isFurnished,
    required super.hasElevator,
    required super.hasParking,
    required super.district,
    super.cityName,
    super.governorateName,
    super.manualAddress,
    super.coverImageUrl,
    super.images = const [],
    super.isBoosted = false,
    super.matchScore,
    super.matchBreakdown,
    super.ownerId,
    super.ownerName,
    super.ownerPhone,
    super.isOwnerVerified = false,
    super.contactRevealed = false,
    super.isFavorite = false,
  });

  factory PropertyDto.fromJson(Map<String, dynamic> json) {
    // Images parsing
    List<String> imageList = [];
    String? coverUrl;
    if (json['propertyImages'] is List) {
      for (var img in (json['propertyImages'] as List)) {
        if (img is Map<String, dynamic> && img['imageUrl'] != null) {
          final url = img['imageUrl'].toString();
          imageList.add(url);
          if (img['isCover'] == true && coverUrl == null) {
            coverUrl = url;
          }
        }
      }
    }
    if (coverUrl == null && imageList.isNotEmpty) {
      coverUrl = imageList.first;
    }

    // Owner details
    String? ownerId;
    String? ownerName;
    String? ownerPhone;
    bool isOwnerVerified = false;
    if (json['owner'] is Map<String, dynamic>) {
      final owner = json['owner'] as Map<String, dynamic>;
      ownerId = owner['id'] as String?;
      ownerName = (owner['fullName'] ?? owner['full_name']) as String?;
      ownerPhone = (owner['phoneNumber'] ?? owner['phone_number']) as String?;
      if (owner['identityVerification'] != null &&
          owner['identityVerification']['status'] == 'APPROVED') {
        isOwnerVerified = true;
      }
    }

    // Locations
    String? cityName;
    if (json['city'] is Map<String, dynamic>) {
      cityName = json['city']['nameAr'] as String?;
    }
    String? govName;
    if (json['governorate'] is Map<String, dynamic>) {
      govName = json['governorate']['nameAr'] as String?;
    }

    // Match score
    double? matchScore;
    if (json['matchScore'] != null) {
      matchScore = (json['matchScore'] as num).toDouble();
    } else if (json['match_score'] != null) {
      matchScore = (json['match_score'] as num).toDouble();
    }

    return PropertyDto(
      id: json['id'] as String,
      title: (json['title'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      rentAmount: (json['rentAmount'] ?? json['rent_amount'] ?? 0) as num,
      areaM2: (json['areaM2'] ?? json['area_m2'] ?? 0) as num,
      bedrooms: (json['bedrooms'] ?? 0) as int,
      bathrooms: (json['bathrooms'] ?? 0) as int,
      isFurnished: (json['isFurnished'] ?? json['is_furnished'] ?? false) as bool,
      hasElevator: (json['hasElevator'] ?? json['has_elevator'] ?? false) as bool,
      hasParking: (json['hasParking'] ?? json['has_parking'] ?? false) as bool,
      district: (json['district'] ?? '') as String,
      cityName: cityName,
      governorateName: govName,
      manualAddress: (json['manualAddress'] ?? json['manual_address']) as String?,
      coverImageUrl: coverUrl,
      images: imageList,
      isBoosted: (json['isBoosted'] ?? json['is_boosted'] ?? false) as bool,
      matchScore: matchScore,
      matchBreakdown: json['matchBreakdown'] as Map<String, dynamic>?,
      ownerId: ownerId,
      ownerName: ownerName,
      ownerPhone: ownerPhone,
      isOwnerVerified: isOwnerVerified,
      contactRevealed: (json['contactRevealed'] ?? json['contact_revealed'] ?? false) as bool,
      isFavorite: json['isFavorite'] == true,
    );
  }
}
