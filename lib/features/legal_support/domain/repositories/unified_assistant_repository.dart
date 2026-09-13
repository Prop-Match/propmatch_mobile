import 'package:propmatch_mobile/features/legal_support/domain/entities/unified_chat_entity.dart';

abstract class UnifiedAssistantRepository {
  Stream<StreamChunk> streamLegalChat(String message);
  Stream<StreamChunk> streamSupportChat(String message, List<UnifiedChatMessage> history, String clientRequestId);
  Future<List<TicketSummaryEntity>> getMyTickets();
  Future<TicketDetailEntity> getTicketDetail(String id);
  Future<TicketDetailEntity> createTicket({required String subject, required String initialMessage});
  Future<TicketDetailEntity> replyToTicket(String ticketId, {String? content, String? attachmentUrl, String? attachmentType, String? attachmentName});
}
