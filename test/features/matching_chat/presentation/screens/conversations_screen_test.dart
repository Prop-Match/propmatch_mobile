import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:propmatch_mobile/core/constants/app_constants.dart';
import 'package:propmatch_mobile/features/matching_chat/domain/entities/match_connection_entity.dart';
import 'package:propmatch_mobile/features/matching_chat/presentation/cubit/chat_cubit.dart';
import 'package:propmatch_mobile/features/matching_chat/presentation/screens/conversations_screen.dart';

class MockChatCubit extends MockCubit<ChatState> implements ChatCubit {}

void main() {
  late MockChatCubit mockChatCubit;

  setUp(() {
    mockChatCubit = MockChatCubit();
  });

  Widget buildWidget() {
    return MaterialApp(
      home: BlocProvider<ChatCubit>.value(
        value: mockChatCubit,
        child: const ConversationsScreen(),
      ),
    );
  }

  testWidgets('renders CircularProgressIndicator when state is ChatLoading', (tester) async {
    when(() => mockChatCubit.state).thenReturn(const ChatState.loading());
    when(() => mockChatCubit.loadConnections()).thenAnswer((_) async {});

    await tester.pumpWidget(buildWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders error view with generous padding and retry button', (tester) async {
    const errorMsg = 'تعذر الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت';
    when(() => mockChatCubit.state).thenReturn(const ChatState.error(errorMsg));
    when(() => mockChatCubit.loadConnections()).thenAnswer((_) async {});

    await tester.pumpWidget(buildWidget());

    // Verify title and error message
    expect(find.text('تعذر تحميل المحادثات'), findsOneWidget);
    expect(find.text(errorMsg), findsOneWidget);

    // Verify retry button is rendered
    final retryBtnFinder = find.widgetWithText(ElevatedButton, 'إعادة المحاولة');
    expect(retryBtnFinder, findsOneWidget);

    // Verify padding exists around retry button
    final paddingWidgets = tester.widgetList<Padding>(find.byType(Padding));
    final hasHorizontalPadding = paddingWidgets.any((p) {
      final insets = p.padding;
      return insets is EdgeInsets && insets.horizontal >= AppConstants.paddingMd * 2;
    });
    expect(hasHorizontalPadding, isTrue, reason: 'Retry button or error container must have horizontal padding');

    // Tap retry button and verify loadConnections is triggered
    await tester.tap(retryBtnFinder);
    verify(() => mockChatCubit.loadConnections()).called(greaterThanOrEqualTo(1));
  });

  testWidgets('renders empty state when connections list is empty', (tester) async {
    when(() => mockChatCubit.state).thenReturn(const ChatState.connectionsLoaded([]));
    when(() => mockChatCubit.loadConnections()).thenAnswer((_) async {});

    await tester.pumpWidget(buildWidget());

    expect(find.text('لا توجد محادثات نشطة حالياً'), findsOneWidget);
    expect(find.text('تبدأ المحادثات تلقائياً عند قبول عروض الإيجار أو المطابقات المباشرة'), findsOneWidget);
  });

  testWidgets('renders list of connections when loaded', (tester) async {
    final connections = [
      const MatchConnectionEntity(
        id: 'conn-1',
        tenantId: 't-1',
        tenantName: 'أحمد المحمد',
        ownerId: 'o-1',
        ownerName: 'سعيد الغامدي',
        propertyId: 'p-1',
        propertyTitle: 'شقة فاخرة في حطين',
        matchScore: 94,
        status: ConnectionStatus.connected,
      ),
    ];

    when(() => mockChatCubit.state).thenReturn(ChatState.connectionsLoaded(connections));
    when(() => mockChatCubit.loadConnections()).thenAnswer((_) async {});

    await tester.pumpWidget(buildWidget());

    expect(find.text('سعيد الغامدي'), findsOneWidget);
    expect(find.text('شقة فاخرة في حطين'), findsOneWidget);
    expect(find.text('94%'), findsOneWidget);
  });
}
