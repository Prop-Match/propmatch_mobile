import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propmatch_mobile/features/matching_chat/domain/repositories/chat_repository.dart';
import 'chat_state.dart';

export 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository repository;

  ChatCubit({required this.repository}) : super(const ChatState.initial());

  Future<void> loadConnections() async {
    emit(const ChatState.loading());
    final result = await repository.getMyConnections();
    if (result.isSuccess && result.data != null) {
      emit(ChatState.connectionsLoaded(result.data!));
    } else {
      emit(ChatState.error(result.failure?.message ?? 'فشل تحميل المحادثات'));
    }
  }

  Future<void> loadMessages(String connectionId) async {
    emit(const ChatState.loading());
    final result = await repository.getMessages(connectionId);
    if (result.isSuccess && result.data != null) {
      emit(ChatState.messagesLoaded(connectionId: connectionId, messages: result.data!));
    } else {
      emit(ChatState.error(result.failure?.message ?? 'فشل تحميل الرسائل'));
    }
  }

  Future<void> sendMessage({
    required String connectionId,
    required String body,
    String? attachmentUrl,
  }) async {
    final result = await repository.sendMessage(
      connectionId: connectionId,
      body: body,
      attachmentUrl: attachmentUrl,
    );
    if (result.isSuccess && result.data != null) {
      loadMessages(connectionId);
    }
  }
}
