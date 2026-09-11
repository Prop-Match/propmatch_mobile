import 'package:propmatch_mobile/core/constants/api_endpoints.dart';
import 'package:propmatch_mobile/core/network/dio_client.dart';
import 'package:propmatch_mobile/features/subscriptions/domain/entities/commercial_entity.dart';

abstract class CommercialRemoteDataSource {
  Future<CommercialCatalogEntity> getCatalog();
  Future<Map<String, dynamic>> getMyQuota();
  Future<CheckoutResultEntity> createCheckout({
    required String paymentType,
    String? propertyId,
    String? method,
    String? walletPhone,
  });
}

class CommercialRemoteDataSourceImpl implements CommercialRemoteDataSource {
  final DioClient client;

  CommercialRemoteDataSourceImpl(this.client);

  @override
  Future<CommercialCatalogEntity> getCatalog() async {
    final response = await client.get<Map<String, dynamic>>(
      ApiEndpoints.productConfigs,
      forceRefresh: true,
    );
    return CommercialCatalogEntity.fromJson(response.data ?? {});
  }

  @override
  Future<Map<String, dynamic>> getMyQuota() async {
    final response = await client.get<Map<String, dynamic>>(
      ApiEndpoints.myQuota,
      forceRefresh: true,
    );
    return response.data ?? {};
  }

  @override
  Future<CheckoutResultEntity> createCheckout({
    required String paymentType,
    String? propertyId,
    String? method,
    String? walletPhone,
  }) async {
    final payload = <String, dynamic>{
      'paymentType': paymentType,
      if (propertyId != null) 'propertyId': propertyId,
      if (method != null) 'method': method,
      if (walletPhone != null) 'walletPhone': walletPhone,
    };

    final response = await client.post<Map<String, dynamic>>(
      ApiEndpoints.paymentsCheckout,
      data: payload,
    );
    return CheckoutResultEntity.fromJson(response.data ?? {});
  }
}
