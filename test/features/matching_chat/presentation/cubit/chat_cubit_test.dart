import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:propmatch_mobile/core/errors/failures.dart';
import 'package:propmatch_mobile/core/utils/result.dart';
import 'package:propmatch_mobile/features/matching_chat/domain/entities/message_entity.dart';
import 'package:propmatch_mobile/features/matching_chat/domain/repositories/chat_repository.dart';
import 'package:propmatch_mobile/features/matching_chat/presentation/cubit/chat_cubit.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late MockChatRepository mockRepository;
  late ChatCubit cubit;

  final tConnections = [
    const MatchConnectionEntity(
      id: 'conn-1',
      propertyId: 'prop-1',
      propertyTitle: 'شقة المشاية',
      ownerId: 'owner-1',
      ownerName: 'محمود السيد',
      tenantId: 'tenant-1',
      matchScore: 92,
      status: ConnectionStatus.connected,
    ),
  ];

  final tMessages = [
    MessageEntity(
      id: 'msg-1',
      matchConnectionId: 'conn-1',
      senderId: 'tenant-1',
      body: 'السلام عليكم',
      createdAt: DateTime.now(),
    ),
  ];

  setUp(() {
    mockRepository = MockChatRepository();
    cubit = ChatCubit(repository: mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state should be ChatInitial', () {
    expect(cubit.state, equals(const ChatState.initial()));
  });

  group('loadConnections', () {
    blocTest<ChatCubit, ChatState>(
      'emits [ChatLoading, ConnectionsLoaded] on success',
      build: () {
        when(() => mockRepository.getMyConnections()).thenAnswer((_) async => Result.success(tConnections));
        return cubit;
      },
      act: (c) => c.loadConnections(),
      expect: () => [
        const ChatState.loading(),
        ChatState.connectionsLoaded(tConnections),
      ],
    );

    blocTest<ChatCubit, ChatState>(
      'emits [ChatLoading, ChatError] on failure',
      build: () {
        when(() => mockRepository.getMyConnections()).thenAnswer((_) async => const Result.failure(ServerFailure('فشل التحميل')));
        return cubit;
      },
      act: (c) => c.loadConnections(),
      expect: () => [
        const ChatState.loading(),
        const ChatState.error('فشل التحميل'),
      ],
    );
  });

  group('loadMessages', () {
    blocTest<ChatCubit, ChatState>(
      'emits [ChatLoading, MessagesLoaded] on success',
      build: () {
        when(() => mockRepository.getMessages('conn-1')).thenAnswer((_) async => Result.success(tMessages));
        return cubit;
      },
      act: (c) => c.loadMessages('conn-1'),
      expect: () => [
        const ChatState.loading(),
        ChatState.messagesLoaded(connectionId: 'conn-1', messages: tMessages),
      ],
    );
  });
}
