import 'package:propmatch_mobile/core/constants/api_endpoints.dart';
import 'package:propmatch_mobile/core/network/dio_client.dart';
import '../models/property_dto.dart';
import '../models/tenant_request_dto.dart';
import '../models/owner_offer_dto.dart';

abstract class TenantRemoteDataSource {
  Future<List<PropertyDto>> getProperties({
    String? query,
    num? minPrice,
    num? maxPrice,
    int? bedrooms,
    bool? isFurnished,
    String? district,
    int page = 1,
    int limit = 20,
  });

  Future<PropertyDto> getPropertyById(String id);
  Future<bool> toggleFavorite(String propertyId);
  Future<List<PropertyDto>> getFavorites();

  Future<TenantRequestDto> createTenantRequest(Map<String, dynamic> data);
  Future<List<TenantRequestDto>> getMyTenantRequests();
  Future<List<OwnerOfferDto>> getIncomingOffers(String requestId);
  Future<bool> acceptOwnerOffer(String offerId);
  Future<bool> rejectOwnerOffer(String offerId);

  Future<bool> sendDirectOffer({
    required String propertyId,
    required num proposedPrice,
    required String message,
  });
}

class TenantRemoteDataSourceImpl implements TenantRemoteDataSource {
  final DioClient _client;

  TenantRemoteDataSourceImpl(this._client);

  @override
  Future<List<PropertyDto>> getProperties({
    String? query,
    num? minPrice,
    num? maxPrice,
    int? bedrooms,
    bool? isFurnished,
    String? district,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    if (query != null && query.isNotEmpty) queryParams['q'] = query;
    if (minPrice != null) queryParams['minPrice'] = minPrice;
    if (maxPrice != null) queryParams['maxPrice'] = maxPrice;
    if (bedrooms != null) queryParams['bedrooms'] = bedrooms;
    if (isFurnished != null) queryParams['isFurnished'] = isFurnished;
    if (district != null && district.isNotEmpty) queryParams['district'] = district;

    // Use hybrid search if free text is provided
    final endpoint = (query != null && query.trim().length > 3)
        ? ApiEndpoints.hybridSearch
        : ApiEndpoints.properties;

    final response = await _client.get(
      endpoint,
      queryParameters: queryParams,
    );

    final data = response.data;
    List items = [];
    if (data is List) {
      items = data;
    } else if (data is Map<String, dynamic> && data['data'] is List) {
      items = data['data'] as List;
    } else if (data is Map<String, dynamic> && data['items'] is List) {
      items = data['items'] as List;
    }

    return items.map((item) => PropertyDto.fromJson(item as Map<String, dynamic>)).toList();
  }

  @override
  Future<PropertyDto> getPropertyById(String id) async {
    final response = await _client.get('${ApiEndpoints.properties}/$id');
    return PropertyDto.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<bool> toggleFavorite(String propertyId) async {
    final response = await _client.post(
      ApiEndpoints.favorites,
      data: {'propertyId': propertyId},
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  @override
  Future<List<PropertyDto>> getFavorites() async {
    final response = await _client.get(ApiEndpoints.favorites);
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
    return list.map((item) {
      final propMap = (item is Map<String, dynamic>) ? (item['property'] ?? item) : item;
      return PropertyDto.fromJson(propMap as Map<String, dynamic>);
    }).toList();
  }

  @override
  Future<TenantRequestDto> createTenantRequest(Map<String, dynamic> data) async {
    final response = await _client.post(
      ApiEndpoints.tenantRequests,
      data: data,
    );
    final resData = response.data;
    final map = (resData is Map<String, dynamic> && resData['data'] is Map<String, dynamic>)
        ? resData['data'] as Map<String, dynamic>
        : resData as Map<String, dynamic>;
    return TenantRequestDto.fromJson(map);
  }

  @override
  Future<List<TenantRequestDto>> getMyTenantRequests() async {
    final response = await _client.get(ApiEndpoints.myTenantRequests);
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
  Future<List<OwnerOfferDto>> getIncomingOffers(String requestId) async {
    final response = await _client.get(ApiEndpoints.ownerOffers);
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
    final allOffers = list.map((item) => OwnerOfferDto.fromJson(item as Map<String, dynamic>)).toList();
    if (requestId.isEmpty) return allOffers;
    return allOffers.where((o) => o.tenantRequestId == requestId).toList();
  }

  @override
  Future<bool> acceptOwnerOffer(String offerId) async {
    final response = await _client.post('${ApiEndpoints.ownerOffers}/$offerId/accept');
    return response.statusCode == 200 || response.statusCode == 201;
  }

  @override
  Future<bool> rejectOwnerOffer(String offerId) async {
    final response = await _client.post('${ApiEndpoints.ownerOffers}/$offerId/reject');
    return response.statusCode == 200 || response.statusCode == 201;
  }

  @override
  Future<bool> sendDirectOffer({
    required String propertyId,
    required num proposedPrice,
    required String message,
  }) async {
    final response = await _client.post(
      ApiEndpoints.tenantOffers,
      data: {
        'propertyId': propertyId,
        'proposedPrice': proposedPrice,
        'message': message,
      },
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }
}
