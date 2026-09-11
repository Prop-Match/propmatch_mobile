import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:propmatch_mobile/features/notifications/domain/entities/notification_entity.dart';
import 'package:propmatch_mobile/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:propmatch_mobile/features/notifications/presentation/cubit/notifications_cubit.dart';

class MockNotificationsRepository extends Mock implements NotificationsRepository {}

void main() {
  late NotificationsCubit cubit;
  late MockNotificationsRepository mockRepository;

  setUp(() {
    mockRepository = MockNotificationsRepository();
    cubit = NotificationsCubit(repository: mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  group('NotificationsCubit', () {
    test('initial state is NotificationsInitial', () {
      expect(cubit.state, equals(NotificationsInitial()));
    });

    test('fetchNotifications emits [NotificationsLoading, NotificationsLoaded] on success', () async {
      final now = DateTime.now();
      final items = [
        NotificationEntity(
          id: 'n1',
          type: 'MATCH',
          title: 'عقار مطابق جديد',
          message: 'تم العثور على عقار مناسب',
          isRead: false,
          createdAt: now,
        ),
      ];
      final result = NotificationsListResult(items: items, unread: 1);

      when(() => mockRepository.getNotifications()).thenAnswer((_) async => result);

      final expectedStates = [
        NotificationsLoading(),
        NotificationsLoaded(notifications: items, unreadCount: 1),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.fetchNotifications();
    });

    test('markAllRead marks all notifications as read and updates count to 0', () async {
      final now = DateTime.now();
      final items = [
        NotificationEntity(
          id: 'n1',
          type: 'MATCH',
          title: 'مطابقة',
          message: 'تفاصيل المطابقة',
          isRead: false,
          createdAt: now,
        ),
      ];
      final result = NotificationsListResult(items: items, unread: 1);

      when(() => mockRepository.getNotifications()).thenAnswer((_) async => result);
      when(() => mockRepository.markAllRead()).thenAnswer((_) async {});

      await cubit.fetchNotifications();

      cubit.markAllRead();

      expect(cubit.state, isA<NotificationsLoaded>());
      final loaded = cubit.state as NotificationsLoaded;
      expect(loaded.unreadCount, equals(0));
      expect(loaded.notifications.first.isRead, isTrue);
    });
  });
}
