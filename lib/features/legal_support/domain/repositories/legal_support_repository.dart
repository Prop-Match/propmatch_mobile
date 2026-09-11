import 'package:propmatch_mobile/features/legal_support/domain/entities/legal_message_entity.dart';

abstract class LegalSupportRepository {
  Future<LegalMessageEntity> sendMessage(String message);
}
