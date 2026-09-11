import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:propmatch_mobile/features/matching_chat/domain/entities/message_entity.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState.initial() = ChatInitial;
  const factory ChatState.loading() = ChatLoading;
  const factory ChatState.connectionsLoaded(List<MatchConnectionEntity> connections) = ConnectionsLoaded;
  const factory ChatState.messagesLoaded({
    required String connectionId,
    required List<MessageEntity> messages,
  }) = MessagesLoaded;
  const factory ChatState.error(String message) = ChatError;
}
