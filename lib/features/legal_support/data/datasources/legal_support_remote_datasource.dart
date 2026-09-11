import 'package:propmatch_mobile/core/constants/api_endpoints.dart';
import 'package:propmatch_mobile/core/network/dio_client.dart';
import 'package:propmatch_mobile/features/legal_support/domain/entities/legal_message_entity.dart';

abstract class LegalSupportRemoteDataSource {
  Future<LegalMessageEntity> sendMessage(String message);
}

class LegalSupportRemoteDataSourceImpl implements LegalSupportRemoteDataSource {
  final DioClient client;

  LegalSupportRemoteDataSourceImpl(this.client);

  @override
  Future<LegalMessageEntity> sendMessage(String message) async {
    final response = await client.post<Map<String, dynamic>>(
      ApiEndpoints.legalChat,
      data: {'message': message},
    );

    final data = response.data ?? {};
    final content = data['content'] as String? ??
        data['message'] as String? ??
        data['reply'] as String? ??
        'تم استلام سؤالك وجارٍ معالجته.';
    final declined = data['declined'] as bool? ?? false;

    return LegalMessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: LegalMessageRole.assistant,
      content: content,
      declined: declined,
      createdAt: DateTime.now(),
    );
  }
}
