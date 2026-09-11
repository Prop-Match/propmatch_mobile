import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:propmatch_mobile/features/landlord/data/datasources/landlord_remote_datasource.dart';
import 'package:propmatch_mobile/features/landlord/data/repositories/landlord_repository_impl.dart';
import 'package:propmatch_mobile/features/landlord/domain/entities/landlord_stats_entity.dart';
import 'package:propmatch_mobile/features/tenant/data/models/property_dto.dart';

class MockLandlordRemoteDataSource extends Mock implements LandlordRemoteDataSource {}

void main() {
  late MockLandlordRemoteDataSource mockRemote;
  late LandlordRepositoryImpl repository;

  setUp(() {
    mockRemote = MockLandlordRemoteDataSource();
    repository = LandlordRepositoryImpl(mockRemote);
  });

  const tPropertyDto = PropertyDto(
    id: 'p1',
    title: 'شقتي بالمنصورة',
    description: 'وصف العقار',
    rentAmount: 9000,
    areaM2: 135,
    bedrooms: 3,
    bathrooms: 2,
    isFurnished: true,
    hasElevator: true,
    hasParking: true,
    district: 'المشاية',
  );

  group('getLandlordDashboardStats', () {
    test('returns landlord dashboard stats and units', () async {
      when(() => mockRemote.getMyProperties()).thenAnswer((_) async => [tPropertyDto]);
      when(() => mockRemote.getStats()).thenAnswer((_) async => const LandlordStatsEntity(
            activeListings: 1,
            totalViews: 420,
            receivedOffers: 8,
            smartMatchesCount: 15,
          ));

      final result = await repository.getDashboardData();

      expect(result.isSuccess, isTrue);
      expect(result.data?.stats.activeListings, equals(1));
      expect(result.data?.properties.length, equals(1));
    });
  });

  group('sendOwnerOffer', () {
    test('successfully sends offer pitch to tenant request', () async {
      when(() => mockRemote.sendOwnerOffer(
            tenantRequestId: 'req-1',
            propertyId: 'p1',
            pitchMessage: 'شقتي مناسبة جداً لطلبكم',
            proposedPrice: 8500,
          )).thenAnswer((_) async => true);

      final result = await repository.sendOwnerOffer(
        tenantRequestId: 'req-1',
        propertyId: 'p1',
        pitchMessage: 'شقتي مناسبة جداً لطلبكم',
        proposedPrice: 8500,
      );

      expect(result.isSuccess, isTrue);
      expect(result.data, isTrue);
    });
  });
}
