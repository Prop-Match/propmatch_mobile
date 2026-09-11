import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:propmatch_mobile/features/subscriptions/domain/entities/commercial_entity.dart';
import 'package:propmatch_mobile/features/subscriptions/domain/repositories/commercial_repository.dart';
import 'package:propmatch_mobile/features/subscriptions/presentation/cubit/commercial_cubit.dart';

class MockCommercialRepository extends Mock implements CommercialRepository {}

void main() {
  late CommercialCubit cubit;
  late MockCommercialRepository mockRepository;

  setUp(() {
    mockRepository = MockCommercialRepository();
    cubit = CommercialCubit(repository: mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  group('CommercialCubit', () {
    test('initial state is CommercialInitial', () {
      expect(cubit.state, equals(CommercialInitial()));
    });

    test('fetchCatalogAndQuota emits [CommercialLoading, CommercialLoaded] on success', () async {
      const catalog = CommercialCatalogEntity(plans: {}, products: []);
      final quota = <String, dynamic>{'activeListingsRemaining': 3};

      when(() => mockRepository.getCatalog()).thenAnswer((_) async => catalog);
      when(() => mockRepository.getMyQuota()).thenAnswer((_) async => quota);

      final expectedStates = [
        CommercialLoading(),
        const CommercialLoaded(catalog: catalog, quota: {'activeListingsRemaining': 3}),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.fetchCatalogAndQuota();
    });

    test('checkout sets isCheckingOut true then updates checkoutResult', () async {
      const catalog = CommercialCatalogEntity(plans: {}, products: []);
      when(() => mockRepository.getCatalog()).thenAnswer((_) async => catalog);
      when(() => mockRepository.getMyQuota()).thenAnswer((_) async => {});
      await cubit.fetchCatalogAndQuota();

      const checkoutResult = CheckoutResultEntity(
        providerOrderId: 'order_123',
        amount: 299,
        currency: 'EGP',
        paymentType: 'OWNER_PLUS_MONTHLY',
        checkoutUrl: 'https://accept.paymob.com/checkout/123',
      );

      when(() => mockRepository.createCheckout(paymentType: 'OWNER_PLUS_MONTHLY'))
          .thenAnswer((_) async => checkoutResult);

      await cubit.checkout(paymentType: 'OWNER_PLUS_MONTHLY');

      expect(cubit.state, isA<CommercialLoaded>());
      final loaded = cubit.state as CommercialLoaded;
      expect(loaded.isCheckingOut, isFalse);
      expect(loaded.checkoutResult, equals(checkoutResult));
    });
  });
}
