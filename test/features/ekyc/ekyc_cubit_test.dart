import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:propmatch_mobile/features/ekyc/domain/entities/verification_entity.dart';
import 'package:propmatch_mobile/features/ekyc/domain/repositories/ekyc_repository.dart';
import 'package:propmatch_mobile/features/ekyc/presentation/cubit/ekyc_cubit.dart';

class MockEkycRepository extends Mock implements EkycRepository {}

void main() {
  late EkycCubit cubit;
  late MockEkycRepository mockRepository;

  setUp(() {
    mockRepository = MockEkycRepository();
    cubit = EkycCubit(repository: mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  group('EkycCubit', () {
    test('initial state is EkycInitial', () {
      expect(cubit.state, equals(EkycInitial()));
    });

    test('fetchVerificationStatus emits [EkycLoading, EkycLoaded] when successful', () async {
      const verification = VerificationEntity(
        status: VerificationStatus.notSubmitted,
        canSubmit: true,
      );
      when(() => mockRepository.getMyVerification()).thenAnswer((_) async => verification);

      final expectedStates = [
        EkycLoading(),
        const EkycLoaded(verification),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.fetchVerificationStatus();
    });

    test('fetchVerificationStatus emits [EkycLoading, EkycError] when fails', () async {
      when(() => mockRepository.getMyVerification()).thenThrow(Exception('Network error'));

      final expectedStates = [
        EkycLoading(),
        const EkycError('Exception: Network error'),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.fetchVerificationStatus();
    });
  });
}
