import 'package:propmatch_mobile/features/legal_support/data/datasources/unified_assistant_remote_datasource.dart';
import 'package:propmatch_mobile/features/legal_support/domain/entities/unified_chat_entity.dart';
import 'package:propmatch_mobile/features/legal_support/domain/repositories/unified_assistant_repository.dart';

class UnifiedAssistantRepositoryImpl implements UnifiedAssistantRepository {
  final UnifiedAssistantRemoteDataSource remote;
  UnifiedAssistantRepositoryImpl(this.remote);

  @override
  Stream<StreamChunk> streamLegalChat(String message) => remote.streamLegalChat(message);

  @override
  Stream<StreamChunk> streamSupportChat(String message, List<UnifiedChatMessage> history, String clientRequestId) =>
      remote.streamSupportChat(message, history, clientRequestId);

  @override
  Future<List<TicketSummaryEntity>> getMyTickets() => remote.getMyTickets();

  @override
  Future<TicketDetailEntity> getTicketDetail(String id) => remote.getTicketDetail(id);

  @override
  Future<TicketDetailEntity> createTicket({required String subject, required String initialMessage}) =>
      remote.createTicket(subject: subject, initialMessage: initialMessage);

  @override
  Future<TicketDetailEntity> replyToTicket(String ticketId, {String? content, String? attachmentUrl, String? attachmentType, String? attachmentName}) =>
      remote.replyToTicket(ticketId, content: content, attachmentUrl: attachmentUrl, attachmentType: attachmentType, attachmentName: attachmentName);
}
