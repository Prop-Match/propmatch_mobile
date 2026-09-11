import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:propmatch_mobile/core/errors/exceptions.dart';
import 'package:propmatch_mobile/core/errors/failures.dart';
import 'package:propmatch_mobile/features/tenant/data/datasources/tenant_remote_datasource.dart';
import 'package:propmatch_mobile/features/tenant/data/models/property_dto.dart';
import 'package:propmatch_mobile/features/tenant/data/models/tenant_request_dto.dart';
import 'package:propmatch_mobile/features/tenant/data/repositories/tenant_repository_impl.dart';

class MockTenantRemoteDataSource extends Mock implements TenantRemoteDataSource {}

void main() {
  late MockTenantRemoteDataSource mockRemote;
  late TenantRepositoryImpl repository;

  setUp(() {
    mockRemote = MockTenantRemoteDataSource();
    repository = TenantRepositoryImpl(mockRemote);
  });

  const tPropertyDto = PropertyDto(
    id: 'p1',
    title: 'شقة مفروشة بالمنصورة',
    description: 'شقة فاخرة',
    rentAmount: 8000,
    areaM2: 120,
    bedrooms: 2,
    bathrooms: 1,
    isFurnished: true,
    hasElevator: true,
    hasParking: false,
    district: 'حي الجامعة',
  );

  group('getProperties', () {
    test('returns list of properties on success', () async {
      when(() => mockRemote.getProperties(
            query: any(named: 'query'),
            minPrice: any(named: 'minPrice'),
            maxPrice: any(named: 'maxPrice'),
            bedrooms: any(named: 'bedrooms'),
            isFurnished: any(named: 'isFurnished'),
            district: any(named: 'district'),
          )).thenAnswer((_) async => [tPropertyDto]);

      final result = await repository.getProperties();

      expect(result.isSuccess, isTrue);
      expect(result.data?.length, equals(1));
      expect(result.data?.first.id, equals('p1'));
    });

    test('returns ServerFailure on ServerException', () async {
      when(() => mockRemote.getProperties(
            query: any(named: 'query'),
            minPrice: any(named: 'minPrice'),
            maxPrice: any(named: 'maxPrice'),
            bedrooms: any(named: 'bedrooms'),
            isFurnished: any(named: 'isFurnished'),
            district: any(named: 'district'),
          )).thenThrow(const ServerException('Error loading properties'));

      final result = await repository.getProperties();

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<ServerFailure>());
    });
  });

  group('createTenantRequest', () {
    const tRequestDto = TenantRequestDto(
      id: 'req-1',
      minBudget: 5000,
      maxBudget: 8000,
      preferredLocations: 'حي الجامعة',
      requiredBedrooms: 2,
      needsFurnished: true,
      lifestyleRequirements: 'قريب من الجامعة',
    );

    test('successfully submits tenant request', () async {
      when(() => mockRemote.createTenantRequest(any()))
          .thenAnswer((_) async => tRequestDto);

      final result = await repository.createTenantRequest(
        minBudget: 5000,
        maxBudget: 8000,
        preferredLocations: 'حي الجامعة',
        requiredBedrooms: 2,
        needsFurnished: true,
        lifestyleRequirements: 'قريب من الجامعة',
      );

      expect(result.isSuccess, isTrue);
      expect(result.data?.id, equals('req-1'));
    });
  });
}
