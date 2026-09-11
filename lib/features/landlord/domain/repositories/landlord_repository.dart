import 'package:propmatch_mobile/core/utils/result.dart';
import 'package:propmatch_mobile/features/tenant/domain/entities/property_entity.dart';
import 'package:propmatch_mobile/features/tenant/domain/entities/tenant_request_entity.dart';
import 'package:propmatch_mobile/features/landlord/domain/entities/landlord_stats_entity.dart';

abstract class LandlordRepository {
  Future<Result<LandlordDashboardData>> getDashboardData();
  Future<Result<List<PropertyEntity>>> getMyProperties();
  Future<Result<PropertyEntity>> createProperty(Map<String, dynamic> propertyData);
  Future<Result<PropertyEntity>> updateProperty(String id, Map<String, dynamic> propertyData);
  Future<Result<bool>> deleteProperty(String id);
  Future<Result<List<TenantRequestEntity>>> getTenantRequestsForMatching();
  Future<Result<bool>> sendOwnerOffer({
    required String tenantRequestId,
    required String propertyId,
    required String pitchMessage,
    required num proposedPrice,
  });
  Future<Result<String>> optimizeDescription({
    required String title,
    required String district,
    required num areaM2,
    required int bedrooms,
    required int bathrooms,
    required bool isFurnished,
    required List<String> amenities,
  });
}
