import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:propmatch_mobile/core/errors/failures.dart';
import 'package:propmatch_mobile/features/matching_chat/data/datasources/chat_remote_datasource.dart';
import 'package:propmatch_mobile/features/matching_chat/data/repositories/chat_repository_impl.dart';

class MockChatRemoteDataSource extends Mock implements ChatRemoteDataSource {}

void main() {
  late MockChatRemoteDataSource mockDataSource;
  late ChatRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockChatRemoteDataSource();
    repository = ChatRepositoryImpl(mockDataSource);
  });

  group('ChatRepositoryImpl Error Handling', () {
    test('converts 404 DioException into ServerFailure with clean message', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/matches'),
        response: Response(
          requestOptions: RequestOptions(path: '/matches'),
          statusCode: 404,
          data: {'statusCode': 404, 'message': 'المحادثة غير موجودة'},
        ),
        type: DioExceptionType.badResponse,
      );

      when(() => mockDataSource.getMyConnections()).thenThrow(dioException);

      final result = await repository.getMyConnections();

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<ServerFailure>());
      expect(result.failure?.message, equals('المحادثة غير موجودة'));
      expect(result.failure?.message.contains('DioException'), isFalse);
    });

    test('converts connection timeout DioException into NetworkFailure in Arabic', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/matches'),
        type: DioExceptionType.connectionTimeout,
      );

      when(() => mockDataSource.getMyConnections()).thenThrow(dioException);

      final result = await repository.getMyConnections();

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<NetworkFailure>());
      expect(result.failure?.message, contains('تعذر الاتصال بالخادم'));
      expect(result.failure?.message.contains('DioException'), isFalse);
    });
  });
}
