import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:propmatch_mobile/core/errors/failures.dart';
import 'package:propmatch_mobile/core/utils/result.dart';
import 'package:propmatch_mobile/features/tenant/domain/entities/property_entity.dart';
import 'package:propmatch_mobile/features/tenant/domain/repositories/tenant_repository.dart';
import 'package:propmatch_mobile/features/tenant/presentation/cubit/tenant_browse_cubit.dart';

class MockTenantRepository extends Mock implements TenantRepository {}

void main() {
  late MockTenantRepository mockRepository;
  late TenantBrowseCubit cubit;

  const tProperty = PropertyEntity(
    id: 'prop-1',
    title: 'شقة مفروشة راقية',
    description: 'شقة 3 غرف في المشاية',
    rentAmount: 8500,
    areaM2: 140,
    bedrooms: 3,
    bathrooms: 2,
    isFurnished: true,
    hasElevator: true,
    hasParking: false,
    district: 'المشاية',
    cityName: 'المنصورة',
    governorateName: 'الدقهلية',
    images: ['https://example.com/img1.jpg'],
    isBoosted: true,
    matchScore: 92,
    ownerId: 'owner-1',
    ownerName: 'محمد أحمد',
    isOwnerVerified: true,
    contactRevealed: false,
  );

  final tPropertyList = [tProperty];

  setUp(() {
    mockRepository = MockTenantRepository();
    cubit = TenantBrowseCubit(repository: mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state should be TenantBrowseInitial', () {
    expect(cubit.state, equals(const TenantBrowseState.initial()));
  });

  group('loadProperties', () {
    blocTest<TenantBrowseCubit, TenantBrowseState>(
      'emits [TenantBrowseLoading, TenantBrowseLoaded] on success',
      build: () {
        when(() => mockRepository.getProperties(
              query: any(named: 'query'),
              minPrice: any(named: 'minPrice'),
              maxPrice: any(named: 'maxPrice'),
              bedrooms: any(named: 'bedrooms'),
              isFurnished: any(named: 'isFurnished'),
              district: any(named: 'district'),
            )).thenAnswer((_) async => Result.success(tPropertyList));
        return cubit;
      },
      act: (c) => c.loadProperties(),
      expect: () => [
        const TenantBrowseState.loading(),
        TenantBrowseState.loaded(properties: tPropertyList),
      ],
    );

    blocTest<TenantBrowseCubit, TenantBrowseState>(
      'emits [TenantBrowseLoading, TenantBrowseError] on failure',
      build: () {
        when(() => mockRepository.getProperties(
              query: any(named: 'query'),
              minPrice: any(named: 'minPrice'),
              maxPrice: any(named: 'maxPrice'),
              bedrooms: any(named: 'bedrooms'),
              isFurnished: any(named: 'isFurnished'),
              district: any(named: 'district'),
            )).thenAnswer((_) async => const Result.failure(ServerFailure('تعذر الاتصال بالخادم')));
        return cubit;
      },
      act: (c) => c.loadProperties(),
      expect: () => [
        const TenantBrowseState.loading(),
        const TenantBrowseState.error('تعذر الاتصال بالخادم'),
      ],
    );
  });
}
