import 'package:propmatch_mobile/core/utils/result.dart';
import '../entities/property_entity.dart';
import '../entities/tenant_request_entity.dart';
import '../entities/owner_offer_entity.dart';

abstract class TenantRepository {
  Future<Result<List<PropertyEntity>>> getProperties({
    String? query,
    num? minPrice,
    num? maxPrice,
    int? bedrooms,
    bool? isFurnished,
    String? district,
    int page = 1,
  });

  Future<Result<PropertyEntity>> getPropertyById(String id);
  Future<Result<bool>> toggleFavorite(String propertyId);
  Future<Result<List<PropertyEntity>>> getFavorites();

  Future<Result<TenantRequestEntity>> createTenantRequest({
    required num minBudget,
    required num maxBudget,
    required String preferredLocations,
    String propertyType = 'APARTMENT',
    required int requiredBedrooms,
    required bool needsFurnished,
    int flexibilityScore = 5,
    required String lifestyleRequirements,
  });

  Future<Result<List<TenantRequestEntity>>> getMyTenantRequests();
  Future<Result<List<OwnerOfferEntity>>> getIncomingOffers(String requestId);
  Future<Result<bool>> acceptOwnerOffer(String offerId);
  Future<Result<bool>> rejectOwnerOffer(String offerId);

  Future<Result<bool>> sendDirectOffer({
    required String propertyId,
    required num proposedPrice,
    required String message,
  });
}
