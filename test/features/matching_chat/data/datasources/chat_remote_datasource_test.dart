import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:propmatch_mobile/core/constants/api_endpoints.dart';
import 'package:propmatch_mobile/core/network/dio_client.dart';
import 'package:propmatch_mobile/features/matching_chat/data/datasources/chat_remote_datasource.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  late MockDioClient mockClient;
  late ChatRemoteDataSourceImpl dataSource;

  setUp(() {
    mockClient = MockDioClient();
    dataSource = ChatRemoteDataSourceImpl(mockClient);
  });

  group('ChatRemoteDataSource Contract & Implementation', () {
    test('getMyConnections calls GET /matches and parses backend response', () async {
      final backendResponse = [
        {
          'matchConnectionId': 'match-123',
          'propertyId': 'prop-456',
          'propertyTitle': 'فيلا عصرية في الملقا',
          'propertyCoverImage': null,
          'otherParticipantName': 'عبدالله الشمري',
          'connectionStatus': 'CONNECTED',
          'agreementReachedAt': null,
          'canConfirmAgreement': true,
          'lastMessagePreview': 'مرحباً، هل يمكن ترتيب موعد زيارة؟',
          'lastMessageAt': '2026-09-11T20:00:00.000Z',
        }
      ];

      when(() => mockClient.get(ApiEndpoints.matchConnections)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiEndpoints.matchConnections),
          statusCode: 200,
          data: backendResponse,
        ),
      );

      final result = await dataSource.getMyConnections();

      expect(result.length, equals(1));
      expect(result.first.id, equals('match-123'));
      expect(result.first.propertyTitle, equals('فيلا عصرية في الملقا'));
      expect(result.first.ownerName, equals('عبدالله الشمري'));
      expect(result.first.lastMessage?.body, equals('مرحباً، هل يمكن ترتيب موعد زيارة؟'));
      verify(() => mockClient.get('/matches')).called(1);
    });

    test('getMessages calls GET /matches/:connectionId/messages', () async {
      final backendMessages = [
        {
          'id': 'msg-01',
          'matchConnectionId': 'match-123',
          'senderId': 'user-1',
          'body': 'أهلاً بك',
          'createdAt': '2026-09-11T20:01:00.000Z',
        }
      ];

      when(() => mockClient.get('${ApiEndpoints.matchConnections}/match-123/messages')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '${ApiEndpoints.matchConnections}/match-123/messages'),
          statusCode: 200,
          data: backendMessages,
        ),
      );

      final result = await dataSource.getMessages('match-123');

      expect(result.length, equals(1));
      expect(result.first.id, equals('msg-01'));
      expect(result.first.body, equals('أهلاً بك'));
      verify(() => mockClient.get('/matches/match-123/messages')).called(1);
    });

    test('sendMessage calls POST /matches/:connectionId/messages with body', () async {
      final createdMessageJson = {
        'id': 'msg-02',
        'matchConnectionId': 'match-123',
        'senderId': 'user-1',
        'body': 'شكراً جزيلاً',
        'createdAt': '2026-09-11T20:05:00.000Z',
      };

      when(() => mockClient.post(
            '${ApiEndpoints.matchConnections}/match-123/messages',
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '${ApiEndpoints.matchConnections}/match-123/messages'),
          statusCode: 201,
          data: createdMessageJson,
        ),
      );

      final result = await dataSource.sendMessage(
        connectionId: 'match-123',
        body: 'شكراً جزيلاً',
      );

      expect(result.id, equals('msg-02'));
      expect(result.body, equals('شكراً جزيلاً'));
      verify(() => mockClient.post(
            '/matches/match-123/messages',
            data: {'body': 'شكراً جزيلاً'},
          )).called(1);
    });
  });
}
