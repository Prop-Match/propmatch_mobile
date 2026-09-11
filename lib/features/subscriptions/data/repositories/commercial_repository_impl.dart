import 'package:propmatch_mobile/features/subscriptions/data/datasources/commercial_remote_datasource.dart';
import 'package:propmatch_mobile/features/subscriptions/domain/entities/commercial_entity.dart';
import 'package:propmatch_mobile/features/subscriptions/domain/repositories/commercial_repository.dart';

class CommercialRepositoryImpl implements CommercialRepository {
  final CommercialRemoteDataSource remoteDataSource;

  CommercialRepositoryImpl(this.remoteDataSource);

  @override
  Future<CommercialCatalogEntity> getCatalog() {
    return remoteDataSource.getCatalog();
  }

  @override
  Future<Map<String, dynamic>> getMyQuota() {
    return remoteDataSource.getMyQuota();
  }

  @override
  Future<CheckoutResultEntity> createCheckout({
    required String paymentType,
    String? propertyId,
    String? method,
    String? walletPhone,
  }) {
    return remoteDataSource.createCheckout(
      paymentType: paymentType,
      propertyId: propertyId,
      method: method,
      walletPhone: walletPhone,
    );
  }
}
