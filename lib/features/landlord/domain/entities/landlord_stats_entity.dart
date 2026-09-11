import 'package:equatable/equatable.dart';
import 'package:propmatch_mobile/features/tenant/domain/entities/property_entity.dart';

class LandlordStatsEntity extends Equatable {
  final int activeListings;
  final int totalViews;
  final int receivedOffers;
  final int smartMatchesCount;
  final int maxActiveListingsAllowed;
  final int freeOffersLeft;
  final int optimizerUsesLeft;

  const LandlordStatsEntity({
    this.activeListings = 0,
    this.totalViews = 0,
    this.receivedOffers = 0,
    this.smartMatchesCount = 0,
    this.maxActiveListingsAllowed = 1,
    this.freeOffersLeft = 5,
    this.optimizerUsesLeft = 3,
  });

  @override
  List<Object?> get props => [
        activeListings,
        totalViews,
        receivedOffers,
        smartMatchesCount,
        maxActiveListingsAllowed,
        freeOffersLeft,
        optimizerUsesLeft,
      ];
}

class LandlordDashboardData extends Equatable {
  final LandlordStatsEntity stats;
  final List<PropertyEntity> properties;

  const LandlordDashboardData({
    required this.stats,
    required this.properties,
  });

  @override
  List<Object?> get props => [stats, properties];
}
