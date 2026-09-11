import 'package:propmatch_mobile/core/utils/result.dart';
import 'package:propmatch_mobile/features/matching_chat/domain/entities/message_entity.dart';

abstract class ChatRepository {
  Future<Result<List<MatchConnectionEntity>>> getMyConnections();
  Future<Result<List<MessageEntity>>> getMessages(String connectionId);
  Future<Result<MessageEntity>> sendMessage({
    required String connectionId,
    required String body,
    String? attachmentUrl,
  });
}
