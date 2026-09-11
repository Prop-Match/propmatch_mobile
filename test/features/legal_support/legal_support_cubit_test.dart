import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:propmatch_mobile/features/legal_support/domain/entities/legal_message_entity.dart';
import 'package:propmatch_mobile/features/legal_support/domain/repositories/legal_support_repository.dart';
import 'package:propmatch_mobile/features/legal_support/presentation/cubit/legal_support_cubit.dart';

class MockLegalSupportRepository extends Mock implements LegalSupportRepository {}

void main() {
  late LegalSupportCubit cubit;
  late MockLegalSupportRepository mockRepository;

  setUp(() {
    mockRepository = MockLegalSupportRepository();
    cubit = LegalSupportCubit(repository: mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  group('LegalSupportCubit', () {
    test('initial state is LegalSupportInitial with empty messages', () {
      expect(cubit.state, equals(const LegalSupportInitial()));
    });

    test('sendMessage adds user message then appends assistant reply', () async {
      final reply = LegalMessageEntity(
        id: 'reply_1',
        role: LegalMessageRole.assistant,
        content: 'وفقاً لقانون الإيجار المصري رقم 4 لسنة 1996...',
        createdAt: DateTime.now(),
      );

      when(() => mockRepository.sendMessage(any())).thenAnswer((_) async => reply);

      await cubit.sendMessage('ما هي حقوق المستأجر؟');

      expect(cubit.state, isA<LegalSupportLoaded>());
      final loaded = cubit.state as LegalSupportLoaded;
      expect(loaded.messages.length, equals(2));
      expect(loaded.messages.first.role, equals(LegalMessageRole.user));
      expect(loaded.messages.first.content, equals('ما هي حقوق المستأجر؟'));
      expect(loaded.messages.last.role, equals(LegalMessageRole.assistant));
      expect(loaded.messages.last.content, equals(reply.content));
    });
  });
}
