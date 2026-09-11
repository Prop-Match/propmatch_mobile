import 'package:dio/dio.dart';
import 'package:propmatch_mobile/core/errors/exceptions.dart';
import 'package:propmatch_mobile/core/errors/failures.dart';
import 'package:propmatch_mobile/core/network/error_handler.dart';
import 'package:propmatch_mobile/core/utils/result.dart';
import 'package:propmatch_mobile/features/matching_chat/domain/entities/message_entity.dart';
import 'package:propmatch_mobile/features/matching_chat/domain/repositories/chat_repository.dart';
import 'package:propmatch_mobile/features/matching_chat/data/datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  Failure _handleException(dynamic e) {
    if (e is DioException) {
      final ex = handleDioError(e);
      if (ex is ServerException) {
        return ServerFailure(ex.message, statusCode: ex.statusCode);
      } else if (ex is NetworkException) {
        return NetworkFailure(ex.message);
      } else if (ex is AuthException) {
        return AuthFailure(ex.message);
      }
      return const ServerFailure('حدث خطأ أثناء الاتصال بالخادم');
    }
    if (e is ServerException) {
      return ServerFailure(e.message, statusCode: e.statusCode);
    }
    if (e is NetworkException) {
      return NetworkFailure(e.message);
    }
    return const ServerFailure('حدث خطأ غير متوقع، يرجى المحاولة لاحقاً');
  }

  @override
  Future<Result<List<MatchConnectionEntity>>> getMyConnections() async {
    try {
      final connections = await remoteDataSource.getMyConnections();
      return Result.success(connections);
    } catch (e) {
      return Result.failure(_handleException(e));
    }
  }

  @override
  Future<Result<List<MessageEntity>>> getMessages(String connectionId) async {
    try {
      final messages = await remoteDataSource.getMessages(connectionId);
      return Result.success(messages);
    } catch (e) {
      return Result.failure(_handleException(e));
    }
  }

  @override
  Future<Result<MessageEntity>> sendMessage({
    required String connectionId,
    required String body,
    String? attachmentUrl,
  }) async {
    try {
      final message = await remoteDataSource.sendMessage(
        connectionId: connectionId,
        body: body,
        attachmentUrl: attachmentUrl,
      );
      return Result.success(message);
    } catch (e) {
      return Result.failure(_handleException(e));
    }
  }
}
