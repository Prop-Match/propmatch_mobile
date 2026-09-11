import 'package:equatable/equatable.dart';

class PropertyEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final num rentAmount;
  final num areaM2;
  final int bedrooms;
  final int bathrooms;
  final bool isFurnished;
  final bool hasElevator;
  final bool hasParking;
  final String district;
  final String? cityName;
  final String? governorateName;
  final String? manualAddress;
  final String? coverImageUrl;
  final List<String> images;
  final bool isBoosted;
  final double? matchScore;
  final Map<String, dynamic>? matchBreakdown;
  final String? ownerId;
  final String? ownerName;
  final String? ownerPhone;
  final bool isOwnerVerified;
  final bool contactRevealed;
  final bool isFavorite;

  const PropertyEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.rentAmount,
    required this.areaM2,
    required this.bedrooms,
    required this.bathrooms,
    required this.isFurnished,
    required this.hasElevator,
    required this.hasParking,
    required this.district,
    this.cityName,
    this.governorateName,
    this.manualAddress,
    this.coverImageUrl,
    this.images = const [],
    this.isBoosted = false,
    this.matchScore,
    this.matchBreakdown,
    this.ownerId,
    this.ownerName,
    this.ownerPhone,
    this.isOwnerVerified = false,
    this.contactRevealed = false,
    this.isFavorite = false,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        rentAmount,
        areaM2,
        bedrooms,
        bathrooms,
        isFurnished,
        hasElevator,
        hasParking,
        district,
        cityName,
        governorateName,
        manualAddress,
        coverImageUrl,
        images,
        isBoosted,
        matchScore,
        matchBreakdown,
        ownerId,
        ownerName,
        ownerPhone,
        isOwnerVerified,
        contactRevealed,
        isFavorite,
      ];
}
