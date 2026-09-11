import 'package:propmatch_mobile/features/legal_support/data/datasources/legal_support_remote_datasource.dart';
import 'package:propmatch_mobile/features/legal_support/domain/entities/legal_message_entity.dart';
import 'package:propmatch_mobile/features/legal_support/domain/repositories/legal_support_repository.dart';

class LegalSupportRepositoryImpl implements LegalSupportRepository {
  final LegalSupportRemoteDataSource remoteDataSource;

  LegalSupportRepositoryImpl(this.remoteDataSource);

  @override
  Future<LegalMessageEntity> sendMessage(String message) {
    return remoteDataSource.sendMessage(message);
  }
}
