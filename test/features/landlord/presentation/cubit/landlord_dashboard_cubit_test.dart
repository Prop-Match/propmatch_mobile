import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:propmatch_mobile/core/errors/failures.dart';
import 'package:propmatch_mobile/core/utils/result.dart';
import 'package:propmatch_mobile/features/landlord/domain/entities/landlord_stats_entity.dart';
import 'package:propmatch_mobile/features/landlord/domain/repositories/landlord_repository.dart';
import 'package:propmatch_mobile/features/landlord/presentation/cubit/landlord_dashboard_cubit.dart';

class MockLandlordRepository extends Mock implements LandlordRepository {}

void main() {
  late MockLandlordRepository mockRepository;
  late LandlordDashboardCubit cubit;

  const tData = LandlordDashboardData(
    stats: LandlordStatsEntity(
      activeListings: 2,
      maxActiveListingsAllowed: 5,
      totalViews: 140,
      receivedOffers: 6,
      smartMatchesCount: 12,
      freeOffersLeft: 3,
      optimizerUsesLeft: 2,
    ),
    properties: [],
  );

  setUp(() {
    mockRepository = MockLandlordRepository();
    cubit = LandlordDashboardCubit(repository: mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state should be LandlordDashboardInitial', () {
    expect(cubit.state, equals(const LandlordDashboardState.initial()));
  });

  group('loadDashboard', () {
    blocTest<LandlordDashboardCubit, LandlordDashboardState>(
      'emits [LandlordDashboardLoading, LandlordDashboardLoaded] on success',
      build: () {
        when(() => mockRepository.getDashboardData()).thenAnswer((_) async => const Result.success(tData));
        return cubit;
      },
      act: (c) => c.loadDashboard(),
      expect: () => [
        const LandlordDashboardState.loading(),
        const LandlordDashboardState.loaded(tData),
      ],
    );

    blocTest<LandlordDashboardCubit, LandlordDashboardState>(
      'emits [LandlordDashboardLoading, LandlordDashboardError] on failure',
      build: () {
        when(() => mockRepository.getDashboardData()).thenAnswer((_) async => const Result.failure(ServerFailure('فشل التحميل')));
        return cubit;
      },
      act: (c) => c.loadDashboard(),
      expect: () => [
        const LandlordDashboardState.loading(),
        const LandlordDashboardState.error('فشل التحميل'),
      ],
    );
  });
}
