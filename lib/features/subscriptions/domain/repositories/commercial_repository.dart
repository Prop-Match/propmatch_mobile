import 'package:propmatch_mobile/features/subscriptions/domain/entities/commercial_entity.dart';

abstract class CommercialRepository {
  Future<CommercialCatalogEntity> getCatalog();
  Future<Map<String, dynamic>> getMyQuota();
  Future<CheckoutResultEntity> createCheckout({
    required String paymentType,
    String? propertyId,
    String? method,
    String? walletPhone,
  });
}
