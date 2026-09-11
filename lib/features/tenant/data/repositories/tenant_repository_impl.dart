import 'package:propmatch_mobile/core/errors/exceptions.dart';
import 'package:propmatch_mobile/core/errors/failures.dart';
import 'package:propmatch_mobile/core/utils/result.dart';
import '../../domain/entities/property_entity.dart';
import '../../domain/entities/tenant_request_entity.dart';
import '../../domain/entities/owner_offer_entity.dart';
import '../../domain/repositories/tenant_repository.dart';
import '../datasources/tenant_remote_datasource.dart';

class TenantRepositoryImpl implements TenantRepository {
  final TenantRemoteDataSource remoteDataSource;

  TenantRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<List<PropertyEntity>>> getProperties({
    String? query,
    num? minPrice,
    num? maxPrice,
    int? bedrooms,
    bool? isFurnished,
    String? district,
    int page = 1,
  }) async {
    try {
      final properties = await remoteDataSource.getProperties(
        query: query,
        minPrice: minPrice,
        maxPrice: maxPrice,
        bedrooms: bedrooms,
        isFurnished: isFurnished,
        district: district,
        page: page,
      );
      return Result.success(properties);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Result.failure(NetworkFailure(e.message));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<PropertyEntity>> getPropertyById(String id) async {
    try {
      final property = await remoteDataSource.getPropertyById(id);
      return Result.success(property);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Result.failure(NetworkFailure(e.message));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<bool>> toggleFavorite(String propertyId) async {
    try {
      final success = await remoteDataSource.toggleFavorite(propertyId);
      return Result.success(success);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<PropertyEntity>>> getFavorites() async {
    try {
      final favorites = await remoteDataSource.getFavorites();
      return Result.success(favorites);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<TenantRequestEntity>> createTenantRequest({
    required num minBudget,
    required num maxBudget,
    required String preferredLocations,
    String propertyType = 'APARTMENT',
    required int requiredBedrooms,
    required bool needsFurnished,
    int flexibilityScore = 5,
    required String lifestyleRequirements,
  }) async {
    try {
      final created = await remoteDataSource.createTenantRequest({
        'minBudget': minBudget,
        'maxBudget': maxBudget,
        'preferredLocations': preferredLocations,
        'propertyType': propertyType,
        'requiredBedrooms': requiredBedrooms,
        'needsFurnished': needsFurnished,
        'flexibilityScore': flexibilityScore,
        'lifestyleRequirements': lifestyleRequirements,
      });
      return Result.success(created);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<TenantRequestEntity>>> getMyTenantRequests() async {
    try {
      final requests = await remoteDataSource.getMyTenantRequests();
      return Result.success(requests);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<OwnerOfferEntity>>> getIncomingOffers(String requestId) async {
    try {
      final offers = await remoteDataSource.getIncomingOffers(requestId);
      return Result.success(offers);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<bool>> acceptOwnerOffer(String offerId) async {
    try {
      final success = await remoteDataSource.acceptOwnerOffer(offerId);
      return Result.success(success);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<bool>> rejectOwnerOffer(String offerId) async {
    try {
      final success = await remoteDataSource.rejectOwnerOffer(offerId);
      return Result.success(success);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<bool>> sendDirectOffer({
    required String propertyId,
    required num proposedPrice,
    required String message,
  }) async {
    try {
      final success = await remoteDataSource.sendDirectOffer(
        propertyId: propertyId,
        proposedPrice: proposedPrice,
        message: message,
      );
      return Result.success(success);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }
}
