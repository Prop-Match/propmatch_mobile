import 'package:propmatch_mobile/core/errors/exceptions.dart';
import 'package:propmatch_mobile/core/errors/failures.dart';
import 'package:propmatch_mobile/core/utils/result.dart';
import 'package:propmatch_mobile/features/tenant/domain/entities/property_entity.dart';
import 'package:propmatch_mobile/features/tenant/domain/entities/tenant_request_entity.dart';
import 'package:propmatch_mobile/features/landlord/domain/entities/landlord_stats_entity.dart';
import 'package:propmatch_mobile/features/landlord/domain/repositories/landlord_repository.dart';
import 'package:propmatch_mobile/features/landlord/data/datasources/landlord_remote_datasource.dart';

class LandlordRepositoryImpl implements LandlordRepository {
  final LandlordRemoteDataSource remoteDataSource;

  LandlordRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<LandlordDashboardData>> getDashboardData() async {
    try {
      final properties = await remoteDataSource.getMyProperties();
      final stats = await remoteDataSource.getStats();
      return Result.success(LandlordDashboardData(
        stats: stats,
        properties: properties,
      ));
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Result.failure(NetworkFailure(e.message));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<PropertyEntity>>> getMyProperties() async {
    try {
      final properties = await remoteDataSource.getMyProperties();
      return Result.success(properties);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<PropertyEntity>> createProperty(Map<String, dynamic> propertyData) async {
    try {
      final created = await remoteDataSource.createProperty(propertyData);
      return Result.success(created);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<PropertyEntity>> updateProperty(String id, Map<String, dynamic> propertyData) async {
    try {
      final updated = await remoteDataSource.updateProperty(id, propertyData);
      return Result.success(updated);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<bool>> deleteProperty(String id) async {
    try {
      final deleted = await remoteDataSource.deleteProperty(id);
      return Result.success(deleted);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<TenantRequestEntity>>> getTenantRequestsForMatching() async {
    try {
      final requests = await remoteDataSource.getTenantRequestsForMatching();
      return Result.success(requests);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<bool>> sendOwnerOffer({
    required String tenantRequestId,
    required String propertyId,
    required String pitchMessage,
    required num proposedPrice,
  }) async {
    try {
      final sent = await remoteDataSource.sendOwnerOffer(
        tenantRequestId: tenantRequestId,
        propertyId: propertyId,
        pitchMessage: pitchMessage,
        proposedPrice: proposedPrice,
      );
      return Result.success(sent);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<String>> optimizeDescription({
    required String title,
    required String district,
    required num areaM2,
    required int bedrooms,
    required int bathrooms,
    required bool isFurnished,
    required List<String> amenities,
  }) async {
    try {
      final optimized = await remoteDataSource.optimizeDescription(
        title: title,
        district: district,
        areaM2: areaM2,
        bedrooms: bedrooms,
        bathrooms: bathrooms,
        isFurnished: isFurnished,
        amenities: amenities,
      );
      return Result.success(optimized);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }
}
