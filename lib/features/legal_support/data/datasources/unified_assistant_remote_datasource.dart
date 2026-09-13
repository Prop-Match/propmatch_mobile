import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:propmatch_mobile/core/constants/api_endpoints.dart';
import 'package:propmatch_mobile/core/errors/exceptions.dart';
import 'package:propmatch_mobile/core/network/dio_client.dart';
import 'package:propmatch_mobile/core/network/error_handler.dart';
import 'package:propmatch_mobile/features/legal_support/domain/entities/unified_chat_entity.dart';

abstract class UnifiedAssistantRemoteDataSource {
  Stream<StreamChunk> streamLegalChat(String message);
  Stream<StreamChunk> streamSupportChat(String message, List<UnifiedChatMessage> history, String clientRequestId);
  Future<List<TicketSummaryEntity>> getMyTickets();
  Future<TicketDetailEntity> getTicketDetail(String id);
  Future<TicketDetailEntity> createTicket({required String subject, required String initialMessage});
  Future<TicketDetailEntity> replyToTicket(String ticketId, {String? content, String? attachmentUrl, String? attachmentType, String? attachmentName});
}

class UnifiedAssistantRemoteDataSourceImpl implements UnifiedAssistantRemoteDataSource {
  final DioClient client;
  UnifiedAssistantRemoteDataSourceImpl(this.client);

  @override
  Stream<StreamChunk> streamLegalChat(String message) async* {
    final dio = client.dio;
    Response<ResponseBody> response;
    try {
      response = await dio.post<ResponseBody>(
        ApiEndpoints.legalChatStream,
        data: jsonEncode({'message': message}),
        options: Options(
          headers: {'Accept': 'text/event-stream', 'Content-Type': 'application/json'},
          responseType: ResponseType.stream,
          sendTimeout: const Duration(seconds: 120),
          receiveTimeout: const Duration(seconds: 120),
        ),
      );
    } on DioException catch (e) {
      throw handleDioError(e);
    }
    if (response.data == null) throw const ServerException('تعذر الحصول على إجابة قانونية الآن');
    yield* _parseSseStream(response.data!.stream);
  }

  @override
  Stream<StreamChunk> streamSupportChat(String message, List<UnifiedChatMessage> history, String clientRequestId) async* {
    final dio = client.dio;
    final body = {
      'message': message,
      'clientRequestId': clientRequestId,
      'history': history.map((m) => {'role': m.role == ChatRole.user ? 'user' : 'assistant', 'content': m.content}).toList(),
    };
    Response<ResponseBody> response;
    try {
      response = await dio.post<ResponseBody>(
        ApiEndpoints.customerSupportStream,
        data: jsonEncode(body),
        options: Options(
          headers: {'Accept': 'text/event-stream', 'Content-Type': 'application/json'},
          responseType: ResponseType.stream,
          sendTimeout: const Duration(seconds: 120),
          receiveTimeout: const Duration(seconds: 120),
        ),
      );
    } on DioException catch (e) {
      throw handleDioError(e);
    }
    if (response.data == null) throw const ServerException('تعذر الحصول على إجابة الآن');
    yield* _parseSseStream(response.data!.stream);
  }

  Stream<StreamChunk> _parseSseStream(Stream<Uint8List> byteStream) async* {
    var buffer = '';
    await for (final chunk in byteStream) {
      buffer += utf8.decode(chunk, allowMalformed: true);
      buffer = buffer.replaceAll('\r\n', '\n');
      final frames = buffer.split('\n\n');
      buffer = frames.removeLast();
      for (final frame in frames) {
        final line = frame.split('\n').firstWhere((l) => l.trimLeft().startsWith('data:'), orElse: () => '');
        if (line.isEmpty) continue;
        final jsonStr = line.substring(line.indexOf(':') + 1).trim();
        if (jsonStr.isEmpty) continue;
        try {
          final map = jsonDecode(jsonStr) as Map<String, dynamic>;
          yield StreamChunk.fromJson(map);
        } catch (_) {
          continue;
        }
      }
    }
    if (buffer.trim().isNotEmpty) {
      final line = buffer.split('\n').firstWhere((l) => l.trimLeft().startsWith('data:'), orElse: () => '');
      if (line.isNotEmpty) {
        final jsonStr = line.substring(line.indexOf(':') + 1).trim();
        try {
          final map = jsonDecode(jsonStr) as Map<String, dynamic>;
          yield StreamChunk.fromJson(map);
        } catch (_) {}
      }
    }
  }

  @override
  Future<List<TicketSummaryEntity>> getMyTickets() async {
    final res = await client.get<Map<String, dynamic>>('/support/my-tickets');
    final data = res.data ?? {};
    final items = (data['items'] as List<dynamic>? ?? []) as List<dynamic>;
    return items.map((e) => TicketSummaryEntity.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<TicketDetailEntity> getTicketDetail(String id) async {
    final res = await client.get<Map<String, dynamic>>('/support/tickets/$id');
    return TicketDetailEntity.fromJson(res.data ?? {});
  }

  @override
  Future<TicketDetailEntity> createTicket({required String subject, required String initialMessage}) async {
    final res = await client.post<Map<String, dynamic>>(
      ApiEndpoints.customerSupport,
      data: {'subject': subject, 'initialMessage': initialMessage},
    );
    return TicketDetailEntity.fromJson(res.data ?? {});
  }

  @override
  Future<TicketDetailEntity> replyToTicket(String ticketId, {String? content, String? attachmentUrl, String? attachmentType, String? attachmentName}) async {
    final res = await client.post<Map<String, dynamic>>(
      '/support/tickets/$ticketId/reply',
      data: {
        if (content != null) 'content': content,
        if (attachmentUrl != null) 'attachmentUrl': attachmentUrl,
        if (attachmentType != null) 'attachmentType': attachmentType,
        if (attachmentName != null) 'attachmentName': attachmentName,
      },
    );
    return TicketDetailEntity.fromJson(res.data ?? {});
  }
}
