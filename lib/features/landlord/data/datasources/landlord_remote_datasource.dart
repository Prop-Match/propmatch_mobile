import 'package:propmatch_mobile/core/constants/api_endpoints.dart';
import 'package:propmatch_mobile/core/network/dio_client.dart';
import 'package:propmatch_mobile/features/tenant/data/models/property_dto.dart';
import 'package:propmatch_mobile/features/tenant/data/models/tenant_request_dto.dart';
import 'package:propmatch_mobile/features/landlord/domain/entities/landlord_stats_entity.dart';

abstract class LandlordRemoteDataSource {
  Future<List<PropertyDto>> getMyProperties();
  Future<LandlordStatsEntity> getStats();
  Future<PropertyDto> createProperty(Map<String, dynamic> propertyData);
  Future<PropertyDto> updateProperty(String id, Map<String, dynamic> propertyData);
  Future<bool> deleteProperty(String id);
  Future<List<TenantRequestDto>> getTenantRequestsForMatching();
  Future<bool> sendOwnerOffer({
    required String tenantRequestId,
    required String propertyId,
    required String pitchMessage,
    required num proposedPrice,
  });
  Future<String> optimizeDescription({
    required String title,
    required String district,
    required num areaM2,
    required int bedrooms,
    required int bathrooms,
    required bool isFurnished,
    required List<String> amenities,
  });
}

class LandlordRemoteDataSourceImpl implements LandlordRemoteDataSource {
  final DioClient _client;

  LandlordRemoteDataSourceImpl(this._client);

  @override
  Future<List<PropertyDto>> getMyProperties() async {
    final response = await _client.get(ApiEndpoints.landlordProperties);
    final data = response.data;
    List list = [];
    if (data is List) {
      list = data;
    } else if (data is Map<String, dynamic>) {
      if (data['items'] is List) {
        list = data['items'] as List;
      } else if (data['data'] is List) {
        list = data['data'] as List;
      }
    }
    return list.map((item) => PropertyDto.fromJson(item as Map<String, dynamic>)).toList();
  }

  @override
  Future<LandlordStatsEntity> getStats() async {
    try {
      final quotaRes = await _client.get(ApiEndpoints.myQuota);
      final quota = quotaRes.data is Map<String, dynamic> ? quotaRes.data : <String, dynamic>{};

      return LandlordStatsEntity(
        activeListings: (quota['activeListings'] ?? quota['active_listings'] ?? 0) as int,
        maxActiveListingsAllowed: (quota['maxActiveListings'] ?? quota['max_active_listings'] ?? 1) as int,
        freeOffersLeft: (quota['freeOffersLeft'] ?? quota['free_offers_left'] ?? 5) as int,
        optimizerUsesLeft: (quota['optimizerUsesLeft'] ?? quota['optimizer_uses_left'] ?? 3) as int,
        totalViews: (quota['totalViews'] ?? 0) as int,
        receivedOffers: (quota['receivedOffers'] ?? 0) as int,
        smartMatchesCount: (quota['smartMatchesCount'] ?? 0) as int,
      );
    } catch (_) {
      return const LandlordStatsEntity();
    }
  }

  @override
  Future<PropertyDto> createProperty(Map<String, dynamic> propertyData) async {
    final response = await _client.post(
      ApiEndpoints.landlordProperties,
      data: propertyData,
    );
    final data = response.data;
    final map = (data is Map<String, dynamic> && data['data'] is Map<String, dynamic>)
        ? data['data'] as Map<String, dynamic>
        : data as Map<String, dynamic>;
    return PropertyDto.fromJson(map);
  }

  @override
  Future<PropertyDto> updateProperty(String id, Map<String, dynamic> propertyData) async {
    final response = await _client.patch(
      '${ApiEndpoints.landlordProperties}/$id',
      data: propertyData,
    );
    final data = response.data;
    final map = (data is Map<String, dynamic> && data['data'] is Map<String, dynamic>)
        ? data['data'] as Map<String, dynamic>
        : data as Map<String, dynamic>;
    return PropertyDto.fromJson(map);
  }

  @override
  Future<bool> deleteProperty(String id) async {
    final response = await _client.delete('${ApiEndpoints.landlordProperties}/$id');
    return response.statusCode == 200 || response.statusCode == 204;
  }

  @override
  Future<List<TenantRequestDto>> getTenantRequestsForMatching() async {
    final response = await _client.get(ApiEndpoints.reverseMarketplace);
    final data = response.data;
    List list = [];
    if (data is List) {
      list = data;
    } else if (data is Map<String, dynamic>) {
      if (data['items'] is List) {
        list = data['items'] as List;
      } else if (data['data'] is List) {
        list = data['data'] as List;
      }
    }
    return list.map((item) => TenantRequestDto.fromJson(item as Map<String, dynamic>)).toList();
  }

  @override
  Future<bool> sendOwnerOffer({
    required String tenantRequestId,
    required String propertyId,
    required String pitchMessage,
    required num proposedPrice,
  }) async {
    final response = await _client.post(
      ApiEndpoints.landlordOffers,
      data: {
        'tenantRequestId': tenantRequestId,
        'propertyId': propertyId,
        'pitchMessage': pitchMessage,
        'proposedPrice': proposedPrice,
      },
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  @override
  Future<String> optimizeDescription({
    required String title,
    required String district,
    required num areaM2,
    required int bedrooms,
    required int bathrooms,
    required bool isFurnished,
    required List<String> amenities,
  }) async {
    try {
      final response = await _client.post(
        '/properties/optimize-description',
        data: {
          'title': title,
          'district': district,
          'areaM2': areaM2,
          'bedrooms': bedrooms,
          'bathrooms': bathrooms,
          'isFurnished': isFurnished,
          'amenities': amenities,
        },
      );
      if (response.data is Map<String, dynamic> && response.data['description'] != null) {
        return response.data['description'] as String;
      }
      return response.data.toString();
    } catch (e) {
      return 'شقة مميزة للإيجار في $district بمساحة $areaM2 م²، تتكون من $bedrooms غرف نوم و$bathrooms حمام، ${isFurnished ? "مفروشة بالكامل وجاهزة للسكن الفوري" : "غير مفروشة بتشطيب سوبر لوكس"}. تقع بالقرب من كافة الخدمات والمواصلات الرئيسية.';
    }
  }
}
