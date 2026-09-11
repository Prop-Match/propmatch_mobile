import 'package:propmatch_mobile/core/constants/api_endpoints.dart';
import 'package:propmatch_mobile/core/network/dio_client.dart';
import 'package:propmatch_mobile/features/matching_chat/data/models/message_dto.dart';

abstract class ChatRemoteDataSource {
  Future<List<MatchConnectionDto>> getMyConnections();
  Future<List<MessageDto>> getMessages(String connectionId);
  Future<MessageDto> sendMessage({
    required String connectionId,
    required String body,
    String? attachmentUrl,
  });
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final DioClient _client;

  ChatRemoteDataSourceImpl(this._client);

  @override
  Future<List<MatchConnectionDto>> getMyConnections() async {
    final response = await _client.get(ApiEndpoints.matchConnections);
    final data = response.data;
    List list = [];
    if (data is List) {
      list = data;
    } else if (data is Map<String, dynamic>) {
      if (data['items'] is List) {
        list = data['items'] as List;
      } else if (data['data'] is List) {
        list = data['data'] as List;
      }
    }
    return list.map((item) => MatchConnectionDto.fromJson(item as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<MessageDto>> getMessages(String connectionId) async {
    final response = await _client.get('${ApiEndpoints.matchConnections}/$connectionId/messages');
    final data = response.data;
    List list = [];
    if (data is List) {
      list = data;
    } else if (data is Map<String, dynamic>) {
      if (data['items'] is List) {
        list = data['items'] as List;
      } else if (data['data'] is List) {
        list = data['data'] as List;
      }
    }
    return list.map((item) => MessageDto.fromJson(item as Map<String, dynamic>)).toList();
  }

  @override
  Future<MessageDto> sendMessage({
    required String connectionId,
    required String body,
    String? attachmentUrl,
  }) async {
    final response = await _client.post(
      '${ApiEndpoints.matchConnections}/$connectionId/messages',
      data: {
        'body': body,
        if (attachmentUrl != null) 'attachmentUrl': attachmentUrl,
      },
    );
    final data = response.data;
    final map = (data is Map<String, dynamic> && data['data'] is Map<String, dynamic>)
        ? data['data'] as Map<String, dynamic>
        : data as Map<String, dynamic>;
    return MessageDto.fromJson(map);
  }
}
